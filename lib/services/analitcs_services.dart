import 'package:extended_image/extended_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalitcsServices {
  final _map = <AnalitcsEnum, String>{
    AnalitcsEnum.UserLocation: 'user_location',
    AnalitcsEnum.OpenImpressions: 'open_plans',
    AnalitcsEnum.StartPayment: 'start_payment'
  };
  final _analitcs = FirebaseAnalytics();
  final acceptedTypes = [String, int, double, bool];

  AnalitcsServices._instance() {}

  static AnalitcsServices get instance => AnalitcsServices._instance();

  logEvent(
      {required AnalitcsEnum analitcsEnum,
      required Map<String, dynamic> data}) {
    data.forEach((key, value) {
      _checkIsValidType(value.runtimeType, key);
    });
    if (analitcsEnum == AnalitcsEnum.StartPayment) {
      _analitcs.logAddPaymentInfo();
    }
    _analitcs.logEvent(
        name: _map[AnalitcsEnum.UserLocation]!, parameters: data);
  }

  bool _checkIsValidType(Type type, String keyname) {
    if (!acceptedTypes.contains(type))
      throw '$keyname of type ${type} is not an accpted Type. only accepted are ${acceptedTypes} ';
    return true;
  }
}

enum AnalitcsEnum {
  UserLocation,
  StartPayment,
  OpenImpressions,
}
