import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';

class AddKnowlege extends StatefulWidget {
  const AddKnowlege({super.key});

  @override
  State<AddKnowlege> createState() => _AddKnowlegeState();
}

class _AddKnowlegeState extends State<AddKnowlege> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarmain(),
      body: Center(
        child: Text("Add"),
      ),
    );
  }
}
