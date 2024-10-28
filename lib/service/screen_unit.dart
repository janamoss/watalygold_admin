import 'package:flutter/material.dart';

// กำหนดขนาด breakpoint สำหรับ 2 ระดับ
const double breakpointWebsite = 975.0;
const double breakpointMoblie = 700.0;

// ฟังก์ชันตรวจสอบขนาดหน้าจอ
enum ScreenSize { minidesktop, moblie , desktop }

ScreenSize getScreenSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth <= breakpointWebsite) {
    return ScreenSize.minidesktop;
  } if(screenWidth <= breakpointMoblie) {
    return ScreenSize.moblie;
  } else {
    return ScreenSize.desktop;
  }
}
