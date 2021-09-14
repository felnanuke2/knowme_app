import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'package:knowme/services/image_service.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    Key? key,
    this.videoAvaliable = false,
  }) : super(key: key);
  final bool videoAvaliable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: videoAvaliable ? 320 : 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () =>
                        Get.back(result: PickerType(source: ImageSource.camera, video: false)),
                    child: CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Imagem da Camera')
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () =>
                        Get.back(result: PickerType(source: ImageSource.gallery, video: false)),
                    child: CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.image),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Imagem da Galeria')
                ],
              )
            ],
          ),
          if (videoAvaliable)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () =>
                          Get.back(result: PickerType(source: ImageSource.camera, video: true)),
                      child: CircleAvatar(
                        radius: 35,
                        child: Icon(Icons.video_call),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Video da Camera')
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () =>
                          Get.back(result: PickerType(source: ImageSource.gallery, video: true)),
                      child: CircleAvatar(
                        radius: 35,
                        child: Icon(Icons.video_collection),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Video da Galeria')
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }

  static Future<dynamic> showImagePickerBottomSheet(BuildContext context,
      {double? ratioX, double? ratioY, bool circular = false, bool video = false}) async {
    var source = await showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      context: context,
      builder: (context) => ImagePickerBottomSheet(
        videoAvaliable: video,
      ),
    );
    if (source == null) return null;
    if (source is PickerType) {
      if (source.video) {
        return await ImageServices.pickVideo(source.source);
      } else {
        return await ImageServices.pickImage(source.source,
            circular: circular, ratioX: ratioX, ratioY: ratioY);
      }
    }
  }
}

class PickerType {
  final ImageSource source;
  final bool video;
  PickerType({
    required this.source,
    required this.video,
  });
}
