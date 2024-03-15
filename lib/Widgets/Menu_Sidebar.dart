import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';

import 'package:watalygold_admin/Widgets/Color.dart';

class SideNav extends StatefulWidget {
  const SideNav({Key? key}) : super(key: key);

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  int selected = -1;
  @override
  void initState() {
    super.initState();
  }

  SidebarController sidebarController = Get.put(SidebarController());

  Widget build(BuildContext context) {
    bool _showDropdown = false;
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
        Obx(
          () => Column(
            children: [
              SideMenutitle(
                selectedColors: WhiteColor,
                title: 'ผลการวิเคราะห์รายวัน',
                icons: Icons.dashboard_outlined,
                press: () {
                  sidebarController.index.value = 0;
                },
                seleteds: sidebarController.index.value == 0,
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    _showDropdown = !_showDropdown;
                  });
                  sidebarController.dropdown.value =
                      !sidebarController.dropdown.value;
                },
                leading: Icon(
                  Icons.menu_book_rounded,
                  color: WhiteColor,
                ),
                title: Text(
                  "คลังความรู้",
                  style: TextStyle(color: WhiteColor, fontSize: 17),
                ),
                trailing: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    _showDropdown
                        ? Icons.keyboard_arrow_left_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: WhiteColor,
                  ),
                ),
                selected: sidebarController.index.value == 4,
              ),
            ],
          ),
        ),
        Obx(() => _buildAddKnowledgeTile(sidebarController.dropdown.value)),
      ],
    );
  }

  Widget _buildAddKnowledgeTile(bool s) {
    if (s == true) {
      return Obx(() => Column(
            children: [
              ListTile(
                onTap: () {
                  sidebarController.index.value = 1;
                  context.goNamed("/mainKnowledge");
                },
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  "หน้าหลักคลังความรู้",
                  style: TextStyle(
                      color: sidebarController.index.value == 1
                          ? YPrimaryColor
                          : WhiteColor,
                      fontSize: 17),
                ),
                selected: sidebarController.index.value == 1,
                selectedTileColor: sidebarController.index.value == 1
                    ? WhiteColor.withOpacity(0.8)
                    : null,
              ),
              ListTile(
                onTap: () {
                  sidebarController.index.value = 2;
                },
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  "เพิ่มคลังความรู้",
                  style: TextStyle(
                      color: sidebarController.index.value == 2
                          ? YPrimaryColor
                          : WhiteColor,
                      fontSize: 17),
                ),
                selected: sidebarController.index.value == 2,
                selectedTileColor: sidebarController.index.value == 2
                    ? WhiteColor.withOpacity(0.8)
                    : null,
              ),
            ],
          ));
    } else {
      return SizedBox.shrink();
    }
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
