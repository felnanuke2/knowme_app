import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/ui/sound_player_ui.dart';

import 'package:get/route_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';

class AudioMessageTile extends StatefulWidget {
  final String audioPath;
  final SesssionController controller;
  const AudioMessageTile({
    Key? key,
    required this.audioPath,
    required this.controller,
  }) : super(key: key);

  @override
  State<AudioMessageTile> createState() => _AudioMessageTileState();
}

class _AudioMessageTileState extends State<AudioMessageTile>
    with AutomaticKeepAliveClientMixin {
  var _future;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: SoundPlayerUI.fromLoader(
      _loader,
      audioFocus: AudioFocus.requestFocusAndDuckOthers,
      showTitle: false,
      textStyle: TextStyle(color: Colors.white),
      iconColor: Colors.white,
      backgroundColor: Get.theme.primaryColor,
      sliderThemeData: SliderThemeData(
          inactiveTrackColor: Colors.grey,
          activeTrackColor: Colors.white,
          activeTickMarkColor: Colors.white,
          valueIndicatorColor: Colors.white,
          overlayColor: Colors.white,
          overlappingShapeStrokeColor: Colors.white,
          inactiveTickMarkColor: Colors.white,
          disabledActiveTickMarkColor: Colors.white,
          thumbColor: Colors.white),
    ));
  }

  Future<Track> _loader(BuildContext context) async {
    final track = Track(
        trackPath:
            await widget.controller.repository.getImageUrl(widget.audioPath));
    return track;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
