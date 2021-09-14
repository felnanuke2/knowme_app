import 'package:flutter/material.dart';

import 'package:knowme/controller/main_screen/session_controller.dart';

class MainScreenBottomNavigationBar extends StatefulWidget {
  final SesssionController controller;
  const MainScreenBottomNavigationBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _MainScreenBottomNavigationBarState createState() => _MainScreenBottomNavigationBarState();
}

class _MainScreenBottomNavigationBarState extends State<MainScreenBottomNavigationBar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(onTap: onchangePage, currentIndex: selectedIndex, items: [
      BottomNavigationBarItem(
        label: 'Home',
        icon: Icon(Icons.home),
      ),
      BottomNavigationBarItem(
        label: 'Feed',
        icon: Icon(Icons.apps),
      ),
      BottomNavigationBarItem(
          label: 'Perfil',
          icon: CircleAvatar(
              child: widget.controller.userAuthRepository.currentUser?.profileImage != null
                  ? Container(
                      width: 49,
                      height: 49,
                      child: ClipOval(
                        child: Image.network(
                          widget.controller.userAuthRepository.currentUser!.profileImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Icon(Icons.person))),
    ]);
  }

  void onchangePage(int value) {
    selectedIndex = value;
    widget.controller.onPageChange(value);
    setState(() {});
  }
}
