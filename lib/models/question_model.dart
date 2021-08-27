import 'dart:convert';

class QuestionTypeFromString {
  QuestionTypeFromString._();
  static QuestionType fromString(String? value) {
    try {
      return QuestionType.values.firstWhere((element) => element.toString() == value);
    } catch (e) {
      return QuestionType.None;
    }
  }
}

class QuestionModel {
  final String enunciation;
  List<String>? answers;
  List<String>? correctAnser;
  final QuestionType questionType;
  String? hint;
  QuestionModel({
    required this.enunciation,
    this.answers,
    this.correctAnser,
    required this.questionType,
    this.hint,
  });

  Map<String, dynamic> toMap() {
    return {
      'enunciation': enunciation,
      'answers': answers,
      'correctAnser': correctAnser,
      'questionType': questionType.toString(),
      'hint': hint,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      enunciation: map['enunciation'],
      answers: List<String>.from(map['answers'] ?? []),
      correctAnser: List<String>.from(map['correctAnser'] ?? []),
      questionType: QuestionTypeFromString.fromString(map['questionType']),
      hint: map['hint'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) => QuestionModel.fromMap(json.decode(source));
}

enum QuestionType { MultipleChoice, Dichotomous, SingleAnswer, OpenAnswer, None }
