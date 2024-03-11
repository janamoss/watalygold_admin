import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';

class MainDash extends StatefulWidget {
  const MainDash({super.key});

  @override
  State<MainDash> createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarmain(),
      body: Center(
        child: Text("Main"),
      ),
    );
  }
}
