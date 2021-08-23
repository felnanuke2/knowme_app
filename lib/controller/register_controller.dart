import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class RegisterController extends GetxController {
  var emailTEC = TextEditingController();
  var passwordTEC = TextEditingController();
  var passwordConfirmTEC = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool passwordObscured = true;
  String errorMessage = '';
  final TickerProvider tickerProvider;
  late AnimationController _animationController;
  late Animation<double> animation;
  RegisterController({
    required this.tickerProvider,
  }) {
    _animationController =
        AnimationController(vsync: tickerProvider, duration: Duration(milliseconds: 450));
    animation = Tween<double>(begin: 45, end: 80)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linearToEaseOut));
    _animationController.forward();
  }

  onpasswordObscuredToggle() {
    passwordObscured = !passwordObscured;
    update();
  }

  onRegisterButtonPressed() {}
}
