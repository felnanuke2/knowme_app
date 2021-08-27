import 'dart:convert';

import 'package:knowme/auth/google_sign_in.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserAuthRepository implements UserAuthInterface {
  final _googleSignIn = GoogleSigInRepo();
  final DbRepositoryInterface _dbRepositoryInterface;

  @override
  UserModel? currentUser;
  UserAuthRepository(
    this._dbRepositoryInterface,
  );

  @override
  Future<String?> completProfile(UserModel userModel) {
    // TODO: implement completProfile
    throw UnimplementedError();
  }

  @override
  // TODO: implement repositoryInterface
  DbRepositoryInterface get repositoryInterface => throw UnimplementedError();

  @override
  Future<String?> sendResetPasswordEmail({required String email}) {
    // TODO: implement sendResetPasswordEmail
    throw UnimplementedError();
  }

  @override
  Future<String?> sigInWithApple() {
    // TODO: implement sigInWithApple
    throw UnimplementedError();
  }

  @override
  Future<String?> sigInWithEmail({required String email, required String password}) {
    // TODO: implement sigInWithEmail
    throw UnimplementedError();
  }

  @override
  Future<String?> sigInWithFacebook() {
    // TODO: implement sigInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<String?> sigInWithGoogle() async {
    var response = await _googleSignIn();
    if (response == null) {
      getUserDataFromGoogle();
    }
  }

  @override
  Future<String?> signUp({required String email, required String password}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<ThirdPartUserDataModel> getUserDataFromGoogle() async {
    final host = 'https://people.googleapis.com';
    final endPoint = '/v1/people/me?personFields=birthdays,genders,phoneNumbers';
    final authHeaders = await _googleSignIn.googleSignIN.currentUser!.authHeaders;
    final response = await http.get(Uri.parse('$host$endPoint'), headers: authHeaders);

    return ThirdPartUserDataModel.fromGoogle(jsonDecode(response.body));
  }
}
