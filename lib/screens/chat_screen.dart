import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/chat_controler.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/widgets/message_tile.dart';
import 'package:get/instance_manager.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key? key,
    required this.chatList,
    required this.room,
    required this.currentUserId,
  }) : super(key: key);
  final List<MessageModel> chatList;
  final ChatRoomModel room;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Column(
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
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Obx(() => ListView.builder(
                        reverse: true,
                        itemCount: controller.chatsMap[room.id]?.length ?? 0,
                        itemBuilder: (context, index) {
                          final itemChats = controller.chatsMap[room.id]![index];
                          if (itemChats.status != 2 && otherUser.id == itemChats.createdBy)
                            controller.addMessagesForRead(itemChats.id);
                          return MessageTile(
                            messageModel: itemChats,
                            sendByMe: itemChats.createdBy == controller.currentUserID,
                            controller: controller,
                            key: Key(itemChats.id.toString()),
                          );
                        },
                      ))),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => controller.sendMediaMessage(otherUser.id!, room.id),
                        icon: Icon(
                          Icons.attach_file,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: controller.messageTEC,
                        onChanged: controller.onMessageChange,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.05),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide(color: Colors.transparent))),
                      )),
                      Obx(() => controller.sendingMessage.value
                          ? Center(
                              child: Container(
                                  width: 28, height: 28, child: CircularProgressIndicator()),
                            )
                          : Obx(() => controller.text.value.isNotEmpty
                              ? IconButton(
                                  onPressed: () => controller.sendTextMessage(otherUser.id!,
                                      chatRoomID: room.id),
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
        ),
      ),
    );
  }

  UserModel get otherUser {
    if (room.user_a.id == currentUserId) return room.user_b;
    return room.user_a;
  }
}
