import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/main_screen_controller.dart';
import 'package:knowme/screens/main_screen/tabs/feed_tab.dart';
import 'package:knowme/screens/main_screen/tabs/home_tab.dart';
import 'package:knowme/screens/main_screen/tabs/profile_tab.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/widgets/main_screen_bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainScreenController>(
      init: MainScreenController(repository: Get.find(), userAuthRepository: Get.find()),
      builder: (mainScreenController) => mainScreenController.isLoadingCurrentUser == true
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
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
                  Obx(
                    () => Visibility(
                      visible: mainScreenController.currentPage.value == 1,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                          )),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: mainScreenController.currentPage.value == 2,
                      child: IconButton(
                          onPressed: mainScreenController.onSettingsPressed,
                          icon: Icon(
                            Icons.settings,
                          )),
                    ),
                  ),
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
    );
  }
}
