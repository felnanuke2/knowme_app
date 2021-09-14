import 'package:camerawesome/models/flashmodes.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import 'package:knowme/controller/camera_controller.dart';

class CameraUiWidget extends StatelessWidget {
  const CameraUiWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            right: 16,
            top: 20,
            child: Obx(() => Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            controller.videoDuration.value.millisecondsSinceEpoch % 2 == 1
                                ? Colors.red
                                : Colors.transparent,
                        radius: 3,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        _getFormatedDate(controller.videoDuration.value),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ))),
        Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 380),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _pickFlashIcon(),
                    Obx(() => InkWell(
                          onTap: controller.isRec.value
                              ? controller.onVideoRecStop
                              : controller.onGetPicture,
                          onLongPress: controller.onVideoRecStart,
                          child: CircleAvatar(
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: controller.isRec.value ? Colors.red : Colors.white,
                            ),
                            radius: 30,
                          ),
                        )),
                    InkWell(
                      onTap: controller.onSensorChange,
                      child: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor.withOpacity(0.2),
                        child: Icon(Icons.cameraswitch_outlined),
                        radius: 18,
                      ),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _pickFlashIcon() {
    ValueNotifier<CameraFlashes> switchFlash = controller.switchFlash;
    Widget? flashIcon;

    return ValueListenableBuilder(
        valueListenable: switchFlash,
        builder: (context, value, child) {
          switch (switchFlash.value) {
            case CameraFlashes.AUTO:
              flashIcon = Icon(Icons.flash_auto);
              break;
            case CameraFlashes.ALWAYS:
              flashIcon = Icon(Icons.flash_on_rounded);
              break;
            case CameraFlashes.NONE:
              flashIcon = Icon(Icons.flash_off);
              break;

            default:
              flashIcon = Icon(Icons.flash_on);
          }
          return InkWell(
            onTap: controller.onFlashChange,
            child: CircleAvatar(
              backgroundColor: Get.theme.primaryColor.withOpacity(0.2),
              child: flashIcon,
              radius: 18,
            ),
          );
        });
  }

  String _getFormatedDate(DateTime datetime) {
    final date = formatDate(datetime, [HH, ':', nn]);
    if (date == '00:00') return '';

    return date;
  }
}
