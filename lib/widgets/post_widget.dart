import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/screens/image_screen.dart';
import 'package:knowme/screens/users_profile_screen.dart';
import 'package:knowme/screens/video_screen.dart';
import 'package:knowme/widgets/report_dialog.dart';
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

class _PostWidgetState extends State<PostWidget>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? videoController;
  UserModel? user;
  bool videoDone = false;
  final sessionController = Get.find<SesssionController>();

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
    return GetBuilder<SesssionController>(
      builder: (controller) => Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                _buildHeaders(),
                InkWell(
                  onDoubleTap: () => widget.postModel.mediaType == 1
                      ? Get.to(() => ImageScreen(
                            imageUrl: widget.postModel.src,
                            imageKey: Key(widget.postModel.id),
                            description: widget.postModel.description,
                            user: widget.postModel.userModel!,
                          ))
                      : Get.to(() => VideoScreen(
                            videoController: videoController,
                            src: widget.postModel.src,
                            controller: Get.find(),
                            isPrivate: false,
                            description: widget.postModel.description,
                            userModel: widget.postModel.userModel,
                          )),
                  child: widget.postModel.mediaType == 0
                      ? _buildVideo()
                      : _buildImage(),
                ),
                _buildBottom(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onvisibiltyChnage(info) {
    print(info.visibleFraction);
    if (info.visibleFraction <= 0.5) {
      videoController?.pause();
    } else if (info.visibleFraction > 0.92) {
      videoController?.play();
    }
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
                text:
                    TextSpan(style: TextStyle(color: Colors.black), children: [
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
                    child: VisibilityDetector(
                        onVisibilityChanged: _onvisibiltyChnage,
                        key: UniqueKey(),
                        child: InkWell(
                            onTap: _onvideoTap,
                            child: Stack(
                              children: [
                                VideoPlayer(videoController!),
                                Obx(() => Visibility(
                                    visible: volume.value == 0,
                                    child: Positioned(
                                        right: 8,
                                        bottom: 8,
                                        child: Icon(Icons.volume_off,
                                            color: Colors.white))))
                              ],
                            )))),
      ),
    );
  }

  Widget _buildHeaders() {
    return InkWell(
      onTap: _openUserProfile,
      child: Container(
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
                      maxLines: 1,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                ],
              ),
            ),
            if (user!.id! !=
                sessionController.userAuthRepository.getCurrentUser!.id)
              _buildPopUpMenu()
          ],
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> _buildPopUpMenu() {
    return PopupMenuButton<int>(
      padding: EdgeInsets.all(2),
      onSelected: _onselectPopUpMenu,
      icon: Icon(
        Icons.adaptive.more,
        color: Get.theme.primaryColor,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: ListTile(
              title: Text(
                'Enviar mensagem',
                style: GoogleFonts.openSans(fontSize: 14),
              ),
              trailing: Icon(Icons.send),
            )),
        PopupMenuItem(
            value: 1,
            child: ListTile(
                title: Text(
                  'Perfil',
                  style: GoogleFonts.openSans(fontSize: 14),
                ),
                trailing: Icon(Icons.person))),
        PopupMenuItem(
            value: 2,
            child: ListTile(
                title: Text(
                  'Denunciar',
                  style: GoogleFonts.openSans(fontSize: 14),
                ),
                trailing: Icon(Icons.report))),
        PopupMenuItem(
            value: 3,
            child: ListTile(
                title: Text(
                  'Bloquear Usuário',
                  style: GoogleFonts.openSans(fontSize: 14),
                ),
                trailing: Icon(Icons.block, color: Colors.red)))
      ],
    );
  }

  _setUserProfile(SesssionController controller) async {
    final currentUser =
        await controller.repository.getCurrentUser(widget.postModel.postedBy);
    this.user = currentUser;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  final volume = 1.0.obs;
  void _onvideoTap() {
    if (volume.value == 0) {
      videoController?.setVolume(1);
    } else {
      videoController?.setVolume(0);
    }

    volume.value = videoController?.value.volume ?? 0;
  }

  /// 0 open chat, 1 open user profile,3 is report,
  void _onselectPopUpMenu(value) {
    switch (value) {
      case 0:
        this.widget.controller.openChat(this.widget.postModel.userModel);

        break;
      case 1:
        if ((widget.postModel.userModel?.id ?? '') ==
            widget.controller.userAuthRepository.getCurrentUser?.id)
          widget.controller.pageController.jumpToPage(4);
        else
          _openUserProfile();
        break;
      case 2:
        ReportDialog.show(widget.postModel);
        break;
      case 3:
        sessionController.blockUser(widget.postModel.userModel!.id!);
        break;
      default:
    }
  }

  void _openUserProfile() {
    final session = Get.find<SesssionController>();
    if (widget.postModel.userModel!.id! ==
        session.userAuthRepository.getCurrentUser!.id!) {
      session.pageController.jumpToPage(4);
      return;
    }
    Get.to(() => UsersProfileScreen(userModel: widget.postModel.userModel!));
  }
}
