import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';
import 'package:knowme/controller/chat_controler.dart';
import 'package:knowme/controller/main_screen/exploring_controller.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/events/posts_events.dart';
import 'package:knowme/events/stream_event.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/chat_room_model.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/models/post_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/chat_screen.dart';
import 'package:knowme/screens/complet_register_screen.dart';
import 'package:knowme/screens/create_post_screen.dart';
import 'package:knowme/screens/login_screen.dart';
import 'package:knowme/screens/settings/quiz/quiz_settings_screen.dart';
import 'package:knowme/screens/settings/settings_screen.dart';
import 'package:knowme/services/analitcs_services.dart';
import 'package:knowme/services/location_services.dart';
import 'package:knowme/services/push_notifications_services.dart';
import 'package:knowme/widgets/image_picker_bottom_sheet.dart';
import 'package:get/instance_manager.dart';

class SesssionController extends GetxController {
  var pageController = PageController();
  RxInt currentPage = 0.obs;
  final DbRepositoryInterface repository;
  final UserAuthInterface userAuthRepository;
  final interactionsSend = <InteractionsModel>[].obs;
  final interactionsReceived = <InteractionsModel>[].obs;

  final friends = <String>[].obs;
  final quizesToAnswer = <EntryQuizModel>[].obs;
  final posts = <PostModel>[].obs;
  late ChatController chatController;

  bool isLoadingCurrentUser;

  SesssionController({
    required this.repository,
    required this.userAuthRepository,
    this.isLoadingCurrentUser = true,
  }) {
    _initUserData();
  }

  _initUserData() async {
    if (userAuthRepository.currentUserdataCompleter.isCompleted ||
        userAuthRepository.getCurrentUser?.profileComplet == true) {
      isLoadingCurrentUser = false;
      chatController = Get.put(ChatController(sesssionController: this));
      Get.put(ExploringController(sessionController: this));
      update();
      await Future.delayed(Duration(milliseconds: 333));
      if (_verifyIfNeedCompletProfile() == true) return;
    } else {
      await userAuthRepository.currentUserdataCompleter.future;
      if (_verifyIfNeedCompletProfile() == true) return;
      await Future.delayed(Duration(milliseconds: 333));
      isLoadingCurrentUser = false;
      update();
    }
    if (userAuthRepository.getCurrentUser?.entryQuizID == null)
      _requestQuizCompletationDialog();

    await getReceivedInteractions();
    await getPosts();

    final latLng = await LocationServices.getLocation();
    if (userAuthRepository.getCurrentUser != null) {
      try {
        PushNotificationsServices.getToken().then((token) {
          if (token != null) {
            repository.updateUser(userAuthRepository.getCurrentUser!.id!,
                firebaseToken: token, lat: latLng?.lat, lng: latLng?.lng);
          }
        });
      } on RequestError catch (e) {
        print(e.message);
      }
    }
    await PushNotificationsServices.init();
    print(await PushNotificationsServices.getToken());
  }

  _verifyIfNeedCompletProfile() {
    if (userAuthRepository.getCurrentUser?.profileComplet == false) {
      Get.off(() => CompletRegisterScreen());
      return true;
    }
  }

  void onPageChange(int value) {
    pageController.animateToPage(value,
        duration: Duration(milliseconds: 450), curve: Curves.decelerate);
    currentPage.value = value;
  }

  void onSettingsPressed() {
    router.Get.to(() => SettingsScreen());
  }

  void _requestQuizCompletationDialog() async {
    await Future.delayed(Duration(seconds: 2));
    Get.dialog(SingleChildScrollView(
      child: AlertDialog(
        title: Text('Parece que você ainda não criou seu quiz de entrada.'),
        content: Text(
            'Para que os outros usuários possam te encontrar é necessário completa-lo.'),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
                Get.to(() => QuizSettingsScren());
              },
              child: Text('Completar Quiz'))
        ],
      ),
    ));
  }

  void createPost() async {
    final image = await ImagePickerBottomSheet.showImagePickerBottomSheet(
        Get.context!,
        video: true);
    if (image == null) return;
    Get.to(() => CreatePostScreen(
          src: image,
        ));
  }

  Future<void> getPosts() async {
    getFriends();
    final result = await repository.getPosts();
    posts.clear();
    posts.addAll(result);
    return;
  }

  Stream<StreamEvent> getPostsBefore() async* {
    yield LoadingPosts();
    final result = await repository.getPostsBefore(int.parse(posts.last.id));
    if (result.isEmpty) {
      yield NoMorePosts();
    } else {
      posts.addAll(result);
      yield SuccessGetingPosts();
    }
  }

  Future<void> getReceivedInteractions() async {
    try {
      final receivedInteractions = await repository
          .getInteractionsReceived(userAuthRepository.getCurrentUser!.id!);
      this.interactionsReceived.value = receivedInteractions;
    } on RequestError catch (e) {
      print(e.message);
    }
  }

  Future<void> updateInteraction(
      InteractionsModel interaction, int status) async {
    final index = interactionsReceived.indexOf(interaction);
    final user = interactionsReceived[index].user;
    try {
      final response =
          await repository.updateInteraction(interaction.id, status);
      interactionsReceived[index] = response..user = user;
      return;
    } on RequestError catch (e) {
      print(e.message);
    }
  }

  Future<void> getListOfQuizes({double maxDistance = 50, Sex? sex}) async {
    print('callGetQuizes');
    try {
      final latLng = await LocationServices.getLocation();
      if (latLng == null) return;
      AnalitcsServices.instance.logEvent(
          analitcsEnum: AnalitcsEnum.UserLocation,
          data: {'latitude': latLng.lat, 'longitude': latLng.lng});

      final list = await repository.getNearbyUsers(
          latitude: latLng.lat,
          longitude: latLng.lng,
          sex: sex,
          maxDistance: maxDistance);
      quizesToAnswer.clear();
      quizesToAnswer.addAll(list);
    } on RequestError catch (e) {
      print(e.message);
    }
  }

  getFriends() async {
    final list = await repository
        .getFriends(userAuthRepository.getCurrentUser?.id ?? '');
    friends.clear();
    friends.addAll(list);
  }

  List<InteractionsModel> get aceptedInteractions =>
      interactionsSend.where((element) => element.status == 1).toList();

  openChat(UserModel? userModel) async {
    if (userModel == null) return;
    pageController.jumpToPage(3);
    Get.back();
    _openChatCreen(userModel);
  }

  _openChatCreen(UserModel userModel) {
    print(chatController.chatRooms.length);
    ChatRoomModel? room;
    try {
      room = chatController.chatRooms.firstWhere((element) =>
          [userModel.id, userAuthRepository.getCurrentUser?.id]
              .contains(element.user_a.id) &&
          [userModel.id, userAuthRepository.getCurrentUser?.id]
              .contains(element.user_b.id));
    } catch (e) {
      print(e);
    }

    Get.to(() => ChatScreen(
        chatList: chatController.chatsMap[room?.id ?? -1] ?? [],
        room: room ??
            ChatRoomModel(
                id: null,
                created_at: DateTime.now(),
                status: 1,
                user_a: userAuthRepository.getCurrentUser!,
                user_b: userModel),
        currentUserId: userAuthRepository.getCurrentUser!.id!));
  }

  singOut() async {
    await userAuthRepository.singOut();
    Get.offAll(LoginScreen());
  }
}
