import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditMutiple.dart';
import 'package:watalygold_admin/Page/Knowlege/MainKnowlege.dart';
import 'package:watalygold_admin/Page/MainDashborad.dart';
import 'package:watalygold_admin/Page/loginpage.dart';
import 'package:watalygold_admin/Page/registerpage.dart';
import 'package:watalygold_admin/service/checkuser.dart';
import 'package:watalygold_admin/service/knowledge.dart';

class RouteConfig {
  static GoRouter returnRotuer() {
    final SidebarController sidebarController = Get.put(SidebarController());

    return GoRouter(
      initialLocation: "/mainKnowledge",
      routes: [
        GoRoute(
          path: "/login",
          name: "/login",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            final extra =
                state.extra as Map<String, dynamic>?; // รับค่าจาก extra
            return LoginPage(
              showSuccessFlushbar: extra?['showSuccessFlushbar'] ??
                  false, // ส่งค่าไปยัง LoginPage
              message: extra?['message'] ?? '',
              description: extra?['description'] ?? '',
            );
          },
        ),
        GoRoute(
          path: "/register",
          name: "/register",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            return const registerPage();
          },
        ),
        GoRoute(
          path: "/dashboard",
          name: "/dashboard",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return MainDash(
              showSuccessFlushbar: extra?['showSuccessFlushbar'] ?? false,
              message: extra?['message'] ?? '',
              description: extra?['description'] ?? '',
            );
            // final User user = state.extra as User;
          },
        ),
        GoRoute(
          path: "/mainKnowledge",
          name: "/mainKnowledge",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            // sidebarController.index.value = 1;
            debugPrint("ทำงานปกตินะคะ");
            final extra =
                state.extra as Map<String, dynamic>?; // รับค่าจาก extra
            return MainKnowlege(
              showSuccessFlushbar: extra?['showSuccessFlushbar'] ??
                  false, // ส่งค่าไปยัง LoginPage
              message: extra?['message'] ?? '',
              description: extra?['description'] ?? '',
            );
          },
        ),
        GoRoute(
          path: "/addKnowledge",
          name: "/addKnowledge",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            // sidebarController.index.value = 2;
            return const Add_Knowlege();
          },
        ),
        GoRoute(
          path: "/editmultiKnowledge",
          name: "/editmultiKnowledge",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            // ดึง id จาก query parameters
            final id = state.uri.queryParameters['id'];
            debugPrint(id);

            // ตรวจสอบว่ามีการส่ง id มาหรือไม่
            if (id != null) {
              // ใช้ FutureBuilder เพื่อดึงข้อมูล knowledge จาก Firestore
              return FutureBuilder<Knowledge?>(
                future: getKnowledgeById(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // กำลังโหลดข้อมูล
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No data found for ID: $id');
                  } else {
                    // ถ้าข้อมูลถูกดึงมาเรียบร้อย
                    final Knowledge knowledge = snapshot.data!;

                    // ส่งข้อมูล knowledge ไปใช้ในหน้า EditKnowlege
                    return EditMutiple(
                      knowledge: knowledge,
                      icons: Icons.edit, // ตัวอย่างไอคอน
                    );
                  }
                },
              );
            } else {
              // ถ้าไม่มี id ถูกส่งมาใน URL
              return Text('No ID provided in the URL');
            }
          },
        ),
        GoRoute(
          path: "/editKnowledge",
          name: "/editKnowledge",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            // ดึง id จาก query parameters
            final id = state.uri.queryParameters['id'];
            debugPrint(id);

            // ตรวจสอบว่ามีการส่ง id มาหรือไม่
            if (id != null) {
              // ใช้ FutureBuilder เพื่อดึงข้อมูล knowledge จาก Firestore
              return FutureBuilder<Knowledge?>(
                future: getKnowledgeById(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // กำลังโหลดข้อมูล
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No data found for ID: $id');
                  } else {
                    // ถ้าข้อมูลถูกดึงมาเรียบร้อย
                    final Knowledge knowledge = snapshot.data!;

                    // ส่งข้อมูล knowledge ไปใช้ในหน้า EditKnowlege
                    return EditKnowlege(
                      knowledge: knowledge,
                      icons: Icons.edit, // ตัวอย่างไอคอน
                    );
                  }
                },
              );
            } else {
              // ถ้าไม่มี id ถูกส่งมาใน URL
              return Text('No ID provided in the URL');
            }
          },
        ),
      ],
    );
  }
}
