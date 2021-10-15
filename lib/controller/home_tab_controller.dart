import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/errors/requestError.dart';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/impression_model.dart';
import 'package:knowme/models/lat_laong.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/answer_quiz_scree.dart';
import 'package:knowme/screens/plans_screen.dart';
import 'package:knowme/services/location_services.dart';

class HomeTabController extends GetxController {
  final DbRepositoryInterface repository;
  final impressionsList = <ImpressionModel>[].obs;
  final loadingQuiz = false.obs;
  final haveNoMoreMale = false.obs;
  final haveNoMoreFemale = false.obs;
  final loadingMore = false.obs;
  HomeTabController({
    required this.repository,
  }) {
    getImpressions();
  }
  getImpressions() async {
    final latlng = await LocationServices.getLocation();
    try {
      impressionsList.value = await repository.getIntmpressions(latlng ?? LatLng(lat: 0, lng: 0));
    } on RequestError catch (e) {
      print(e.message);
    }
  }

  openQuiz(ImpressionModel impression) async {
    try {
      loadingQuiz.value = true;
      final quiz = await repository.getQuiz(impression.quiz_id.toString());
      loadingQuiz.value = false;
      quiz.user = UserModel(profileName: impression.profileName, id: impression.user_uid);
      final result = await Get.to(() => AnswerQuizScreen(quiz: quiz));
      if (result != null) impressionsList.remove(impression);
    } catch (e) {}
    loadingQuiz.value = false;
  }

  void loadingMoreImpressions() async {
    loadingMore.value = true;
    if (haveNoMoreMale.value && haveNoMoreFemale.value) return;
    final latlng = await LocationServices.getLocation();
    final list = await repository.getIntmpressions(latlng ?? LatLng(lat: 0, lng: 0));
    if (list
        .where((element) =>
            element.sex == Sex.MALE &&
            !impressionsList.map((element) => element.user_uid).contains(element.user_uid))
        .toList()
        .isEmpty) haveNoMoreMale.value = true;
    if (list
        .where((element) =>
            element.sex != Sex.MALE &&
            !impressionsList.map((element) => element.user_uid).contains(element.user_uid))
        .toList()
        .isEmpty) haveNoMoreFemale.value = true;

    list.forEach((element) {
      if (!impressionsList.map((element) => element.user_uid).contains(element.user_uid)) {
        impressionsList.add(element);
      }
    });
    loadingMore.value = false;
  }

  void checkImpression(int impression) async {
    repository.checkImpression(impression);
  }

  void openPlansScreen() {
    Get.to(() => PlansScreen());
  }
}
