import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Chart/barchart.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class CardChart extends StatefulWidget {
  final List<Map<String, dynamic>> results;
  const CardChart({super.key, required this.results});

  @override
  State<CardChart> createState() => _CardChartState();
}

class _CardChartState extends State<CardChart> {
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
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "(ณ วันปัจจุบัน)",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                    dropdownMenuEntries: months
                        .map((month) =>
                            DropdownMenuEntry(value: month, label: month))
                        .toList(),
                    menuStyle: MenuStyle(
                      elevation: MaterialStatePropertyAll(2),
                    ),
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
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: null,
                        label: "1973",
                        style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(2),
                          maximumSize: MaterialStatePropertyAll(
                            Size.fromHeight(kTextTabBarHeight),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: buildBarChart(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
