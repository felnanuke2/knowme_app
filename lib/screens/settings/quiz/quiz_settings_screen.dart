import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/controller/settings/quiz/quiz_contoller.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/widgets/question_item_tile.dart';

class QuizSettingsScren extends StatelessWidget {
  EntryQuizModel? entryQuiz;
  QuizSettingsScren({
    Key? key,
    this.entryQuiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: QuizController(quizModel: entryQuiz),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Configurar Quiz'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: ListTile(
                onTap: controller.onNewQuizPressed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                tileColor: Get.theme.primaryColor,
                leading: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                title: Text('Nova Pergunta',
                    style: Get.theme.textTheme.headline6!.copyWith(
                      color: Colors.white,
                    )),
              ),
            ),
            Expanded(
                child: Obx(() => ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                      itemBuilder: (context, index) {
                        var questionItem = controller.questions[index];

                        return QuestionItemTile(
                          questionItem: questionItem,
                          controller: controller,
                          questionList: controller.questions,
                          index: index,
                        );
                      },
                      itemCount: controller.questions.length,
                    )))
          ],
        ),
      ),
    );
  }
}
