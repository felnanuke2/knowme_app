import 'package:flutter/material.dart';

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
    await Future.delayed(Duration(milliseconds: 500));
    isCompleted = !isCompleted;
    setState(() {});
    await Future.delayed(Duration(seconds: 2, milliseconds: 500));
    isCompleted = !isCompleted;
    setState(() {});
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
          curve: Curves.elasticIn,
          child: Image.asset(
            'assets/knowme logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
