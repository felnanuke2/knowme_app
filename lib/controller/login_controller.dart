import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:string_validator/string_validator.dart';

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

  onTapLoginButton() {
    if (!(formKey.currentState?.validate() ?? false)) return;

    _animationController.reverse();
  }

  onTapRecoveryPasswordButton() {}

  goToLoginWithEmailTab() => pageController.animateToPage(1,
      duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);

  goToLoginWithSocialMediaTab() => pageController.animateToPage(0,
      duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);

  goToRecoveryPasswordTab() => pageController.animateToPage(2,
      duration: Duration(milliseconds: 500), curve: Curves.linearToEaseOut);

  String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Insira uma senha';
    return null;
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) return 'Insira um email válido';
    if (!isEmail(value)) return 'Email inválido';
    return null;
  }
}
