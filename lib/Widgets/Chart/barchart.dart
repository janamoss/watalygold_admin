import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

// เดือนทั้งหมด
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

// สร้าง BarChart widget
Widget buildBarChart(BuildContext context, List<BarChartGroupData> bargroups,
    List<String> dateLabels) {
  return SizedBox(
    height: 400,
    width: MediaQuery.of(context).size.width,
    child: BarChart(BarChartData(
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(
              color: G2PrimaryColor, width: 4), // เพิ่ม border ด้านซ้าย
          bottom: BorderSide(
              color: G2PrimaryColor, width: 4), // เพิ่ม border ด้านล่าง
        ),
      ),
      barGroups: bargroups,
      gridData: FlGridData(
          show: true, drawHorizontalLine: true, drawVerticalLine: false),
      alignment: BarChartAlignment.spaceAround,
      maxY: 30, // กำหนดค่าสูงสุดของแกน Y เพื่อป้องกันข้อผิดพลาด Infinity
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              final iValue = value.toInt();
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text('$iValue'),
              );
            },
            reservedSize: 32,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              // value จะเป็น index ของ bar group
              final barGroupIndex = value.toInt();
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  dateLabels[barGroupIndex],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              );
            },
          ),
        ),
      ),
    )),
  );
}
