import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/login_controller.dart';
import 'package:get/route_manager.dart' as route;
import 'package:get/instance_manager.dart' as instance;
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/screens/register_screen.dart';
import 'package:knowme/widgets/animated_loading_button.dart';
import 'package:knowme/widgets/privacy_policy_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _imageBanner = Container(
  margin: EdgeInsets.only(bottom: 12),
  child: Column(
    children: [
      Container(
        width: 340,
        height: 220,
        child: Image.asset(
          'assets/knowme_logo-removebg.png',
          fit: BoxFit.fitWidth,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Text(
          'Olá, seja bem vindo ao ConePlay!',
          style: route.Get.textTheme.headline5,
        ),
      ),
    ],
  ),
);

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(
          tickerProvider: this,
          userAuthRepo: instance.Get.find<UserAuthInterface>()),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            children: [
              _buildSocialMediaLoginTab(controller),
              _buildLoginWithEmailTab(controller),
              _buildRecoveryPasswordTab(controller)
            ],
          ),
        ),
      ),
    );
  }

  Container _buildRecoveryPasswordTab(LoginController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: controller.emailRecoveryFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageBanner,
              TextFormField(
                controller: controller.emailTEC,
                validator: controller.validateEmail,
                decoration: InputDecoration(
                  hintText: 'Digite seu email',
                  prefixIcon: Icon(Icons.email),
                ),
                style: TextStyle(decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => Text(
                  controller.recoveryPasswordErrorText.value,
                  style: GoogleFonts.openSans(
                      color: controller.recoveryPasswordErrorText.value
                              .contains('sucesso')
                          ? Colors.green
                          : Colors.red),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AnimatedLoadingButton(
                  child: Text('Enviar email de troca de senha'),
                  heigth: 45,
                  animation: controller.animation,
                  onTap: controller.onTapRecoveryPasswordButton),
              SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: controller.goToLoginWithEmailTab,
                  child: Text('Voltar para a tela de login'))
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSocialMediaLoginTab(LoginController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            _imageBanner,
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 45,
              width: 380,
              child: SignInButton(
                Buttons.GoogleDark,
                onPressed: controller.sigInWithGoogle,
                text: 'Continuar com Google',
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 45,
              width: 380,
              child: SignInButton(
                Buttons.FacebookNew,
                onPressed: controller.signInWithFacebook,
                text: 'Continuar com Facebook',
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
            ),
            if (Platform.isIOS)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 45,
                width: 380,
                child: SignInButton(
                  Buttons.AppleDark,
                  onPressed: controller.siginWithApple,
                  text: 'Continuar com a Apple',
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
              ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 45,
              width: 380,
              child: SignInButton(
                Buttons.Email,
                onPressed: controller.goToLoginWithEmailTab,
                text: 'Entrar com email e senha',
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22)),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            PrivacyPolicyButton()
          ],
        ),
      ),
    );
  }

  Container _buildLoginWithEmailTab(LoginController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageBanner,
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  validator: controller.validateEmail,
                  controller: controller.emailTEC,
                  decoration: InputDecoration(
                    labelText: 'Digite seu email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  style: TextStyle(decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  validator: controller.validatePassword,
                  controller: controller.passworTEC,
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
              ),
              Obx(() => controller.errorMessage.isNotEmpty
                  ? Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox.shrink()),
              SizedBox(
                height: 20,
              ),
              AnimatedLoadingButton(
                onTap: controller.onTapLoginButton,
                heigth: 45,
                animation: controller.animation,
                child: Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: controller.goToRecoveryPasswordTab,
                      child: Text('Esqueceu sua senha?')),
                  TextButton(
                      onPressed: () {
                        route.Get.to(() => RegisterScreen());
                      },
                      child: Text('Registre-se')),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: controller.goToLoginWithSocialMediaTab,
                  child: Text('Outras opções de login')),
              SizedBox(
                height: 25,
              ),
              PrivacyPolicyButton()
            ],
          ),
        ),
      ),
    );
  }
}
