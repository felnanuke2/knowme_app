import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/ui/sound_player_ui.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:knowme/controller/chat_controler.dart';

class RecorderTile extends StatefulWidget {
  RecorderTile({
    Key? key,
    required this.controller,
    required this.otherUserId,
    required this.roomId,
  }) : super(key: key);

  final ChatController controller;
  final String otherUserId;
  final int roomId;

  @override
  State<RecorderTile> createState() => _RecorderTileState();
}

class _RecorderTileState extends State<RecorderTile> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      duration.value = DateTime.fromMillisecondsSinceEpoch(
          duration.value.millisecondsSinceEpoch + Duration(seconds: 1).inMilliseconds);
    });
    super.initState();
  }

  final image = AssetImage('assets/playng_music.gif');

  final duration = DateTime(0).obs;
  final isPaused = false.obs;
  String? path;

  @override
  Widget build(BuildContext context) {
    image.evict();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(() => !isPaused.value
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: widget.controller.deletAudio,
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ))),
          Expanded(
              child:
                  Obx(() => isPaused.value ? SoundPlayerUI.fromLoader(_load) : SizedBox.shrink())),
          Obx(() => isPaused.value
              ? SizedBox.shrink()
              : Container(
                  height: 35,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.mode(Get.theme.primaryColor, BlendMode.srcIn),
                      child: Image(
                        image: image,
                      )))),
          Obx(() => isPaused.value
              ? SizedBox.shrink()
              : Text(formatDate(duration.value, [nn, ':', ss]),
                  style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600))),
          Obx(() => isPaused.value
              ? SizedBox.shrink()
              : IconButton(onPressed: _stopRecoreder, icon: Icon(Icons.stop_rounded))),
          Obx(() => !isPaused.value
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () => widget.controller.sendAudio(widget.otherUserId, widget.roomId),
                  icon: Icon(
                    Icons.send,
                    color: Get.theme.primaryColor,
                  )))
        ],
      ),
    );
  }

  Future<Track> _load(BuildContext context) async {
    final track = Track(trackPath: path);
    return track;
  }

  void _stopRecoreder() async {
    path = await widget.controller.stopRecorder();
    if (path == null) return;
    isPaused.value = true;
  }
}
