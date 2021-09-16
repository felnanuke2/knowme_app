import 'package:knowme/models/user_model.dart';
import 'package:knowme/sucess/login_sucess_interface.dart';

class SupabaseLoginSucess implements LoginSucessInterface {
  UserModel user;
  SupabaseLoginSucess({
    required this.user,
  });
}
