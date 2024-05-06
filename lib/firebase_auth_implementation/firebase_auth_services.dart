import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FirebaseAuthService {
  final logger = Logger();

  Future<User?> RegisterWithEmailandPassword(
      String email, String password, String username) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      credential.user?.updateDisplayName(username);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      logger.e(e);
    } catch (e) {
      logger.e("error someting someone");
    }
    return null;
  }

  Future<User?> LoginWithEmailandPassword(String email, String password) async {
    logger.d("ทำงานปกติ");
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      if (e.code == 'user-not-found') {
        logger.d('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        logger.d('Wrong password provided for that user.');
      }
    }
    return null;
  }
}
