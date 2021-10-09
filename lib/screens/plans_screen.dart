import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/controller/settings/plans_controller.dart';
import 'package:knowme/widgets/plans_widget.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlansController>(
        init: PlansController(repository: Get.find()),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Planos',
                  style: TextStyle(color: Get.theme.primaryColor),
                ),
              ),
              body: Obx(
                () => controller.loadPlan.value ? _buildLoading() : _buildPLans(controller),
              ),
            ));
  }

  Widget _buildLoading() {
    return Center(child: LinearProgressIndicator());
  }

  Widget _buildPLans(PlansController controller) {
    return PageView.builder(
      itemCount: controller.plansList.length,
      itemBuilder: (context, index) {
        final planItem = controller.plansList[index];
        return PlansWidget(
          plan: planItem,
          controller: controller,
        );
      },
    );
  }
}
