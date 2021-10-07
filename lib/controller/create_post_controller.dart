import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/post_model.dart';
import 'package:get/route_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatePostController extends GetxController {
  final SesssionController sesssionController;
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CreatePostController({
    required this.sesssionController,
  });

  final loading = false.obs;
  void createpost(dynamic src) async {
    if (!formKey.currentState!.validate()) return;
    bool isVideo = false;
    final userId = sesssionController.userAuthRepository.getCurrentUser!.id!;
    String srcUrl = '';
    String? thumnail;
    loading.value = true;
    if (src is String) {
      try {
        final thumbData =
            await VideoThumbnail.thumbnailData(video: src, quality: 60, maxWidth: 360);

        thumnail =
            await sesssionController.repository.upLoadImage(imageByte: thumbData!, userID: userId);
      } catch (e) {
        print('faill to upload thumnaill');
      }

      isVideo = true;
      final video = File(src);
      srcUrl = await sesssionController.repository.uploadVideo(video, userId);
    } else {
      final url = await sesssionController.repository.upLoadImage(imageByte: src, userID: userId);
      srcUrl = url;
    }
    final post = PostModel(
        id: '',
        postedBy: userId,
        mediaType: isVideo ? 0 : 1,
        src: srcUrl,
        viewedBy: [],
        thumbnail: thumnail,
        createAt: DateTime.now(),
        description: descriptionController.text);

    await sesssionController.repository.createpost(post);
    loading.value = false;
    sesssionController.getPosts();
    Get.back();
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty) return 'Insira uma descrição';
    return null;
  }
}
