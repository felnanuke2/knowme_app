import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:knowme/controller/chat_controler.dart';
import 'package:knowme/models/message_model.dart';

class MessageTile extends StatefulWidget {
  final MessageModel messageModel;
  const MessageTile({
    Key? key,
    required this.messageModel,
    required this.sendByMe,
    required this.controller,
  }) : super(key: key);
  final bool sendByMe;
  final ChatController controller;

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  var _future;
  @override
  void initState() {
    if (widget.messageModel.src != null)
      _future = widget.controller.repository.getImageUrl(widget.messageModel.src!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Card(
          elevation: 0,
          color: widget.sendByMe
              ? Colors.green.shade200.withOpacity(0.2)
              : Get.theme.primaryColor.withOpacity(0.080),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.70, minWidth: 40),
              child: Wrap(
                alignment: WrapAlignment.end,
                children: [
                  sourceWidget,
                  Text(
                    widget.messageModel.text,
                    style: GoogleFonts.openSans(),
                  ),
                  Container(
                    width: 68,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          formatDate(widget.messageModel.createdAt, [HH, ':', mm]),
                          textAlign: TextAlign.end,
                          style: GoogleFonts.openSans(color: Colors.grey.shade800.withOpacity(0.8)),
                        ),
                        if (widget.sendByMe)
                          SizedBox(
                            width: 6,
                          ),
                        if (widget.sendByMe) messageStatusIcon,
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

  Widget get messageStatusIcon {
    if (widget.messageModel.status == 0)
      return Container(
        width: 12,
        height: 12,
        child: SvgPicture.asset(
          'assets/message_sender.svg',
          color: Colors.grey,
        ),
      );
    if (widget.messageModel.status == 1)
      return Container(
        width: 12,
        height: 12,
        child: SvgPicture.asset(
          'assets/message_sender.svg',
          color: Get.theme.primaryColor,
        ),
      );

    return Container(
      width: 18,
      height: 18,
      child: SvgPicture.asset(
        'assets/messager_reader.svg',
        color: Get.theme.primaryColor,
      ),
    );
  }

  Widget get sourceWidget {
    if (widget.messageModel.type == 0) return SizedBox.shrink();
    if (widget.messageModel.type == 1)
      return FutureBuilder<String>(
          future: _future,
          builder: (context, snapshot) {
            return CachedNetworkImage(
              key: Key(snapshot.data ?? widget.messageModel.src!),
              imageUrl: snapshot.data ?? widget.messageModel.src!,
              cacheKey: widget.messageModel.id.toString(),
              errorWidget: (context, url, error) {
                return CircularProgressIndicator.adaptive();
              },
              progressIndicatorBuilder: (context, url, progress) => LinearProgressIndicator(),
            );
          });
    return SizedBox.shrink();
  }
}
