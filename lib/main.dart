import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/constants/constant_colors.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/repositorys/firebase_repository.dart';
import 'package:knowme/repositorys/firebase_user_auth_repository.dart';
import 'package:knowme/screens/camera_screen.dart';
import 'package:knowme/screens/secundary_splash_screen.dart';
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
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshotFirebase) {
            if (snapshotFirebase.connectionState == ConnectionState.done) _inectDependency();
            return SecundarySplashScreen(
              snapshotFirebase,
            );
          }),
    );
  }

  _inectDependency() {
    Get.put<DbRepositoryInterface>(FirebaseRepository(), permanent: true);
    Get.put<UserAuthInterface>(UserAuthRepository(Get.find<DbRepositoryInterface>()),
        permanent: true);
  }
}
