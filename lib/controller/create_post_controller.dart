import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';

import 'package:knowme/models/post_model.dart';
import 'package:get/route_manager.dart';

class CreatePostController extends GetxController {
  final SesssionController sesssionController;
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CreatePostController({
    required this.sesssionController,
  });
  void createpost(dynamic src) async {
    if (!formKey.currentState!.validate()) return;
    bool isVideo = false;
    final userId = sesssionController.userAuthRepository.currentUser!.id!;
    String srcUrl = '';
    if (src is String) {
      isVideo = true;
      final video = File(src);
      srcUrl = await sesssionController.repository.uploadVideo(video, userId);
    } else {
      final url = await sesssionController.repository.upLoadImage(imageByte: src, userID: userId);
      srcUrl = url!;
    }

    final post = PostModel(
        id: '',
        postedBy: userId,
        mediaType: isVideo ? 0 : 1,
        src: srcUrl,
        viewedBy: [],
        createAt: DateTime.now(),
        description: descriptionController.text);

    final postid = await sesssionController.repository.createpost(post);
    Get.back();
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty) return 'Insira uma descirção';
    return null;
  }
}
