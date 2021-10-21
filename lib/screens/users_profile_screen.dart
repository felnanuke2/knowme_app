import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/post_model.dart';

import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/answer_quiz_scree.dart';
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
  bool isFriends = false;
  final answered = false.obs;
  final loading = false.obs;
  late DbRepositoryInterface repo;
  late SesssionController sesssionController;
  @override
  void initState() {
    sesssionController = Get.find<SesssionController>();

    repo = Get.find<DbRepositoryInterface>();
    _checkIfExistInteraction();
    super.initState();
  }

  getPosts() {
    if (isFriends)
      repo.getPosts([widget.userModel.id ?? '']).then((value) {
        poststList.addAll(value);
        setState(() {});
      });
  }

  _getUserDetails() async {
    widget.userModel = await repo.getCurrentUser(widget.userModel.id ?? '');
    setState(() {});
  }

  _checkIfExistInteraction() async {
    loading.value = true;
    await sesssionController.getFriends();
    isFriends = sesssionController.friends.contains(widget.userModel.id);
    await _getUserDetails();
    final result = await sesssionController.repository
        .checkIfExistInterationBtween(widget.userModel.id!);
    answered.value = result;
    getPosts();

    loading.value = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Get.theme.primaryColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (isFriends)
            TextButton.icon(
                onPressed: () => sesssionController.openChat(widget.userModel),
                icon: Text('Mensagem'),
                label: Icon(Icons.message_outlined,
                    color: router.Get.theme.primaryColor))
        ],
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
                              child: ProfileImageWidget(
                                  imageUrl:
                                      widget.userModel.profileImage ?? ''),
                            ),
                          ),
                          if (isFriends)
                            Container(
                              child: Text(
                                widget.userModel.completName ?? "",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: router.Get.textTheme.headline6!
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          Text(
                            (widget.userModel.profileName ?? '') + '#',
                            style: router.Get.textTheme.headline3!
                                .copyWith(fontSize: 15),
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
              body: isFriends
                  ? Container(
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
                    )
                  : Container(
                      padding: EdgeInsets.all(18),
                      child: Card(
                        child: Obx(() => loading.value
                            ? Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : !answered.value
                                ? _canAnser()
                                : _awaitForAnswer()),
                      ),
                    ))),
    );
  }

  Column _canAnser() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            'Para poder ver as publicações desse usuário ou enviar mensagens você precisa',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 16),
          ),
        ),
        TextButton(
            onPressed: _openQuizInProfile,
            child: Text(
              'Responder ao Quiz',
              style: GoogleFonts.openSans(fontSize: 20),
            ))
      ],
    );
  }

  Container _awaitForAnswer() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Text(
          'Aguardando a resposta do usuário',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(fontSize: 16),
        ),
      ),
    );
  }

  _openQuizInProfile() async {
    final quiz = await sesssionController.repository
        .getQuiz(widget.userModel.entryQuizID!);
    quiz.user = widget.userModel;
    final response = await router.Get.to(() => AnswerQuizScreen(quiz: quiz));
    if (response != null) {
      answered.value = true;
    }
  }
}
