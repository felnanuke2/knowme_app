import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/screens/plans_screen.dart';
import 'package:knowme/screens/settings/personal_info_settings_screen.dart';
import 'package:knowme/screens/settings/quiz/quiz_settings_screen.dart';
import 'package:knowme/widgets/settings_items_tile.dart';
import 'package:get/instance_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(Scaffoldcontext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SettingsItemsTile(
                      iconData: Icons.quiz,
                      title: 'Quiz',
                      screen: QuizSettingsScren()),
                  SettingsItemsTile(
                      iconData: Icons.monetization_on_outlined,
                      title: 'Impulsionar Perfil',
                      screen: PlansScreen())
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 18),
            width: Get.width * 0.6,
            child: ElevatedButton.icon(
                onPressed: Get.find<SesssionController>().singOut,
                icon: Icon(Icons.logout),
                label: Text('SAIR')),
          )
        ],
      ),
    );
  }
}
