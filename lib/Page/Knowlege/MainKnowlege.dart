import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Header.dart';

class MainKnowlege extends StatefulWidget {
  const MainKnowlege({super.key});

  @override
  State<MainKnowlege> createState() => _MainKnowlegeState();
}

class _MainKnowlegeState extends State<MainKnowlege> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F1F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Color(0xffFAFAFA),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: PopupMenuButton(
              color: G2PrimaryColor,
              child: GestureDetector(
                child: Image.asset(
                  "assets/images/watalygold_profile.png",
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, "/login");
                      },
                      leading: Icon(
                        Icons.logout_rounded,
                        color: WhiteColor,
                      ),
                      title: Text(
                        "ออกจากระบบ",
                        style: TextStyle(color: WhiteColor, fontSize: 17),
                      ),
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  print("Log out menu is selected.");
                } else
                  print("another menu is selected.");
              },
              offset: Offset(0, 75),
            ),
          )
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
