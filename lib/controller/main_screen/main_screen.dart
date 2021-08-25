import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:get/route_manager.dart' as router;
import 'package:knowme/screens/settings/settings_screen.dart';

class MainScreenController extends GetxController {
  var pageController = PageController();
  RxInt currentPage = 0.obs;

  void onPageChange(int value) {
    pageController.animateToPage(value,
        duration: Duration(milliseconds: 450), curve: Curves.decelerate);
    currentPage.value = value;
  }

  void onSettingsPressed() {
    router.Get.to(() => SettingsScreen());
  }
}
