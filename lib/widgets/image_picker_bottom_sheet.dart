import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowme/controller/image_controller.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () => Get.back(result: ImageSource.camera),
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.camera_alt),
                ),
              ),
              Text('Camera')
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () => Get.back(result: ImageSource.gallery),
                child: CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.image),
                ),
              ),
              Text('Galeria')
            ],
          )
        ],
      ),
    );
  }

  static Future<Uint8List?> showImagePickerBottomSheet(BuildContext context) async {
    var source = await showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      context: context,
      builder: (context) => ImagePickerBottomSheet(),
    );
    if (source == null) return null;
    return await ImageController.pickImage(source);
  }
}
