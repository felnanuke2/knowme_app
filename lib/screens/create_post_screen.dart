import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/create_post_controller.dart';

import 'package:knowme/models/post_model.dart';

import 'package:video_player/video_player.dart';
import 'package:get/instance_manager.dart';

class CreatePostScreen extends StatefulWidget {
  final dynamic src;
  const CreatePostScreen({
    Key? key,
    required this.src,
  }) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  VideoPlayerController? controller;
  @override
  void initState() {
    if (widget.src is String) {
      initfile();
    }
    super.initState();
  }

  initfile() async {
    final file = File(widget.src);
    controller = VideoPlayerController.file(file);
    await controller!.initialize();
    setState(() {});
    controller?.play();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(
      init: CreatePostController(sesssionController: Get.find()),
      builder: (postController) => Scaffold(
        appBar: AppBar(
          actions: [
            TextButton.icon(
                onPressed: () => postController.createpost(widget.src),
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text(
                  'Finalizar',
                  style: TextStyle(color: Colors.white),
                ))
          ],
          title: Text('Nova Publicação'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: postController.formKey,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    child: widget.src is String
                        ? Center(
                            child: AspectRatio(
                                aspectRatio: controller!.value.aspectRatio,
                                child: VideoPlayer(controller!)))
                        : Image.memory(widget.src),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: postController.descriptionController,
                    validator: postController.validateDescription,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: 'Descrição'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
