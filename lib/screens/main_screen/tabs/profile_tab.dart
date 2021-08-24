import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart' as router;
import 'package:knowme/controller/main_screen/profile_controller.dart';
import 'package:knowme/controller/user_controller.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (userController) => GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (profileController) => Container(
            child: userController.currentUser == null && !userController.isLoading
                ? Text('Erro Ao Obter o Usuário')
                : NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 45,
                                ),
                                Container(
                                  width: 140,
                                  height: 140,
                                  child: ClipOval(
                                    child: Image.network(
                                      userController.currentUser!.profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  userController.currentUser!.completName,
                                  style: router.Get.textTheme.headline6!.copyWith(fontSize: 18),
                                ),
                                Text(
                                  userController.currentUser!.profileName + '#',
                                  style: router.Get.textTheme.headline3!.copyWith(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(userController.currentUser!.bio ?? '')),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Seguidores',
                                            textAlign: TextAlign.center,
                                            style: router.Get.textTheme.headline2!
                                                .copyWith(fontSize: 14),
                                          ),
                                          Text(userController.currentUser!.followMe.length
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Seguindo',
                                            textAlign: TextAlign.center,
                                            style: router.Get.textTheme.headline2!
                                                .copyWith(fontSize: 14),
                                          ),
                                          Text(
                                              userController.currentUser!.follow.length.toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Interações Enviadas',
                                            textAlign: TextAlign.center,
                                            style: router.Get.textTheme.headline2!
                                                .copyWith(fontSize: 14),
                                          ),
                                          Text(userController.currentUser!.followMe.length
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Interações Recebidas',
                                            textAlign: TextAlign.center,
                                            style: router.Get.textTheme.headline2!
                                                .copyWith(fontSize: 14),
                                          ),
                                          Text(userController.currentUser!.followMe.length
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                    body: GridView.builder(
                      padding: EdgeInsets.only(top: 15, left: 4, right: 4),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          crossAxisCount: 3,
                          childAspectRatio: 1),
                      itemCount: profileController.poststList.length,
                      itemBuilder: (context, index) {
                        var postItem = profileController.poststList[index];
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(postItem.src, fit: BoxFit.cover));
                      },
                    ))),
      ),
    );
  }
}
