import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigInRepo {
  final googleSignIN = GoogleSignIn(scopes: [
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/user.phonenumbers.read',
    'https://www.googleapis.com/auth/user.gender.read',
    // 'https://www.googleapis.com/auth/contacts.readonly'
  ]);

  Future<String?> call() async {
    final googleSignInAccount = await googleSignIN.signIn();
    if (googleSignInAccount == null) return 'Falha ao Conectar-se com o google';
    final googleSignInAuthentication = await googleSignInAccount.authentication;
    try {
      await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken));
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
