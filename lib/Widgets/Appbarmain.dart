import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class Appbarmain extends StatefulWidget implements PreferredSizeWidget {
  const Appbarmain({super.key});

  @override
  State<Appbarmain> createState() => _AppbarmainState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(100);
}

class _AppbarmainState extends State<Appbarmain> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
