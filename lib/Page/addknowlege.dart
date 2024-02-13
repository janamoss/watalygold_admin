import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/database.dart';

class AddKnowlege extends StatefulWidget {
  const AddKnowlege({super.key});

  @override
  State<AddKnowlege> createState() => _AddKnowlegeState();
}

class _AddKnowlegeState extends State<AddKnowlege> {
  TextEditingController namecontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Container(
            margin: EdgeInsets.only(top: 20.0,left: 50.0),
            child: Column(children: [
              Container(
                width: 1065,
                height: 140,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        width: 1065,
                        height: 120,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
// SizedBox(height: 20),
                    // Text(
                    //   "ชื่อ",
                    //   style: TextStyle(color: Colors.black, fontSize: 20),
                    // ),
                    // SizedBox(height: 5),
                    // Container(
                    //   padding: EdgeInsets.only(left: 10.0),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(), borderRadius: BorderRadius.circular(5)),
                    //   child: TextField(
                    //     controller: namecontroller,
                    //     decoration: InputDecoration(border: InputBorder.none),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {},
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Color(0xC5C5C5),
                    //       ),
                    //       child: Text(
                    //         "ยกเลิก",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         String Id = randomAlphaNumeric(10);
                    //         Map<String, dynamic> knowledgeMap = {
                    //           "KnowledgeName": namecontroller.text
                    //         };
                    //         await Databasemethods()
                    //             .addKnowlege(knowledgeMap, Id)
                    //             .then((value) {
                    //           Fluttertoast.showToast(
                    //               msg: "add knowlege successfully",
                    //               toastLength: Toast.LENGTH_SHORT,
                    //               gravity: ToastGravity.CENTER,
                    //               timeInSecForIosWeb: 1,
                    //               backgroundColor: Colors.red,
                    //               textColor: Colors.white,
                    //               fontSize: 16.0);
                    //         });
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: GPrimaryColor,
                    //       ),
                    //       child: Text(
                    //         "เพิ่ม",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   ],
                    // )