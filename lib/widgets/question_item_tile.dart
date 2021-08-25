import 'package:flutter/material.dart';
import 'package:knowme/constants/constant_alphbet.dart';
import 'package:knowme/controller/settings/quiz/quiz_contoller.dart';

import 'package:knowme/models/question_model.dart';

class QuestionItemTile extends StatelessWidget {
  QuestionItemTile(
      {Key? key,
      required this.questionItem,
      required this.index,
      required this.questionList,
      required this.controller})
      : super(key: key);

  final QuestionModel questionItem;
  final int index;
  final QuizController controller;
  final List<QuestionModel> questionList;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.onTapQuestionTile(index, questionItem),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.grey.withOpacity(0.1),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
                title: Text(questionItem.enunciation),
                subtitle: Text('Tipo de Questão: $subTitle'),
                trailing: IconButton(
                    onPressed: () => controller.onDeletQuestionPressed(questionList, questionItem),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ),
              ListView(
                padding: EdgeInsets.only(left: 30),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                    questionItem.answers?.length ?? 0,
                    (index) => Container(
                          margin: EdgeInsets.only(top: 10),
                          child: ListTile(
                            selectedTileColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            selected: questionItem.correctAnser
                                    ?.contains((questionItem.answers?[index] ?? '')) ??
                                false,
                            leading: CircleAvatar(
                              radius: 10,
                              child: Text(ALPHABET_LIST[index].toUpperCase()),
                            ),
                            title: Text(
                              questionItem.answers?[index] ?? '',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }

  String get subTitle {
    String subtitle = '';
    switch (questionItem.questionType) {
      case QuestionType.SingleAnswer:
        subtitle = 'Resposta Única';
        break;
      case QuestionType.MultipleChoice:
        subtitle = 'Múltipla Escolha';
        break;
      case QuestionType.OpenAnswer:
        subtitle = 'Resposta Aberta';

        break;
      default:
    }
    return subtitle;
  }
}
