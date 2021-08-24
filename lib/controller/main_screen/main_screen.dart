import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';

class MainScreenController extends GetxController {
  var pageController = PageController();

  void onPageChange(int value) {
    pageController.animateToPage(value,
        duration: Duration(milliseconds: 450), curve: Curves.decelerate);
  }
}
