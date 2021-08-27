import 'package:flutter/material.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';

import 'package:knowme/constants/constant_alphbet.dart';
import 'package:knowme/controller/settings/quiz/create_update_question_controller.dart';
import 'package:knowme/models/question_model.dart';

class CreateUpdateQuestionScreen extends StatelessWidget {
  QuestionModel? questionModel;
  CreateUpdateQuestionScreen({
    Key? key,
    this.questionModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateUpdateQuestionController>(
      init: CreateUpdateQuestionController(questionModel: questionModel),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Pergunta'),
          actions: [
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: controller.onCompletQuestion,
                icon: Icon(Icons.check, color: Colors.green),
                label: Text('Concluir'))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Selecione o tipo de pergunta',
                  style: router.Get.textTheme.headline6,
                ),
                Obx(() => controller.questionType.value == QuestionType.None
                    ? Column(
                        children: [..._buildList(controller)],
                      )
                    : Column(
                        children: [
                          _buildList(controller).firstWhere(
                              (element) => element.value == controller.questionType.value),
                          TextButton(
                              onPressed: controller.showMoreQuestionsType,
                              child: Text('Mostrar mais opções')),
                          SizedBox(
                            height: 15,
                          ),
                          Form(
                            key: controller.enunciationFormKey,
                            child: TextFormField(
                              validator: controller.enunciationValidator,
                              controller: controller.enunciationController,
                              decoration: InputDecoration(
                                  labelText: 'Enunciado', prefixIcon: Icon(Icons.quiz_sharp)),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: 4,
                            ),
                          ),
                          if (controller.questionType.value == QuestionType.MultipleChoice ||
                              controller.questionType.value == QuestionType.SingleAnswer)
                            _buildAnswers(controller)
                        ],
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<RadioListTile<QuestionType>> _buildList(CreateUpdateQuestionController controller) {
    return [
      RadioListTile<QuestionType>(
          title: Text('Resposta Única'),
          value: QuestionType.SingleAnswer,
          groupValue: controller.questionType.value,
          onChanged: controller.onRadioChanged),
      RadioListTile<QuestionType>(
          title: Text('Multiplas Respostas'),
          value: QuestionType.MultipleChoice,
          groupValue: controller.questionType.value,
          onChanged: controller.onRadioChanged),
      RadioListTile<QuestionType>(
          title: Text('Resposta Aberta'),
          value: QuestionType.OpenAnswer,
          groupValue: controller.questionType.value,
          onChanged: controller.onRadioChanged)
    ];
  }

  Widget _buildAnswers(CreateUpdateQuestionController controller) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          _buildAddAnswerField(controller),
          Obx(() => controller.answers.isEmpty
              ? Container(
                  height: 250,
                  width: 320,
                  alignment: Alignment.center,
                  child: Text(
                    'Você ainda não adicionou nenhuma alternativa',
                    style: Get.textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.answers.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      selectedTileColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      selected: controller.correctAnswers.contains(controller.answers[index]),
                      onTap: () => controller.onTapAnswer(controller.answers[index]),
                      leading: CircleAvatar(
                        child: Text(ALPHABET_LIST[index].toUpperCase()),
                      ),
                      title: Text(controller.answers[index]),
                      trailing: IconButton(
                          onPressed: () => controller.onDeletAnswer(controller.answers, index),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  ),
                ))
        ],
      ),
    );
  }

  Widget _buildAddAnswerField(CreateUpdateQuestionController controller) {
    return Form(
      key: controller.answerAddFormKey,
      child: Column(
        children: [
          TextFormField(
            validator: controller.validateAnswerField,
            textCapitalization: TextCapitalization.sentences,
            decoration:
                InputDecoration(labelText: 'Alternativa', prefixIcon: Icon(Icons.quiz_sharp)),
            controller: controller.answerTEC,
            onFieldSubmitted: (value) => controller.onPressAddAnswerButton(),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                onPressed: controller.onPressAddAnswerButton,
                icon: Icon(Icons.add),
                label: Text('Adicionar Alternativa'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
