import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/events/stream_event.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/message_model.dart';
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
  Future<List<InteractionsModel>> getInteractionsReceived(String currentUserId) async {
    final response = await client.from('interactions').select('''
  *, users: from_user ( profileName, completName, profileImage, uid )
  ''').eq('to_user', currentUserId).order('created_at').limit(20).execute();
    if (response.error != null) throw RequestError(message: response.error!.message);
    final interactions = List.from(response.data).map((e) => InteractionsModel.fromMap(e)).toList();
    return interactions;
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
    if (bio != null) mapToUpdate['bio'] = bio;
    if (completName != null) mapToUpdate['completName'] = completName;
    if (profileName != null) mapToUpdate['profileName'] = profileName;
    if (birthDay != null) mapToUpdate['birthDay'] = birthDay;
    if (city != null) mapToUpdate['city'] = city;
    if (uf != null) mapToUpdate['uf'] = uf;
    if (lat != null) mapToUpdate['lat'] = lat;
    if (lng != null) mapToUpdate['lng'] = lng;
    if (state != null) mapToUpdate['state'] = state;
    if (sex != null) mapToUpdate['sex'] = sex;
    if (phoneNumber != null) mapToUpdate['phoneNumber'] = phoneNumber;
    if (firebaseToken != null) mapToUpdate['firebaseToken'] = firebaseToken;

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

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final response = await client
        .from('users')
        .select('uid,profileName,completName,profileImage')
        .ilike('profileName', '%$query%')
        // .textSearch('profileName', '$query', type: TextSearchType.websearch)
        .limit(40)
        .execute();
    if (response.error != null) throw RequestError(message: response.error!.message);
    final userList = List.from(response.data).map((e) => UserModel.fromMap(e)).toList();
    return userList;
  }

  @override
  Future<InteractionsModel> updateInteraction(String interactionId, int status) async {
    final response = await client
        .from('interactions')
        .update({'status': status}, returning: ReturningOption.representation)
        .eq('id', int.parse(interactionId))
        .execute();
    if (response.error != null) throw RequestError(message: response.error?.message);
    final interaction = InteractionsModel.fromMap(response.data[0]);
    return interaction;
  }

  @override
  Future<List<EntryQuizModel>> getLisOfQuizes(String userId) async {
    final response = await client.from('users').select(''' 
    profileName,profileImage,uid, quizes: entryQuizID (*)
    ''').not('entryQuizID', 'is', null).limit(30).execute();
    if (response.error != null) throw RequestError(message: response.error?.message);
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
  Future<InteractionsModel> sendInteraction(InteractionsModel interactionsModel) async {
    final response = await client.from('interactions').insert(interactionsModel.toMap()).execute();
    if (response.error != null) throw RequestError(message: response.error?.message);
    final iteraction = InteractionsModel.fromMap(response.data[0]);
    return iteraction;
  }

  @override
  Future<List<String>> getFriends(String id) async {
    final response = await client.rpc('getfriends', params: {'uid': id}).execute();
    if (response.error != null) throw RequestError(message: response.error?.message ?? '');
    final list = List<String>.from(response.data[0]['frieds_list']);
    return list;
  }

  @override
  Future<MessageModel> sendMessage(String userId, String message, int type, {String? src}) async {
    final response = await client.rpc('sendmessage', params: {
      'message': message,
      'to_user': userId,
      'message_type': type,
      'src': src
    }).execute();
    if (response.error != null) throw RequestError(message: response.error?.message ?? '');
    final messageResponse = MessageModel.fromMap(response.data);
    return messageResponse;
  }

  @override
  Future<List<ChatRoomModel>> getChatChannels(String userId) async {
    final response = await client
        .from('chat_room')
        .select(
            'id,user_a (profileName, completName, profileImage, uid ),user_b (profileName, completName, profileImage, uid ),created_at,status')
        .or('user_a.eq.$userId,user_b.eq.$userId')
        .order('updated_at', ascending: false)
        .execute();
    if (response.error != null) throw RequestError(message: response.error?.message ?? '');
    final listRooms = List.from(response.data).map((e) => ChatRoomModel.fromMap(e)).toList();
    return listRooms;
  }

  @override
  Future<List<MessageModel>> getMessages(int roomId) async {
    final response = await client.rpc('get_last_messages', params: {'room': roomId}).execute();
    if (response.error != null) throw RequestError(message: response.error?.message ?? '');
    final listMessages = List.from(response.data).map((e) => MessageModel.fromMap(e)).toList();
    return listMessages;
  }

  @override
  Future<void> readMessage(int messageId) async {
    final response = await client.rpc('read_message', params: {'message_id': messageId}).execute();
    if (response.error != null) throw RequestError(message: response.error?.message ?? '');
  }

  @override
  StreamController<StreamEvent> chatRoomListen(String uid) {
    final stream = StreamController<StreamEvent>.broadcast();
    final responseA = client.from('chat_room:user_a=eq.$uid').on(SupabaseEventTypes.all, (payload) {
      stream.add(StreamEventUpdate()..data = payload.newRecord);
    }).subscribe(_onSubscribe);
    final responseB = client.from('chat_room:user_b=eq.$uid').on(SupabaseEventTypes.all, (payload) {
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
}
