import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/widgets/answers_dialog.dart';
import 'package:knowme/widgets/profile_image_widget.dart';
import 'package:get/state_manager.dart';

class ReceivedInteractionTile extends StatelessWidget {
  ReceivedInteractionTile({
    Key? key,
    required this.interaction,
    required this.controller,
  }) : super(key: key);
  final InteractionsModel interaction;
  final SesssionController controller;
  final loadingUpdate = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 12),
          child: Column(
            children: [
              Container(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enviado ' + timeago.format(interaction.createdAt, locale: 'pt'),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                        onPressed: () => AnswersDialog.showDialog(interaction.answers),
                        child: Text('Ver Respostas')),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageWidget(radius: 60, imageUrl: interaction.user?.profileImage ?? ''),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          interaction.user?.completName ?? '',
                          maxLines: 1,
                          style: Get.textTheme.subtitle2,
                        ),
                        Text(
                          (interaction.user?.profileName ?? '') + '#',
                          maxLines: 1,
                          style: Get.textTheme.bodyText2
                              ?.copyWith(fontWeight: FontWeight.w300, fontSize: 13),
                        ),
                      ],
                    ),
                  )),
                  if (interaction.status == 0)
                    Obx(() => loadingUpdate.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    loadingUpdate.value = true;
                                    controller
                                        .updateInteraction(interaction, 1)
                                        .then((value) => loadingUpdate.value = false);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.checkmark,
                                    color: Colors.green,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    loadingUpdate.value = true;
                                    controller
                                        .updateInteraction(interaction, 2)
                                        .then((value) => loadingUpdate.value = false);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.clear,
                                    color: Colors.red,
                                  )),
                              PopupMenuButton(
                                itemBuilder: (context) => [],
                              )
                            ],
                          )),
                  if (interaction.status == 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          CupertinoIcons.checkmark,
                          color: Colors.green,
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) => [],
                        )
                      ],
                    ),
                  if (interaction.status == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) => [],
                        )
                      ],
                    )
                ],
              ),
              SizedBox(
                height: 35,
              )
            ],
          ),
        ),
      ),
    );
  }
}
