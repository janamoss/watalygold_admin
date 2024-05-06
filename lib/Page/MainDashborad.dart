import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Card/card_chart.dart';
import 'package:watalygold_admin/Widgets/Card/card_resultDetail.dart';
import 'package:watalygold_admin/Widgets/Card/resultCard.dart';
import 'package:watalygold_admin/Widgets/Chart/barchart.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/Widgets/drawer.dart';
import 'package:watalygold_admin/service/result.dart';

class MainDash extends StatefulWidget {
  final User? users;
  const MainDash({super.key, this.users});

  @override
  State<MainDash> createState() => _MainDashState();
}

class _MainDashState extends State<MainDash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> results = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllResults();
  }

  Future<void> fetchAllResults() async {
    try {
      results = await fetchAllResultsAsMaps();
      // await countResult();
    } catch (e) {
      printInfo(info: 'Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 950) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // ให้ Column จัดวางวิดเจ็ตย่อยชิดซ้าย
                              children: [
                                ResultCard(
                                  results: results,
                                ),
                                CardChart(
                                  results: results,
                                ),
                                CardResultDetail(
                                  lefts: 20,
                                )
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // ให้ Column จัดวางวิดเจ็ตย่อยชิดซ้าย
                              children: [
                                ResultCard(
                                  results: results,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // ให้ Row จัดวางวิดเจ็ตย่อยชิดด้านบน
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: CardChart(
                                        results: results,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      // child: Container(
                                      //   width: MediaQuery.of(context).size.width,
                                      //   height: MediaQuery.of(context).size.height,
                                      //   color: Colors.blue,
                                      // ),
                                      child: CardResultDetail(),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    )),
        )
      ],
    )));
  }
}
