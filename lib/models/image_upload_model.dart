import 'dart:typed_data';

class ImageUploadModel {
  Uint8List? byteImage;
  String? imageUrl;
  ImageUploadModel({
    this.byteImage,
    this.imageUrl,
  });
}
