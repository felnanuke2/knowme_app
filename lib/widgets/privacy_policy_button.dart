import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:knowme/screens/privacy_policy_screen.dart';

class PrivacyPolicyButton extends StatelessWidget {
  const PrivacyPolicyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: Get.textTheme.bodyText1,
            text: 'Ao continuar, você concorda com nossos ',
            children: [
              TextSpan(
                  text: 'Termos & Política de Privacidade',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.to(() => PrivacyPolicyScreen());
                    },
                  style:
                      TextStyle(color: Get.theme.accentColor, decoration: TextDecoration.underline))
            ]),
      ),
    );
  }
}
