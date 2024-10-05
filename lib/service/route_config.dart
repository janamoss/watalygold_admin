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
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: "/register",
          name: "/register",
          builder: (context, state) {
            return const registerPage();
          },
        ),
        GoRoute(
          path: "/dashboard",
          name: "/dashboard",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            // sidebarController.index.value = 0;
            return const MainDash();
            // final User user = state.extra as User;
          },
        ),
        GoRoute(
          path: "/mainKnowledge",
          name: "/mainKnowledge",
          redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            // sidebarController.index.value = 1;
            return const MainKnowlege();
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
            final args = state.extra as Map<String, dynamic>;
            final Knowledge knowledge = args['knowledge'] as Knowledge;
            final IconData icons = args['icon'] as IconData;
            return EditMutiple(
              knowledge: knowledge,
              icons: icons,
            );
          },
        ),
        GoRoute(
          path: "/editKnowledge",
          name: "/editKnowledge",
          // redirect: (context, state) => CheckUser.handleAuthRedirect(context),
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;
            final Knowledge knowledge = args['knowledge'] as Knowledge;
            final IconData icons = args['icon'] as IconData;
            return EditKnowlege(
              knowledge: knowledge,
              icons: icons,
            );
          },
        ),
      ],
    );
  }
}
