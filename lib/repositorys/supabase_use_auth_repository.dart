import 'dart:async';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/state_manager.dart';
import 'package:knowme/deep_link_services/supabase_deep_link_services.dart';
import 'package:knowme/errors/requestError.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/local_db_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/main.dart';

import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/repositorys/supabase_repository.dart';
import 'package:knowme/sucess/login_sucess_interface.dart';
import 'package:knowme/sucess/password_recovery_sucess.dart';
import 'package:knowme/sucess/supabase_login_sucess.dart';
import 'package:supabase/supabase.dart';
import 'package:get/instance_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supaflutter;

class SupabaseUserAuthRepository implements UserAuthInterface {
  SupabaseUserAuthRepository({
    required this.repositoryInterface,
  }) {
    SupabaseDeepLinkServices();
    if (local.getAuthToken() != null) {
      (repositoryInterface as SupabaseRepository)
          .client
          .auth
          .recoverSession(local.getAuthToken()!)
          .then((value) {
        print('recoverysessio = ' + (value.error?.message).toString());
        if (value.error == null) {
          local.putAuthToken(value.data!.persistSessionString);
          MyApp.initializationComplete.complete();
        } else {
          MyApp.initializationComplete.completeError(value.error!.message);
        }
      });
    } else {
      MyApp.initializationComplete.complete();
    }
    (repositoryInterface as SupabaseRepository)
        .client
        .auth
        .onAuthStateChange((event, session) async {
      print('auth stateChange');
      if (session != null) local.putAuthToken(session.persistSessionString);
    });
  }
  UserModel? _currentUser;
  final local = Get.find<LocalDbInterface>();

  UserModel? get getCurrentUser => _currentUser ?? local.getUser();

  set setCurrentUser(UserModel? user) {
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
    final response =
        await repo.client.auth.signIn(email: email, password: password);
    if (response.error != null)
      throw RequestError(message: response.error?.message ?? '');
    await _setuserData(response.user!);

    return SupabaseLoginSucess(user: getCurrentUser!);
  }

  @override
  Future<LoginSucessInterface> signUp(
      {required String email, required String password}) async {
    final repo = (repositoryInterface as SupabaseRepository);
    final response = await repo.client.auth.signUp(email, password);
    if (response.error != null)
      throw RequestError(message: response.error!.message);
    setCurrentUser = UserModel(
      id: response.user!.id,
      email: response.user!.email,
    );
    return SupabaseLoginSucess(user: getCurrentUser!);
  }

  Future<dynamic> _setuserData(User responseUser) async {
    final repo = (repositoryInterface as SupabaseRepository);
    final u = UserModel();
    u.id = responseUser.id;
    u.email = responseUser.email;
    u.emailConfirm = responseUser.emailConfirmedAt != null ? true : false;
    setCurrentUser = u;
    try {
      var user = await repositoryInterface.getCurrentUser(responseUser.id);
      setCurrentUser = user..profileComplet = true;

      if (!currentUserdataCompleter.isCompleted)
        currentUserdataCompleter.complete();
      return user;
    } on RequestError catch (e) {
      if (!currentUserdataCompleter.isCompleted)
        currentUserdataCompleter.complete();
      return setCurrentUser = getCurrentUser?..profileComplet = false;
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
  Future<LoginSucessInterface> sendResetPasswordEmail(
      {required String email}) async {
    final repo = (repositoryInterface as SupabaseRepository);
    final response = await repo.client.auth.api.resetPasswordForEmail(email);
    if (response.error != null)
      throw RequestError(message: 'email não encontrado');
    return RecoveryPasswordSucess();
  }

  @override
  Future<LoginSucessInterface> sigInWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<LoginSucessInterface> sigInWithFacebook() async {
    final repo = (repositoryInterface as SupabaseRepository);
    final url = await repo.client.auth.signIn(provider: Provider.facebook);
    final authUrl = await FlutterWebAuth.authenticate(
        url: url.url!, callbackUrlScheme: 'my-app-coneplay');

    final result = await repo.client.auth.getSessionFromUrl(Uri.parse(authUrl));
    if (result.error != null)
      throw RequestError(message: result.error?.message ?? '');

    await _setuserData(result.user!);

    return SupabaseLoginSucess(user: getCurrentUser!);
  }

  @override
  Future<LoginSucessInterface> sigInWithGoogle() async {
    final repo = (repositoryInterface as SupabaseRepository);
    final url = await repo.client.auth.signIn(provider: Provider.google);
    final authUrl = await FlutterWebAuth.authenticate(
      url: url.url!,
      callbackUrlScheme: 'my-app-coneplay',
    );

    final result = await repo.client.auth.getSessionFromUrl(Uri.parse(authUrl));
    if (result.error != null)
      throw RequestError(message: result.error?.message ?? '');

    await _setuserData(result.user!);

    return SupabaseLoginSucess(user: getCurrentUser!);
  }

  @override
  Future<void> singOut() async {
    final repo = (repositoryInterface as SupabaseRepository);
    repo.updateUser(getCurrentUser!.id!, firebaseToken: '');
    await repo.client.auth.signOut();
    await local.cleanUser();
    currentUserdataCompleter = Completer();
  }
}
