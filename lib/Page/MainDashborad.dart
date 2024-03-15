import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';

class MainDash extends StatefulWidget {
  const MainDash({super.key});

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
            child: SideNav(),
          ),
        ),
        Expanded(
          child: Scaffold(
            appBar: Appbarmain(),
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
