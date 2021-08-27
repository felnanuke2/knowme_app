import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart' as instance;

import 'package:knowme/controller/settings/quiz/quiz_contoller.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';

import 'package:knowme/widgets/question_item_tile.dart';

class QuizSettingsScren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuizController>(
      init: QuizController(
          repository: instance.Get.find<DbRepositoryInterface>(),
          userAuthRepo: instance.Get.find<UserAuthInterface>()),
      builder: (controller) => Scaffold(
          appBar: AppBar(
            title: Text('Configurar Quiz'),
            actions: [
              TextButton.icon(
                  onPressed: controller.onQuizCompleted,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Concluir',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    if (controller.loadingQuiz)
                      SliverToBoxAdapter(
                          child: Container(
                        height: Get.height * 0.7,
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ))
                    else
                      SliverToBoxAdapter(
                          child: Obx(
                        () => Container(
                          height: Get.height * 0.7,
                          child: AspectRatio(
                            aspectRatio: 3 / 4,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: controller.imagesList.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Você ainda não adicionou nenhuma imagem sobre você.'
                                            '\n\nClique no botão (+) abaixo para adicionar',
                                            style: Get.theme.textTheme.headline5,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : PageView.builder(
                                          controller: controller.pageController,
                                          itemBuilder: (context, index) {
                                            var imageItem = controller.imagesList[index];

                                            return Center(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(18),
                                                child: AspectRatio(
                                                  aspectRatio: 3 / 4,
                                                  child: Stack(
                                                    children: [
                                                      if (imageItem.byteImage != null)
                                                        Container(
                                                          child: Image.memory(
                                                            imageItem.byteImage!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      Positioned(
                                                          right: 8,
                                                          top: 8,
                                                          child: IconButton(
                                                              onPressed: () => controller
                                                                  .onDeletImage(imageItem),
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color: Colors.red,
                                                              )))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: controller.imagesList.length,
                                        ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  height: 90,
                                  child: Row(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 3 / 4,
                                        child: InkWell(
                                          onTap: controller.pickImage,
                                          child: Container(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Get.theme.primaryColor,
                                                borderRadius: BorderRadius.circular(18)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4),
                                          child: ReorderableListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                final imageItem =
                                                    controller.imagesList[index].byteImage;
                                                return Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                                  key: Key(index.toString()),
                                                  height: 90,
                                                  child: InkWell(
                                                    onTap: () =>
                                                        controller.onImageScrollToIndex(index),
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(18),
                                                        child: Obx(() => Stack(
                                                              children: [
                                                                if (imageItem != null)
                                                                  Image.memory(imageItem)
                                                                else
                                                                  Container(
                                                                    height: 90,
                                                                  ),
                                                                if (controller.pageIndex.value !=
                                                                    index)
                                                                  Positioned(
                                                                    top: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child: Container(
                                                                      color: Colors.black
                                                                          .withOpacity(0.6),
                                                                    ),
                                                                  )
                                                              ],
                                                            ))),
                                                  ),
                                                );
                                              },
                                              itemCount: controller.imagesList.length,
                                              onReorder: controller.onReorder),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                  ],
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
              ))),
    );
  }
}
