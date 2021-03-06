import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/events/stream_event.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/impression_model.dart';
import 'package:knowme/models/lat_laong.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/models/plans_model.dart';
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
    final privateData = {};
    if (userModel.phoneNumber != null)
      privateData['phone_number'] = userModel.phoneNumber;
    if (userModel.email != null) privateData['email'] = userModel.email;
    if (userModel.city != null) privateData['city'] = userModel.city;
    if (userModel.uf != null) privateData['uf'] = userModel.uf;
    privateData['uid'] = userModel.id;
    final privateResponse =
        await client.from('private_infos').insert(privateData).execute();
    if (privateResponse.error != null)
      throw RequestError(message: privateResponse.error!.message);
    final response = await client
        .from('users')
        .insert(userModel.toMap()
          ..['private_infos'] = privateResponse.data[0]['id']
          ..removeWhere((key, value) => value == null))
        .execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    final user = UserModel.fromMap(response.data[0]);

    return user..profileComplet = true;
  }

  @override
  Future<PostModel> createpost(PostModel post) async {
    final response = await client.from('posts').insert(post.toMap()).execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);

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
    final response =
        await client.from('users').select().eq('uid', id).execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
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
  Future<List<InteractionsModel>> getInteractionsReceived(
      String currentUserId) async {
    final response = await client.rpc('get_interactions_received').execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    final interactions = List.from(response.data)
        .map((e) => InteractionsModel.fromMap(e))
        .toList();
    return interactions;
  }

  @override
  Future<List<InteractionsModel>> getInteractionsSend(String currentYserId) {
    // TODO: implement getInteractionsSend
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getPosts({String? userId}) async {
    if (userId == null)
      return await _getPostFromFriends();
    else
      return await _getPostFromUser(userId);
  }

  _getPostFromUser(String userId) async {
    final result = await client.rpc('get_post_from_user', params: {
      'user_id': userId,
      'last_post_id': null,
    }).execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message);
    final listPosts = List.from(result.data)
        .map((e) =>
            PostModel.fromMap(e)..userModel = UserModel.fromMap(e['user']))
        .toList();
    return listPosts;
  }

  _getPostFromFriends() async {
    var result = await client.rpc('get_latest_posts').execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message);
    final listPosts = List.from(result.data)
        .map((e) =>
            PostModel.fromMap(e)..userModel = UserModel.fromMap(e['user']))
        .toList();
    return listPosts;
  }

  @override
  Future<List<PostModel>> getPostsBefore(int lastPostId,
      {String? userId}) async {
    if (userId == null)
      return await _getPostBefore(lastPostId);
    else
      return await _getPostBEforeEspecificUser(lastPostId, userId);
  }

  @override
  Future<EntryQuizModel> getQuiz(String quizId) async {
    final response = await client
        .from('quizes')
        .select()
        .eq('id', int.parse(quizId))
        .execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    final quiz = EntryQuizModel.fromMap(response.data[0]);
    return quiz;
  }

  @override
  Future<EntryQuizModel> createQuiz(
    EntryQuizModel entryQuizModel,
  ) async {
    final response =
        await client.from('quizes').insert(entryQuizModel.toMap()).execute();
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
  Future<String> upLoadImage(
      {required Uint8List imageByte, required String userID}) async {
    final name = '${DateTime.now().microsecondsSinceEpoch}.png';
    final file = File('${Directory.systemTemp.path}/' + name);
    await file.writeAsBytes(imageByte);
    final response = await client.storage
        .from('public')
        .upload('$userID/images/$name', file);
    if (response.hasError) throw RequestError(message: response.error!.message);
    final imageUrl =
        'https://exnanxgdrezylebvvgcp.supabase.in/storage/v1/object/public/' +
            response.data!;
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
    if (bio != null) mapToUpdate['bio'] = bio;
    if (completName != null) mapToUpdate['completName'] = completName;
    if (profileName != null) mapToUpdate['profileName'] = profileName;
    if (birthDay != null) mapToUpdate['birthDay'] = birthDay;
    if (sex != null) mapToUpdate['sex'] = sex;
    if (state != null) mapToUpdate['state'] = state;
    if (firebaseToken != null) mapToUpdate['firebaseToken'] = firebaseToken;

    final privateData = {};

    if (city != null) privateData['city'] = city;
    if (uf != null) privateData['uf'] = uf;
    if (lat != null) privateData['lat'] = lat;
    if (lng != null) privateData['lng'] = lng;
    if (phoneNumber != null) privateData['phone_number'] = phoneNumber;
    if (privateData.isNotEmpty) {
      final privateResponse = await client
          .from('private_infos')
          .update(privateData)
          .eq('uid', id)
          .execute();
      if (privateResponse.error != null)
        throw RequestError(message: privateResponse.error!.message);
    }

    final response =
        await client.from('users').update(mapToUpdate).eq('uid', id).execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    final user = UserModel.fromMap(response.data[0]);
    return user;
  }

  @override
  Future<String> uploadVideo(File file, String userID) async {
    final name = '${DateTime.now().microsecondsSinceEpoch}.mp4';

    final response = await client.storage
        .from('public')
        .upload('$userID/videos/$name', file);
    if (response.hasError) throw RequestError(message: response.error!.message);
    final imageUrl =
        'https://exnanxgdrezylebvvgcp.supabase.in/storage/v1/object/public/' +
            response.data!;
    return imageUrl;
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final response = await client
        .from('users')
        .select('uid,profileName,completName,profileImage')
        .ilike('profileName', '%$query%')
        // .textSearch('profileName', '$query', type: TextSearchType.websearch)
        .limit(40)
        .execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    final userList =
        List.from(response.data).map((e) => UserModel.fromMap(e)).toList();
    return userList;
  }

  @override
  Future<InteractionsModel> updateInteraction(
      String interactionId, int status) async {
    final response = await client
        .from('interactions')
        .update({'status': status}, returning: ReturningOption.representation)
        .eq('id', int.parse(interactionId))
        .execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message);
    final interaction = InteractionsModel.fromMap(response.data[0]);
    return interaction;
  }

  @override
  Future<List<EntryQuizModel>> getLisOfQuizes(String userId) async {
    final response = await client.from('users').select(''' 
    profileName,profileImage,uid, quizes: entryQuizID (*)
    ''').not('entryQuizID', 'is', null).limit(30).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message);
    final listQuizes = List.from(response.data).map((e) {
      final map = <String, dynamic>{};
      map['users'] = e;
      map.remove('quizes');
      map.addAll(e['quizes']);
      return EntryQuizModel.fromMap(map);
    }).toList();
    return listQuizes;
  }

  @override
  Future<InteractionsModel> sendInteraction(
      InteractionsModel interactionsModel) async {
    final response = await client
        .from('interactions')
        .insert(interactionsModel.toMap())
        .execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message);
    final iteraction = InteractionsModel.fromMap(response.data[0]);
    return iteraction;
  }

  @override
  Future<List<String>> getFriends(String id) async {
    final response =
        await client.rpc('getfriends', params: {'uid': id}).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    final list = List<String>.from(response.data[0]['frieds_list']);
    return list;
  }

  @override
  Future<MessageModel> sendMessage(String userId, String message, int type,
      {String? src}) async {
    final response = await client.rpc('sendmessage', params: {
      'message': message,
      'to_user': userId,
      'message_type': type,
      'src': src
    }).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    final messageResponse = MessageModel.fromMap(response.data);
    return messageResponse;
  }

  @override
  Future<List<ChatRoomModel>> getChatChannels(String userId) async {
    final response = await client.rpc('get_chats_rooms').execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    final listRooms =
        List.from(response.data).map((e) => ChatRoomModel.fromMap(e)).toList();
    return listRooms;
  }

  @override
  Future<List<MessageModel>> getMessages(int roomId) async {
    final response = await client
        .rpc('get_last_messages', params: {'room': roomId}).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    final listMessages =
        List.from(response.data).map((e) => MessageModel.fromMap(e)).toList();
    return listMessages;
  }

  @override
  Future<List<MessageModel>> getMessagesBefore(
      int roomId, int lastMessage) async {
    final response = await client.rpc('get_messages_before',
        params: {'room': roomId, 'messsage_id': lastMessage}).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    final listMessages =
        List.from(response.data).map((e) => MessageModel.fromMap(e)).toList();
    return listMessages;
  }

  @override
  Future<void> readMessage(int messageId) async {
    final response = await client
        .rpc('read_message', params: {'message_id': messageId}).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
  }

  @override
  StreamController<StreamEvent> chatRoomListen(String uid) {
    final stream = StreamController<StreamEvent>.broadcast();
    final responseA = client
        .from('chat_room:user_a=eq.$uid')
        .on(SupabaseEventTypes.all, (payload) {
      stream.add(StreamEventUpdate()..data = payload.newRecord);
    }).subscribe(_onSubscribe);
    final responseB = client
        .from('chat_room:user_b=eq.$uid')
        .on(SupabaseEventTypes.all, (payload) {
      stream.add(StreamEventUpdate()..data = payload.newRecord);
    }).subscribe(_onSubscribe);
    stream.stream.listen((event) {
      if (event is StreamEventCancel) {
        client.removeSubscription(responseA);
        client.removeSubscription(responseB);
      }
    });
    return stream;
  }

  void _onSubscribe(String event, {String? errorMsg}) {
    print(errorMsg);
  }

  @override
  Future<String> sendImage(int roomID, File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await client.storage
        .from('messages.files')
        .upload('$roomID/images/$fileName', file);
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    return response.data!;
  }

  @override
  Future<String> getImageUrl(String src) async {
    final response = await client.storage
        .from('messages.files')
        .createSignedUrl(src.replaceAll('messages.files/', ''), 20);
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');

    return response.data!;
  }

  @override
  Future<String> sendVideo(int roomID, File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await client.storage
        .from('messages.files')
        .upload('$roomID/videos/$fileName', file);
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    return response.data!;
  }

  @override
  Future<String> sendAudio(int roomId, File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await client.storage
        .from('messages.files')
        .upload('$roomId/audios/$fileName', file);
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    return response.data!;
  }

  @override
  Future<List<EntryQuizModel>> getNearbyUsers(
      {double maxDistance = 50,
      Sex? sex,
      required double latitude,
      required double longitude}) async {
    final response = await client.rpc('get_nearby_users', params: {
      'lat': latitude,
      'max_distance': maxDistance,
      'lng': longitude,
      'sex': sex == Sex.NONE ? null : sex.toString()
    }).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    final listQuiz =
        List.from(response.data).map((e) => EntryQuizModel.fromMap(e));
    return listQuiz.toList();
  }

  @override
  Future<void> passQuiz(int quizId) async {
    final response =
        await client.rpc('pass_quiz', params: {'quiz_id': quizId}).execute();

    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
  }

  @override
  Future<Map<String, dynamic>> createPaymentSession(int plantId) async {
    final response = await client
        .rpc('create_impression', params: {'plan_id': plantId}).execute();
    final preferenceId = await _paymentLoop(response.data);
    print(preferenceId);
    return Map.from(preferenceId);
  }

  Future _paymentLoop(int requestID) async {
    final completer = Completer<Map>();
    while (!completer.isCompleted) {
      final response = await client.rpc('get_payment_preferences', params: {
        'request_id': requestID,
      }).execute();
      if (response.error != null)
        throw RequestError(message: response.error!.message);
      if (response.data[0]['status'] == 'PENDING') {
        await Future.delayed(Duration(seconds: 1));
      } else {
        completer.complete(jsonDecode(response.data[0]['response']['body']));
      }
    }
    return await completer.future;
  }

  @override
  Future<List<PlansModel>> getPlans() async {
    final response = await client
        .rpc(
          'get_plans',
        )
        .execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    final plansList =
        List.from(response.data).map((e) => PlansModel.fromMap(e)).toList();
    return plansList;
  }

  @override
  Future<List<ImpressionModel>> getIntmpressions(LatLng latlng) async {
    final response = await client.rpc('get_impressions').execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    final list = List.from(response.data)
        .map((e) => ImpressionModel.fromMap(e))
        .toList();
    return list;
  }

  @override
  Future<void> checkImpression(int impressionId) async {
    final response = await client.rpc('check_impression', params: {
      'impression_id': impressionId,
    }).execute();
    if (response.error != null)
      throw RequestError(message: response.error!.message);
  }

  @override
  Future<ChatRoomModel> createRoom(String toUser) async {
    final response = await client.rpc('sendmessage', params: {
      'message': '',
      'to_user': toUser,
      'message_type': 0,
      'src': null,
    }).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    final chatRoom = ChatRoomModel.fromMap(response.data['room']);
    return chatRoom;
  }

  @override
  Future<bool> checkIfExistInterationBtween(String userdUid) async {
    final response = await client.rpc('check_exist_intercation',
        params: {'other_user': userdUid}).execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    return response.data;
  }

  @override
  Future<Map> countInteractions() async {
    final response = await client
        .rpc(
          'count_interaction',
        )
        .execute();
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    return response.data;
  }

  _getPostBefore(int lastPostId) async {
    final result = await client
        .rpc('get_posts_before', params: {'post_id': lastPostId}).execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message);
    final listPosts = List.from(result.data)
        .map((e) =>
            PostModel.fromMap(e)..userModel = UserModel.fromMap(e['user']))
        .toList();
    return listPosts;
  }

  _getPostBEforeEspecificUser(int lastPostId, String userId) async {
    final result = await client.rpc('get_post_from_user', params: {
      'user_id': userId,
      'last_post_id': lastPostId,
    }).execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message);
    final listPosts = List.from(result.data)
        .map((e) =>
            PostModel.fromMap(e)..userModel = UserModel.fromMap(e['user']))
        .toList();
    return listPosts;
  }

  @override
  Future<String> blockUser(String userId) async {
    final result = await client.rpc('block_user', params: {
      'user_uid': userId,
    }).execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message ?? '');
    return result.data;
  }

  @override
  Future<List<String>> getBlockedUsers() async {
    final result = await client.rpc('get_blocked_users').execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message ?? '');
    return List<String>.from(result.data);
  }

  @override
  Future<String> unblockUser(String userId) async {
    final result = await client.rpc('unblock_user', params: {
      'user_uid': userId,
    }).execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message ?? '');
    return result.data;
  }

  @override
  Future<int> sendReport(int postId, List<String> reasons) async {
    final result = await client.rpc('create_report', params: {
      'post_id': postId,
      'reasons': reasons,
    }).execute();
    if (result.error != null)
      throw RequestError(message: result.error?.message ?? '');
    return result.data;
  }
}
