import 'dart:async';

import 'package:knowme/interface/db_repository_interface.dart';

import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:knowme/sucess/login_sucess_interface.dart';

abstract class UserAuthInterface {
  Completer currentUserdataCompleter = Completer();

  Completer get completer;

  UserModel? get currentUser;
  set currentUser(UserModel? user);

  final DbRepositoryInterface repositoryInterface;
  UserAuthInterface({
    required this.repositoryInterface,
  });

  Future<LoginSucessInterface> sigInWithGoogle();
  Future<LoginSucessInterface> sigInWithEmail({required String email, required String password});
  Future<LoginSucessInterface> sigInWithFacebook();
  Future<LoginSucessInterface> sigInWithApple();
  Future<LoginSucessInterface> completProfile(UserModel userModel);
  Future<LoginSucessInterface> signUp({required String email, required String password});
  Future<LoginSucessInterface> sendResetPasswordEmail({required String email});
  Future<ThirdPartUserDataModel> getUserDataFromGoogle();
}
