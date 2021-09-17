import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/widgets/received_interaction_tile.dart';

class ReceivedInteractionsScreen extends StatefulWidget {
  const ReceivedInteractionsScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedInteractionsScreen> createState() => _ReceivedInteractionsScreenState();
}

class _ReceivedInteractionsScreenState extends State<ReceivedInteractionsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SesssionController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Interações Recebidas'),
          actions: [
            FutureBuilder(
                future: controller.getReceivedInteractions(),
                builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : SizedBox.shrink()),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Obx(() => RefreshIndicator(
                      onRefresh: controller.getReceivedInteractions,
                      child: ListView.builder(
                        itemCount: controller.interactionsReceived.length,
                        itemBuilder: (context, index) {
                          final interactionItem = controller.interactionsReceived[index];
                          return ReceivedInteractionTile(
                            interaction: interactionItem,
                            controller: controller,
                          );
                        },
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
