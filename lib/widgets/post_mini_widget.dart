import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/models/post_model.dart';
import 'package:knowme/screens/image_screen.dart';
import 'package:knowme/screens/video_screen.dart';

class PostMiniWidget extends StatelessWidget {
  final PostModel post;
  const PostMiniWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () => post.mediaType == 1
              ? Get.to(() => ImageScreen(
                    imageUrl: post.src,
                    imageKey: Key(post.id),
                    description: post.description,
                    user: post.userModel!,
                  ))
              : Get.to(() => VideoScreen(
                    src: post.src,
                    controller: Get.find(),
                    isPrivate: false,
                    description: post.description,
                    userModel: post.userModel,
                  )),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                imageUrl: post.mediaType == 0 ? post.thumbnail ?? '' : post.src,
                fit: BoxFit.cover,
              )),
        ),
        if (post.mediaType == 0)
          Positioned(
              right: 8,
              top: 8,
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ))
      ],
    ));
  }
}
