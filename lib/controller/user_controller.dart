import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:knowme/mock/user_mock.dart';
import 'package:knowme/models/user_model.dart';

class UserController extends GetxController {
  bool isLoading = false;
  UserModel? currentUser;
  UserController() {
    _getCurrentUser();
  }
  _getCurrentUser() async {
    isLoading = true;
    update();
    await Future.delayed(Duration(seconds: 1));
    isLoading = false;
    currentUser = CURRENT_USER;
    update();
  }
}
