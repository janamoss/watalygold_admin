import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watalygold_admin/Page/Home.dart';
import 'package:watalygold_admin/Page/registerpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'firebase_options.dart';
import 'Page/loginPage.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainWeb());
}

class MainWeb extends StatelessWidget {
  const MainWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: GoogleFonts.ibmPlexSansThai().fontFamily,
          listTileTheme: ListTileThemeData(selectedTileColor: Colors.amber)),
      title: "Wataly Gold Admin",
      home: const LoginPage(),
      initialRoute: '/login', // หน้าแรกเริ่มต้น
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => registerPage(),
        '/homeKnowlege': (context) => Home_Knowlege(),
      },
    );
  }
}
