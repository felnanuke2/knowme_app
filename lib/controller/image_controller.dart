import 'dart:io';
import 'dart:typed_data';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageController {
  static Future<Uint8List?> pickImage(ImageSource source) async {
    var picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return null;

    var byteImage = await picked.readAsBytes();
    var cropedImage = _cropImage(byteImage);
    return cropedImage;
  }

  static Future<Uint8List?> _cropImage(Uint8List imageByte) async {
    var file = File(Directory.systemTemp.path + '/' + DateTime.now().toString());
    await file.writeAsBytes(imageByte);
    await file.create();
    var cropedImage = await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: file.path,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(toolbarTitle: 'Cortar imagem'),
        iosUiSettings: IOSUiSettings(title: 'Cortar Image'));
    var byte = cropedImage?.readAsBytes();
    await cropedImage?.delete();
    await file.delete();
    return byte;
  }
}
