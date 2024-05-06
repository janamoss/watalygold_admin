import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class CardResultDetail extends StatefulWidget {
  final double? lefts;
  final double? height;
  final List<Map<String, dynamic>> results;
  const CardResultDetail(
      {super.key, this.lefts, required this.results, this.height});

  @override
  State<CardResultDetail> createState() => _CardResultDetailState();
}

class _CardResultDetailState extends State<CardResultDetail> {
  late double? setleft;

  List<String> months = [
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
    "ธ.ค.",
  ];

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final day = dateTime.day;
    final month = dateTime.month;
    final year = dateTime.year + 543; // แปลงเป็น พ.ศ.
    return '$day ${months[month - 1]} $year';
  }

  int compareByTimestamp(Map<String, dynamic> a, Map<String, dynamic> b) {
    final timestampA = a['create_at'] as Timestamp;
    final timestampB = b['create_at'] as Timestamp;
    return timestampB.compareTo(timestampA); // เรียงจากใหม่ไปเก่า
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setleft = widget.lefts ?? 0;
  }

  Widget build(BuildContext context) {
    final sortedResults = widget.results.toList() // copy list
      ..sort(compareByTimestamp);
    return Padding(
      padding: EdgeInsets.only(right: 20, left: setleft!, bottom: 20),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: WhiteColor,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Center(
                  child: Text(
                    "รายการการวิเคราะห์ทั้งหมด",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                DataTable(
                  // headingRowColor: MaterialStateProperty.all(GPrimaryColor),
                  headingTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  // dataRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                  dataTextStyle: TextStyle(color: Colors.black, fontSize: 15),
                  columnSpacing: setleft == 0
                      ? 15
                      : MediaQuery.of(context).size.width * 0.2,
                  columns: const [
                    DataColumn(
                      label: Text("รายการ"),
                    ),
                    DataColumn(
                      label: Text("ระดับ"),
                    ),
                    DataColumn(
                      label: Text("วันที่"),
                    ),
                  ],
                  rows: sortedResults.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final item = entry.value;
                    final quality = item['Quality'];
                    final timestamp = item['create_at'] as Timestamp;
                    final dateString = formatTimestamp(timestamp);
                    return DataRow(cells: [
                      DataCell(Text('$index')),
                      DataCell(Text(
                        quality,
                        style: TextStyle(
                            color: quality == "ขั้นพิเศษ"
                                ? G2PrimaryColor
                                : quality == "ขั้นที่ 1"
                                    ? Color(0xFF86BD41)
                                    : quality == "ขั้นที่ 1"
                                        ? Color(0xFFB6AC55)
                                        : quality == "ขั้นที่ 1"
                                            ? Color(0xFFB68955)
                                            : Color(0xFFB68955)),
                      )),
                      DataCell(Text(dateString)),
                    ]);
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
