import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/screens/main_screen/main_screen.dart';
import 'package:string_validator/string_validator.dart';

import 'package:knowme/interface/user_auth_interface.dart';
import 'package:get/route_manager.dart' as router;

class LoginController extends GetxController {
  PageController pageController = PageController();
  final UserAuthInterface userAuthRepo;

  var emailTEC = TextEditingController();
  var passworTEC = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final errorMessage = ''.obs;
  bool passwordObscured = true;

  final emailRecoveryFormKey = GlobalKey<FormState>();

  final recoveryPasswordErrorText = ''.obs;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  late AnimationController _animationController;
  late Animation<double> animation;
  _initState() {
    _animationController = AnimationController(
        vsync: tickerProvider, duration: Duration(milliseconds: 450));
    animation = Tween<double>(
      begin: 45,
      end: 280,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linearToEaseOut));
    _animationController.forward();
  }

  final TickerProvider tickerProvider;
  LoginController({
    required this.userAuthRepo,
    required this.tickerProvider,
  }) {
    _initState();
  }
  onpasswordObscuredToggle() {
    passwordObscured = !passwordObscured;
    update();
  }

  onTapLoginButton() async {
    errorMessage.value = '';
    bool hasError = false;
    if (!(formKey.currentState?.validate() ?? false)) return;

    _animationController.reverse();
    try {
      await userAuthRepo.sigInWithEmail(
          email: emailTEC.text, password: passworTEC.text);
    } on RequestError catch (e) {
      errorMessage.value = e.message ?? '';
      hasError = true;
      print(e.message);
    }
    _animationController.forward();
    if (!hasError) Get.offAll(() => MainScreen());
  }

  onTapRecoveryPasswordButton() async {
    recoveryPasswordErrorText.value = '';
    if (!emailRecoveryFormKey.currentState!.validate()) return;

    try {
      _animationController.reverse();

      await this.userAuthRepo.sendResetPasswordEmail(email: emailTEC.text);
      recoveryPasswordErrorText.value = 'Email enviado com sucesso';
    } on RequestError catch (e) {
      recoveryPasswordErrorText.value = e.message ?? '';
    }
    _animationController.forward();
  }

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
    if (value!.isEmpty) return 'Insira um email v??lido';
    if (!isEmail(value)) return 'Email inv??lido';
    return null;
  }

  sigInWithGoogle() async {
    try {
      final result = await userAuthRepo.sigInWithGoogle();
      Get.offAll(() => MainScreen());
    } catch (e) {
      print(e);
    }
  }

  signInWithFacebook() async {
    try {
      final result = await userAuthRepo.sigInWithFacebook();
      Get.offAll(() => MainScreen());
    } catch (e) {}
  }

  siginWithApple() async {
    try {
      final result = await userAuthRepo.sigInWithApple();
      Get.offAll(() => MainScreen());
    } catch (e) {}
  }
}
