import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckUser {
  static Future<bool> checkUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  static Future<bool> checkSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getString("UserID");
    return userID != null;
  }

  static Future<String?> handleAuthRedirect(BuildContext context) async {
    final hasUser = await checkUser();
    final hasUserID = await checkSharedPrefs();

    if (hasUser && hasUserID) {
      return null; // มี user และ UserID ให้คงอยู่ path ปัจจุบัน
    } else {
      return '/login'; // ไม่มี user หรือ UserID ให้ redirect ไป login
    }
  }
}

// final userPath = Uri.parse(state.uri.path).path; // เก็บ path ที่ผู้ใช้ป้อน

//     if (!hasUser) {
//       if (userPath != '/register') {
//         return '/login';
//       } else {
//         // ไม่มี User ให้ไป login
//         return '/register';
//       }
//     }

//     // ตรวจสอบว่า path ที่ผู้ใช้ป้อนมีอยู่ใน GoRoute หรือไม่
//     final matchingRoute = GoRouter.of(context)
//         .routerDelegate
//         .currentConfiguration
//         .routes
//         .any((route) => (route as GoRoute).path == userPath);

//     if (matchingRoute) {
//       return null; // พบ path ใน GoRoute ให้คงอยู่ที่ path ปัจจุบัน
//     } else {
//       return '/dashboard'; // ไม่พบ path ให้ไป dashboard
//     }