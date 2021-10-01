import 'dart:io';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knowme/models/image_upload_model.dart';

class ImageServices {
  static final _imagePicker = ImagePicker();

  static Future<Uint8List?> pickImage(ImageSource source,
      {double? ratioX, double? ratioY, bool circular = false}) async {
    var picked = await _imagePicker.pickImage(source: source);
    if (picked == null) return null;

    var byteImage = await picked.readAsBytes();
    var cropedImage = cropImage(byteImage, ratioX: ratioX, ratioY: ratioY, circular: circular);
    return cropedImage;
  }

  static Future<void> pickMultipleImage(List<ImageUploadModel> imageList,
      {double? ratioX, double? ratioY, bool circular = false}) async {
    var picked = await _imagePicker.pickMultiImage();
    if (picked == null) return null;

    for (var image in picked) {
      var imageByte = await image.readAsBytes();
      var cropedImage =
          await cropImage(imageByte, ratioX: ratioX, ratioY: ratioY, circular: circular);
      if (cropedImage == null) return;
      imageList.add(ImageUploadModel(byteImage: cropedImage));
    }
    return;
  }

  static Future<Uint8List?> cropImage(Uint8List imageByte,
      {double? ratioX, double? ratioY, bool circular = false}) async {
    var file = File(Directory.systemTemp.path + '/' + DateTime.now().toString());
    await file.writeAsBytes(imageByte);
    await file.create();
    var cropedImage = await ImageCropper.cropImage(
        aspectRatio: ratioY != null && ratioX != null
            ? CropAspectRatio(ratioX: ratioX, ratioY: ratioY)
            : null,
        sourcePath: file.path,
        cropStyle: circular ? CropStyle.circle : CropStyle.rectangle,
        androidUiSettings: AndroidUiSettings(toolbarTitle: 'Cortar imagem'),
        iosUiSettings: IOSUiSettings(title: 'Cortar Image'));
    var byte = cropedImage?.readAsBytes();
    await cropedImage?.delete();
    await file.delete();
    return byte;
  }

  static Future<dynamic> pickVideo(ImageSource source) async {
    final pickedVideo =
        await _imagePicker.pickVideo(source: source, preferredCameraDevice: CameraDevice.front);
    if (pickedVideo == null) return;

    return pickedVideo.path;
  }
}
