import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart' as router;
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/controller/main_screen/profile_controller.dart';
import 'package:knowme/widgets/post_mini_widget.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<SesssionController>(
        builder: (sessionController) => GetBuilder<ProfileController>(
              init: ProfileController(sesssionController: sessionController),
              builder: (profileController) => Container(
                  child: sessionController.userAuthRepository.currentUser == null
                      ? Text('Erro ao Obter o Usuário')
                      : NestedScrollView(
                          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: 45,
                                          ),
                                          width: 140,
                                          height: 140,
                                          child: Obx(() => ClipOval(
                                                child: profileController.loadingProfileImage.value
                                                    ? Center(
                                                        child: CircularProgressIndicator(),
                                                      )
                                                    : sessionController.userAuthRepository
                                                                .currentUser!.profileImage ==
                                                            null
                                                        ? InkWell(
                                                            onTap: profileController
                                                                .changeProfileImage,
                                                            child: CircleAvatar(
                                                              child: Icon(Icons.person),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: profileController
                                                                .changeProfileImage,
                                                            child: CachedNetworkImage(
                                                              imageUrl: sessionController
                                                                  .userAuthRepository
                                                                  .currentUser!
                                                                  .profileImage!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                              )),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          sessionController
                                                  .userAuthRepository.currentUser!.completName ??
                                              "",
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: router.Get.textTheme.headline6!
                                              .copyWith(fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        sessionController
                                                .userAuthRepository.currentUser!.profileName ??
                                            '' + '#',
                                        style:
                                            router.Get.textTheme.headline3!.copyWith(fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Text(sessionController
                                                    .userAuthRepository.currentUser!.bio ??
                                                '')),
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
                                                Obx(() => Text(
                                                    (sessionController.interactionsSend.length)
                                                        .toString())),
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
                                                Obx(
                                                  () => Text((sessionController
                                                          .interactionsReceived.length)
                                                      .toString()),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: 280,
                                        child: ElevatedButton(
                                          child: Text('Editar Perfil'),
                                          onPressed: profileController.editUserProfileIndos,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                          body: Obx(() => Container(
                                margin: EdgeInsets.only(top: 15),
                                child: RefreshIndicator(
                                  onRefresh: profileController.getMyPosts,
                                  child: GridView.builder(
                                    padding: EdgeInsets.only(top: 15, left: 4, right: 4),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 4,
                                        crossAxisCount: 3,
                                        childAspectRatio: 1),
                                    itemCount: profileController.poststList.length,
                                    itemBuilder: (context, index) {
                                      var postItem = profileController.poststList[index];
                                      return PostMiniWidget(post: postItem);
                                    },
                                  ),
                                ),
                              )))),
            ));
  }

  @override
  bool get wantKeepAlive => true;
}
