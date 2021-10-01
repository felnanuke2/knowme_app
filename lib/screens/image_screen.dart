import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen({Key? key, required this.imageUrl, required this.imageKey, this.cacheKey})
      : super(key: key);
  final String imageUrl;
  final Key imageKey;
  String? cacheKey;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late ImageProvider image;
  Color? color;
  @override
  void initState() {
    image = CachedNetworkImageProvider(widget.imageUrl, cacheKey: widget.cacheKey);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values)
        .then((value) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Hero(
                  tag: widget.imageUrl,
                  child: ExtendedImage(
                    image: image,
                    mode: ExtendedImageMode.gesture,
                    initGestureConfigHandler: _gestureConfg,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              child: BackButton(
            color: Get.theme.primaryColor,
          ))
        ],
      ),
    );
  }

  GestureConfig _gestureConfg(ExtendedImageState state) {
    return GestureConfig(
      minScale: 0.9,
      animationMinScale: 0.7,
      maxScale: 3.0,
      animationMaxScale: 3.5,
      speed: 1.0,
      inertialSpeed: 100.0,
      initialScale: 1.0,
      inPageView: false,
      initialAlignment: InitialAlignment.center,
    );
  }
}
