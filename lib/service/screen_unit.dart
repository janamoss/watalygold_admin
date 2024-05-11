import 'package:flutter/material.dart';

// กำหนดขนาด breakpoint สำหรับ 2 ระดับ
const double breakpointWebsite = 975.0;
const double breakpointMoblie = 760.0;

// ฟังก์ชันตรวจสอบขนาดหน้าจอ
enum ScreenSize { minidesktop, desktop }

ScreenSize getScreenSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth <= breakpointWebsite) {
    return ScreenSize.minidesktop;
  } else {
    return ScreenSize.desktop;
  }
}
