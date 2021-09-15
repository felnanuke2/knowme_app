import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/screens/complet_register_screen.dart';
import 'package:knowme/screens/create_post_screen.dart';
import 'package:knowme/screens/settings/quiz/quiz_settings_screen.dart';
import 'package:knowme/screens/settings/settings_screen.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';

class SesssionController extends GetxController {
  var pageController = PageController();
  RxInt currentPage = 0.obs;
  final DbRepositoryInterface repository;
  final UserAuthInterface userAuthRepository;
  final interactionsSend = <InteractionsModel>[].obs;
  final interactionsReceived = <InteractionsModel>[].obs;
  final posts = <PostModel>[].obs;

  bool isLoadingCurrentUser = true;

  SesssionController({
    required this.repository,
    required this.userAuthRepository,
  }) {
    _initUserData();
    getPosts();
  }
  _initUserData() async {
    if (userAuthRepository.currentUserdataCompleter.isCompleted) {
      isLoadingCurrentUser = false;
      update();
      await Future.delayed(Duration(milliseconds: 333));
      if (_verifyIfNeedCompletProfile() == true) return;
    } else {
      await userAuthRepository.currentUserdataCompleter.future;
      if (_verifyIfNeedCompletProfile() == true) return;
      await Future.delayed(Duration(milliseconds: 333));
      isLoadingCurrentUser = false;
      update();
    }
    if (userAuthRepository.currentUser?.entryQuizID == null) _requestQuizCompletationDialog();
  }

  _verifyIfNeedCompletProfile() {
    if (userAuthRepository.currentUser?.profileComplet == false) {
      Get.off(() => CompletRegisterScreen());
      return true;
    }
  }

  void onPageChange(int value) {
    pageController.animateToPage(value,
        duration: Duration(milliseconds: 450), curve: Curves.decelerate);
    currentPage.value = value;
  }

  void onSettingsPressed() {
    router.Get.to(() => SettingsScreen());
  }

  void _requestQuizCompletationDialog() async {
    await Future.delayed(Duration(seconds: 2));
    Get.dialog(SingleChildScrollView(
      child: AlertDialog(
        title: Text('Parece que você ainda não criou seu quiz de entrada.'),
        content: Text('Para que os outros usuários possam te encontrar é necessário completa-lo.'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                Get.to(() => QuizSettingsScren());
              },
              child: Text('Completar Quiz'))
        ],
      ),
    ));
  }

  void createPost() async {
    final image =
        await ImagePickerBottomSheet.showImagePickerBottomSheet(Get.context!, video: true);
    if (image == null) return;
    Get.to(() => CreatePostScreen(
          src: image,
        ));
  }

  Future<void> getPosts() async {
    print('helloworld');
    final result = await repository.getPosts(aceptedInteractions.map((e) => e.id).toList()
      ..add(this.userAuthRepository.currentUser?.id ?? '06546313153'));
    posts.clear();
    posts.addAll(result);
    return;
  }

  List<InteractionsModel> get aceptedInteractions =>
      interactionsSend.where((element) => element.status == 1).toList();
}