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
    
    // ตรวจสอบ error code ว่าเป็น "email-already-in-use" หรือไม่
    if (e.code == 'email-already-in-use') {
      return Future.error('อีเมลนี้ถูกใช้งานไปแล้ว');
    }
    return Future.error(e.message ?? 'เกิดข้อผิดพลาดบางอย่าง');
  } catch (e) {
    logger.e("error something someone");
    return Future.error("เกิดข้อผิดพลาดบางอย่าง");
  }
}


  Future<String?> LoginWithEmailandPassword(
      String email, String password) async {
    logger.d("ทำงานปกติ");
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user?.uid; // ส่ง UID กลับไป
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      logger.e(e.message);
      if (e.code == 'user-not-found') {
        return null; // ส่งข้อความข้อผิดพลาด
      } else if (e.code == 'wrong-password') {
        return null; // ส่งข้อความข้อผิดพลาด
      } else {
        return null; // ส่งข้อความข้อผิดพลาดทั่วไป
      }
    }
  }
}
