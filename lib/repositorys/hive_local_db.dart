import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:knowme/constants/constant_hive_ids.dart';
import 'package:knowme/interface/local_db_interface.dart';
import 'package:knowme/models/user_model.dart';

const USER_BOX = 'user_box';
const APP_BOX = 'app_box';

class HiveLocalDb extends LocalDbInterface {
  late Box<UserModel> _userBox;
  late Box _appAdapter;

  @override
  Future<void> initializeDatabase() async {
    await Hive.initFlutter();
    _registerAdapter();
    _userBox = await Hive.openBox(USER_BOX);
    _appAdapter = await Hive.openBox(APP_BOX);
  }

  _registerAdapter() {
    if (!Hive.isAdapterRegistered(USER_HIVE_ID)) Hive.registerAdapter(UserModelAdapter());
    if (!Hive.isAdapterRegistered(SEX_HIVE_ID)) Hive.registerAdapter(SexAdapter());
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    print(user.profileComplet);
    if (user.profileComplet) {
      await _userBox.put(0, user);
      print(_userBox.get(0));
    }
  }

  @override
  Future<void> cleanUser() async {
    await _userBox.clear();
  }

  @override
  UserModel? getUser() {
    final u = _userBox.get(0);
    return u;
  }

  @override
  String? getAuthToken() {
    return _appAdapter.get('token');
  }

  @override
  Future<void> putAuthToken(String token) async {
    await _appAdapter.put('token', token);
  }

  @override
  Future<void> removeAuthToken() async {
    await _appAdapter.delete('token');
  }
}
