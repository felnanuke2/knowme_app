import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:string_validator/string_validator.dart';

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

  @override
  void dispose() {
    _animationController.dispose();
    emailTEC.dispose();
    passwordTEC.dispose();
    passwordConfirmTEC.dispose();

    super.dispose();
  }

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

  String? onValidateEmail(String? value) {
    if (value!.isEmpty) return 'Insira um email válido';
    if (!isEmail(value)) return 'Email inválido';
    return null;
  }

  String? onValidatePassword(String? value) {
    var regExp = RegExp('(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])');
    if (value!.isEmpty) return 'Insira uma Senha';
    if (value.length < 6) return 'Senha muito curta';
    if (!regExp.hasMatch(value)) return 'Senha inválida';
    return null;
  }

  String? onValideteConfirmPassword(String? value) {
    if (value!.isEmpty) return 'Insira a confirmação da senha';
    if (value != passwordTEC.text) return 'Senhas não conferem';
    return null;
  }

  void onPasswordChange(String value) {
    update();
  }

  bool get passwordHaveOneLowerCaseCharacter {
    var regExp = RegExp('(?=.*?[a-z])');

    return regExp.hasMatch(passwordTEC.text);
  }

  bool get passwordHaveOneUpperCaseCharacter {
    var regExp = RegExp('(?=.*?[A-Z])');

    return regExp.hasMatch(passwordTEC.text);
  }

  bool get passwordHaveOneNumberCharacter {
    var regExp = RegExp('(?=.*?[0-9])');

    return regExp.hasMatch(passwordTEC.text);
  }

  onRegisterButtonPressed() {
    if (!(formKey.currentState?.validate() ?? false)) return;
  }
}
