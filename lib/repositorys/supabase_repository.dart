import 'dart:typed_data';

import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:knowme/errors/requestError.dart';
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
  Future<UserModel> createUser(UserModel userModel) async {
    final response = await client.from('users').insert([userModel.toMap()]).execute();
    if (response.error != null) throw RequestError(message: response.error!.message);
    final user = UserModel.fromMap(response.data[0]);
    return user;
  }

  @override
  Future<PostModel> createpost(PostModel post) async {
    final response = await client.from('posts').insert(post.toMap()).execute();
    if (response.error != null) throw RequestError(message: response.error!.message);

    return PostModel.fromMap(response.data[0]);
  }

  @override
  Future<void> deletImage(String imageUrl) async {
    final path = imageUrl.substring(73);
    final response = await client.storage.from('public').remove([path]);
    if (response.hasError) throw RequestError(message: response.error!.message);
    return;
  }

  @override
  Future<UserModel> getCurrentUser(String id) async {
    final response = await client.from('users').select().eq('uid', id).execute();
    if (response.error != null) throw RequestError(message: response.error!.message);
    if (response.data.isEmpty) throw RequestError();
    final user = UserModel.fromMap(response.data[0]);
    return user;
  }

  @override
  Future<Uint8List> getImageBytesFromURL({required String url}) {
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
  Future<List<PostModel>> getPosts(List<String> usersList) async {
    final result = await client
        .from('posts')
        .select()
        .in_('posted_by', usersList)
        .limit(80)
        .order('created_at', ascending: false)
        .execute();
    if (result.error != null) throw RequestError();
    final listPosts = List.from(result.data).map((e) => PostModel.fromMap(e)).toList();
    final listofUsersId = listPosts.map((e) => e.postedBy).toList();
    final userResult = await client
        .from('users')
        .select('uid,profileImage,profileName,completName')
        .in_('uid', listofUsersId)
        .execute();
    if (userResult.error != null) throw RequestError(message: userResult.error!.message);
    final listofUsers = List.from(userResult.data).map((e) => UserModel.fromMap(e)).toList();
    listPosts.forEach((post) {
      post.userModel = listofUsers.firstWhere((user) => user.id == post.postedBy);
    });

    return listPosts;
  }

  @override
  Future<EntryQuizModel> getQuiz(String quizId) async {
    final response = await client.from('quizes').select().eq('id', int.parse(quizId)).execute();
    if (response.error != null) throw RequestError(message: response.error!.message);
    final quiz = EntryQuizModel.fromMap(response.data[0]);
    return quiz;
  }

  @override
  Future<EntryQuizModel> createQuiz(
    EntryQuizModel entryQuizModel,
  ) async {
    final response = await client.from('quizes').insert(entryQuizModel.toMap()).execute();
    if (response.error != null) throw RequestError();
    final eQuiz = EntryQuizModel.fromMap(response.data[0]);
    return eQuiz;
  }

  @override
  Future<EntryQuizModel> updateQuiz(EntryQuizModel entryQuizModel) async {
    final response = await client
        .from('quizes')
        .update(entryQuizModel.toMap())
        .eq('id', int.parse(entryQuizModel.id!))
        .execute();
    if (response.error != null) throw RequestError();
    final eQuiz = EntryQuizModel.fromMap(response.data[0]);
    return eQuiz;
  }

  @override
  Future<String> upLoadImage({required Uint8List imageByte, required String userID}) async {
    final name = '${DateTime.now().microsecondsSinceEpoch}.png';
    final file = File('${Directory.systemTemp.path}/' + name);
    await file.writeAsBytes(imageByte);
    final response = await client.storage.from('public').upload('$userID/images/$name', file);
    if (response.hasError) throw RequestError(message: response.error!.message);
    final imageUrl =
        'https://vxtotlcitdlsfylnfyxs.supabase.in/storage/v1/object/public/' + response.data!;
    return imageUrl;
  }

  @override
  Future<UserModel> updateUser(String id,
      {String? profileImage,
      String? entryQuizId,
      String? bio,
      String? completName,
      String? profileName,
      String? birthDay,
      String? uf,
      String? city,
      double? lat,
      double? lng,
      int? state,
      String? sex,
      String? phoneNumber,
      String? firebaseToken}) async {
    final mapToUpdate = {};
    if (profileImage != null) mapToUpdate['profileImage'] = profileImage;
    if (entryQuizId != null) mapToUpdate['entryQuizID'] = entryQuizId;
    final response = await client.from('users').update(mapToUpdate).eq('uid', id).execute();
    if (response.error != null) throw RequestError(message: response.error!.message);
    final user = UserModel.fromMap(response.data[0]);
    return user;
  }

  @override
  Future<String> uploadVideo(File file, String userID) async {
    final name = '${DateTime.now().microsecondsSinceEpoch}.mp4';

    final response = await client.storage.from('public').upload('$userID/videos/$name', file);
    if (response.hasError) throw RequestError(message: response.error!.message);
    final imageUrl =
        'https://vxtotlcitdlsfylnfyxs.supabase.in/storage/v1/object/public/' + response.data!;
    return imageUrl;
  }
}
