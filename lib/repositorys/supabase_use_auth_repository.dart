import 'dart:async';

import 'package:knowme/errors/requestError.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/repositorys/supabase_repository.dart';
import 'package:knowme/sucess/login_sucess_interface.dart';
import 'package:knowme/sucess/supabase_login_sucess.dart';
import 'package:supabase/supabase.dart';

class SupabaseUserAuthRepository implements UserAuthInterface {
  SupabaseUserAuthRepository({
    required this.repositoryInterface,
  }) {
    if ((repositoryInterface as SupabaseRepository).client.auth.currentUser != null) {}
  }
  @override
  UserModel? currentUser;

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
    currentUser = UserModel();
    currentUser?.id = responseUser.id;
    currentUser?.email = responseUser.email;
    currentUser?.emailConfirm = responseUser.emailConfirmedAt != null ? true : false;
    try {
      var user = await repositoryInterface.getCurrentUser(responseUser.id);
      currentUser = user..profileComplet = true;
      if (!currentUserdataCompleter.isCompleted) currentUserdataCompleter.complete();
      return user;
    } on RequestError catch (e) {
      if (!currentUserdataCompleter.isCompleted) currentUserdataCompleter.complete();
      return currentUser?..profileComplet = false;
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
