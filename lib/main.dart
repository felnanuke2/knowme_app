import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:knowme/constants/constant_colors.dart';
import 'package:knowme/screens/main_screen/main_screen.dart';
import 'package:knowme/screens/settings/quiz/create_update_question_scree.dart';
import 'package:material_color_generator/material_color_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt')],
      title: 'Know me',
      theme: ThemeData(
        accentColor: ACCET_COLOR,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        primarySwatch: generateMaterialColor(color: PRIMARY_COLOR),
      ),
      home: CreateUpdateQuestionScreen(),
    );
  }
}
