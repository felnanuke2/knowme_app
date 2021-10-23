import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/widgets/loading_more_post_widget.dart';
import 'package:knowme/widgets/post_widget.dart';

class FeedTab extends StatefulWidget {
  FeedTab({Key? key}) : super(key: key);

  @override
  _FeedTabState createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SesssionController>(
      builder: (controller) => Container(
          color: Color(0xffEBEAEB), child: _scolableListCount(controller)),
    );
  }

  Widget _scolableListCount(SesssionController controller) {
    return RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Obx(() => ListView.builder(
            itemCount: controller.posts.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.posts.length) {
                return LoadingMorePostsWidget(
                  sesssionController: controller,
                  key: UniqueKey(),
                );
              }
              final itemPost = controller.posts[index];
              return PostWidget(
                controller: controller,
                postModel: itemPost,
                key: Key(itemPost.id),
                thisIndex: index,
              );
            })),
        onRefresh: controller.getPosts);
  }

  PageView _buildPageview(SesssionController controller) {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.posts.length,
        itemBuilder: (context, index) {
          final itemPost = controller.posts[index];
          return PostWidget(
            controller: controller,
            postModel: itemPost,
            key: Key(index.toString()),
            thisIndex: index,
          );
        });
  }
}
