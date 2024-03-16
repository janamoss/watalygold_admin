import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';

class AddKnowlege extends StatefulWidget {
  const AddKnowlege({super.key});

  @override
  State<AddKnowlege> createState() => _AddKnowlegeState();
}

class _AddKnowlegeState extends State<AddKnowlege> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              child: Container(
                  color: GPrimaryColor,
                  child: SideNav(
                    status: 2,
                    dropdown: true,
                  ))),
          Expanded(
            flex: 4,
            child: Scaffold(
              appBar: Appbarmain(),
              body: Center(
                child: Text("Add"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
