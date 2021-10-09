import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/session_controller.dart';
import 'package:knowme/screens/main_screen/tabs/exploring_tab.dart';
import 'package:knowme/screens/main_screen/tabs/feed_tab.dart';
import 'package:knowme/screens/main_screen/tabs/home_tab.dart';
import 'package:knowme/screens/main_screen/tabs/messages_tab.dart';
import 'package:knowme/screens/main_screen/tabs/profile_tab.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/screens/received_interactions_screen.dart';
import 'package:knowme/widgets/main_screen_bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SesssionController>(
        init: SesssionController(repository: Get.find(), userAuthRepository: Get.find()),
        builder: (sessionController) => sessionController.isLoadingCurrentUser == true
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Obx(
                () => Scaffold(
                  appBar: sessionController.currentPage.value != 2
                      ? AppBar(
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
                                visible: sessionController.currentPage.value == 1,
                                child: IconButton(
                                    onPressed: sessionController.createPost,
                                    icon: Icon(
                                      Icons.add,
                                    )),
                              ),
                            ),
                            Obx(
                              () => Visibility(
                                visible: sessionController.currentPage.value == 4,
                                child: IconButton(
                                    onPressed: sessionController.onSettingsPressed,
                                    icon: Icon(
                                      Icons.settings,
                                    )),
                              ),
                            ),
                            IconButton(
                                onPressed: () => Get.to(() => ReceivedInteractionsScreen()),
                                icon: Stack(
                                  children: [
                                    Icon(
                                      Icons.notifications,
                                    ),
                                    Obx(() => Visibility(
                                          visible: sessionController.interactionsReceived
                                              .where((e) => e.status == 0)
                                              .toList()
                                              .isNotEmpty,
                                          child: CircleAvatar(
                                            radius: 5,
                                            backgroundColor: Colors.green,
                                          ),
                                        )),
                                  ],
                                )),
                          ],
                        )
                      : null,
                  bottomNavigationBar: MainScreenBottomNavigationBar(
                    controller: sessionController,
                  ),
                  body: PageView(
                    onPageChanged: (value) => sessionController.currentPage.value = value,
                    physics: NeverScrollableScrollPhysics(),
                    controller: sessionController.pageController,
                    children: [
                      HomeTab(),
                      FeedTab(),
                      ExploringTab(),
                      MessagesTab(),
                      ProfileTab(),
                    ],
                  ),
                ),
              ));
  }
}
