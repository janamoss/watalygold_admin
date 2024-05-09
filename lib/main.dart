import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/main_screen_locations.dart';
import 'package:watalygold_admin/service/route_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainWeb());
}

class MainWeb extends StatelessWidget {
  MainWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
          fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: GPrimaryColor),
          useMaterial3: true),
      title: "Wataly Gold Admin",
      routerConfig: RouteConfig.returnRotuer(),
    );
  }
}

// home: const LoginPage(),
      // initialRoute: '/login', // หน้าแรกเริ่มต้น
      // routes: {
      //   '/login': (context) => LoginPage(),
      //   '/register': (context) => registerPage(),
      //   '/home': (context) => HomePage(),
      //   '/mainKnowlege': (context) => MainKnowlege(),
      //   '/mainDashborad' : (context) => MainDash(),
      //   '/addKnowlege' : (context) => AddKnowlege(),
      // },
      // getPages: [
      //   GetPage(name: '/login', page: () => LoginPage()),
      //   GetPage(name: '/register', page: () => registerPage()),
      //   GetPage(name: '/home', page: () => HomePage()),
      //   GetPage(name: '/mainDashboard', page: () => MainDash()),
      //   GetPage(name: '/mainKnowledge', page: () => MainKnowlege()),
      //   GetPage(name: '/addKnowledge', page: () => AddKnowlege()),
      // ],