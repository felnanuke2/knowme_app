import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:knowme/models/message_model.dart';

class MessageTile extends StatelessWidget {
  final MessageModel messageModel;
  const MessageTile({
    Key? key,
    required this.messageModel,
    required this.sendByMe,
  }) : super(key: key);
  final bool sendByMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Card(
          elevation: 0,
          color: sendByMe
              ? Colors.green.shade200.withOpacity(0.2)
              : Get.theme.primaryColor.withOpacity(0.080),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.80, minWidth: 40),
              child: Wrap(
                alignment: WrapAlignment.end,
                children: [
                  Text(
                    messageModel.text,
                    style: GoogleFonts.openSans(),
                  ),
                  if (sendByMe)
                    Container(
                      width: 68,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            formatDate(messageModel.createdAt, [HH, ':', mm]),
                            textAlign: TextAlign.end,
                            style:
                                GoogleFonts.openSans(color: Colors.grey.shade800.withOpacity(0.8)),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          if (messageModel.status == 0)
                            Container(
                              width: 12,
                              height: 12,
                              child: SvgPicture.asset(
                                'assets/message_sender.svg',
                                color: Colors.grey,
                              ),
                            ),
                          if (messageModel.status == 1)
                            Container(
                              width: 12,
                              height: 12,
                              child: SvgPicture.asset(
                                'assets/message_sender.svg',
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          if (messageModel.status == 2)
                            Container(
                              width: 18,
                              height: 18,
                              child: SvgPicture.asset(
                                'assets/messager_reader.svg',
                                color: Get.theme.primaryColor,
                              ),
                            )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
