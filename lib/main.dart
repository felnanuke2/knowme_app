import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:knowme/constants/constant_colors.dart';

import 'package:knowme/screens/secundary_splash_screen.dart';
import 'package:material_color_generator/material_color_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final initializationComplete = Completer();

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
      title: 'ConePlay',
      theme: ThemeData(
        accentColor: ACCET_COLOR,
        dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18))),
        cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18))),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        primarySwatch: generateMaterialColor(color: PRIMARY_COLOR),
      ),
      home: SecundarySplashScreen(),
    );
  }
}
