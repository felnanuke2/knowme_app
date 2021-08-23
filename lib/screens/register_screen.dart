import 'dart:math';

import 'package:flutter/material.dart';

import 'package:get/route_manager.dart' as router;
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/register_controller.dart';
import 'package:knowme/widgets/animated_loading_button.dart';

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
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: _buildNewUserText(),
                    ),
                    ColorFiltered(
                        colorFilter: ColorFilter.mode(Get.theme.primaryColor, BlendMode.dstOver),
                        child: Image.asset('assets/signIn_ilustration.png')),
                    SizedBox(
                      height: 45,
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: controller.passwordTEC,
                      obscureText: controller.passwordObscured,
                      decoration: InputDecoration(
                          hintText: 'Senha',
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
                    TextFormField(
                      controller: controller.passwordConfirmTEC,
                      obscureText: controller.passwordObscured,
                      decoration: InputDecoration(
                          hintText: 'Confirmar Senha',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: 45,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18))),
                                onPressed: router.Get.back,
                                child: Text('Voltar'))),
                        AnimatedLoadingButton(
                            child: Text('Registra'),
                            heigth: 45,
                            animation: controller.animation,
                            onTap: controller.onRegisterButtonPressed),
                      ],
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
        style: router.Get.textTheme.headline4,
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
