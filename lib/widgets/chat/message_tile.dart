import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:knowme/controller/chat_controler.dart';
import 'package:knowme/models/message_model.dart';
import 'package:knowme/screens/image_screen.dart';
import 'package:knowme/widgets/chat/audio_tile.dart';

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
              constraints: BoxConstraints(
                  maxWidth: widget.messageModel.type == 3 ? Get.width : Get.width * 0.70,
                  minWidth: 40),
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                runSpacing: 12,
                children: [
                  sourceWidget,
                  Text(
                    widget.messageModel.text,
                    style: GoogleFonts.openSans(),
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 68, maxWidth: 150),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          DateTime.now().difference(widget.messageModel.createdAt).inHours >= 24
                              ? formatDate(widget.messageModel.createdAt,
                                  [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn])
                              : formatDate(widget.messageModel.createdAt, [HH, ':', nn]),
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
    if (widget.messageModel.type == 3)
      return AudioMessageTile(
          audioPath: widget.messageModel.src!,
          controller: widget.controller.sesssionController,
          key: Key(widget.messageModel.id.toString()));
    if (widget.messageModel.type == 2)
      return Container(
        width: 120,
        height: 40,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          onPressed: () => this.widget.controller.openVideoScreen(widget.messageModel.src),
          icon: Text('Video'),
          label: Icon(Icons.play_arrow_rounded),
        ),
      );
    if (widget.messageModel.type == 1)
      return FutureBuilder<String>(
          future: _future,
          builder: (context, snapshot) {
            return InkWell(
              onTap: snapshot.hasData
                  ? () => Get.to(() => ImageScreen(
                        imageUrl: snapshot.data ?? '',
                        imageKey: Key('abc'),
                        cacheKey: widget.messageModel.id.toString(),
                      ))
                  : null,
              child: Hero(
                tag: snapshot.data ?? '',
                child: CachedNetworkImage(
                  key: Key(snapshot.data ?? widget.messageModel.src ?? ''),
                  imageUrl: snapshot.data ?? widget.messageModel.src!,
                  cacheKey: widget.messageModel.id.toString(),
                  errorWidget: (context, url, error) {
                    return CircularProgressIndicator.adaptive();
                  },
                  progressIndicatorBuilder: (context, url, progress) => LinearProgressIndicator(),
                ),
              ),
            );
          });
    return SizedBox.shrink();
  }
}
