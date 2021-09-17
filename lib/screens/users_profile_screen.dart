import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/post_model.dart';

import 'package:knowme/models/user_model.dart';
import 'package:knowme/widgets/post_mini_widget.dart';
import 'package:knowme/widgets/profile_image_widget.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/instance_manager.dart';

class UsersProfileScreen extends StatefulWidget {
  UsersProfileScreen({
    Key? key,
    required this.userModel,
  }) : super(key: key);
  UserModel userModel;

  @override
  State<UsersProfileScreen> createState() => _UsersProfileScreenState();
}

class _UsersProfileScreenState extends State<UsersProfileScreen> {
  final poststList = <PostModel>[];
  @override
  void initState() {
    final repo = Get.find<DbRepositoryInterface>();
    repo.getCurrentUser(widget.userModel.id ?? '').then((value) {
      widget.userModel = value;
      setState(() {});
    });
    repo.getPosts([widget.userModel.id ?? '']).then((value) {
      poststList.addAll(value);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Get.theme.primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 12,
                              ),
                              child:
                                  ProfileImageWidget(imageUrl: widget.userModel.profileImage ?? ''),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.userModel.completName ?? "",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: router.Get.textTheme.headline6!.copyWith(fontSize: 18),
                            ),
                          ),
                          Text(
                            widget.userModel.profileName ?? '' + '#',
                            style: router.Get.textTheme.headline3!.copyWith(fontSize: 15),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(widget.userModel.bio ?? '')),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
              body: Container(
                margin: EdgeInsets.only(top: 15),
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 15, left: 4, right: 4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: 3,
                      childAspectRatio: 1),
                  itemCount: poststList.length,
                  itemBuilder: (context, index) {
                    var postItem = poststList[index];
                    return PostMiniWidget(post: postItem);
                  },
                ),
              ))),
    );
  }
}
