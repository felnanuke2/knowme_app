import 'package:flutter/material.dart';
import 'package:knowme/screens/plans_screen.dart';
import 'package:knowme/screens/settings/personal_info_settings_screen.dart';
import 'package:knowme/screens/settings/quiz/quiz_settings_screen.dart';
import 'package:knowme/widgets/settings_items_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(Scaffoldcontext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsItemsTile(
                iconData: Icons.person,
                title: 'Informações Pessoais',
                screen: PersonalInfoSettingsScren()),
            SettingsItemsTile(iconData: Icons.quiz, title: 'Quiz', screen: QuizSettingsScren()),
            SettingsItemsTile(
                iconData: Icons.monetization_on_outlined,
                title: 'Impulsionar Perfil',
                screen: PlansScreen())
          ],
        ),
      ),
    );
  }
}
