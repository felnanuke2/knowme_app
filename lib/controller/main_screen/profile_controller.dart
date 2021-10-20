import 'dart:typed_data';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/screens/complet_register_screen.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';

class ProfileController extends GetxController {
  final poststList = <PostModel>[].obs;
  final loadingProfileImage = false.obs;
  final loadingPosts = false.obs;
  final SesssionController sesssionController;
  final interactionSendCounter = 0.obs;
  final interactionReceivedCounter = 0.obs;
  ProfileController({
    required this.sesssionController,
  }) {
    refresh();
    getFriendsList();
  }
  getFriendsList() async {
    await sesssionController.repository.getFriends(
        sesssionController.userAuthRepository.getCurrentUser?.id ?? '');
  }

  void changeProfileImage() async {
    final pickedImage = await ImagePickerBottomSheet.showImagePickerBottomSheet(
      Get.context!,
      circular: true,
    );
    if (pickedImage == null) return;
    if (!(pickedImage is Uint8List)) return;
    try {
      final user = sesssionController.userAuthRepository.getCurrentUser!;
      loadingProfileImage.value = true;
      final imageUrl = await sesssionController.repository
          .upLoadImage(imageByte: pickedImage, userID: user.id!);

      await sesssionController.repository
          .updateUser(user.id!, profileImage: imageUrl);
      final lastImageProfile = user.profileImage;
      sesssionController.userAuthRepository.setCurrentUser = sesssionController
          .userAuthRepository.getCurrentUser!
        ..profileImage = imageUrl;
      sesssionController.repository.deletImage(lastImageProfile!);
    } catch (e) {
      print(e);
    }
    loadingProfileImage.value = false;
  }

  Future<void> refresh() async {
    countInteractios();
    loadingPosts.value = true;
    final post = await sesssionController.repository
        .getPosts([sesssionController.userAuthRepository.getCurrentUser!.id!]);
    poststList.clear();
    poststList.addAll(post);
    loadingPosts.value = false;
  }

  void editUserProfileIndos() async {
    final result = await Get.to(() => CompletRegisterScreen(
          userModel: sesssionController.userAuthRepository.getCurrentUser,
        ));
    if (result != null) {
      update();
    }
  }

  void updateUserProfile() {}

  countInteractios() async {
    try {
      final response = await sesssionController.repository.countInteractions();
      interactionSendCounter.value = response['send'];
      interactionReceivedCounter.value = response['received'];
    } catch (e) {
      print(e.toString());
    }
  }
}
