import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:watalygold_admin/Page/Knowlege/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/MainKnowlege.dart';
import 'package:watalygold_admin/Page/MainDashborad.dart';
import 'package:watalygold_admin/Page/loginpage.dart';
import 'package:watalygold_admin/Page/registerpage.dart';

class RouteConfig {
  static GoRouter returnRotuer() {
    return GoRouter(initialLocation: "/login", routes: [
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
          return const AddKnowlege();
        },
      ),
    ]);
  }
}
