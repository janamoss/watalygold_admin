import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Card/card_chart.dart';
import 'package:watalygold_admin/Widgets/Card/card_resultDetail.dart';
import 'package:watalygold_admin/Widgets/Card/resultCard.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:flutter/scheduler.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

class MainDash extends StatefulWidget {
  final User? users;
  const MainDash({super.key, this.users});

  @override
  State<MainDash> createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> resultstoday = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllResults();
  }

  Future<void> fetchAllResults() async {
    try {
      results = await fetchAllResultsAsMaps();
      resultstoday = await fetchResultsForToday();
      // await countResult();
    } catch (e) {
      printInfo(info: 'Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchResultsForToday() async {
    try {
      final resultsCollection = FirebaseFirestore.instance.collection('Result');
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final querySnapshot = await resultsCollection
          .where('create_at', isGreaterThanOrEqualTo: startOfDay)
          .where('create_at', isLessThanOrEqualTo: endOfDay)
          .get();

      final resultList = querySnapshot.docs.map((doc) => doc.data()).toList();
      printInfo(info: "${resultList.length}");
      return resultList;
    } catch (error) {
      printInfo(info: "Error fetching results: $error");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllResultsAsMaps() async {
    try {
      final resultsCollection = FirebaseFirestore.instance.collection('Result');
      final querySnapshot = await resultsCollection.get();
      final resultList = querySnapshot.docs.map((doc) => doc.data()).toList();
      printInfo(info: "${resultList.length}");
      return resultList; // List of Maps
    } catch (error) {
      printInfo(info: "Error fetching results: $error");
      return []; // หรือจัดการ Error ตามต้องการ
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);

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
                      child: const SideNav(
                        status: 0,
                      ),
                    ),
                    backgroundColor: Color(0xffF1F1F1),
                    appBar: Appbarmain(
                        // users: widget.users,
                        ),
                    body: isLoading // ตรวจสอบสถานะการโหลด
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // ให้ Column จัดวางวิดเจ็ตย่อยชิดซ้าย
                              children: [
                                ResultCard(
                                  results: resultstoday,
                                ),
                                CardChart(
                                  results: results,
                                ),
                                CardResultDetail(
                                  results: results,
                                  lefts: 20,
                                )
                              ],
                            ),
                          )),
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
                  child: const SideNav(
                    status: 0,
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
                  body: isLoading // ตรวจสอบสถานะการโหลด
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // ให้ Column จัดวางวิดเจ็ตย่อยชิดซ้าย
                            children: [
                              ResultCard(
                                results: resultstoday,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // ให้ Row จัดวางวิดเจ็ตย่อยชิดด้านบน
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                      height: 600,
                                      child: CardChart(
                                        results: results,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height:
                                          600, // ใช้ chartHeight ที่อัปเดตแล้ว
                                      child: CardResultDetail(
                                        results: results,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
}
