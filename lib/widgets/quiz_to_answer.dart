import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/screens/answer_quiz_scree.dart';
import 'package:knowme/widgets/profile_image_widget.dart';

class QuizToAnswer extends StatelessWidget {
  const QuizToAnswer({
    Key? key,
    required this.quiz,
  }) : super(key: key);
  final EntryQuizModel quiz;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildHeaders(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: CachedNetworkImage(
                  imageUrl: quiz.presentImagesList[0],
                  fit: BoxFit.cover,
                )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                        (quiz.presentImagesList.length - 1) < 3
                            ? quiz.presentImagesList.length - 1
                            : 3,
                        (index) => Expanded(
                                child: CachedNetworkImage(
                              imageUrl: quiz.presentImagesList[index + 1],
                              fit: BoxFit.cover,
                            ))),
                  ),
                )
              ],
            ),
          )
        ],
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
