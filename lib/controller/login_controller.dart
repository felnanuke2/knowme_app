import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class LoginController extends GetxController {
  PageController pageController = PageController();
  var emailTEC = TextEditingController();
  var passworTEC = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool passwordObscured = true;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  late AnimationController _animationController;
  late Animation<double> animation;
  _initState() {
    _animationController =
        AnimationController(vsync: tickerProvider, duration: Duration(milliseconds: 450));
    animation = Tween<double>(
      begin: 45,
      end: 280,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linearToEaseOut));
    _animationController.forward();
  }

  final TickerProvider tickerProvider;
  LoginController({
    required this.tickerProvider,
  }) {
    _initState();
  }
  onpasswordObscuredToggle() {
    passwordObscured = !passwordObscured;
    update();
  }

  onTapLoginButton() => _animationController.reverse();
  onTapRecoveryPasswordButton() {}
  onTapRegisterButton() {}

  goToLoginWithEmailTab() => pageController.animateToPage(1,
      duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);

  goToLoginWithSocialMediaTab() => pageController.animateToPage(0,
      duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);

  goToRecoveryPasswordTab() => pageController.animateToPage(2,
      duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
}
