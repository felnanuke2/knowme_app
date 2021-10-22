import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/main_screen/exploring_controller.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/widgets/exploring_tab_filter_drawer.dart';
import 'package:knowme/widgets/no_nearby_widget.dart';

import 'package:knowme/widgets/quiz_to_answer.dart';

class ExploringTab extends StatefulWidget {
  const ExploringTab({Key? key}) : super(key: key);

  @override
  State<ExploringTab> createState() => _ExploringTabState();
}

class _ExploringTabState extends State<ExploringTab>
    with AutomaticKeepAliveClientMixin {
  @override
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ExploringController>(
      builder: (exploringController) => Scaffold(
        key: exploringController.scaffoldKey,
        endDrawer: ExploringTabFilterDrawer(controller: exploringController),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 65,
                    ),
                    SizedBox(
                      height: 160,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 65,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Perto de Você',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20)),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: exploringController.openSearch,
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(), primary: Colors.white),
                              child: Icon(
                                Icons.search,
                                color: Get.theme.primaryColor,
                              )),
                          ElevatedButton(
                              onPressed: exploringController.openFilterDrawer,
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(), primary: Colors.white),
                              child: Icon(
                                Icons.filter_list_rounded,
                                color: Get.theme.primaryColor,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: StreamBuilder<List<EntryQuizModel>>(
                      stream: exploringController
                          .sessionController.quizesToAnswer.stream,
                      builder: (context, snapshot) {
                        return PageView.builder(
                          key: UniqueKey(),
                          physics: NeverScrollableScrollPhysics(),
                          controller: exploringController.pageController,
                          itemCount: exploringController
                                  .sessionController.quizesToAnswer.length +
                              1,
                          itemBuilder: (context, index) {
                            if (exploringController
                                    .sessionController.quizesToAnswer.length ==
                                index) {
                              exploringController.reFindUser();
                              return NoNearbyWidget(
                                  imageUrl: exploringController
                                      .sessionController
                                      .userAuthRepository
                                      .getCurrentUser!
                                      .profileImage!);
                            }
                            final itemQuiz = exploringController
                                .sessionController.quizesToAnswer[index];
                            return QuizToAnswer(quiz: itemQuiz);
                          },
                        );
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
