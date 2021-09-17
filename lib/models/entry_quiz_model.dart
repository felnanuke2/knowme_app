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
    return EntryQuizModel(
        id: map['id'].toString(),
        presentImagesList: List<String>.from(map['presentImagesList']),
        questions: List<QuestionModel>.from(map['questions']?.map((x) => QuestionModel.fromMap(x))),
        createAt: DateTime.parse(map['created_at'] ?? 0),
        updateAt: DateTime.parse(map['updated_at'] ?? 0),
        createdByID: map['created_by'],
        user: map['users'] == null ? null : UserModel.fromMap(map['users']));
  }

  String toJson() => json.encode(toMap());
}
