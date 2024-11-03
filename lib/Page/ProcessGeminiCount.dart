import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Model/User.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/service/screen_unit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ProcessGeminiCount extends StatefulWidget {
  final User? users;
  final bool showSuccessFlushbar;
  final String message;
  final String description;

  const ProcessGeminiCount({
    super.key,
    this.users,
    this.showSuccessFlushbar = false,
    this.message = '',
    this.description = '',
  });

  @override
  State<ProcessGeminiCount> createState() => _MyTokenState();
}

class _MyTokenState extends State<ProcessGeminiCount> {
  int processCount = 0;
  @override
  void initState() {
    super.initState();
    fetchProcessCount();
  }

  Future<void> fetchProcessCount() async {
    try {
      DateTime now = DateTime.now();
      String formattedDate =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("GeminiProcesscount")
          .doc(formattedDate)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          processCount = data['process_count'] ?? 0;
        });
      }
    } catch (e) {
      print("Error fetching process count: $e");
    }
  }

  final List<String> thaiMonths = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];

  String getThaiDate(DateTime date) {
    int thaiYear = date.year + 543;
    String thaiMonth = thaiMonths[date.month - 1];
    return '${date.day} $thaiMonth $thaiYear';
  }

  final sidebarController = Get.put(SidebarController());
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);
    int remainingCount = 1500 - processCount;

    DateTime now = DateTime.now();
    String thaiDate = getThaiDate(now);

    if (screenSize == ScreenSize.minidesktop) {
      return Scaffold(
        // appBar: Appbarmain(),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Scaffold(
                    drawer: Container(
                      width: 300,
                      color: GPrimaryColor,
                      child: SideNav(
                        status: sidebarController.index.value == 3
                            ? sidebarController.index.value = 3
                            : sidebarController.index.value = 3,
                      ),
                    ),
                    backgroundColor: Color(0xffF1F1F1),
                    appBar: Appbarmain(
                        // users: widget.users,
                        ),
                    body: Container()),
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        // appBar: Appbarmain(),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: GPrimaryColor,
                  child: SideNav(
                    status: sidebarController.index.value == 3
                        ? sidebarController.index.value = 3
                        : sidebarController.index.value = 3,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Scaffold(
                  backgroundColor: Color(0xffF1F1F1),
                  appBar: Appbarmain(
                      // users: widget.users,
                      ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // จัดตำแหน่ง Text ทั้งหมดใน Column ชิดซ้าย
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // จัดตำแหน่ง Text ใน Column ชิดซ้าย
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        "จำนวนครั้งที่ส่งรูปภาพไปประมวลผลที่ Gemini",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "(${thaiDate})",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 50),
                              child: Row(
                                children: [
                                  Text(
                                    "ผุู้ใช้งานสามารถส่งรูปภาพไปประมวลผลได้",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "1500",
                                    style: TextStyle(
                                      color: GPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "ภาพต่อวัน",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 250,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: PieChart(
                                          PieChartData(
                                            pieTouchData: PieTouchData(
                                              touchCallback:
                                                  (FlTouchEvent event,
                                                      pieTouchResponse) {
                                                setState(() {
                                                  if (!event
                                                          .isInterestedForInteractions ||
                                                      pieTouchResponse ==
                                                          null ||
                                                      pieTouchResponse
                                                              .touchedSection ==
                                                          null) {
                                                    touchedIndex = -1;
                                                    return;
                                                  }
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSection!
                                                          .touchedSectionIndex;
                                                });
                                              },
                                            ),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 40,
                                            sections: showingSections(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 50),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 15,
                                                height: 15,
                                                color: Color(0xff00D27C),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "จำนวนที่ส่งไป: $processCount",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  10), // ระยะห่างระหว่าง legend สีเขียวกับสีแดง
                                          Row(
                                            children: [
                                              Container(
                                                width: 15,
                                                height: 15,
                                                color: Color(0xffFEA42C),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "จำนวนที่เหลือ: $remainingCount",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Padding(
                               padding: const EdgeInsets.all(50),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "หากต้องการเปลี่ยนแพ็กเกจการใช้งานสามารถดูข้อมูลเพิ่มเติมได้ที่ : ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: "Google AI Pricing",
                                      style: TextStyle(
                                        fontSize: 14,
                                        
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launchUrl(Uri.parse(
                                              "https://ai.google.dev/pricing?hl=th#1_5flash"));
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  List<PieChartSectionData> showingSections() {
    int remainingCount = 1500 - processCount;
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xff00D27C),
            value: processCount.toDouble(),
            title: '$processCount',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xffFEA42C),
            value: remainingCount.toDouble(),
            title: '$remainingCount',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          );

        default:
          throw Error();
      }
    });
  }
}
