import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:knowme/models/post_model.dart';

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
        ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: CachedNetworkImage(
              imageUrl: post.mediaType == 0 ? post.thumbnail ?? '' : post.src,
              fit: BoxFit.cover,
            )),
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
