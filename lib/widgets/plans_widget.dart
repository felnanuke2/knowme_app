import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:knowme/controller/settings/plans_controller.dart';
import 'package:knowme/models/plans_model.dart';

class PlansWidget extends StatelessWidget {
  const PlansWidget({
    Key? key,
    required this.plan,
    required this.controller,
  }) : super(key: key);
  final PlansModel plan;
  final PlansController controller;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          color: Get.theme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        plan.name,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        plan.description,
                        style: GoogleFonts.openSans(color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        price,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Por',
                        style: GoogleFonts.openSans(color: Colors.white54),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        plan.impressions.toString() + '\nImpressões',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            ...plan.vantages.map((e) => ListTile(
                                  leading: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    e,
                                    style:
                                        GoogleFonts.openSans(color: Colors.white60, fontSize: 14),
                                    textAlign: TextAlign.left,
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Divider(
                      color: Colors.white60,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: TextButton(
                          onPressed: () => controller.selectPlan(plan),
                          child: Text(
                            'Selecionar Plano',
                            style: GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                            textAlign: TextAlign.left,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get price => 'R\$ ' + plan.price.toStringAsFixed(2).replaceAll('.', ',');
}
