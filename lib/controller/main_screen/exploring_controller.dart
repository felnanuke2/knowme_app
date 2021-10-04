import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/users_profile_screen.dart';
import 'package:knowme/widgets/exploring_search_delegate.dart';
import 'package:get/instance_manager.dart';

class ExploringController extends GetxController {
  final SesssionController sesssionController;
  ExploringController({
    required this.sesssionController,
  });
  void openSearch() async {
    final result = await showSearch(
        context: Get.context!, delegate: ExploringSearchDelegate(controller: this));
    if (result == null) return;
    if (result is UserModel) {
      if (result.id != sesssionController.userAuthRepository.getCurrentUser?.id) {
        await Future.delayed(Duration(seconds: 1));
        Get.to(() => UsersProfileScreen(userModel: result));
      } else {
        sesssionController.pageController.jumpToPage(3);
      }
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    final usersList = await sesssionController.repository.searchUsers(query);
    return usersList;
  }
}
