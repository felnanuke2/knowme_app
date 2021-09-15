import 'dart:async';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/repositorys/supabase_repository.dart';
import 'package:supabase/supabase.dart';

class SupabaseUserAuthRepository implements UserAuthInterface {
  final DbRepositoryInterface repository;
  UserModel? _userModel;
  SupabaseUserAuthRepository({
    required this.repository,
  });
  @override
  UserModel? get currentUser {
    return _userModel;
  }

  @override
  Completer currentUserdataCompleter = Completer();

  @override
  Future completProfile(UserModel userModel) {
    // TODO: implement completProfile
    throw UnimplementedError();
  }

  @override
  Future<ThirdPartUserDataModel> getUserDataFromGoogle() {
    // TODO: implement getUserDataFromGoogle
    throw UnimplementedError();
  }

  @override
  // TODO: implement repositoryInterface
  DbRepositoryInterface get repositoryInterface => throw UnimplementedError();

  @override
  Future sendResetPasswordEmail({required String email}) {
    // TODO: implement sendResetPasswordEmail
    throw UnimplementedError();
  }

  @override
  Future sigInWithApple() {
    // TODO: implement sigInWithApple
    throw UnimplementedError();
  }

  @override
  Future sigInWithEmail({required String email, required String password}) async {
    final repo = (repository as SupabaseRepository);
    final response = await repo.client.auth.signIn(email: email, password: password);
    print(response);
  }

  @override
  Future sigInWithFacebook() {
    // TODO: implement sigInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future sigInWithGoogle() {
    // TODO: implement sigInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future signUp({required String email, required String password}) async {
    final repo = (repository as SupabaseRepository);
    final response = await repo.client.auth.signUp(email, password);
    if (response.user != null) {
      currentUser = UserModel(
        id: response.user!.id,
        email: response.user!.email,
      );
      return;
      currentUserdataCompleter.complete();
    }
    throw 'error';
  }

  @override
  set currentUser(UserModel? _currentUser) {
    _userModel = _currentUser;
  }

  Future<dynamic> _setuserData(User responseUser) async {
    final repo = (repository as SupabaseRepository);
    currentUser = UserModel();
    currentUser?.id = responseUser.id;
    currentUser?.email = responseUser.email;
    currentUser?.emailConfirm = responseUser.emailConfirmedAt != null ? true : false;

    var user = await repository.getCurrentUser(responseUser.id);
    if (user != null) {
      currentUser = user;
      if (!currentUserdataCompleter.isCompleted) currentUserdataCompleter.complete();
      return user;
    } else {
      if (!currentUserdataCompleter.isCompleted) currentUserdataCompleter.complete();
      return currentUser?..profileComplet = false;
    }
  }
}
