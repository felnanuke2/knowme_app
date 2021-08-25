import 'package:knowme/models/question_model.dart';

class EntryQuizModel {
  final String id;
  final List<String> presentImagesList;
  final List<QuestionModel> questions;
  EntryQuizModel({
    required this.id,
    required this.presentImagesList,
    required this.questions,
  });
}
