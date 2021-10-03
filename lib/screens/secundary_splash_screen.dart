import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/local_db_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';

import 'package:knowme/repositorys/hive_local_db.dart';
import 'package:knowme/repositorys/supabase_repository.dart';
import 'package:knowme/repositorys/supabase_use_auth_repository.dart';
import 'package:knowme/screens/main_screen/main_screen.dart';
import 'package:get/instance_manager.dart' as instance;
import 'package:knowme/services/push_notifications_services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'login_screen.dart';

class SecundarySplashScreen extends StatefulWidget {
  @override
  _SecundarySplashScreenState createState() => _SecundarySplashScreenState();
}

class _SecundarySplashScreenState extends State<SecundarySplashScreen> {
  bool isCompleted = true;
  @override
  void initState() {
    _animateContainer();

    super.initState();
  }

  _animateContainer() async {
    final _completer = Completer();

    _initializeDependencys().then((value) => _completer.complete());
    await Future.delayed(Duration(milliseconds: 700));
    isCompleted = !isCompleted;
    setState(() {});
    try {
      await _completer.future;
    } catch (e) {
      Get.snackbar('Erro', e.toString());
      Get.off(() => LoginScreen());
    }

    Get.off(() =>
        instance.Get.find<UserAuthInterface>().currentUser != null ? MainScreen() : LoginScreen());

    print('complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        child: AnimatedContainer(
          width: isCompleted ? 200 : 400,
          height: isCompleted ? 200 : 400,
          alignment: Alignment.center,
          duration: Duration(seconds: 2),
          curve: Curves.easeIn,
          child: Image.asset(
            'assets/knowme logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  late LocalDbInterface localDb;

  Future<void> _initializeDependencys() async {
    localDb = Get.put<LocalDbInterface>(HiveLocalDb());
    await localDb.initializeDatabase();
    Get.put<DbRepositoryInterface>(SupabaseRepository(), permanent: true);
    Get.put<UserAuthInterface>(
        SupabaseUserAuthRepository(repositoryInterface: Get.find<DbRepositoryInterface>()),
        permanent: true);
    timeago.setLocaleMessages('pt', timeago.PtBrMessages());
    await Firebase.initializeApp();
  }
}
