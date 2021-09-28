import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/chat_controler.dart';
import 'package:knowme/widgets/chat_conversation_tile.dart';
import 'package:get/instance_manager.dart';

class MessagesTab extends StatefulWidget {
  const MessagesTab({Key? key}) : super(key: key);

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ChatController>(
      init: ChatController(sesssionController: Get.find()),
      builder: (controller) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.person),
        ),
        body: Container(
          child: Obx(() => RefreshIndicator(
                onRefresh: controller.onRefresh,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 80),
                  itemCount: controller.listChat.length,
                  itemBuilder: (context, index) {
                    final roomItem = controller.listChat[index];

                    return Obx(() {
                      final lastMessage = controller.chatsMap[roomItem.id];
                      return ChatConvesationTile(
                        chatRoom: roomItem,
                        listMessages: lastMessage ?? [],
                        currentUserId: controller.currentUserID,
                      );
                    });
                  },
                ),
              )),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
