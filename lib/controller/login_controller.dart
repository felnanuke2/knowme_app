import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/complet_profile_controller.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/screens/complet_register_screen.dart';
import 'package:knowme/screens/main_screen/main_screen.dart';
import 'package:knowme/screens/settings/quiz/quiz_settings_screen.dart';
import 'package:string_validator/string_validator.dart';

import 'package:knowme/auth/google_sign_in.dart';
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
      await userAuthRepo.sigInWithEmail(email: emailTEC.text, password: passworTEC.text);
    } on RequestError catch (e) {
      errorMessage.value = e.message ?? '';
      hasError = true;
      print(e.message);
    }
    _animationController.forward();
    if (!hasError) Get.to(() => MainScreen());
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

  sigInWithGoogle() async {
//     final result = await userAuthRepo.sigInWithGoogle();
//     if (result is UserModel) {
// //need CompletProfile
//       if (result.profileComplet) {
//         if (result.entryQuizID == null)
//           router.Get.off(() => QuizSettingsScren());
//         else
//           router.Get.off(() => MainScreen());
//       } else {
//         router.Get.snackbar(
//           'Carregando Dados do Usuário',
//           '',
//           showProgressIndicator: true,
//           backgroundColor: Colors.white,
//           barBlur: 0,
//         );
//         var data = await userAuthRepo.getUserDataFromGoogle();
//         router.Get.off(() => CompletRegisterScreen(
//               dataModel: data,
//               userModel: result,
//             ));
//       }
//     }
  }
}
