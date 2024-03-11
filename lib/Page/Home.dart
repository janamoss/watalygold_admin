import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';

class Home_Knowlege extends StatefulWidget {
  const Home_Knowlege({super.key});

  @override
  State<Home_Knowlege> createState() => _Home_KnowlegeState();
}

class _Home_KnowlegeState extends State<Home_Knowlege> {
  int selectedIndex = 0;
  bool _showDropdown = false;

  late List<Widget> _widgetOption;

  @override
  void initState() {
    super.initState();
    _widgetOption = [];
  }

  SidebarController sidebarController = Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: G2PrimaryColor,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  Center(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: Image.asset(
                          "assets/images/watalygold-logo-2.png",
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
                  Obx(() =>
                      _buildAddKnowledgeTile(sidebarController.dropdown.value)),
                ],
              ),
            )),
            Expanded(
                flex: 4,
                child: Obx(() =>
                    sidebarController.pages[sidebarController.index.value]))
          ],
        ),
      ),
    );
  }

  Widget _buildAddKnowledgeTile(bool s) {
    if (s == true) {
      return Obx(() => Column(
            children: [
              ListTile(
                onTap: () {
                  sidebarController.index.value = 1;
                },
                contentPadding: EdgeInsets.only(left: 50),
                title: Text(
                  "หน้าหลักคลังความรู้",
                  style: TextStyle(
                      color: sidebarController.index.value == 1
                          ? G2PrimaryColor
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
                          ? G2PrimaryColor
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

// IconButton(
//                       onPressed: () {
                        
//                       },
//                       icon: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [Icon(Icons.logout_rounded), Text("Log out")],
//                       ))
