import 'dart:typed_data';

import 'dart:io';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:supabase/supabase.dart';
import 'package:knowme/constants/.env.dart' as env;

class SupabaseRepository implements DbRepositoryInterface {
  final client = SupabaseClient(env.SUPABASE_URL, env.SUPABASE_PUBLIC_KEY);

  @override
  Future<String?> createQuiz(EntryQuizModel entryQuizModel, UserModel userModel, {String? quizId}) {
    // TODO: implement createQuiz
    throw UnimplementedError();
  }

  @override
  Future<String?> createUser(UserModel userModel) async {
    final response = await client.from('users').insert([userModel.toMap()]).execute();
    return null;
  }

  @override
  Future<String> createpost(PostModel post) {
    // TODO: implement createpost
    throw UnimplementedError();
  }

  @override
  Future<String?> deletImage(String imageUrl) {
    // TODO: implement deletImage
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> getCurrentUser(String id) {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> getImageBytesFromURL({required String url}) {
    // TODO: implement getImageBytesFromURL
    throw UnimplementedError();
  }

  @override
  Future<List<InteractionsModel>> getInteractionsReceived(String currentYserId) {
    // TODO: implement getInteractionsReceived
    throw UnimplementedError();
  }

  @override
  Future<List<InteractionsModel>> getInteractionsSend(String currentYserId) {
    // TODO: implement getInteractionsSend
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getPosts(List<String> usersList) {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

  @override
  Future<EntryQuizModel?> getQuiz(String quizId) {
    // TODO: implement getQuiz
    throw UnimplementedError();
  }

  @override
  Future<String?> upLoadImage({required Uint8List imageByte, required String userID}) {
    // TODO: implement upLoadImage
    throw UnimplementedError();
  }

  @override
  Future<String?> updateQuiz(EntryQuizModel entryQuizModel) {
    // TODO: implement updateQuiz
    throw UnimplementedError();
  }

  @override
  Future<String?> updateUser(String id, {String? profileImage}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<String> uploadVideo(File file, String userID) {
    // TODO: implement uploadVideo
    throw UnimplementedError();
  }
}
