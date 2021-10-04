import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/models/question_model.dart';

class AnswerQuizController extends GetxController {
  final EntryQuizModel quiz;
  final answersMap = <String, dynamic>{}.obs;
  final SesssionController sesssionController;
  final loading = false.obs;

  AnswerQuizController({
    required this.quiz,
    required this.sesssionController,
  });

  selectAnser(String answer, String enunciation, QuestionType type) {
    if (type == QuestionType.MultipleChoice) {
      if (answersMap[enunciation] == null) answersMap[enunciation] = [];
      if ((answersMap[enunciation] as List).contains(answer)) {
        (answersMap[enunciation] as List).remove(answer);
      } else {
        (answersMap[enunciation] as List).add(answer);
      }
    } else {
      answersMap[enunciation] = answer;
    }
    answersMap[enunciation] = answersMap[enunciation];
  }

  void sendAsnwers() async {
    if (!_checkAnsers()) return;
    try {
      loading.value = true;
      final interaction = InteractionsModel(
          id: '',
          status: 0,
          fromUser: sesssionController.userAuthRepository.getCurrentUser?.id ?? '',
          toUser: quiz.user?.id ?? '',
          createdAt: DateTime.now(),
          answers: answersMap);
      await sesssionController.repository.sendInteraction(interaction);
      loading.value = false;
      Get.back(result: true);
    } on RequestError catch (e) {
      _callErrorSnackBar(title: 'Erro', message: e.message ?? '');
    }
  }

  bool _checkAnsers() {
    bool isValid = true;
    quiz.questions.forEach((question) {
      if (answersMap[question.enunciation] == null) {
        isValid = false;
        _callErrorSnackBar(
          title: 'a pergunta \"${question.enunciation}\" ainda não foi respondida',
          message: 'Responda para prosseguir',
        );
      }
    });
    return isValid;
  }

  _callErrorSnackBar({required String title, required String message}) {
    Get.snackbar(title, message,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(8),
        icon: CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.close),
        ),
        backgroundColor: Colors.white,
        barBlur: 0,
        snackStyle: SnackStyle.FLOATING);
  }
}
