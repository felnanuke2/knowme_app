import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:knowme/auth/google_sign_in.dart';
import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/interface/user_auth_interface.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserAuthRepository implements UserAuthInterface {
  final _googleSignIn = GoogleSigInRepo();
  final DbRepositoryInterface _dbRepositoryInterface;
  final _auth = FirebaseAuth.instance;

  @override
  Completer currentUserdataCompleter = Completer();

  @override
  UserModel? currentUser;
  UserAuthRepository(
    this._dbRepositoryInterface,
  ) {
    if (_auth.currentUser != null) {
      _setuserData();
    }
  }

  @override
  Future<dynamic> completProfile(UserModel userModel) async {
    await _dbRepositoryInterface.createUser(userModel);
  }

  @override
  // TODO: implement repositoryInterface
  DbRepositoryInterface get repositoryInterface => throw UnimplementedError();

  @override
  Future<dynamic> sendResetPasswordEmail({required String email}) {
    // TODO: implement sendResetPasswordEmail
    throw UnimplementedError();
  }

  @override
  Future<dynamic> sigInWithApple() {
    // TODO: implement sigInWithApple
    throw UnimplementedError();
  }

  @override
  Future<dynamic> sigInWithEmail({required String email, required String password}) {
    // TODO: implement sigInWithEmail
    throw UnimplementedError();
  }

  @override
  Future<dynamic> sigInWithFacebook() {
    // TODO: implement sigInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<dynamic> sigInWithGoogle() async {
    var response = await _googleSignIn();
    if (response == null) {
      return await _setuserData();
    } else {
      return response;
    }
  }

  @override
  Future<dynamic> signUp({required String email, required String password}) {
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

  Future<dynamic> _setuserData() async {
    currentUser = UserModel();
    currentUser?.id = _auth.currentUser?.uid;
    currentUser?.profileImage = _auth.currentUser?.photoURL;
    currentUser?.completName = _auth.currentUser?.displayName;
    currentUser?.email = _auth.currentUser?.email;
    currentUser?.emailConfirm = _auth.currentUser?.emailVerified;

    var user = await _dbRepositoryInterface.getUserCurrentUser(_auth.currentUser!.uid);
    if (user != null) {
      currentUser = user;
      currentUserdataCompleter.complete();
      return user;
    } else {
      return currentUser?..profileComplet = false;
    }
  }
}
