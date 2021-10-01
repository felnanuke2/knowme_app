import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/state_manager.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/events/stream_event.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/screens/video_screen.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  final chatRooms = <ChatRoomModel>[].obs;
  final chatsMap = <int, RxList<MessageModel>>{}.obs;
  final SesssionController sesssionController;
  late DbRepositoryInterface repository;
  String get currentUserID => sesssionController.userAuthRepository.currentUser!.id!;
  final messageTEC = TextEditingController();
  final sendingMessage = false.obs;
  StreamController? roomStream;
  final messagesForRead = <int>[];
  final text = ''.obs;
  final isRecAudio = false.obs;
  FlutterSoundRecorder soundRecorder = FlutterSoundRecorder();
  String? recorderName;
  final haveNoMoreMessages = false.obs;

  ChatController({
    required this.sesssionController,
  }) {
    repository = sesssionController.repository;
    onRefresh();
    _readMessagesLoop();
  }

  List<String> get usersChatsUids {
    final list = <String>[];
    list.addAll(chatRooms.map((element) => element.user_a.id!));
    list.addAll(chatRooms.map((element) => element.user_b.id!));
    return list;
  }

  disponse() async {
    messageTEC.dispose();
    closeStream();
  }

  disposeChatScreen() async {
    isRecAudio.value = false;
    await soundRecorder.stopRecorder();
  }

  Future<void> onRefresh() async {
    await _getChatRooms();
    await _getMessages();
  }

  _getChatRooms() async {
    final response =
        await repository.getChatChannels(sesssionController.userAuthRepository.currentUser!.id!);
    chatRooms.clear();
    chatRooms.addAll(response);
    onRegisterListen();
  }

  _getMessages() async {
    for (var i = 0; i < chatRooms.length; i++) {
      final listChats = await repository.getMessages(chatRooms[i].id);
      chatsMap[chatRooms[i].id] = listChats.obs;
    }
  }

  getMessagesBefore(int roomId, int lastMessageid) async {
    final listMessagesBefore = await repository.getMessagesBefore(roomId, lastMessageid);
    if (listMessagesBefore.isEmpty) {
      haveNoMoreMessages.value = true;
    }
    chatsMap[roomId]?.addAll(listMessagesBefore);
  }

  Future<MessageModel?> sendTextMessage(String userid,
      {int? chatRoomID, String? messageTextInput}) async {
    try {
      sendingMessage.value = true;
      final messageText = messageTEC.text;

      messageTEC.clear();

      final message = await repository.sendMessage(userid, messageTextInput ?? messageText, 0);
      if (chatRoomID != null) {
        chatsMap[chatRoomID]?.insert(0, message);
      } else {
        await onRefresh();
      }
      sendingMessage.value = false;
      return message;
    } on RequestError catch (e) {
      print(e);
    }
    sendingMessage.value = false;
  }

  void recAudio() async {
    final permissionStatus = await requestMicPermissions();
    if (!permissionStatus) return;
    await soundRecorder.openAudioSession();
    recorderName = DateTime.now().millisecondsSinceEpoch.toString();
    await soundRecorder.startRecorder(
        toFile: recorderName, sampleRate: 128000, bitRate: 128000, numChannels: 2);
    isRecAudio.value = true;
  }

  void onMessageChange(String value) {
    text.value = value;
  }

  void onRegisterListen() {
    if (roomStream != null) return;
    this.roomStream =
        repository.chatRoomListen(sesssionController.userAuthRepository.currentUser!.id!);
    roomStream?.stream.listen((event) async {
      if (event is StreamEventUpdate) {
        final data = event.data;
        if (data is Map) {
          if (data.containsKey('id')) {
            final roomId = data['id'];
            final listChat = await repository.getMessages(roomId);
            chatsMap[roomId] = listChat.obs;

            _getChatRooms();
          }
        }
      }
    });
  }

  void closeStream() async {
    this.roomStream?.add(StreamEventCancel());
    await this.roomStream?.close();
    this.roomStream = null;
  }

  void addMessagesForRead(int messageId) {
    if (messagesForRead.contains(messageId)) return;
    messagesForRead.add(messageId);
  }

  bool isSending = false;
  void _readMessagesLoop() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if (isSending) return;
      if (messagesForRead.isEmpty) return;
      try {
        isSending = true;
        final messageId = messagesForRead.first;
        await repository.readMessage(messageId);
        messagesForRead.remove(messageId);
      } catch (e) {
        print(e.toString());
      }
      isSending = false;
    });
  }

  /// the return if not null contains type and src keys
  Future<Map?> _openSourcePicker(
    int roomID,
  ) async {
    final source = await ImagePickerBottomSheet.showImagePickerBottomSheet(
      Get.context!,
      video: true,
    );
    String? src;
    int type = 0;
    if (source is Uint8List) {
      type = 1;
      try {
        this.sendingMessage.value = true;
        src = await repository.sendImage(roomID,
            File(Directory.systemTemp.path + '/${DateTime.now()}.png')..writeAsBytesSync(source));
      } catch (e) {}
    }
    if (source is String) {
      try {
        type = 2;
        src = await repository.sendVideo(roomID, File(source));
      } catch (e) {
        print(e.toString());
      }
    }

    this.sendingMessage.value = false;
    if (src != null) {
      return {'type': type, 'src': src};
    }
  }

  sendMediaMessage(String toUser, int roomId) async {
    this.sendingMessage.value = true;
    final message = messageTEC.text;
    final picked = await _openSourcePicker(roomId);
    if (picked == null) return;
    messageTEC.clear();
    await repository.sendMessage(toUser, message, picked['type'], src: picked['src']);
    this.sendingMessage.value = false;
  }

  openVideoScreen(String? src) {
    Get.to(() => VideoScreen(src: src!, controller: sesssionController));
  }

  Future<bool> requestMicPermissions() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void sendAudio(String uid, int roomId) async {
    isRecAudio.value = false;
    this.sendingMessage.value = true;
    final path = await soundRecorder.stopRecorder();
    if (path == null) return;
    final src = await repository.sendAudio(roomId, File(path));

    messageTEC.clear();
    await repository.sendMessage(uid, '', 3, src: src);
    this.sendingMessage.value = false;
  }

  void deletAudio() async {
    await soundRecorder.deleteRecord(fileName: recorderName!);
    isRecAudio.value = false;
    await soundRecorder.closeAudioSession();
  }
}
