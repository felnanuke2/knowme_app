import 'package:get/state_manager.dart';

import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/question_model.dart';

class AnswerQuizController extends GetxController {
  final EntryQuizModel quiz;
  final answersMap = <String, dynamic>{}.obs;

  AnswerQuizController({
    required this.quiz,
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
}
