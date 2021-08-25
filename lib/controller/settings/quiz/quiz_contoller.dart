import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';
import 'package:knowme/controller/settings/quiz/create_update_question_controller.dart';

import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/question_model.dart';
import 'package:knowme/screens/settings/quiz/create_update_question_scree.dart';

class QuizController extends GetxController {
  EntryQuizModel? quizModel;
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  QuizController({
    this.quizModel,
  }) {
    if (quizModel != null) questions.addAll(quizModel!.questions);
  }

  void onNewQuizPressed() async {
    var question = await router.Get.to(() => CreateUpdateQuestionScreen());
    if (question == null) return;
    questions.add(question);
  }

  void onTapQuestionTile(int index, QuestionModel questionModel) async {
    var question = await router.Get.to(() => CreateUpdateQuestionScreen(
          questionModel: questionModel,
        ));
    if (question == null) return;
    questions[index] = (question);
  }

  onDeletQuestionPressed(List<QuestionModel> questionList, QuestionModel questionItem) async {
    var result = await router.Get.dialog(AlertDialog(
      title: Text('Deseja remover essa pergunta??'),
      actions: [
        TextButton(
            onPressed: Get.back,
            child: Text(
              'Não',
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Sim',
              style: TextStyle(color: Colors.green),
            ))
      ],
    ));
    if (result != null) questionList.remove(questionItem);
  }
}
