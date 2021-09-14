import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/widgets/post_widget.dart';
import 'package:get/state_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FeedTab extends StatefulWidget {
  FeedTab({Key? key}) : super(key: key);

  @override
  _FeedTabState createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  final currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SesssionController>(
      builder: (controller) => Container(
          child: PageView.builder(
              onPageChanged: (value) => currentIndex.value = value,
              scrollDirection: Axis.vertical,
              itemCount: controller.posts.length,
              itemBuilder: (context, index) {
                final itemPost = controller.posts[index];
                return PostWidget(
                  postModel: itemPost,
                  key: Key(index.toString()),
                  currentIndex: currentIndex,
                  thisIndex: index,
                );
              })),
    );
  }
}
