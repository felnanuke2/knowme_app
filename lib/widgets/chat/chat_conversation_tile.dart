import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:knowme/controller/chat_controler.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/chat_screen.dart';

class ChatConvesationTile extends StatelessWidget {
  final ChatRoomModel chatRoom;
  final String currentUserId;
  final List<MessageModel> listMessages;
  final ChatController controller;
  const ChatConvesationTile({
    Key? key,
    required this.chatRoom,
    required this.currentUserId,
    required this.listMessages,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ChatScreen(
            chatList: listMessages,
            currentUserId: currentUserId,
            room: chatRoom,
          )),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              child: ClipOval(
                child: CachedNetworkImage(imageUrl: otherUser.profileImage!),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(otherUser.completName!,
                              maxLines: 1,
                              style:
                                  GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                        Text(date, maxLines: 1, style: GoogleFonts.montserrat(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.openSans(),
                          ),
                        ),
                        if (unreadMessages != '0')
                          CircleAvatar(
                            radius: 14,
                            child: Text(
                              unreadMessages,
                              style: GoogleFonts.openSans(fontSize: 12),
                              maxLines: 1,
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  UserModel get otherUser {
    if (chatRoom.user_a.id == currentUserId) return chatRoom.user_b;
    return chatRoom.user_a;
  }

  String get unreadMessages {
    final unread = listMessages
        .where((element) => element.status != 2 && element.createdBy == otherUser.id)
        .toList();

    return (unread.length -
            unread
                .where((element) => controller.messagesForRead.contains(element.id))
                .toList()
                .length)
        .toString();
  }

  String get text {
    if (listMessages.isEmpty) return '';
    if (listMessages.first.type == 1) return 'Imagem';
    if (listMessages.first.type == 2) return 'Video';
    if (listMessages.first.type == 3) return 'Áudio';

    return listMessages.first.text;
  }

  String get date {
    if (listMessages.isEmpty) return '';
    return timeago
        .format(listMessages.first.createdAt, locale: 'pt')
        .replaceAll('há poucos segundos', 'agora');
  }
}
