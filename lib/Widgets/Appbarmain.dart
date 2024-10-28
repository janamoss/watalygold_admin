import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

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
  final logger = Logger();

  String? username;

  static Future<String?> checkSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("username");
    return username;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSharedPrefs().then((value) {
      setState(() {
        username = value ?? ""; // กำหนดค่าให้ username หรือ "" ถ้าเป็น null
        debugPrint(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);

    return AppBar(
      leading: screenSize == ScreenSize.minidesktop
          ? InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.menu_rounded,
                  color: GPrimaryColor,
                  size: 40,
                ),
              ),
            )
          : null,
      elevation: 4,
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      backgroundColor: Color(0xffFAFAFA),
      surfaceTintColor: Color(0xffFAFAFA),
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
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text(
                          "คุณ $username",
                          style: TextStyle(
                            color: WhiteColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();
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
                    ],
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                logger.d("Log out menu is selected.");
              } else
                logger.d("another menu is selected.");
            },
            offset: Offset(0, 75),
          ),
        )
      ],
    );
  }
}
