import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:knowme/constants/constant_colors.dart';
import 'package:knowme/screens/complet_register_screen.dart';
import 'package:knowme/screens/login_screen.dart';
import 'package:material_color_generator/material_color_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Know me',
      theme: ThemeData(
        accentColor: ACCET_COLOR,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        primarySwatch: generateMaterialColor(color: PRIMARY_COLOR),
      ),
      home: CompletRegister(),
    );
  }
}
