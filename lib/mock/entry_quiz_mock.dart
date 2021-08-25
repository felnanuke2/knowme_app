import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/question_model.dart';

final ENTRY_QUIZ_MOCK = EntryQuizModel(id: 'sd', presentImagesList: [], questions: [
  QuestionModel(
      enunciation: 'Estado Civil',
      questionType: QuestionType.SingleAnswer,
      answers: ['Solteiro', 'Enroaldo', 'Namorando', 'Casado'],
      correctAnser: ['Solteiro']),
  QuestionModel(
      enunciation: 'Personalidade',
      questionType: QuestionType.SingleAnswer,
      answers: ['Extrovertido', 'Reservado', 'Calmo', 'Bravo', 'Bipola', 'Impulsivo'],
      correctAnser: ['Reservado']),
  QuestionModel(enunciation: 'Passeios', questionType: QuestionType.MultipleChoice, answers: [
    'Praia',
    'Parque Aquático',
    'Parque de Diversão',
    'Cinema',
    'Shopping',
    'Balada',
    'Caseiro',
    'Viajar'
  ], correctAnser: [
    'Viajar'
  ]),
  QuestionModel(enunciation: 'Pratos', questionType: QuestionType.SingleAnswer, answers: [
    'Lasanha',
    'Strogonoff',
    'Macarronada',
    'Yakisoba',
    'Comida Vegetariana',
    'Balada',
    'Caseiro',
    'Viajar'
  ], correctAnser: [
    'Lasanha'
  ]),
  QuestionModel(
    enunciation: 'Me Levaria Para Sair?',
    questionType: QuestionType.OpenAnswer,
  )
]);
