import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SecundarySplashScreen extends StatefulWidget {
  SecundarySplashScreen(this.snapshotFirebase, this.widget);
  final AsyncSnapshot<Object?> snapshotFirebase;
  final Widget widget;
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
    await Future.delayed(Duration(milliseconds: 500));
    isCompleted = !isCompleted;
    setState(() {});

    Timer.periodic(Duration(seconds: 3), (timer) async {
      if (widget.snapshotFirebase.connectionState == ConnectionState.done) {
        timer.cancel();
        isCompleted = !isCompleted;
        setState(() {});

        Get.off(() => widget.widget);
      }
    });
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
}
