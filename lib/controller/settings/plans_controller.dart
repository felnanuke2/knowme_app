import 'package:get/state_manager.dart';
import 'package:knowme/errors/requestError.dart';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/plans_model.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:knowme/constants/.env.dart' as env;

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
    final prefId = await repository.createPaymentSession(plan.id);
    final platform = await MercadoPagoMobileCheckout.platformVersion;
    final response =
        await MercadoPagoMobileCheckout.startCheckout(env.MERCADO_PAGO_PUBLIC_KEY, prefId);

    loadPlan.value = false;
  }
}
