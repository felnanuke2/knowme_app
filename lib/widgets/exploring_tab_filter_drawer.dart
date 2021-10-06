import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:knowme/controller/main_screen/exploring_controller.dart';

class ExploringTabFilterDrawer extends StatelessWidget {
  const ExploringTabFilterDrawer({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final ExploringController controller;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 65,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filtros',
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white, padding: EdgeInsets.all(6)),
                                onPressed: controller.setNewFilters,
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                label: Text(
                                  'Buscar',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green),
                                ))
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 65,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  SizedBox(
                    height: 145,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        controller.distanceTEC.text = '1';
                      }
                    },
                    inputFormatters: [controller.distanceMask],
                    controller: controller.distanceTEC,
                    decoration: InputDecoration(
                        labelText: 'Distância',
                        icon: Icon(Icons.pin_drop_sharp),
                        helperText: 'ex: 25 km'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
