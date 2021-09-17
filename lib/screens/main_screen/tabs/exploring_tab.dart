import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/main_screen/exploring_controller.dart';
import 'package:get/instance_manager.dart';

class ExploringTab extends StatefulWidget {
  const ExploringTab({Key? key}) : super(key: key);

  @override
  State<ExploringTab> createState() => _ExploringTabState();
}

class _ExploringTabState extends State<ExploringTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ExploringController>(
      init: ExploringController(sesssionController: Get.find()),
      builder: (controller) => Scaffold(
        body: Column(
          children: [
            AppBar(
              leadingWidth: 0,
              leading: SizedBox.shrink(),
              titleSpacing: 0,
              title: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: controller.openSearch,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(18)),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.search,
                              color: Get.theme.primaryColor,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Pesquisar',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
