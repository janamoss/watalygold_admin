import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Widgets/Card/crad_detail.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/result.dart';

class ResultCard extends StatefulWidget {
  final List<Map<String, dynamic>> results;
  const ResultCard({super.key, required this.results});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  // List<Map<String, dynamic>> results = [];
  Map<String, int> qualityCountMap = {};

  @override
  void initState() {
    super.initState();
    fetchAllResults();
  }

  Future<void> fetchAllResults() async {
    try {
      // results = await fetchAllResultsAsMaps();
      await countResult();
    } catch (e) {
      log('Error: $e');
    } finally {
      setState(() {});
    }
  }

  Future<void> countResult() async {
    for (var result in widget.results) {
      // log("$result");
      final quality = result['Quality'];
      qualityCountMap[quality] = (qualityCountMap[quality] ?? 0) + 1;
    }
    log("$qualityCountMap");
  }

  final List<String> list_image = [
    "assets/images/grade 1.svg",
    "assets/images/grade 2.svg",
    "assets/images/grade 3.svg",
    "assets/images/grade 4.svg",
  ];

  final List<Color> list_color = [
    G2PrimaryColor,
    const Color(0xFF86BD41),
    const Color(0xFFB6AC55),
    const Color(0xFFB68955),
  ];

  final List<String> list_name = [
    "ขั้นพิเศษ",
    "ขั้นที่ 1",
    "ขั้นที่ 2",
    "ไม่เข้าข่าย",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: WhiteColor,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.baseline, // จัดวางบนบรรทัดเดียวกัน
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "ผลการวิเคราะห์รายวัน",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "(ณ วันปัจจุบัน)",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 900) {
                    return GridView.builder(
                      itemCount: 4,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 6 / 3,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 12.0),
                      itemBuilder: (context, index) => CardDetail(
                        color: list_color[index],
                        name: list_name[index],
                        number:
                            (qualityCountMap[list_name[index]] ?? 0).toInt(),
                        svgurl: list_image[index],
                      ),
                    );
                  } else {
                    return GridView.builder(
                      itemCount: 4,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 6 / 3.8,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 12.0),
                      itemBuilder: (context, index) => CardDetail(
                        color: list_color[index],
                        name: list_name[index],
                        number:
                            (qualityCountMap[list_name[index]] ?? 0).toInt(),
                        svgurl: list_image[index],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
