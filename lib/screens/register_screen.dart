import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/register_controller.dart';

import 'package:knowme/widgets/password_validate_tile.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  List<String> newUserStringList = 'Novo Usuário'.split('');

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      init: RegisterController(tickerProvider: this),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Get.theme.primaryColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: _buildNewUserText(),
          actions: [
            TextButton.icon(
                onPressed: controller.onRegisterButtonPressed,
                icon: Icon(Icons.check),
                label: Text('Registrar'))
          ],
        ),
        backgroundColor: Color(0xffFFFFFF),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 120, child: Image.asset('assets/signIn_ilustration.png')),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: controller.emailTEC,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.onValidateEmail,
                      decoration:
                          InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: controller.onValidatePassword,
                      controller: controller.passwordTEC,
                      onChanged: controller.onPasswordChange,
                      obscureText: controller.passwordObscured,
                      decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: controller.onpasswordObscuredToggle,
                              icon: Icon(controller.passwordObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                    Container(
                      child: Column(
                        children: [
                          PasswordValidateTile(
                              validation: controller.passwordHaveOneUpperCaseCharacter,
                              title: 'Contém ao menos uma letra maiúscula'),
                          PasswordValidateTile(
                              validation: controller.passwordHaveOneLowerCaseCharacter,
                              title: 'Contém ao menos uma letra minúscula'),
                          PasswordValidateTile(
                              validation: controller.passwordHaveOneNumberCharacter,
                              title: 'Contém ao menos um número'),
                          PasswordValidateTile(
                              validation: controller.passwordTEC.text.length >= 6,
                              title: 'Contém ao menos 6 caracteres'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      validator: controller.onValideteConfirmPassword,
                      controller: controller.passwordConfirmTEC,
                      obscureText: controller.passwordObscured,
                      decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: controller.onpasswordObscuredToggle,
                              icon: Icon(controller.passwordObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText _buildNewUserText() {
    return RichText(
      text: TextSpan(
        style: router.Get.textTheme.headline6,
        children: List.generate(
          newUserStringList.length,
          (index) => TextSpan(
              text: newUserStringList[index],
              style: GoogleFonts.frederickaTheGreat(
                  color: getColorsList[Random().nextInt(getColorsList.length)])),
        ),
      ),
    );
  }

  List<Color> get getColorsList =>
      [router.Get.theme.primaryColor, router.Get.theme.accentColor, Color(0xff008037)];
}
