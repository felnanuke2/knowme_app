import 'dart:io';
import 'dart:typed_data';

import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/models/user_model.dart';

abstract class DbRepositoryInterface {
  Future<UserModel?> getCurrentUser(String id);
  Future<String?> createUser(
    UserModel userModel,
  );
  Future<String?> updateUser(UserModel user);

  Future<String?> createQuiz(EntryQuizModel entryQuizModel, UserModel userModel, {String? quizId});

  Future<String?> updateQuiz(EntryQuizModel entryQuizModel);

  Future<EntryQuizModel?> getQuiz(String quizId);

  Future<String?> upLoadImage({
    required Uint8List imageByte,
    required String userID,
  });

  Future<String> uploadVideo(File file, String userID);

  Future<Uint8List?> getImageBytesFromURL({required String url});

  Future<String?> deletImage(String imageUrl);

  Future<List<InteractionsModel>> getInteractionsSend(String currentYserId);
  Future<List<InteractionsModel>> getInteractionsReceived(String currentYserId);

  Future<String> createpost(PostModel post);

  Future<List<PostModel>> getPosts(List<String> usersList);
}
