import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class CardResultDetail extends StatefulWidget {
  final double? lefts;
  const CardResultDetail({super.key, this.lefts});

  @override
  State<CardResultDetail> createState() => _CardResultDetailState();
}

class _CardResultDetailState extends State<CardResultDetail> {
  late double? setleft;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setleft = widget.lefts ?? 0;
  }

  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(right: 20, left: setleft!, bottom: 20),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: WhiteColor,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                  headingTextStyle:
                      TextStyle(color: Colors.black, fontSize: 20),
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
                  rows: [
                    DataRow(cells: [
                      DataCell(
                        Text("1"),
                      ),
                      DataCell(
                        Text("ขั้นพิเศษ"),
                      ),
                      DataCell(
                        Text("24 พ.ค 2566"),
                      ),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("2")),
                      DataCell(Text("ขั้นพิเศษ")),
                      DataCell(Text("24 พ.ค 2566")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("3")),
                      DataCell(Text("ไม่เข้าข่าย")),
                      DataCell(Text("24 พ.ค ")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("4")),
                      DataCell(Text("ขั้นพิเศษ")),
                      DataCell(Text("24 พ.ค ")),
                    ]),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
