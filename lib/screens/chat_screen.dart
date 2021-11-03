import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/chat_controler.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/widgets/chat/message_tile.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/widgets/chat/recorder_tile.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.chatList,
    required this.room,
    required this.currentUserId,
  }) : super(key: key);
  final List<MessageModel> chatList;
  ChatRoomModel room;
  final String currentUserId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final showDropButton = false.obs;
  final sController = ScrollController();
  late ChatController _chatController;
  final isBlocked = false.obs;
  final sessionController = Get.find<SesssionController>();

  @override
  void initState() {
    Get.find<ChatController>().text.value = '';
    ;
    sController.addListener(() {
      if (sController.position.pixels > 250) {
        showDropButton.value = true;
      } else {
        showDropButton.value = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        dispose: (state) => state.controller?.disposeChatScreen(),
        builder: (controller) {
          print('rebuild');
          _chatController = controller;
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: BackButton(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 14),
                                  width: 50,
                                  height: 50,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: otherUser.profileImage ?? '',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Text(
                                  otherUser.completName ?? '',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Expanded(child: Container()),
                                _buildPopUpOptions()
                              ],
                            ),
                          ],
                        ),
                      ),
                      Obx(() =>
                          sessionController.blockUsers.contains(otherUser.id!)
                              ? ListTile(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.red)),
                                  leading: Icon(
                                    Icons.block,
                                    color: Colors.red,
                                  ),
                                  trailing: TextButton(
                                      onPressed: () => sessionController
                                          .unBlockUser(otherUser.id),
                                      child: Text('Desbloquear')),
                                  title: Text('Esse usuario está bloqueado'),
                                )
                              : SizedBox.shrink()),
                      Expanded(
                          child: widget.room.id == null
                              ? SizedBox.shrink()
                              : Obx(() => ListView.builder(
                                    controller: sController,
                                    reverse: true,
                                    itemCount: (controller
                                                .chatsMap[widget.room.id]
                                                ?.length ??
                                            0) +
                                        1,
                                    itemBuilder: _buildMessages,
                                  ))),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Obx(() => controller.isRecAudio.value
                                  ? SizedBox.shrink()
                                  : IconButton(
                                      onPressed: () =>
                                          controller.sendMediaMessage(
                                              otherUser.id!, widget.room.id,
                                              chatScreen: widget),
                                      icon: Icon(
                                        Icons.attach_file,
                                        color: Get.theme.primaryColor,
                                      ),
                                    )),
                              Obx(() => Expanded(
                                  child: controller.isRecAudio.value
                                      ? RecorderTile(
                                          otherUserId: otherUser.id!,
                                          roomId: widget.room.id,
                                          chatScreen: widget,
                                          controller: controller,
                                        )
                                      : TextFormField(
                                          controller: controller.messageTEC,
                                          onChanged: controller.onMessageChange,
                                          minLines: 1,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  Colors.grey.withOpacity(0.05),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent))),
                                        ))),
                              Obx(() => controller.sendingMessage.value
                                  ? Center(
                                      child: Container(
                                          width: 28,
                                          height: 28,
                                          child: CircularProgressIndicator()),
                                    )
                                  : Obx(() => controller.isRecAudio.value
                                      ? SizedBox.shrink()
                                      : controller.text.value.isNotEmpty
                                          ? IconButton(
                                              onPressed: () =>
                                                  controller.sendTextMessage(
                                                      otherUser.id!,
                                                      chatScreen: widget,
                                                      chatRoomID:
                                                          widget.room.id),
                                              icon: Icon(
                                                Icons.send,
                                                color: Get.theme.primaryColor,
                                              ))
                                          : IconButton(
                                              onPressed: controller.recAudio,
                                              icon: Icon(
                                                Icons.mic,
                                                color: Get.theme.primaryColor,
                                              )))),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Obx(() => !showDropButton.value
                      ? SizedBox.shrink()
                      : Positioned(
                          bottom: 130,
                          right: 8,
                          child: FloatingActionButton(
                            onPressed: () {
                              sController.animateTo(0,
                                  duration: Duration(seconds: 2),
                                  curve: Curves.linearToEaseOut);
                            },
                            backgroundColor: Get.theme.primaryColor,
                            child: Icon(
                              Icons.arrow_drop_down,
                              size: 40,
                            ),
                          )))
                ],
              ),
            ),
          );
        });
  }

  UserModel get otherUser {
    if (widget.room.user_a.id == widget.currentUserId)
      return widget.room.user_b;
    return widget.room.user_a;
  }

  void _setHasReadMessages(ChatController controller) {
    if (!controller.haveNoMoreMessages.value) {
      if (controller.chatsMap[widget.room.id]?.isNotEmpty ?? false)
        controller.getMessagesBefore(widget.room.id ?? -1,
            controller.chatsMap[widget.room.id]?.last.id ?? 0);
      else
        controller.haveNoMoreMessages.value = true;
    }
  }

  Widget _buildMessages(BuildContext context, int index) {
    final controller = _chatController;
    if (index == controller.chatsMap[widget.room.id]?.length) {
      _setHasReadMessages(controller);
      return Center(
          child: Obx(() => controller.haveNoMoreMessages.value
              ? SizedBox.shrink()
              : Container(
                  margin: EdgeInsets.all(8),
                  child: CircularProgressIndicator())));
    }
    if (controller.chatsMap[widget.room.id]?.isEmpty ?? true)
      return SizedBox.shrink();
    final itemChats = controller.chatsMap[widget.room.id]![index];
    if (itemChats.status != 2 && otherUser.id == itemChats.createdBy)
      controller.addMessagesForRead(itemChats.id);
    return MessageTile(
      messageModel: itemChats,
      sendByMe: itemChats.createdBy == controller.currentUserID,
      controller: controller,
      key: Key(itemChats.id.toString()),
    );
  }

  Widget _buildPopUpOptions() {
    return Obx(() => !sessionController.blockUsers.contains(otherUser.id!)
        ? PopupMenuButton(
            onSelected: _onSelectOptions,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.block,
                      color: Colors.red,
                    ),
                    title: Text('Bloquear'),
                  )),
            ],
          )
        : SizedBox.shrink());
  }

  void _onSelectOptions(int value) {
    switch (value) {
      case 0:
        _blockUser();
        break;
      default:
    }
  }

  void _blockUser() async {
    sessionController.blockUser(otherUser.id!);
  }
}
