import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';

class MainScreenController extends GetxController {
  var pageController = PageController();
  RxInt currentPage = 0.obs;

  void onPageChange(int value) {
    pageController.animateToPage(value,
        duration: Duration(milliseconds: 450), curve: Curves.decelerate);
    currentPage.value = value;
  }
}
