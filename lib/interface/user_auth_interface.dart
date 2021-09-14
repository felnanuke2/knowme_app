import 'dart:async';

import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/interactions_model.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';

abstract class UserAuthInterface {
  Completer currentUserdataCompleter = Completer();

  UserModel? currentUser;

  final DbRepositoryInterface repositoryInterface;
  UserAuthInterface({
    required this.repositoryInterface,
  });

  Future<dynamic> sigInWithGoogle();
  Future<dynamic> sigInWithEmail({required String email, required String password});
  Future<dynamic> sigInWithFacebook();
  Future<dynamic> sigInWithApple();
  Future<dynamic> completProfile(UserModel userModel);
  Future<dynamic> signUp({required String email, required String password});
  Future<dynamic> sendResetPasswordEmail({required String email});
  Future<ThirdPartUserDataModel> getUserDataFromGoogle();
}
