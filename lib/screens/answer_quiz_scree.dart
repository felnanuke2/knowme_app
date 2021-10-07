import 'package:cached_network_image/cached_network_image.dart';
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
  AnswerQuizScreen({
    Key? key,
    required this.quiz,
  }) : super(key: key);
  final EntryQuizModel quiz;
  final pageController = PageController();
  final currentPage = 0.obs;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnswerQuizController>(
      init: AnswerQuizController(quiz: quiz, sesssionController: Get.find()),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text((quiz.user?.profileName ?? '') + '#'),
          actions: [
            Obx(() => Visibility(
                visible: !controller.loading.value,
                child: TextButton.icon(
                    onPressed: controller.sendAsnwers,
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Enviar',
                      style: TextStyle(color: Colors.white),
                    ))))
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: NestedScrollView(
                headerSliverBuilder: _buildHeaderSliver,
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600, fontSize: 16),
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
                                                                  controller.answersMap[
                                                                      itemQuestion.enunciation],
                                                                  itemQuestion.answers![index],
                                                                  itemQuestion.questionType),
                                                              leading: CircleAvatar(
                                                                backgroundColor: _getIsSelected(
                                                                        controller.answersMap[
                                                                            itemQuestion
                                                                                .enunciation],
                                                                        itemQuestion
                                                                            .answers![index],
                                                                        itemQuestion.questionType)
                                                                    ? Colors.green
                                                                    : null,
                                                                child: Text(ALPHABET_LIST[index]
                                                                    .toUpperCase()),
                                                              ),
                                                              title: Text(
                                                                  itemQuestion.answers![index]),
                                                            )),
                                                      ),
                                                    )),
                                          ),
                                        )
                                      : Container(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          child: TextField(
                                            decoration: InputDecoration(labelText: 'Resposta: '),
                                            onChanged: (value) => controller.selectAnser(
                                                value,
                                                itemQuestion.enunciation,
                                                itemQuestion.questionType),
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
            ),
            Positioned.fill(
              child: Obx(() => Visibility(
                  visible: controller.loading.value,
                  child: Container(
                    child: Center(
                      child: LinearProgressIndicator(),
                    ),
                    color: Colors.white.withOpacity(0.4),
                  ))),
            )
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

  Widget _buildListImagesMini(BuildContext context, int index) {
    final imageItem = quiz.presentImagesList[index];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => pageController.jumpToPage(index),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageItem,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Obx(() => Visibility(
                        visible: currentPage.value != index,
                        child: Container(
                          color: Colors.white.withOpacity(0.65),
                        ),
                      )),
                )
              ],
            ),
          )),
    );
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverToBoxAdapter(
        child: Container(
          height: Get.height * 0.6,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: PageView.builder(
                      pageSnapping: true,
                      controller: pageController,
                      onPageChanged: (value) => currentPage.value = value,
                      itemCount: quiz.presentImagesList.length,
                      itemBuilder: (context, index) {
                        final imageItem = quiz.presentImagesList[index];
                        return Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: CachedNetworkImage(
                                imageUrl: imageItem,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 75,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount: quiz.presentImagesList.length,
                    itemBuilder: _buildListImagesMini),
              )
            ],
          ),
        ),
      )
    ];
  }
}
