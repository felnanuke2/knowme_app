import 'dart:typed_data';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/models/entry_quiz_model.dart';

class FirebaseRepository implements DbRepositoryInterface {
  @override
  Future<Uint8List> getImageBytesFromURL({required String url}) {
    // TODO: implement getImageBytesFromURL
    throw UnimplementedError();
  }

  @override
  Future<String?> createUser(UserModel userModel) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<String?> creteQuiz(EntryQuizModel entryQuizModel) {
    // TODO: implement creteQuiz
    throw UnimplementedError();
  }

  @override
  Future<String?> deletImage(String imageUrl) {
    // TODO: implement deletImage
    throw UnimplementedError();
  }

  @override
  Future<EntryQuizModel?> getQuiz(String quizId) {
    // TODO: implement getQuiz
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getUserCurrentUser(String id) {
    // TODO: implement getUserCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<String?> upLoadImageForQuiz({required Uint8List imageByte, required String userID}) {
    // TODO: implement upLoadImageForQuiz
    throw UnimplementedError();
  }

  @override
  Future<String?> updateQuiz(EntryQuizModel entryQuizModel) {
    // TODO: implement updateQuiz
    throw UnimplementedError();
  }

  @override
  Future<String?> updateUser(UserModel user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
