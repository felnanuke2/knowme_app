import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/exploring_controller.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/widgets/quiz_to_answer.dart';

class ExploringTab extends StatefulWidget {
  const ExploringTab({Key? key}) : super(key: key);

  @override
  State<ExploringTab> createState() => _ExploringTabState();
}

class _ExploringTabState extends State<ExploringTab> with AutomaticKeepAliveClientMixin {
  final SesssionController controller = Get.find();
  final loadingQuizes = false.obs;
  @override
  void initState() {
    _getQuizes();
    super.initState();
  }

  _getQuizes() {
    loadingQuizes.value = true;
    controller.getListOfQuizes().then((value) => loadingQuizes.value = false);
  }

  @override
  Widget build(BuildContext context) {
    _getQuizes();
    super.build(context);
    return GetBuilder<ExploringController>(
      init: ExploringController(sesssionController: controller),
      builder: (explringController) => Scaffold(
        body: Column(
          children: [
            AppBar(
              leadingWidth: 0,
              leading: SizedBox.shrink(),
              titleSpacing: 0,
              title: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: explringController.openSearch,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(18)),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.search,
                              color: Get.theme.primaryColor,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Pesquisar',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => Visibility(
                visible: loadingQuizes.value,
                child: Center(
                  child: CircularProgressIndicator(),
                ))),
            Expanded(
              flex: 4,
              child: Obx(() => PageView.builder(
                    itemCount: explringController.sesssionController.quizesToAnswer.length,
                    itemBuilder: (context, index) {
                      final itemQuiz = explringController.sesssionController.quizesToAnswer[index];
                      return QuizToAnswer(quiz: itemQuiz);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
