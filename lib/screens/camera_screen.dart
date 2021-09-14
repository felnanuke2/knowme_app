import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/camera_controller.dart';
import 'package:knowme/widgets/camera/camera_ui.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraController>(
      init: CameraController(),
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraAwesome(
                testMode: false,
                selectDefaultSize: (List<Size> availableSizes) => availableSizes.first,
                onCameraStarted: controller.opCameraStarted,
                orientation: controller.orientation,
                onPermissionsResult: controller.onPermissionresult,
                onOrientationChanged: controller.onOrientationChanged,
                sensor: controller.sensor,
                photoSize: controller.photoSize,
                switchFlashMode: controller.switchFlash,
                captureMode: controller.captureMode,
                fitted: false,
              ),
              CameraUiWidget(controller: controller)
            ],
          ),
        ),
      ),
    );
  }
}
