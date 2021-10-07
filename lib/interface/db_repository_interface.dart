import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:knowme/events/stream_event.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/models/user_model.dart';

abstract class DbRepositoryInterface {
  Future<UserModel> getCurrentUser(String id);
  Future<UserModel> createUser(
    UserModel userModel,
  );
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
      String? firebaseToken});

  Future<EntryQuizModel> createQuiz(EntryQuizModel entryQuizModel);

  Future<EntryQuizModel> updateQuiz(EntryQuizModel entryQuizModel);

  Future<EntryQuizModel> getQuiz(String quizId);

  Future<String> upLoadImage({
    required Uint8List imageByte,
    required String userID,
  });

  Future<String> uploadVideo(File file, String userID);

  Future<Uint8List> getImageBytesFromURL({required String url});

  Future<void> deletImage(String imageUrl);

  Future<List<InteractionsModel>> getInteractionsSend(String currentYserId);

  Future<List<InteractionsModel>> getInteractionsReceived(String currentYserId);

  Future<PostModel> createpost(PostModel post);

  Future<List<PostModel>> getPosts(List<String> usersList);

  Future<List<UserModel>> searchUsers(String query);

  /// on update use 1 for accept and 2 for refuse 0 is await for answer
  Future<InteractionsModel> updateInteraction(String interactionId, int status);

  Future<List<EntryQuizModel>> getLisOfQuizes(String userId);

  Future<InteractionsModel> sendInteraction(InteractionsModel interactionsModel);

  Future<List<String>> getFriends(String id);

  Future<MessageModel> sendMessage(String userId, String message, int type, {String? src});

  Future<List<ChatRoomModel>> getChatChannels(String userId);

  Future<List<MessageModel>> getMessages(int roomIds);
  Future<List<MessageModel>> getMessagesBefore(int roomId, int lastMessage);

  StreamController<StreamEvent> chatRoomListen(String uid);

  Future<void> readMessage(int messageId);

  Future<String> sendImage(int roomID, File file);

  Future<String> sendVideo(int roomID, File file);
  Future<String> sendAudio(int roomId, File file);

  Future<String> getImageUrl(String src);

  Future<List<EntryQuizModel>> getNearbyUsers(
      {double maxDistance = 50, required double latitude, required double longitude});

  Future<void> passQuiz(int quizId);
}
