import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/controller/main_screen/exploring_controller.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/widgets/exploring_sugestion_tile.dart';

class ExploringSearchDelegate extends SearchDelegate {
  final ExploringController controller;
  ExploringSearchDelegate({
    required this.controller,
  }) {
    loopSugestions();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // IconButton(onPressed: _filter, icon: Icon(Icons.filter_alt_outlined))
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Get.theme.copyWith(
        scaffoldBackgroundColor: Get.theme.primaryColor.withOpacity(0.4),
        appBarTheme: AppBarTheme(
          titleSpacing: 0,
          backgroundColor: Get.theme.primaryColor,
        ),
        textTheme: TextTheme(
            headline4: TextStyle(
              fontSize: 16,
            ),
            subtitle1: TextStyle(color: Colors.black)),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ));
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: Get.back,
        icon: RotationTransition(
            turns: transitionAnimation, child: Icon(Icons.close)));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Get.theme.primaryColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Obx(() => loadingSugestion.value
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : SizedBox.shrink()),
                SizedBox(
                  height: 15,
                ),
                Obx(() => Expanded(
                      child: ListView.builder(
                        itemCount: listUserSugestions.length,
                        itemBuilder: (context, index) {
                          final itemUser = listUserSugestions[index];
                          return Row(
                            children: [
                              Expanded(
                                child:
                                    ExploringSugestionTile(itemUser: itemUser),
                              ),
                            ],
                          );
                        },
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  final loadingSugestion = false.obs;
  String lastWorkSearched = '';
  final listUserSugestions = <UserModel>[].obs;
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Get.theme.primaryColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Obx(() => loadingSugestion.value
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : SizedBox.shrink()),
                SizedBox(
                  height: 15,
                ),
                Obx(() => Expanded(
                      child: ListView.builder(
                        itemCount: listUserSugestions.length,
                        itemBuilder: (context, index) {
                          final itemUser = listUserSugestions[index];
                          return Row(
                            children: [
                              Expanded(
                                child:
                                    ExploringSugestionTile(itemUser: itemUser),
                              ),
                            ],
                          );
                        },
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Timer? timer;
  loopSugestions() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      this.timer = timer;
      if (query.isNotEmpty) {
        if (lastWorkSearched != query) {
          if (!loadingSugestion.value) {
            loadingSugestion.value = true;
            lastWorkSearched = query;
            controller.searchUsers(query).then((value) {
              listUserSugestions.clear();
              listUserSugestions.addAll(value);
              loadingSugestion.value = false;
            });
          }
        }
      }
    });
  }

  @override
  void close(BuildContext context, result) {
    timer?.cancel();
    super.close(context, result);
  }

  void _filter() {}
}
