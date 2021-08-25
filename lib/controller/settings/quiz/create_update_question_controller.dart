import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/models/question_model.dart';

class CreateUpdateQuestionController extends GetxController {
  final questionType = QuestionType.None.obs;
  final enunciationController = TextEditingController();
  final answerAddFormKey = GlobalKey<FormState>();
  final answerTEC = TextEditingController();

  final answers = <String>[].obs;
  final correctAnswers = <String>[].obs;

  void onRadioChanged(QuestionType? value) {
    if (value == questionType.value) questionType.value = QuestionType.None;
    questionType.value = value!;
  }

  void showMoreQuestionsType() {
    questionType.value = QuestionType.None;
  }

  void onPressAddAnswerButton() {
    if (!answerAddFormKey.currentState!.validate()) return;
    if (questionType.value == QuestionType.MultipleChoice) answers.add(answerTEC.text);
    answerTEC.clear();
  }

  String? validateAnswerField(String? value) {
    if (value!.isEmpty) return 'Insira uma resposta';
    return null;
  }

  onDeletAnser(RxList<String> answerList, int index) {
    answerList.removeAt(index);
  }
}
