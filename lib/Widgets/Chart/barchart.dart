import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

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
      maxY: 40, // กำหนดค่าสูงสุดของแกน Y เพื่อป้องกันข้อผิดพลาด Infinity
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
            reservedSize: 55, // เพิ่มขนาดพื้นที่สำรองให้มากขึ้น
            getTitlesWidget: (value, meta) {
              final barGroupIndex = value.toInt();
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 16, // เพิ่มระยะห่างระหว่างแกน X กับข้อความ
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 4,
                      right: 4), // เพิ่ม padding เพื่อขยับข้อความลงและไปทางขวา
                  child: Transform.rotate(
                    angle: -45 * 3.14159 / 180, // ลดองศาการหมุนลงเหลือ 30 องศา
                    child: Text(
                      dateLabels[barGroupIndex],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    )),
  );
}
