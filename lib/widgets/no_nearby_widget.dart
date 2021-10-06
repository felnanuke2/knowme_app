import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/widgets/profile_image_widget.dart';

class NoNearbyWidget extends StatelessWidget {
  NoNearbyWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);
  final image = AssetImage('assets/radar.gif');
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    image.evict;
    return Container(
      color: Get.theme.primaryColor,
      child: Center(
        child: CircleAvatar(
          radius: 100,
          backgroundColor: Colors.white,
          child: Stack(
            children: [
              ClipOval(
                child: Image(
                  image: image,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: ProfileImageWidget(imageUrl: imageUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
