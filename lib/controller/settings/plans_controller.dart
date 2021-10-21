import 'dart:io';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/errors/requestError.dart';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/plans_model.dart';
import 'package:knowme/platform_channel/deep_link_channel.dart';
import 'package:knowme/services/analitcs_services.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:knowme/constants/.env.dart' as env;
import 'package:url_launcher/url_launcher.dart' as launch;

class PlansController extends GetxController {
  final DbRepositoryInterface repository;
  final plansList = <PlansModel>[].obs;
  PlansController({
    required this.repository,
  }) {
    getPlans();
  }

  final loadPlan = false.obs;
  getPlans() async {
    AnalitcsServices.instance
        .logEvent(analitcsEnum: AnalitcsEnum.OpenImpressions, data: {});
    loadPlan.value = true;
    try {
      final plans = await repository.getPlans();
      plansList.clear();
      plansList.addAll(plans);
    } on RequestError catch (e) {
      print(e.message);
    }
    loadPlan.value = false;
  }

  selectPlan(PlansModel plan) async {
    loadPlan.value = true;
    final result = await repository.createPaymentSession(plan.id);
    AnalitcsServices.instance.logEvent(
        analitcsEnum: AnalitcsEnum.StartPayment, data: {'plan': plan.id});
    if (Platform.isIOS) {
      _startIosPaymentSession(result['init_point'].toString());
      loadPlan.value = false;
      return;
    }
    final platform = await MercadoPagoMobileCheckout.platformVersion;

    final response = await MercadoPagoMobileCheckout.startCheckout(
        env.MERCADO_PAGO_PUBLIC_KEY, result['id'].toString());

    loadPlan.value = false;
  }

  void _startIosPaymentSession(String prefId) async {
    DeepLinkChannel.instance.stream.listen((url) {
      if (url == 'mp-callback://paymentsuccess') {
        launch.closeWebView();
      }
    });
    launch.launch(prefId);
  }
}
