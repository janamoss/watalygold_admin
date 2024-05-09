import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class Appbarmain extends StatefulWidget implements PreferredSizeWidget {
  final User? users;
  const Appbarmain({super.key, this.users});

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
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(
            widget.users?.displayName ?? "",
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: PopupMenuButton(
            color: GPrimaryColor,
            child: GestureDetector(
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/watalygold_profile.png",
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      context.goNamed('/login');
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
