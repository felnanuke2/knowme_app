import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/models/question_model.dart';
import 'package:get/route_manager.dart' as router;

class CreateUpdateQuestionController extends GetxController {
  CreateUpdateQuestionController({QuestionModel? questionModel}) {
    if (questionModel != null) {
      questionType.value = questionModel.questionType;
      enunciationController.text = questionModel.enunciation;
      answers.addAll(questionModel.answers ?? []);
      correctAnswers.addAll(questionModel.correctAnser ?? []);
    }
  }
  final questionType = QuestionType.None.obs;
  final enunciationController = TextEditingController();
  final enunciationFormKey = GlobalKey<FormState>();
  final answerAddFormKey = GlobalKey<FormState>();
  final answerTEC = TextEditingController();
  final answers = <String>[].obs;
  final correctAnswers = <String>[].obs;

  void onRadioChanged(QuestionType? value) {
    if (value == questionType.value) questionType.value = QuestionType.None;
    questionType.value = value!;
    correctAnswers.clear();
  }

  void showMoreQuestionsType() {
    questionType.value = QuestionType.None;
    correctAnswers.clear();
  }

  void onPressAddAnswerButton() {
    if (!answerAddFormKey.currentState!.validate()) return;
    answers.add(answerTEC.text);
    answerTEC.clear();
  }

  String? validateAnswerField(String? value) {
    if (value!.isEmpty) return 'Insira uma resposta';
    return null;
  }

  onDeletAnswer(RxList<String> answerList, int index) {
    answerList.removeAt(index);
  }

  onTapAnswer(String answerString) {
    if (this.questionType.value == QuestionType.SingleAnswer) {
      this.correctAnswers.clear();
      this.correctAnswers.add(answerString);
    } else {
      if (this.correctAnswers.contains(answerString)) {
        this.correctAnswers.remove(answerString);
      } else {
        this.correctAnswers.add(answerString);
      }
    }
    update();
  }

  String? enunciationValidator(String? value) {
    if (value!.isEmpty) return 'Insira um enunciado para a pergunta';
  }

  void onCompletQuestion() {
    if (!enunciationFormKey.currentState!.validate()) return;
    if (questionType.value != QuestionType.OpenAnswer) {
      if (answers.length < 2) {
        _callErrorSnackBar(
            title: 'Questão Incompleta',
            message: 'adicione ao menos duas alternativas para a questão');
        return;
      }
      if (correctAnswers.isEmpty) {
        _callErrorSnackBar(
            title: 'Questão Incompleta',
            message: 'Escolha ao menos uma alternativa correta para a questão');

        return;
      }
    }
    router.Get.back(
        result: QuestionModel(
            enunciation: enunciationController.text,
            questionType: questionType.value,
            answers: answers.value,
            correctAnser: correctAnswers));
  }

  _callErrorSnackBar({required String title, required String message}) {
    router.Get.snackbar(title, message,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(8),
        icon: CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.close),
        ),
        backgroundColor: Colors.white,
        barBlur: 0,
        snackStyle: router.SnackStyle.FLOATING);
  }
}
