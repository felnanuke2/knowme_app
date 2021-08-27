import 'dart:convert';

import 'package:knowme/models/question_model.dart';

class EntryQuizModel {
  final String? id;
  final List<String> presentImagesList;
  final List<QuestionModel> questions;
  DateTime? createAt;
  DateTime? updateAt;
  final String createdByID;
  final List<String> answeredBy;
  EntryQuizModel({
    this.id,
    required this.presentImagesList,
    required this.questions,
    this.createAt,
    this.updateAt,
    required this.createdByID,
    required this.answeredBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'presentImagesList': presentImagesList,
      'questions': questions.map((x) => x.toMap()).toList(),
      'createAt': createAt?.millisecond,
      'updateAt': updateAt?.millisecond,
      'createdByID': createdByID,
      'answeredBy': answeredBy,
    };
  }

  factory EntryQuizModel.fromMap(Map<String, dynamic> map, String id) {
    return EntryQuizModel(
      id: id,
      presentImagesList: List<String>.from(map['presentImagesList']),
      questions: List<QuestionModel>.from(map['questions']?.map((x) => QuestionModel.fromMap(x))),
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt'] ?? 0),
      updateAt: DateTime.fromMillisecondsSinceEpoch(map['updateAt'] ?? 0),
      createdByID: map['createdByID'],
      answeredBy: List<String>.from(map['answeredBy']),
    );
  }

  String toJson() => json.encode(toMap());
}
