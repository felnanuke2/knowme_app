import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/models/user_model.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.postModel,
    required this.thisIndex,
    required this.controller,
  }) : super(key: key);
  final PostModel postModel;

  final int thisIndex;
  final SesssionController controller;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? videoController;
  UserModel? user;
  bool videoDone = false;

  @override
  void initState() {
    user = widget.postModel.userModel;
    if (user == null) {
      _setUserProfile(Get.find());
    }

    if (widget.postModel.mediaType == 0) {
      videoController = VideoPlayerController.network(widget.postModel.src);
      videoController!.initialize().then((value) {
        videoDone = true;
        setState(() {});
      });
      videoController?.setLooping(true);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VisibilityDetector(
      key: UniqueKey(),
      child: GetBuilder<SesssionController>(
        builder: (controller) => Container(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  _buildHeaders(),
                  if (widget.postModel.mediaType == 0) _buildVideo() else _buildImage(),
                  _buildBottom(),
                ],
              ),
            ),
          ),
        ),
      ),
      onVisibilityChanged: (info) {
        if (info.visibleFraction <= 0.5) {
          videoController?.pause();
        } else if (info.visibleFraction > 0.88) {
          videoController?.play();
        }
      },
    );
  }

  Widget _buildBottom() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
                textAlign: TextAlign.left,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(style: TextStyle(color: Colors.black), children: [
                  TextSpan(
                      text: (user?.profileName ?? '') + '#',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(
                    text: ' ' + widget.postModel.description,
                  )
                ])),
          ),
          Text(
            '\nEnviado ' +
                timeago.format(
                  widget.postModel.createAt,
                  locale: 'pt',
                ),
            style: TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: CachedNetworkImage(imageUrl: widget.postModel.src),
          ),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    return Container(
      constraints: BoxConstraints(maxHeight: Get.height * 0.6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: widget.postModel.thumbnail != null && !videoDone
            ? CachedNetworkImage(
                imageUrl: widget.postModel.thumbnail!,
                fit: BoxFit.cover,
              )
            : !videoDone
                ? SizedBox.shrink()
                : AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,
                    child: VideoPlayer(videoController!)),
      ),
    );
  }

  Container _buildHeaders() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            child: ClipOval(
              child: user == null
                  ? Icon(Icons.person)
                  : Image.network(
                      user!.profileImage!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.profileName ?? '',
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(user?.completName ?? '',
                    maxLines: 1, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.adaptive.more,
              color: Get.theme.primaryColor,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: TextButton.icon(
                onPressed: () => this.widget.controller.openChat(this.widget.postModel.userModel),
                icon: Text('Enviar mensagem'),
                label: Icon(Icons.send),
              ))
            ],
          )
        ],
      ),
    );
  }

  _setUserProfile(SesssionController controller) async {
    final currentUser = await controller.repository.getCurrentUser(widget.postModel.postedBy);
    this.user = currentUser;
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
