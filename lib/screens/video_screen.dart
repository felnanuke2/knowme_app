import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/users_profile_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class VideoScreen extends StatefulWidget {
  bool isPrivate;
  String src;
  SesssionController controller;
  String? description;
  UserModel? userModel;
  VideoPlayerController? videoController;

  VideoScreen({
    Key? key,
    this.isPrivate = true,
    required this.src,
    required this.controller,
    this.description,
    this.userModel,
    this.videoController,
  }) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  var _future;
  late FlickManager _flickManager;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.isPrivate)
      _future = widget.controller.repository.getImageUrl(widget.src);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.videoController == null) _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(),
      ),
      endDrawer: widget.isPrivate
          ? null
          : IgnorePointer(
              child: Container(
                width: Get.width * 0.7,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 100),
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: widget.userModel!.profileName! + '# ',
                            style: GoogleFonts.montserrat(
                                color: Get.theme.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.back();
                                Get.to(() => UsersProfileScreen(
                                    userModel: widget.userModel!));
                              }),
                        TextSpan(
                          text: widget.description!,
                          style: GoogleFonts.openSans(
                              color: Colors.white, fontSize: 14),
                        )
                      ])),
                    )
                  ],
                ),
              ),
            ),
      backgroundColor: Colors.black,
      body: FutureBuilder<String>(
        future: widget.isPrivate ? _future : null,
        initialData: widget.src,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LinearProgressIndicator();
          _flickManager = FlickManager(
              videoPlayerController: widget.videoController ??
                  VideoPlayerController.network(snapshot.data!),
              onVideoEnd: _onVideoEnd);

          return VisibilityDetector(
            key: UniqueKey(),
            onVisibilityChanged: _onvisibilityChange,
            child: FlickVideoPlayer(
              flickManager: _flickManager,
            ),
          );
        },
      ),
    );
  }

  _onVideoEnd() {
    if (!widget.isPrivate) {
      scaffoldKey.currentState?.openEndDrawer();
    }
  }

  void _onvisibilityChange(VisibilityInfo info) {
    if (info.visibleFraction > 0.7) widget.videoController?.play();
  }
}
