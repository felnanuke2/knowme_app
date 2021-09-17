import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String imageUrl;
  double radius;
  ProfileImageWidget({
    Key? key,
    required this.imageUrl,
    this.radius = 140,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Icon(Icons.person),
        ),
      ),
    );
  }
}
