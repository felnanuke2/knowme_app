import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:knowme/controller/home_tab_controller.dart';
import 'package:knowme/models/impression_model.dart';

class ImpressionWidget extends StatefulWidget {
  final ImpressionModel impression;
  final HomeTabController controller;
  const ImpressionWidget({
    Key? key,
    required this.impression,
    required this.controller,
  }) : super(key: key);

  @override
  State<ImpressionWidget> createState() => _ImpressionWidgetState();
}

class _ImpressionWidgetState extends State<ImpressionWidget> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    widget.controller.checkImpression(widget.impression.impressions_id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        child: Card(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: () => widget.controller.openQuiz(widget.impression),
              child: CachedNetworkImage(
                imageUrl: widget.impression.profile_image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
