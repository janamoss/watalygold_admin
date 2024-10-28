import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold_admin/Widgets/Card/Con_resultdetail.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class CardResultDetail extends StatefulWidget {
  final double? lefts;
  final double? parentWidth;
  final List<Map<String, dynamic>> results;
  const CardResultDetail(
      {super.key, this.lefts, required this.results, this.parentWidth});

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
    // debugPrint("$sortedResults");

    // เก็บวันที่ไม่ซ้ำกันไว้
    final dateDataMap = <String, Map<String, dynamic>>{};
    final uniqueDates = Set<String>();
    int totalCount = 0;

    for (var result in sortedResults) {
      final timestamp = result['create_at'] as Timestamp;
      final dateString = formatTimestamp(timestamp);
      final quality = result['Quality'] as String;

      uniqueDates.add(dateString);

      if (!dateDataMap.containsKey(dateString)) {
        dateDataMap[dateString] = {
          'count': 0,
          'qualities': {
            'ขั้นพิเศษ': 0,
            'ขั้นที่ 1': 0,
            'ขั้นที่ 2': 0,
            'ไม่เข้าข่าย': 0,
          },
        };
      }

      dateDataMap[dateString]!['count'] =
          (dateDataMap[dateString]!['count'] as int) + 1;
      dateDataMap[dateString]!['qualities'][quality] =
          (dateDataMap[dateString]!['qualities'][quality] as int) + 1;
      totalCount++;
    }

    // แปลง Set กลับเป็น List และเรียงลำดับจากวันที่ล่าสุดไปหาวันที่เก่าที่สุด
    final uniqueDatesList = uniqueDates.toList()
      ..sort((a, b) {
        final dateA = parseThaiDate(a);
        final dateB = parseThaiDate(b);
        return dateB.compareTo(dateA);
      });

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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "ทั้งหมด ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$totalCount รายการ",
                      style: TextStyle(
                        color: GPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Spacer(),
                    // Container(
                    //   margin: EdgeInsets.all(5),
                    //   width: widget.parentWidth,
                    //   height: 40,
                    //   child: TextField(
                    //     // controller: _controller,
                    //     decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.all(10),
                    //       fillColor: Color(0xffF1F1F1),
                    //       filled: true,
                    //       hintText: "ค้นหาการวิเคราะห์",
                    //       prefixIcon: Icon(
                    //         Icons.search_rounded,
                    //         color: GPrimaryColor,
                    //         size: 30,
                    //       ),
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(20),
                    //           borderSide: BorderSide.none),
                    //     ),
                    //     // onChanged: searchHistory,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: uniqueDatesList.length,
                    itemBuilder: (context, index) {
                      final date = uniqueDatesList[index];
                      final dateData = dateDataMap[date]!;
                      return Container_resultdetail(
                        date: date,
                        count: dateData['count'] as int,
                        qualities: dateData['qualities'] as Map<String, int>,
                      );
                    },
                  ),
                ),
                // DataTable(
                //   // headingRowColor: MaterialStateProperty.all(GPrimaryColor),
                //   headingTextStyle: TextStyle(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                //   // dataRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                //   dataTextStyle: TextStyle(color: Colors.black, fontSize: 15),
                //   columnSpacing: setleft == 0
                //       ? 15
                //       : MediaQuery.of(context).size.width * 0.2,
                //   columns: const [
                //     DataColumn(
                //       label: Text("รายการ"),
                //     ),
                //     DataColumn(
                //       label: Text("ระดับ"),
                //     ),
                //     DataColumn(
                //       label: Text("วันที่"),
                //     ),
                //   ],
                //   rows: sortedResults.asMap().entries.map((entry) {
                //     final index = entry.key + 1;
                //     final item = entry.value;
                //     final quality = item['Quality'];
                //     final timestamp = item['create_at'] as Timestamp;
                //     final dateString = formatTimestamp(timestamp);
                //     return DataRow(cells: [
                //       DataCell(Text('$index')),
                //       DataCell(Text(
                //         quality,
                //         style: TextStyle(
                //             color: quality == "ขั้นพิเศษ"
                //                 ? G2PrimaryColor
                //                 : quality == "ขั้นที่ 1"
                //                     ? Color(0xFF86BD41)
                //                     : quality == "ขั้นที่ 2"
                //                         ? Color(0xFFB6AC55)
                //                         : quality == "ไม่เข้าข่าย"
                //                             ? Color(0xFFB68955)
                //                             : Color(0xFFB68955)),
                //       )),
                //       DataCell(Text(dateString)),
                //     ]);
                //   }).toList(),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime parseThaiDate(String thaiDate) {
    final parts = thaiDate.split(' ');
    final day = int.parse(parts[0]);
    final monthIndex = months.indexOf(parts[1]);
    final year = int.parse(parts[2]) - 543; // แปลงปี พ.ศ. เป็น ค.ศ.
    return DateTime(year, monthIndex + 1, day);
  }
}
