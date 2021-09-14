import 'package:camerawesome/video_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerEditorScreen extends StatefulWidget {
  const TrimmerEditorScreen({
    Key? key,
    required this.trimmer,
  }) : super(key: key);
  final Trimmer trimmer;

  @override
  _TrimmerEditorScreenState createState() => _TrimmerEditorScreenState();
}

class _TrimmerEditorScreenState extends State<TrimmerEditorScreen> {
  bool play = false;
  double startvalue = 0;
  double endValue = 0;

  @override
  void dispose() {
    widget.trimmer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.trimmer.loadVideo(videoFile: widget.trimmer.currentVideoFile!).then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Vídeo'),
          actions: [
            TextButton.icon(
                onPressed: () async {
                  final path = await widget.trimmer.saveTrimmedVideo(
                      startValue: startvalue,
                      endValue: endValue,
                      videoFileName: DateTime.now().microsecondsSinceEpoch.toString());
                  Get.back(result: path);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text(
                  'Concluir',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
                child: Container(
              child: Center(
                child: AspectRatio(
                    aspectRatio: widget.trimmer.videoPlayerController!.value.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(widget.trimmer.videoPlayerController!),
                        Center(
                          child: IconButton(
                            padding: EdgeInsets.all(20),
                            icon: Icon(
                              play ? Icons.pause_circle : Icons.play_arrow_rounded,
                              color: Get.theme.primaryColor,
                              size: 60,
                            ),
                            onPressed: () {
                              widget.trimmer
                                  .videPlaybackControl(startValue: startvalue, endValue: endValue);
                            },
                          ),
                        )
                      ],
                    )),
              ),
            )),
            TrimEditor(
              onChangeEnd: (endValue) {
                this.endValue = endValue;
              },
              onChangePlaybackState: (isPlaying) {
                play = isPlaying;
                setState(() {});
              },
              onChangeStart: (startValue) {
                this.startvalue = startValue;
              },
              thumbnailQuality: 90,
              viewerHeight: 50,
              viewerWidth: Get.width,
              trimmer: widget.trimmer,
              maxVideoLength: Duration(seconds: 45),
            ),
          ],
        ));
  }
}
