import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';
import 'package:knowme/models/question_model.dart';
import 'package:knowme/screens/settings/quiz/create_update_question_scree.dart';

class QuizController extends GetxController {
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  void onNewQuizPressed() async {
    var question = await router.Get.to(() => CreateUpdateQuestionScreen());
    if (question == null) return;
    questions.add(question);
  }
}
