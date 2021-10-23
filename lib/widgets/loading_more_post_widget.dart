import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/events/posts_events.dart';
import 'package:knowme/events/stream_event.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LoadingMorePostsWidget extends StatefulWidget {
  final SesssionController sesssionController;
  const LoadingMorePostsWidget({
    Key? key,
    required this.sesssionController,
  }) : super(key: key);

  @override
  _LoadingMorePostsWidgetState createState() => _LoadingMorePostsWidgetState();
}

class _LoadingMorePostsWidgetState extends State<LoadingMorePostsWidget> {
  final _evenStream = StreamController<StreamEvent>.broadcast();
  StreamEvent? _lastEvent;

  @override
  void initState() {
    widget.sesssionController.getPostsBefore().listen((event) {
      _evenStream.add(event);
    });
    super.initState();
    _evenStream.stream.listen(_setlasEvent);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: _oVisibilityChange,
      child: StreamBuilder<StreamEvent>(
          stream: _evenStream.stream, builder: _buildSomeView),
    );
  }

  Widget _buildSomeView(
      BuildContext context, AsyncSnapshot<StreamEvent> snapshot) {
    final state = snapshot.data;
    switch (state.runtimeType) {
      case LoadingPosts:
        return _buildLoadingMorePosts();
      case NoMorePosts:
        return _buildNoMorePosts();
      default:
        return _buildDefaulWidget();
    }
  }

  Widget _buildLoadingMorePosts() {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircularProgressIndicator(),
              Text(
                'Carregando Publicações',
                style: GoogleFonts.openSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoMorePosts() {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Isso é tudo por Hoje.',
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.primaryColor),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                'Você pode interagir com mais pessoas para ver mais publicações.',
                style: GoogleFonts.openSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaulWidget() {
    return Container();
  }

  void _oVisibilityChange(VisibilityInfo info) {
    if (info.visibleFraction > 0.6 &&
        _lastEvent.runtimeType != NoMorePosts &&
        _lastEvent.runtimeType != LoadingPosts) {
      widget.sesssionController.getPostsBefore().listen(_setlasEvent);
    }
  }

  void _setlasEvent(StreamEvent event) {
    _lastEvent = event;
  }
}
