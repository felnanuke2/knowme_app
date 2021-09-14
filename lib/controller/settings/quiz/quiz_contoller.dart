import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/instance_manager.dart' as instance;
import 'package:get/state_manager.dart';
import 'package:knowme/services/image_service.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/mock/entry_quiz_mock.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/image_upload_model.dart';
import 'package:knowme/models/question_model.dart';
import 'package:knowme/repositorys/firebase_repository.dart';
import 'package:knowme/screens/main_screen/main_screen.dart';
import 'package:knowme/screens/settings/quiz/create_update_question_scree.dart';

class QuizController extends GetxController {
  final UserAuthInterface userAuthRepo;
  final DbRepositoryInterface repository;
  EntryQuizModel? quizModel;
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  RxList<ImageUploadModel> imagesList = <ImageUploadModel>[].obs;

  final pageController = PageController();
  var pageIndex = 0.obs;
  List<String> deletedImages = [];
  bool loadingQuiz = false;
  QuizController({
    required this.userAuthRepo,
    required this.repository,
  }) {
    if (userAuthRepo.currentUser?.entryQuizID == null) {
      _setDefaultQuestionsList();
    } else {
      _getQuizData();
    }
    pageController.addListener(() {
      pageIndex.value = pageController.page!.round();
    });
  }
  _getQuizData() async {
    loadingQuiz = true;
    update();
    var responseQuiz = await repository.getQuiz(userAuthRepo.currentUser!.entryQuizID!);
    if (responseQuiz != null) {
      await _setDefaultQuestionsList(quiz: responseQuiz);
      loadingQuiz = false;
      update();
    }
  }

  _setDefaultQuestionsList({EntryQuizModel? quiz}) async {
    quizModel = quiz == null ? ENTRY_QUIZ_MOCK : quiz;
    questions.addAll(quizModel!.questions);
    //Add Images to ImageList
    if (quizModel!.presentImagesList.isNotEmpty) {
      quizModel!.presentImagesList.forEach((element) {
        imagesList.add(ImageUploadModel(imageUrl: element));
      });
      await _getImageBytesFromString();
    }
  }

  /// will getBytelImageFrom StringUrl
  _getImageBytesFromString() async {
    for (var index = 0; index < quizModel!.presentImagesList.length; index++) {
      var byteImage =
          await repository.getImageBytesFromURL(url: quizModel!.presentImagesList[index]);
      imagesList[index].byteImage = byteImage;
    }
  }

  void onNewQuizPressed() async {
    var question = await router.Get.to(() => CreateUpdateQuestionScreen());
    if (question == null) return;
    questions.add(question);
  }

  void onTapQuestionTile(int index, QuestionModel questionModel) async {
    var question = await router.Get.to(() => CreateUpdateQuestionScreen(
          questionModel: questionModel,
        ));
    if (question == null) return;
    questions[index] = (question);
  }

  onDeletQuestionPressed(List<QuestionModel> questionList, QuestionModel questionItem) async {
    final result = await _confirmDialog('Deseja remover essa pergunta??');
    if (result != null) questionList.remove(questionItem);
  }

  void pickImage() async {
    var image = await ImageServices.pickMultipleImage(imagesList, ratioX: 3, ratioY: 4);

    final _index = imagesList.length - 1;
    pageController.jumpToPage(_index);
    pageIndex.value = _index;
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final oldImage = imagesList[oldIndex];
    final newImage = imagesList[newIndex];
    imagesList[oldIndex] = newImage;
    imagesList[newIndex] = oldImage;
  }

  onImageScrollToIndex(int index) {
    pageController.jumpToPage(index);
    pageIndex.value = index;
  }

  onDeletImage(ImageUploadModel imageItem) async {
    final result = await _confirmDialog('Deseja remover essa imagem??');
    if (result == null) return;
    if (imageItem.imageUrl != null) deletedImages.add(imageItem.imageUrl!);
    imagesList.remove(imageItem);
  }

  Future<dynamic> _confirmDialog(String title) async {
    return await router.Get.dialog(AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
            onPressed: Get.back,
            child: Text(
              'Não',
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Sim',
              style: TextStyle(color: Colors.green),
            ))
      ],
    ));
  }

  void onQuizCompleted() async {
    if (questions.length < 2) {
      _callErrorSnackBar(
          title: 'Error ao Completar o Quiz',
          message: 'Você precisa adicionar pelo menos duas perguntas ao seu quiz.');
      return;
    }
    if (imagesList.length < 2 || imagesList.length > 10) {
      _callErrorSnackBar(
          title: 'Error ao Completar o Quiz',
          message: 'Seus quiz precisa conter entre 2 e 10 imagens.');
      return;
    }
    final List<String> imagesListUrl = [];

    for (var image in imagesList) {
      if (image.imageUrl == null) {
        _callErrorSnackBar(
            title: 'Enviando Imagens', message: 'Estamos Enviando suas Inagens', failure: false);
        final url = await repository.upLoadImage(
            imageByte: image.byteImage!, userID: userAuthRepo.currentUser!.id!);
        if (url != null) imagesListUrl.add(url);
      } else {
        imagesListUrl.add(image.imageUrl!);
      }
    }
    deletedImages.forEach((element) {
      repository.deletImage(element);
    });

    final quiz = EntryQuizModel(
        id: quizModel!.id,
        presentImagesList: imagesListUrl,
        questions: questions,
        createdByID: userAuthRepo.currentUser!.id!,
        answeredBy: []);
    await repository.createQuiz(quiz, userAuthRepo.currentUser!, quizId: quiz.id);
    if (Get.isSnackbarOpen == true) {
      Get.back();
    }
    Get.back();
  }

  _callErrorSnackBar({required String title, required String message, bool failure = true}) {
    Get.snackbar(title, message,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(8),
        icon: !failure
            ? null
            : CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.close),
              ),
        backgroundColor: Colors.white,
        barBlur: 0,
        showProgressIndicator: !failure,
        snackStyle: SnackStyle.FLOATING);
  }
}
