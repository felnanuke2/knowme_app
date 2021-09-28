import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/events/stream_event.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/message_model.dart';

class ChatController extends GetxController {
  final listChat = <ChatRoomModel>[].obs;
  final chatsMap = <int, RxList<MessageModel>>{}.obs;
  final SesssionController sesssionController;
  late DbRepositoryInterface repository;
  String get currentUserID => sesssionController.userAuthRepository.currentUser!.id!;
  final messageTEC = TextEditingController();
  final sendingMessage = false.obs;
  StreamController? stream;

  final text = ''.obs;

  ChatController({
    required this.sesssionController,
  }) {
    repository = sesssionController.repository;
  }

  Future<void> onRefresh() async {
    await _getChatRooms();
    await _getMessages();
  }

  _getChatRooms() async {
    final response =
        await repository.getChatChannels(sesssionController.userAuthRepository.currentUser!.id!);
    listChat.clear();
    listChat.addAll(response);
  }

  _getMessages() async {
    for (var i = 0; i < listChat.length; i++) {
      final listChats = await repository.getMessages([listChat[i].id]);
      chatsMap[listChat[i].id] = listChats.obs;
    }
  }

  void sendTextMessage(String userid, int chatRoomID) async {
    try {
      sendingMessage.value = true;
      final messageText = messageTEC.text;

      messageTEC.clear();

      final message = await repository.sendMessage(userid, messageText, 0);
      chatsMap[chatRoomID]?.add(message);
    } on RequestError catch (e) {
      print(e);
    }
    sendingMessage.value = false;
  }

  void recAudio() {}

  void onMessageChange(String value) {
    text.value = value;
  }

  void onRegisterListen(int roomId) {
    stream = repository.roomListenMessages(roomId);
    stream?.stream.listen((event) async {
      if (event is StreamEventUpdate) {
        final response = await repository.getMessages([roomId]);
        chatsMap[roomId] = response.obs;
      }
    });
  }

  void closeStream() {
    stream?.add(StreamEventCancel());
    stream?.close();
    stream = null;
  }
}
