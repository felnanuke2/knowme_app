import 'package:knowme/models/user_model.dart';

class ThirdPartUserDataModel {
  Sex? gender;
  DateTime? dateTime;
  String? phoneNumber;
  ThirdPartUserDataModel({
    this.gender,
    this.dateTime,
    this.phoneNumber,
  });
  factory ThirdPartUserDataModel.fromGoogle(Map map) {
    final userdataModel = ThirdPartUserDataModel();
    try {
      var gender = map['genders'].first['value'];
      if (gender != null) {
        if (gender == 'male') {
          userdataModel.gender = Sex.MALE;
        } else if (gender == 'female') {
          userdataModel.gender = Sex.FEMALE;
        }
      }
      var year = map['birthdays'].first['date']['year'];
      var month = map['birthdays'].first['date']['month'];
      var day = map['birthdays'].first['date']['day'];

      userdataModel.dateTime = DateTime(year, month, day);
    } catch (e) {}

    return userdataModel;
  }
}
