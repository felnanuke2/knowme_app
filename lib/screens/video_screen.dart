import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:video_player/video_player.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';

// ignore: must_be_immutable
class VideoScreen extends StatefulWidget {
  bool isPrivate;
  String src;
  SesssionController controller;
  VideoScreen({
    Key? key,
    this.isPrivate = true,
    required this.src,
    required this.controller,
  }) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  var _future;
  late FlickManager _flickManager;
  @override
  void initState() {
    if (widget.isPrivate) _future = widget.controller.repository.getImageUrl(widget.src);
    super.initState();
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<String>(
            future: widget.isPrivate ? _future : null,
            initialData: widget.src,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return LinearProgressIndicator();
              _flickManager = FlickManager(
                  videoPlayerController: VideoPlayerController.network(snapshot.data!));
              return FlickVideoPlayer(flickManager: _flickManager);
            },
          ),
          Positioned(
              top: 40,
              left: 4,
              child: BackButton(
                color: Get.theme.primaryColor,
              )),
        ],
      ),
    );
  }
}
