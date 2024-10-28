import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Widgets/Chart/barchart.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class CardChart extends StatefulWidget {
  final List<Map<String, dynamic>> results;
  const CardChart({super.key, required this.results});

  @override
  State<CardChart> createState() => _CardChartState();
}

class _CardChartState extends State<CardChart> {
  String? selectedMonth;
  String? selectedYear;

  final dateLabels = <String>[];
  final yearLabels = <String>[];

  List<String> shortMonths = [
    "ม.ค.",
    "ก.พ.",
    "มี.ค.",
    "เม.ย.",
    "พ.ค.",
    "มิ.ย.",
    "ก.ค.",
    "ส.ค.",
    "ก.ย.",
    "ต.ค.",
    "พ.ย.",
    "ธ.ค."
  ];

  String getMonthNumber(int month) {
    return month.toString().padLeft(2, '0');
  }

  Map<String, Map<String, int>> groupDataByDayMonthYear() {
    Map<String, Map<String, int>> result = {};
    for (var item in widget.results) {
      final timestamp = item['create_at'] as Timestamp;
      final dateTime = timestamp.toDate();
      final year = dateTime.year;
      final month =
          dateTime.month.toString().padLeft(2, '0'); // เพิ่ม 0 นำหน้าถ้าจำเป็น
      final day = dateTime.day.toString().padLeft(2, '0');
      final dateKey = '$year-$month-$day'; // YYYY-MM-DD
      final quality = item['Quality'];

      // สร้าง map สำหรับแต่ละวัน ถ้ายังไม่มี
      result[dateKey] ??= {
        'ขั้นพิเศษ': 0,
        'ขั้นที่ 1': 0,
        'ขั้นที่ 2': 0,
        'ไม่เข้าข่าย': 0
      };

      // เพิ่มจำนวนใน quality ที่ตรงกัน
      result[dateKey]![quality] = (result[dateKey]![quality] ?? 0) + 1;
    }
    return result;
  }

  void _populateYearLabels() {
    final groupedData = groupDataByDayMonthYear();
    final sortedEntries = groupedData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (var entry in sortedEntries) {
      final dateKey = entry.key;
      final dateParts = dateKey.split('-');
      final year = int.parse(dateParts[0]);
      final thaiYear = year + 543;

      if (!yearLabels.contains(thaiYear.toString())) {
        yearLabels.add(thaiYear.toString());
      }
    }
  }

  List<BarChartGroupData?> getBarData(String? month, String? year) {
    final groupedData = groupDataByDayMonthYear();
    final sortedEntries = groupedData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries.map((entry) {
      final dateKey = entry.key;
      final qualityCounts = entry.value;
      final dateParts = dateKey.split('-');
      final entryYear = int.parse(dateParts[0]);
      final entryMonth = int.parse(dateParts[1]);

      final day = int.parse(dateParts[2]);
      final thaiYear = entryYear + 543;

      // ตรวจสอบเงื่อนไขการกรอง
      if ((month == null || months[entryMonth - 1] == month) &&
          (year == null || thaiYear.toString() == year)) {
        final dateString = '$day/${getMonthNumber(entryMonth)}/$thaiYear';
        printInfo(info: dateString);
        dateLabels.add(dateString);
        return BarChartGroupData(
          x: dateLabels.indexOf(dateString),
          barRods: [
            BarChartRodData(
                width: 10,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                toY: qualityCounts['ขั้นพิเศษ']?.toDouble() ?? 0,
                color: G2PrimaryColor),
            BarChartRodData(
                width: 10,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                toY: qualityCounts['ขั้นที่ 1']?.toDouble() ?? 0,
                color: Color(0xFF86BD41)),
            BarChartRodData(
                width: 10,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                toY: qualityCounts['ขั้นที่ 2']?.toDouble() ?? 0,
                color: Color(0xFFB6AC55)),
            BarChartRodData(
                width: 10,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                toY: qualityCounts['ไม่เข้าข่าย']?.toDouble() ?? 0,
                color: Color(0xFFB68955)),
          ],
        );
      } else {
        return null; // ไม่แสดงข้อมูลที่ไม่ตรงเงื่อนไข
      }
    }).toList()
      ..removeWhere((element) => element == null);
  }

  @override
  void initState() {
    super.initState();
    _populateYearLabels();
    // ดึงข้อมูลเดือนและปีปัจจุบัน
    final now = DateTime.now();
    final currentMonth = months[now.month - 1]; // แปลงเป็นชื่อเดือน
    final currentYear = (now.year + 543).toString(); // ปีปัจจุบันเป็น พ.ศ.

    // ตั้งค่า selectedMonth และ selectedYear
    selectedMonth = currentMonth;
    selectedYear = currentYear;

    // โหลดข้อมูลเริ่มต้นของกราฟ
    barData = getBarData(selectedMonth, selectedYear)
        .cast<BarChartGroupData?>()
        .whereType<BarChartGroupData>()
        .toList();
  }

  List<String> months = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม"
  ];

  List<BarChartGroupData?> barData = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                    "กราฟการวิเคราะห์",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "เดือน",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DropdownMenu(
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    label: Text("เลือกเดือน"),
                    initialSelection: selectedMonth,
                    dropdownMenuEntries: months
                        .map((month) =>
                            DropdownMenuEntry(value: month, label: month))
                        .toList(),
                    menuStyle: MenuStyle(
                      elevation: MaterialStatePropertyAll(2),
                    ),
                    onSelected: (value) {
                      setState(() {
                        selectedMonth = value;
                        if (selectedMonth != null && selectedYear != null) {
                          barData = getBarData(selectedMonth, selectedYear)
                              .cast<BarChartGroupData?>();
                          log("ทำงาน barData");
                        } else {
                          barData = [];
                          log("ไม่ทำงาน barData");
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "ปี",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DropdownMenu(
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      outlineBorder: BorderSide(color: GPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    label: Text("เลือกปี"),
                    initialSelection: selectedYear,
                    dropdownMenuEntries: yearLabels
                        .map((year) =>
                            DropdownMenuEntry(value: year, label: year))
                        .toList(),
                    onSelected: (value) {
                      setState(() {
                        selectedYear = value;
                        if (selectedMonth != null && selectedYear != null) {
                          barData = getBarData(selectedMonth, selectedYear)
                              .cast<BarChartGroupData?>();
                          barData.whereType<BarChartGroupData>().toList();
                          log("ทำงาน barData");
                        } else {
                          barData = [];
                          log("ไม่ทำงาน barData");
                        }
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    buildBarChart(
                        context,
                        barData.whereType<BarChartGroupData>().toList(),
                        dateLabels),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
