import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/chat_screen.dart';

class ChatConvesationTile extends StatelessWidget {
  final ChatRoomModel chatRoom;
  final String currentUserId;
  final List<MessageModel> listMessages;
  const ChatConvesationTile({
    Key? key,
    required this.chatRoom,
    required this.currentUserId,
    required this.listMessages,
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
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Text(timeago.format(listMessages.last.createdAt, locale: 'pt'),
                            maxLines: 1, style: GoogleFonts.montserrat(fontSize: 12)),
                      ],
                    ),
                    Text(
                      listMessages.last.text,
                      maxLines: 2,
                      style: GoogleFonts.openSans(),
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
}
