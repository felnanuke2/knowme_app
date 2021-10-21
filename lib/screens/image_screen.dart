import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/users_profile_screen.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen(
      {Key? key,
      required this.imageUrl,
      required this.imageKey,
      this.cacheKey,
      this.description,
      this.user})
      : super(key: key);
  final String imageUrl;
  final Key imageKey;
  String? cacheKey;
  String? description;
  UserModel? user;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late ImageProvider image;
  Color? color;
  final isUIVisible = true.obs;
  @override
  void initState() {
    image =
        CachedNetworkImageProvider(widget.imageUrl, cacheKey: widget.cacheKey);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values)
        .then((value) {});
    super.dispose();
  }

  _hiddeUi() async {
    if (isUIVisible.value) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
    isUIVisible.value = !isUIVisible.value;
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
                child: InkWell(
                  onTap: () {
                    _hiddeUi();
                  },
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
              ),
            ],
          ),
          Obx(() => Visibility(
                visible: isUIVisible.value,
                child: Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 1600),
                        child: AppBar(
                          iconTheme:
                              IconThemeData(color: Get.theme.primaryColor),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                        ))),
              )),
          if (widget.description != null)
            Obx(() => Visibility(
                  visible: isUIVisible.value,
                  child: DraggableScrollableSheet(
                    minChildSize: 0.1,
                    initialChildSize: 0.1,
                    maxChildSize: 0.6,
                    builder: (context, scrollController) => Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        ListView(
                          padding: EdgeInsets.all(12),
                          controller: scrollController,
                          children: [
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: widget.user!.profileName! + '# ',
                                  style: GoogleFonts.montserrat(
                                      color: Get.theme.primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.back();
                                      Get.to(() => UsersProfileScreen(
                                          userModel: widget.user!));
                                    }),
                              TextSpan(
                                text: widget.description!,
                                style: GoogleFonts.openSans(
                                    color: Colors.white, fontSize: 14),
                              )
                            ]))
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  bool fisrGesture = true;
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
      gestureDetailsIsChanged: (details) {
        if (fisrGesture) _hiddeUi();
        fisrGesture = false;
      },
      initialAlignment: InitialAlignment.center,
    );
  }
}
