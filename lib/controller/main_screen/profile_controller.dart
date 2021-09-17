import 'dart:typed_data';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/screens/complet_register_screen.dart';
import 'package:knowme/screens/edit_profile_infos_screen.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';

class ProfileController extends GetxController {
  final poststList = <PostModel>[].obs;
  final loadingProfileImage = false.obs;
  final loadingPosts = false.obs;
  final SesssionController sesssionController;
  ProfileController({
    required this.sesssionController,
  }) {
    getMyPosts();
  }

  void changeProfileImage() async {
    final pickedImage = await ImagePickerBottomSheet.showImagePickerBottomSheet(
      Get.context!,
      circular: true,
    );
    if (pickedImage == null) return;
    if (!(pickedImage is Uint8List)) return;
    try {
      final user = sesssionController.userAuthRepository.currentUser!;
      loadingProfileImage.value = true;
      final imageUrl =
          await sesssionController.repository.upLoadImage(imageByte: pickedImage, userID: user.id!);

      await sesssionController.repository.updateUser(user.id!, profileImage: imageUrl);
      final lastImageProfile = user.profileImage;
      sesssionController.userAuthRepository.currentUser!.profileImage = imageUrl;
      sesssionController.repository.deletImage(lastImageProfile!);
    } catch (e) {
      print(e);
    }
    loadingProfileImage.value = false;
  }

  Future<void> getMyPosts() async {
    loadingPosts.value = true;
    final post = await sesssionController.repository
        .getPosts([sesssionController.userAuthRepository.currentUser!.id!]);
    poststList.clear();
    poststList.addAll(post);
    loadingPosts.value = false;
  }

  void editUserProfileIndos() async {
    final result = await Get.to(() => CompletRegisterScreen(
          userModel: sesssionController.userAuthRepository.currentUser,
        ));
    if (result != null) {
      update();
    }
  }

  void updateUserProfile() {}
}
