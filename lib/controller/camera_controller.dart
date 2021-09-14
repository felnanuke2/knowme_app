import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/services/image_service.dart';
import 'package:video_trimmer/video_trimmer.dart';

class CameraController extends GetxController {
  final videoDuration = DateTime.now().obs;
  final _trimmerController = Trimmer();
  final isRec = false.obs;
  final _videoController = VideoController();
  final _pictureController = PictureController();
  final orientation = DeviceOrientation.portraitUp;

  final sensor = ValueNotifier<Sensors>(Sensors.FRONT);

  final photoSize = ValueNotifier<Size>(Size(1920, 1080));

  final switchFlash = ValueNotifier<CameraFlashes>(CameraFlashes.AUTO);

  final captureMode = ValueNotifier<CaptureModes>(CaptureModes.PHOTO);

  void onOrientationChanged(CameraOrientations? orientatitionReceived) {
    if (orientatitionReceived == null) return;
  }

  void onPermissionresult(bool? result) {
    print('permissionResult = ' + result.toString());
  }

  void opCameraStarted() {
    update();
  }

  void onGetPicture() async {
    final imagePath = Directory.systemTemp.path + '/${DateTime.now()}.png';
    await _pictureController.takePicture(imagePath);
    final file = File(imagePath);

    final cropedImage = await ImageServices.cropImage(await file.readAsBytes());
    if (cropedImage == null) return;
    //sendSrcToPostScreen
  }

  String? lastVideo;
  Timer? videoTimer;
  void onVideoRecStart() async {
    lastVideo = Directory.systemTemp.path + '/${DateTime.now()}.mp4';
    captureMode.value = CaptureModes.VIDEO;
    return;
    await _videoController.recordVideo(lastVideo!);
    isRec.value = true;
    videoDuration.value = DateTime(0);
    Timer.periodic(Duration(seconds: 1), (timer) {
      videoTimer = timer;
      videoDuration.value = DateTime.fromMicrosecondsSinceEpoch(
          videoDuration.value.microsecondsSinceEpoch + Duration(seconds: 1).inMilliseconds);
    });
  }

  void onVideoRecStop() async {
    await _videoController.stopRecordingVideo();
    isRec.value = false;
    lastVideo = null;
    videoTimer?.cancel();
    videoTimer = null;
    captureMode.value = CaptureModes.PHOTO;
  }

  void onSensorChange() {
    if (sensor.value == Sensors.FRONT) {
      sensor.value = Sensors.BACK;
    } else {
      sensor.value = Sensors.FRONT;
    }
  }

  void onFlashChange() {
    int currentFlashMode = CameraFlashes.values.indexOf(switchFlash.value);
    if (switchFlash.value == CameraFlashes.values.last) {
      currentFlashMode = 0;
    } else {
      currentFlashMode++;
    }
    switchFlash.value = CameraFlashes.values[currentFlashMode];
  }
}
