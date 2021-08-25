class QuestionModel {
  final String enunciation;
  List<String>? answers;
  final QuestionType questionType;
  String? hint;
  QuestionModel({
    required this.enunciation,
    this.answers,
    required this.questionType,
    this.hint,
  });
}

enum QuestionType { MultipleChoice, Dichotomous, SingleAnswer, OpenAnswer, None }
