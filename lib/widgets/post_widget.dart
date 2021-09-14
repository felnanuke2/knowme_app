import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:video_player/video_player.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:get/state_manager.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.postModel,
    required this.currentIndex,
    required this.thisIndex,
  }) : super(key: key);
  final PostModel postModel;
  final RxInt currentIndex;
  final int thisIndex;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? videoController;
  UserModel? user;

  @override
  void initState() {
    if (widget.postModel.mediaType == 0) {
      videoController = VideoPlayerController.network(widget.postModel.src);
      videoController!.initialize().then((value) {
        setState(() {});
      });
      videoController?.setLooping(true);
      videoController?.play();
    }
    _setUserProfile(Get.find());
    widget.currentIndex.listen((index) {
      if (index != widget.thisIndex)
        videoController?.pause();
      else
        videoController?.play();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SesssionController>(
      builder: (controller) => Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Row(
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
                  Text(user?.profileName ?? ''),
                ],
              ),
            ),
            if (widget.postModel.mediaType == 0)
              AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: AspectRatio(
                      aspectRatio: videoController!.value.aspectRatio,
                      child: VideoPlayer(videoController!)),
                ),
              )
            else
              AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: CachedNetworkImage(imageUrl: widget.postModel.src),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(
                    user?.completName ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.postModel.description),
                ],
              ),
            ),
          ],
        ),
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
