import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Singlecontent.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

Map<String, IconData> icons = {
  'ใบไม้': FontAwesomeIcons.leaf,
  'ต้นกล้า': FontAwesomeIcons.seedling,
  'ไวรัส': FontAwesomeIcons.virus,
  'สถิติ': Icons.analytics_outlined,
  'ดอกไม้': Icons.yard,
  'หนังสือ': FontAwesomeIcons.book,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded,
  'คำถาม': Icons.quiz_outlined,
  'รูปภาพ': FontAwesomeIcons.image,
  'ระฆัง': FontAwesomeIcons.bell,
  'ความคิดเห็น': FontAwesomeIcons.comments,
  'ตำแหน่ง': FontAwesomeIcons.locationDot,
  'กล้อง': FontAwesomeIcons.camera,
  'ปฏิทิน': FontAwesomeIcons.calendarDays,
};

class Add_Knowlege extends StatefulWidget {
  final Knowledge? knowledge;
  final IconData? icons;
  final Contents? contents;

  const Add_Knowlege({super.key, this.knowledge, this.contents, this.icons});

  @override
  _Add_KnowlegeState createState() => _Add_KnowlegeState();
}

class _Add_KnowlegeState extends State<Add_Knowlege>
    with SingleTickerProviderStateMixin {
  final sidebarController = Get.put(SidebarController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      ScreenSize screenSize = getScreenSize(context);

      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              screenSize == ScreenSize.minidesktop
                  ? SizedBox.shrink()
                  : Expanded(
                      child: Container(
                        color: GPrimaryColor,
                        child: SideNav(
                          status: sidebarController.index.value == 2
                              ? sidebarController.index.value = 2
                              : sidebarController.index.value = 2,
                          dropdown: sidebarController.dropdown.value == true
                              ? sidebarController.dropdown.value == true
                              : sidebarController.dropdown.value == true,
                        ),
                      ),
                    ),
              Expanded(
                flex: 4,
                child: Scaffold(
                  appBar: Appbarmain(),
                  drawer: screenSize == ScreenSize.minidesktop
                      ? Container(
                          color: GPrimaryColor,
                          width: 300,
                          child: SideNav(
                            status: sidebarController.index.value == 2
                                ? sidebarController.index.value = 2
                                : sidebarController.index.value = 2,
                            dropdown: sidebarController.dropdown.value == true
                                ? sidebarController.dropdown.value == true
                                : sidebarController.dropdown.value == true,
                          ),
                        )
                      : null,
                  backgroundColor: GrayColor,
                  body: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: TabBar(
                              unselectedLabelColor: Colors.black45,
                              controller: _tabController,
                              labelStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                              labelPadding: EdgeInsets.symmetric(vertical: 15),
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                color: GPrimaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tabs: [
                                Tab(
                                  child: screenSize == ScreenSize.minidesktop
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [Text('เนื้อหาเดียว')],
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 90),
                                          child: Text('เนื้อหาเดียว'),
                                        ),
                                ),
                                Tab(
                                  child: screenSize == ScreenSize.minidesktop
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [Text('หลายเนื้อหา')],
                                        )
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 90),
                                          child: Text('หลายเนื้อหา'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              SingleChildScrollView(child: Singlecontent()),
                              SingleChildScrollView(child: Multiplecontent()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}