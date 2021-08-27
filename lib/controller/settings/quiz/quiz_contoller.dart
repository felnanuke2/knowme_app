import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart' as router;
import 'package:get/instance_manager.dart' as instance;
import 'package:get/state_manager.dart';
import 'package:knowme/controller/image_controller.dart';
import 'package:knowme/models/entry_quiz_model.dart';
import 'package:knowme/models/image_upload_model.dart';
import 'package:knowme/models/question_model.dart';
import 'package:knowme/repositorys/firebase_repository.dart';
import 'package:knowme/screens/settings/quiz/create_update_question_scree.dart';

class QuizController extends GetxController {
  EntryQuizModel? quizModel;
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  RxList<ImageUploadModel> imagesList = <ImageUploadModel>[].obs;
  late FirebaseRepository firebaseRepository;
  final pageController = PageController();
  var pageIndex = 0.obs;
  List<String> deletedImages = [];

  QuizController({
    this.quizModel,
  }) {
    firebaseRepository = instance.Get.find<FirebaseRepository>();
    if (quizModel == null) return;
    questions.addAll(quizModel!.questions);
    //Add Images to ImageList
    if (quizModel!.presentImagesList.isNotEmpty) {
      quizModel!.presentImagesList.forEach((element) {
        imagesList.add(ImageUploadModel(imageUrl: element));
      });
      _getImageBytesFromString();
    }
    pageController.addListener(() {
      pageIndex.value = pageController.page!.round();
    });
  }

  /// will getBytelImageFrom StringUrl
  _getImageBytesFromString() async {
    for (var index = 0; index <= quizModel!.presentImagesList.length; index++) {
      var byteImage =
          await firebaseRepository.getImageBytesFromURL(url: quizModel!.presentImagesList[index]);
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
    var image = await ImageController.pickMultipleImage(imagesList, ratioX: 3, ratioY: 4);

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
}
