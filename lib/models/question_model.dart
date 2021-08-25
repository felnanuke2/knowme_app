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
}

enum QuestionType { MultipleChoice, Dichotomous, SingleAnswer, OpenAnswer, None }
