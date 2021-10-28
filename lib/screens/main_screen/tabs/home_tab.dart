import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:knowme/controller/complet_profile_controller.dart';
import 'package:knowme/controller/home_tab_controller.dart';
import 'package:get/instance_manager.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/widgets/impression_widget.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeTabController>(
      init: HomeTabController(repository: Get.find()),
      builder: (controller) => Container(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                TextButton.icon(
                    onPressed: controller.openPlansScreen,
                    icon: Icon(Icons.star, color: Colors.amberAccent),
                    label: Text(
                      'Turbine seu Perfil',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Container(
                              height: controller.impressionsList
                                      .where((p0) => p0.sex == Sex.MALE)
                                      .isEmpty
                                  ? 0
                                  : 200,
                              child: ListView.builder(
                                itemCount: controller.impressionsList
                                        .where((p0) => p0.sex == Sex.MALE)
                                        .length +
                                    1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index ==
                                      controller.impressionsList
                                          .where((p0) => p0.sex == Sex.MALE)
                                          .length) {
                                    return Obx(
                                      () => controller.haveNoMoreMale.value
                                          ? SizedBox.fromSize()
                                          : AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                child: InkWell(
                                                  onTap: controller
                                                      .loadingMoreImpressions,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('Mostrar Mais',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontSize:
                                                                      16)),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Icon(Icons.add, size: 28)
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    );
                                  }
                                  final impression = controller.impressionsList
                                      .where((p0) => p0.sex == Sex.MALE)
                                      .toList()[index];
                                  return ImpressionWidget(
                                    controller: controller,
                                    impression: impression,
                                    key: Key(
                                        impression.impressions_id.toString()),
                                  );
                                },
                              ),
                            )),
                        Obx(() => Visibility(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'Nenhuma recomendação aqui por enquanto',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(fontSize: 17),
                                ),
                              ),
                              visible: controller.impressionsList
                                      .where((p0) => p0.sex == Sex.MALE)
                                      .isEmpty &&
                                  controller.impressionsList
                                      .where((p0) => p0.sex != Sex.MALE)
                                      .isEmpty,
                            )),
                        Obx(() => Container(
                              height: controller.impressionsList
                                      .where((p0) => p0.sex != Sex.MALE)
                                      .isEmpty
                                  ? 0
                                  : 200,
                              child: ListView.builder(
                                itemCount: controller.impressionsList
                                        .where((p0) => p0.sex != Sex.MALE)
                                        .length +
                                    1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  if (index ==
                                      controller.impressionsList
                                          .where((p0) => p0.sex != Sex.MALE)
                                          .length) {
                                    return Obx(
                                      () => controller.haveNoMoreFemale.value
                                          ? SizedBox.fromSize()
                                          : AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                child: InkWell(
                                                  onTap: controller
                                                      .loadingMoreImpressions,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('Mostrar Mais',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontSize:
                                                                      16)),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Icon(Icons.add, size: 28)
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    );
                                  }
                                  final impression = controller.impressionsList
                                      .where((p0) => p0.sex != Sex.MALE)
                                      .toList()[index];
                                  return ImpressionWidget(
                                    impression: impression,
                                    controller: controller,
                                    key: Key(
                                        impression.impressions_id.toString()),
                                  );
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Obx(() => Visibility(
                  visible: controller.loadingQuiz.value,
                  child: Positioned.fill(
                      child: Container(
                    child: Center(child: LinearProgressIndicator()),
                  )),
                ))
          ],
        ),
      ),
    );
  }
}
