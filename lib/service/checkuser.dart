import 'dart:html';

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
    final hasUser = await checkUser(); // ตรวจสอบว่าผู้ใช้ล็อกอินแล้วหรือยัง
    final hasUserID =
        await checkSharedPrefs(); // ตรวจสอบ UserID ใน SharedPreferences

    debugPrint(hasUser.toString());
    debugPrint(hasUserID.toString());

    // ดึง URL ปัจจุบัน
    final currentUrl = window.location.href;

    final uri = Uri.parse(currentUrl);
    final currentRoute = uri.path;

    // Debug ดูว่าตอนนี้อยู่ใน route ไหน
    debugPrint(currentRoute);

    if (hasUser && hasUserID) {
      // ตรวจสอบว่าผู้ใช้พยายามเข้าหน้า /login หรือ /register และได้ทำการล็อกอินแล้ว
      if (currentRoute == '/login' || currentRoute == '/register') {
        return '/dashboard'; // Redirect ผู้ใช้ไปที่หน้าอื่น เช่นหน้า home
      }
      return null; // ให้คงอยู่ path ปัจจุบันถ้าไม่ใช่หน้า /login หรือ /register
    } else {
      if (currentRoute == '/login' || currentRoute == '/register') {
        return null; // อนุญาตให้ไปหน้าล็อกอินหรือสมัครสมาชิก
      }

      // ถ้าผู้ใช้พยายามเข้าถึง path อื่นที่ต้องล็อกอิน ให้ redirect ไปที่หน้า /login
      return '/login';
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