import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/login_controller.dart';
import 'package:get/route_manager.dart' as route;
import 'package:knowme/screens/register_screen.dart';
import 'package:knowme/widgets/animated_loading_button.dart';
import 'package:knowme/widgets/privacy_policy_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(tickerProvider: this),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: 340,
                height: 170,
                child: Image.asset(
                  'assets/knowme logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  'Olá, seja bem vindo ao Know me!',
                  style: route.Get.textTheme.headline5,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.pageController,
                  children: [
                    _buildSocialMediaLoginTab(controller),
                    _buildLoginWithEmailTab(controller),
                    _buildRecoveryPasswordTab(controller)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildRecoveryPasswordTab(LoginController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: controller.emailTEC,
              decoration: InputDecoration(
                hintText: 'Digite seu email',
                prefixIcon: Icon(Icons.email),
              ),
              style: TextStyle(decoration: TextDecoration.none),
            ),
            if (controller.errorMessage.isNotEmpty)
              Text(
                controller.errorMessage,
                style: TextStyle(color: Colors.red),
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
    );
  }

  Container _buildSocialMediaLoginTab(LoginController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20),
            height: 45,
            width: 380,
            child: SignInButton(
              Buttons.GoogleDark,
              onPressed: () {},
              text: 'Continuar com Google',
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            height: 45,
            width: 380,
            child: SignInButton(
              Buttons.FacebookNew,
              onPressed: () {},
              text: 'Continuar com Facebook',
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
          ),
          if (Platform.isIOS)
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 45,
              width: 380,
              child: SignInButton(
                Buttons.AppleDark,
                onPressed: () {},
                text: 'Continuar com a Apple',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          PrivacyPolicyButton()
        ],
      ),
    );
  }

  Container _buildLoginWithEmailTab(LoginController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
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
              if (controller.errorMessage.isNotEmpty)
                Text(
                  controller.errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
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
