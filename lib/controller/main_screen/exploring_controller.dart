import 'package:flutter/material.dart';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/answer_quiz_scree.dart';
import 'package:knowme/screens/users_profile_screen.dart';
import 'package:knowme/widgets/exploring_search_delegate.dart';
import 'package:get/instance_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ExploringController extends GetxController {
  final SesssionController sessionController;
  ExploringController({
    required this.sessionController,
  }) {
    sessionController.getListOfQuizes();
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pageController = PageController();
  var _selectedSex = Sex.NONE;
  final _sexTEC = TextEditingController(text: 'Todos');
  set selectedSex(Sex sex) {
    _selectedSex = sex;
    _sexTEC.text = replaceSexForString(sex);
  }

  TextEditingController get getSelectedSex => _sexTEC;

  final distanceTEC = TextEditingController(text: '50');
  final distanceMask =
      MaskTextInputFormatter(mask: '######', filter: {'#': RegExp('[0-9]')});
  void openSearch() async {
    final result = await showSearch(
        context: Get.context!,
        delegate: ExploringSearchDelegate(controller: this));
    if (result == null) return;
    if (result is UserModel) {
      if (result.id !=
          sessionController.userAuthRepository.getCurrentUser?.id) {
        await Future.delayed(Duration(seconds: 1));
        Get.to(() => UsersProfileScreen(userModel: result));
      } else {
        sessionController.pageController.jumpToPage(3);
      }
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    final usersList = await sessionController.repository.searchUsers(query);
    return usersList;
  }

  void passQuiz() {
    pageController.nextPage(
        duration: Duration(milliseconds: 350), curve: Curves.easeInExpo);
    final quiz =
        sessionController.quizesToAnswer.removeAt(pageController.page!.round());
    sessionController.repository.passQuiz(int.parse(quiz.id!));
  }

  answerQuiz(EntryQuizModel quiz) async {
    final result = await Get.to(() => AnswerQuizScreen(
          quiz: quiz,
        ));
    if (result != null) sessionController.quizesToAnswer.remove(quiz);
  }

  void openFilterDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void setNewFilters() {
    sessionController.getListOfQuizes(
        maxDistance: double.parse(distanceTEC.text), sex: _selectedSex);
    Get.back();
  }

  DateTime? lastSearch;
  reFindUser() {
    if (lastSearch != null &&
        lastSearch!.difference(DateTime.now()).inSeconds > -30) return;
    print('timmer = ');
    print(lastSearch?.difference(DateTime.now()).inSeconds);
    lastSearch = DateTime.now();

    setNewFilters();
  }

  var sexMap = {Sex.NONE: 'Todos', Sex.MALE: 'Homens', Sex.FEMALE: 'Mulheres'};
  String replaceSexForString(Sex sex) {
    return sexMap[sex]!;
  }
}
