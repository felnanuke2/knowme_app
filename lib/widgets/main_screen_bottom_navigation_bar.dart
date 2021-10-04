import 'package:flutter/cupertino.dart';
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
  void initState() {
    widget.controller.currentPage.listen((page) {
      selectedIndex = page;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onchangePage,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Feed',
            icon: Icon(Icons.apps),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.chat_bubble_2_fill,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
              label: 'Perfil',
              icon: CircleAvatar(
                  child: widget.controller.userAuthRepository.getCurrentUser?.profileImage != null
                      ? Container(
                          width: 49,
                          height: 49,
                          child: ClipOval(
                            child: Image.network(
                              widget.controller.userAuthRepository.getCurrentUser!.profileImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Icon(Icons.person))),
        ]);
  }

  void onchangePage(int value) {
    widget.controller.onPageChange(value);
  }
}
