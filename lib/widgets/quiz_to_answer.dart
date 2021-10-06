import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/main_screen/exploring_controller.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/screens/answer_quiz_scree.dart';
import 'package:knowme/widgets/profile_image_widget.dart';

class QuizToAnswer extends StatelessWidget {
  QuizToAnswer({
    Key? key,
    required this.quiz,
  }) : super(key: key);
  final EntryQuizModel quiz;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExploringController>(
      builder: (controller) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: PageView.builder(
                    itemCount: quiz.presentImagesList.length,
                    itemBuilder: (context, index) => Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: quiz.presentImagesList[index],
                                progressIndicatorBuilder: (context, url, progress) =>
                                    Center(child: LinearProgressIndicator()),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                                        child: Container(
                                            color: Colors.black12,
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            height: 80,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (quiz.user?.profileName ?? '') + '#',
                                                  style: GoogleFonts.openSans(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.pin_drop,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      '${quiz.user?.city ?? ''} - ${quiz.user?.uf ?? ''} • ${quiz.user?.distance ?? '?'} km',
                                                      style: GoogleFonts.openSans(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ))),
                                  ))
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white, shape: CircleBorder()),
                      onPressed: controller.removeUserFromExploring,
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 30,
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 25,
                          ))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: CircleBorder(), primary: Colors.green),
                      onPressed: () => controller.answerQuiz(quiz),
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 30,
                          child: SvgPicture.asset(
                            'assets/question-and-answer-svgrepo-com.svg',
                            color: Colors.white,
                            height: 28,
                            width: 28,
                          )))
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Container _buildHeaders() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileImageWidget(radius: 70, imageUrl: quiz.user!.profileImage!),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.user?.profileName ?? '',
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () => Get.to(() => AnswerQuizScreen(
                    quiz: quiz,
                  )),
              child: Text('Responder')),
          PopupMenuButton(
            icon: Icon(
              Icons.adaptive.more,
              color: Get.theme.primaryColor,
            ),
            itemBuilder: (context) => [],
          )
        ],
      ),
    );
  }
}
