import 'dart:convert';

import 'package:knowme/models/question_model.dart';
import 'package:knowme/models/user_model.dart';

class EntryQuizModel {
  final String? id;
  final List<String> presentImagesList;
  final List<QuestionModel> questions;
  DateTime? createAt;
  DateTime? updateAt;
  final String createdByID;
  UserModel? user;

  EntryQuizModel({
    this.id,
    required this.presentImagesList,
    required this.questions,
    this.createAt,
    this.updateAt,
    this.user,
    required this.createdByID,
  });

  Map<String, dynamic> toMap() {
    return {
      'presentImagesList': presentImagesList,
      'questions': questions.map((x) => x.toMap()).toList(),
      'created_by': createdByID,
    };
  }

  factory EntryQuizModel.fromMap(Map<String, dynamic> map) {
    final quiz = map['quiz'];
    return EntryQuizModel(
        id: quiz['id'].toString(),
        presentImagesList: List<String>.from(quiz['images']),
        questions:
            List<QuestionModel>.from(quiz['questions']?.map((x) => QuestionModel.fromMap(x))),
        createAt: DateTime.tryParse(quiz['created_at'] ?? ''),
        updateAt: DateTime.tryParse(quiz['updated_at'] ?? ''),
        createdByID: quiz['created_by'],
        user: map['user'] == null ? null : UserModel.fromMap(map['user']));
  }

  String toJson() => json.encode(toMap());
}
