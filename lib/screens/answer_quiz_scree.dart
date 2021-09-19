import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/constants/constant_alphbet.dart';
import 'package:knowme/controller/answer_quiz_controller.dart';

import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/question_model.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';

class AnswerQuizScreen extends StatelessWidget {
  const AnswerQuizScreen({
    Key? key,
    required this.quiz,
  }) : super(key: key);
  final EntryQuizModel quiz;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnswerQuizController>(
      init: AnswerQuizController(quiz: quiz, sesssionController: Get.find()),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text((quiz.user?.profileName ?? '') + '#'),
          actions: [
            TextButton.icon(
                onPressed: controller.sendAsnwers,
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                label: Text(
                  'Enviar',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.only(bottom: 40),
              itemCount: controller.quiz.questions.length,
              itemBuilder: (context, index) {
                final itemQuestion = controller.quiz.questions[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      ExpandablePanel(
                          controller: ExpandableController(initialExpanded: index == 0),
                          header: Row(
                            children: [
                              CircleAvatar(
                                child: Text((index + 1).toString()),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    itemQuestion.enunciation,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    _getQuestionType(itemQuestion.questionType),
                                  ),
                                ),
                              )
                            ],
                          ),
                          collapsed: Container(),
                          expanded: itemQuestion.questionType != QuestionType.OpenAnswer
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Get.theme.primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(18)),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: List.generate(
                                        itemQuestion.answers!.length,
                                        (index) => Container(
                                              child: Card(
                                                child: Obx(() => ListTile(
                                                      onTap: () => controller.selectAnser(
                                                          itemQuestion.answers![index],
                                                          itemQuestion.enunciation,
                                                          itemQuestion.questionType),
                                                      selected: _getIsSelected(
                                                          controller
                                                              .answersMap[itemQuestion.enunciation],
                                                          itemQuestion.answers![index],
                                                          itemQuestion.questionType),
                                                      leading: CircleAvatar(
                                                        backgroundColor: _getIsSelected(
                                                                controller.answersMap[
                                                                    itemQuestion.enunciation],
                                                                itemQuestion.answers![index],
                                                                itemQuestion.questionType)
                                                            ? Colors.green
                                                            : null,
                                                        child: Text(
                                                            ALPHABET_LIST[index].toUpperCase()),
                                                      ),
                                                      title: Text(itemQuestion.answers![index]),
                                                    )),
                                              ),
                                            )),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: TextField(
                                    decoration: InputDecoration(labelText: 'Resposta: '),
                                    onChanged: (value) => controller.selectAnser(
                                        value, itemQuestion.enunciation, itemQuestion.questionType),
                                  ),
                                ))
                    ],
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  _getQuestionType(QuestionType questionType) {
    switch (questionType) {
      case QuestionType.OpenAnswer:
        return 'Questão aberta';

      case QuestionType.MultipleChoice:
        return 'Multipla escolha';
      case QuestionType.SingleAnswer:
        return 'Resposta única';
      default:
        return '';
    }
  }

  bool _getIsSelected(dynamic value, String answer, QuestionType type) {
    if (type == QuestionType.MultipleChoice) {
      return ((value ?? []) as List).contains(answer);
    } else {
      return value == answer;
    }
  }
}
