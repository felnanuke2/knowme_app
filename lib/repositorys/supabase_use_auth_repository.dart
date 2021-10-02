import 'dart:async';

import 'package:get/state_manager.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/local_db_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/main.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/repositorys/supabase_repository.dart';
import 'package:knowme/sucess/login_sucess_interface.dart';
import 'package:knowme/sucess/supabase_login_sucess.dart';
import 'package:supabase/supabase.dart';
import 'package:get/instance_manager.dart';

class SupabaseUserAuthRepository implements UserAuthInterface {
  SupabaseUserAuthRepository({
    required this.repositoryInterface,
  }) {
    if (local.getAuthToken() != null) {
      (repositoryInterface as SupabaseRepository).client.auth.recoverSession(local.getAuthToken()!);
    }
    (repositoryInterface as SupabaseRepository).client.auth.onAuthStateChange((event, session) {
      if (session != null) local.putAuthToken(session.persistSessionString);
    });
  }
  UserModel? _currentUser;
  final local = Get.find<LocalDbInterface>();

  UserModel? get currentUser => _currentUser ?? local.getUser();

  set currentUser(UserModel? user) {
    _currentUser = user;
    if (user == null) return;
    local.cacheUser(user);
  }

  @override
  Completer currentUserdataCompleter = Completer();

  @override
  Future<ThirdPartUserDataModel> getUserDataFromGoogle() {
    // TODO: implement getUserDataFromGoogle
    throw UnimplementedError();
  }

  @override
  Future<LoginSucessInterface> sigInWithEmail(
      {required String email, required String password}) async {
    final repo = (repositoryInterface as SupabaseRepository);
    final response = await repo.client.auth.signIn(email: email, password: password);
    if (response.error != null) throw RequestError(message: response.error?.message ?? '');
    await _setuserData(response.user!);

    return SupabaseLoginSucess(user: currentUser!);
  }

  @override
  Future<LoginSucessInterface> signUp({required String email, required String password}) async {
    final repo = (repositoryInterface as SupabaseRepository);
    final response = await repo.client.auth.signUp(email, password);
    if (response.error != null) throw RequestError(message: response.error!.message);
    currentUser = UserModel(
      id: response.user!.id,
      email: response.user!.email,
    );
    return SupabaseLoginSucess(user: currentUser!);
  }

  Future<dynamic> _setuserData(User responseUser) async {
    final repo = (repositoryInterface as SupabaseRepository);
    final u = UserModel();
    u.id = responseUser.id;
    u.email = responseUser.email;
    u.emailConfirm = responseUser.emailConfirmedAt != null ? true : false;
    currentUser = u;
    try {
      var user = await repositoryInterface.getCurrentUser(responseUser.id);
      currentUser = user..profileComplet = true;

      if (!currentUserdataCompleter.isCompleted) currentUserdataCompleter.complete();
      return user;
    } on RequestError catch (e) {
      if (!currentUserdataCompleter.isCompleted) currentUserdataCompleter.complete();
      return currentUser = currentUser?..profileComplet = false;
    }
  }

  @override
  Future<LoginSucessInterface> completProfile(UserModel userModel) {
    // TODO: implement completProfile
    throw UnimplementedError();
  }

  @override
  // TODO: implement repositoryInterface
  final DbRepositoryInterface repositoryInterface;

  @override
  Future<LoginSucessInterface> sendResetPasswordEmail({required String email}) {
    // TODO: implement sendResetPasswordEmail
    throw UnimplementedError();
  }

  @override
  Future<LoginSucessInterface> sigInWithApple() {
    // TODO: implement sigInWithApple
    throw UnimplementedError();
  }

  @override
  Future<LoginSucessInterface> sigInWithFacebook() {
    // TODO: implement sigInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<LoginSucessInterface> sigInWithGoogle() {
    // TODO: implement sigInWithGoogle
    throw UnimplementedError();
  }
}
