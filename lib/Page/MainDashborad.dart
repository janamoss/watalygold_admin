import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';

class MainDash extends StatefulWidget {
  final User? users;
  const MainDash({super.key, this.users});

  @override
  State<MainDash> createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: Appbarmain(),
        body: SafeArea(
            child: Row(
      children: [
        Expanded(
          child: Container(
            color: GPrimaryColor,
            child: SideNav(
              status: 0,
            ),
          ),
        ),
        Expanded(
          child: Scaffold(
            appBar: Appbarmain(users: widget.users,),
            body: Center(
              child: Text("dsdsd"),
            ),
          ),
          flex: 4,
        )
      ],
    )));
  }
}
