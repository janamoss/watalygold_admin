import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';

import 'package:watalygold_admin/Widgets/Color.dart';

class SideNav extends StatefulWidget {
  final bool? dropdown;
  final int? status;
  const SideNav({Key? key, this.status, this.dropdown}) : super(key: key);

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  final logger = Logger();

  final SidebarController sidebarController = Get.find<SidebarController>();

  final showDropdown = false.obs; // ใช้ .obs สำหรับตัวแปรที่รีแอคทีฟ

  @override
  void initState() {
    super.initState();
    sidebarController.index.value = widget.status ?? 0;
    showDropdown.value = widget.dropdown ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Image.asset(
                "assets/images/watalygold-logo-3.png",
                fit: BoxFit.cover,
              )),
        ),
        Column(
          children: [
            SideMenutitle(
              selectedColors: WhiteColor,
              title: 'ผลการวิเคราะห์รายวัน',
              icons: Icons.dashboard_outlined,
              press: () {
                sidebarController.index.value = 0;
                context.goNamed("/dashboard");
              },
              seleteds: sidebarController.index.value == 0,
            ),
            ListTile(
              onTap: () {
                sidebarController.dropdown.value =
                    !sidebarController.dropdown.value; // ใช้ค่า RxBool แทน
              },
              leading: Icon(
                Icons.menu_book_rounded,
                color: WhiteColor,
              ),
              title: Text(
                "คลังความรู้",
                style: TextStyle(color: WhiteColor, fontSize: 17),
              ),
              trailing: Obx(() => RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      sidebarController.dropdown.value // ใช้ค่าใน Obx แทน
                          ? Icons.keyboard_arrow_left_rounded
                          : Icons.keyboard_arrow_right_rounded,
                      color: WhiteColor,
                    ),
                  )),
              selected: sidebarController.index.value == 4,
            ),
          ],
        ),
        // ใช้ Obx ครอบคลุมการแสดงผลของ Dropdown เพื่อสังเกตการเปลี่ยนแปลง
        Obx(
          () => sidebarController.dropdown.value
              ? Column(
                  children: [
                    _buildMainKnowledgeListTile(context, sidebarController),
                    _buildAddKnowledgeListTile(context, sidebarController),
                  ],
                )
              : SizedBox.shrink(),
        ),
        SideMenutitle(
          selectedColors: WhiteColor,
          title: 'จำนวนการประมวลผล',
          icons: Icons.insert_chart_outlined_outlined,
          press: () {
            sidebarController.index.value = 3;
            context.goNamed("/ProcessGeminiCount");
          },
          seleteds: sidebarController.index.value == 3,
        ),
      ],
    );
  }

  Widget _buildMainKnowledgeListTile(
      BuildContext context, SidebarController sidebarController) {
    return ListTile(
      onTap: () {
        sidebarController.index.value = 1;
        context.goNamed("/mainKnowledge");
      },
      contentPadding: EdgeInsets.only(left: 50),
      title: Text(
        "หน้าหลักคลังความรู้",
        style: TextStyle(
          color:
              sidebarController.index.value == 1 ? YPrimaryColor : WhiteColor,
          fontSize: 17,
        ),
      ),
      selected: sidebarController.index.value == 1,
      selectedTileColor: sidebarController.index.value == 1
          ? WhiteColor.withOpacity(0.8)
          : null,
    );
  }

  Widget _buildAddKnowledgeListTile(
      BuildContext context, SidebarController sidebarController) {
    return ListTile(
      onTap: () {
        sidebarController.index.value = 2;
        context.goNamed("/addKnowledge");
      },
      contentPadding: EdgeInsets.only(left: 50),
      title: Text(
        "เพิ่มคลังความรู้",
        style: TextStyle(
          color:
              sidebarController.index.value == 2 ? YPrimaryColor : WhiteColor,
          fontSize: 17,
        ),
      ),
      selected: sidebarController.index.value == 2,
      selectedTileColor: sidebarController.index.value == 2
          ? WhiteColor.withOpacity(0.8)
          : null,
    );
  }
}

class SideMenutitle extends StatelessWidget {
  const SideMenutitle({
    super.key,
    required this.title,
    required this.icons,
    required this.press,
    required this.seleteds,
    required this.selectedColors,
  });

  final String title;
  final IconData icons;
  final VoidCallback press;
  final bool seleteds;
  final Color selectedColors;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: Icon(
        icons,
        color: seleteds ? YPrimaryColor : WhiteColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: seleteds ? YPrimaryColor : WhiteColor, fontSize: 17),
      ),
      selected: seleteds,
      selectedTileColor: selectedColors.withOpacity(0.8),
    );
  }
}
