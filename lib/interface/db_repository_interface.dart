import 'dart:typed_data';

import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/user_model.dart';

abstract class DbRepositoryInterface {
  Future<UserModel?> getUserCurrentUser(String id);
  Future<String?> createUser(
    UserModel userModel,
  );
  Future<String?> updateUser(UserModel user);

  Future<String?> creteQuiz(EntryQuizModel entryQuizModel);

  Future<String?> updateQuiz(EntryQuizModel entryQuizModel);

  Future<EntryQuizModel?> getQuiz(String quizId);

  Future<String?> upLoadImageForQuiz({
    required Uint8List imageByte,
    required String userID,
  });

  Future<Uint8List> getImageBytesFromURL({required String url});

  Future<String?> deletImage(String imageUrl);
}