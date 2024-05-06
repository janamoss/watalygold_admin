import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

// สร้างข้อมูลสำหรับกราฟแท่ง
final barData = [
  BarChartGroupData(
    x: 0,
    barRods: [
      BarChartRodData(toY: 8, color: G2PrimaryColor),
      BarChartRodData(toY: 6, color: Color(0xFF86BD41)),
      BarChartRodData(toY: 7, color: Color(0xFFB6AC55)),
      BarChartRodData(toY: 16, color: Color(0xFFB68955)),
    ],
  ),
  BarChartGroupData(
    x: 1,
    barRods: [
      BarChartRodData(toY: 8, color: G2PrimaryColor),
      BarChartRodData(toY: 6, color: Color(0xFF86BD41)),
      BarChartRodData(toY: 7, color: Color(0xFFB6AC55)),
      BarChartRodData(toY: 16, color: Color(0xFFB68955)),
    ],
  ),
  BarChartGroupData(
    x: 2,
    barRods: [
      BarChartRodData(toY: 8, color: G2PrimaryColor),
      BarChartRodData(toY: 6, color: Color(0xFF86BD41)),
      BarChartRodData(toY: 7, color: Color(0xFFB6AC55)),
      BarChartRodData(toY: 16, color: Color(0xFFB68955)),
    ],
  ),
  BarChartGroupData(
    x: 3,
    barRods: [
      BarChartRodData(toY: 16, color: Colors.orangeAccent),
    ],
  ),
  BarChartGroupData(
    x: 4,
    barRods: [
      BarChartRodData(toY: 16, color: Colors.orangeAccent),
    ],
  ),
  BarChartGroupData(
    x: 5,
    barRods: [
      BarChartRodData(toY: 16, color: Colors.orangeAccent),
    ],
  ),
  BarChartGroupData(
    x: 6,
    barRods: [
      BarChartRodData(toY: 16, color: Colors.orangeAccent),
    ],
  ),
];

// สร้าง BarChart widget
Widget buildBarChart(BuildContext context) {
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
      barGroups: barData,
      gridData: FlGridData(
          show: true, drawHorizontalLine: true, drawVerticalLine: false),
      alignment: BarChartAlignment.spaceAround,
      maxY: 20, // กำหนดค่าสูงสุดของแกน Y เพื่อป้องกันข้อผิดพลาด Infinity
      titlesData: FlTitlesData(
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
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text('เดือน $value'),
              );
            },
          ),
        ),
      ),
    )),
  );
}
