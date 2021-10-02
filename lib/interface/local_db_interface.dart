import 'package:knowme/models/user_model.dart';

abstract class LocalDbInterface {
  Future<void> initializeDatabase();

  Future<void> cacheUser(UserModel user);

  Future<void> cleanUser();

  UserModel? getUser();

  Future<void> putAuthToken(String toke);

  Future<void> removeAuthToken();

  String? getAuthToken();
}
