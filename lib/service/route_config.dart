import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditMutiple.dart';
import 'package:watalygold_admin/Page/Knowlege/MainKnowlege.dart';
import 'package:watalygold_admin/Page/MainDashborad.dart';
import 'package:watalygold_admin/Page/loginpage.dart';
import 'package:watalygold_admin/Page/registerpage.dart';
import 'package:watalygold_admin/service/knowledge.dart';

class RouteConfig {
  static GoRouter returnRotuer() {
    return GoRouter(initialLocation: "/mainKnowledge", routes: [
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
        path: "/dashborad",
        name: "/dashborad",
        builder: (context, state) {
          final User user = state.extra as User;
          return MainDash(
            users: user,
          );
        },
      ),
      GoRoute(
        path: "/mainKnowledge",
        name: "/mainKnowledge",
        builder: (context, state) {
          return const MainKnowlege();
        },
      ),
      GoRoute(
        path: "/addKnowledge",
        name: "/addKnowledge",
        builder: (context, state) {
          return const Add_Knowlege();
        },
      ),
      GoRoute(
        path: "/editmultiKnowledge",
        name: "/editmultiKnowledge",
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
    ]);
  }
}
