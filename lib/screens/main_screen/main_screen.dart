import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/main_screen.dart';
import 'package:knowme/controller/user_controller.dart';
import 'package:knowme/screens/main_screen/tabs/feed_tab.dart';
import 'package:knowme/screens/main_screen/tabs/home_tab.dart';
import 'package:knowme/screens/main_screen/tabs/profile_tab.dart';
import 'package:knowme/widgets/main_screen_bottom_navigation_bar.dart';
import 'package:knowme/widgets/main_screen_drawer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (userController) => userController.isLoading
          ? Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : GetBuilder<MainScreenController>(
              init: MainScreenController(),
              builder: (mainScreenController) => Scaffold(
                drawer: MainScreenDrawer(),
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Get.theme.primaryColor),
                  backgroundColor: Colors.white,
                  title: Container(
                    height: 38,
                    child: Image.asset(
                      'assets/knowme_logo-removebg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications,
                        )),
                    Obx(
                      () => Visibility(
                        visible: mainScreenController.currentPage.value == 1,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                            )),
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: MainScreenBottomNavigationBar(
                  controller: mainScreenController,
                ),
                body: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: mainScreenController.pageController,
                  children: [
                    HomeTab(),
                    FeedTab(),
                    ProfileTab(),
                  ],
                ),
              ),
            ),
    );
  }
}
