import 'package:knowme/interface/db_repository_interface.dart';
import 'package:knowme/models/third_part_user_data_model.dart';
import 'package:knowme/models/user_model.dart';

abstract class UserAuthInterface {
  final DbRepositoryInterface repositoryInterface;
  UserAuthInterface({
    required this.repositoryInterface,
  });
  UserModel? currentUser;

  Future<String?> sigInWithGoogle();
  Future<String?> sigInWithEmail({required String email, required String password});
  Future<String?> sigInWithFacebook();
  Future<String?> sigInWithApple();
  Future<String?> completProfile(UserModel userModel);
  Future<String?> signUp({required String email, required String password});
  Future<String?> sendResetPasswordEmail({required String email});
  Future<ThirdPartUserDataModel> getUserDataFromGoogle();
}
