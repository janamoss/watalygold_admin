import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Singlecontent.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';

import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:web/helpers.dart';

Map<String, IconData> icons = {
  'สถิติ': Icons.analytics_outlined,
  'ดอกไม้': Icons.yard,
  'หนังสือ': Icons.book,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded,
  'คำถาม': Icons.quiz_outlined,
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
  late TabController tapController;
  // final List<bool> _tabEnabled = [false, true];

  @override
  void initState() {
    tapController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
    // เปลี่ยนค่า _tabEnabled เพื่อให้ Tab 'เนื้อหาเดียว' ไม่แสดงผล
    // setState(() {
    //   _tabEnabled[0] = false;
    //   _tabEnabled[1] = true;
    // });
  }

  @override
  void dispose() {
    tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: GPrimaryColor,
                child: SideNav(
                  status: 2,
                  dropdown: true,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Scaffold(
                backgroundColor: GrayColor,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(30),
                                    child: TabBar(
                                      unselectedLabelColor: Colors.black45,
                                      controller: tapController,
                                      labelStyle: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                      dividerColor: Colors.transparent,
                                      // indicatorWeight: 10,
                                      indicator: BoxDecoration(
                                        color: GPrimaryColor,
                                        // color: tapController.index == 1 ? Colors.blue : Color(0xFF42BD41),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      tabs: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 17,
                                              bottom: 10,
                                              left: 80,
                                              right: 80),
                                          // padding: EdgeInsets.symmetri60c(horizontal: 60),
                                          child: Tab(
                                            text: 'เนื้อหาเดียว',
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 80,
                                              right: 80),
                                          // padding: EdgeInsets.symmetri60c(horizontal: 60),
                                          child: Tab(
                                            text: 'หลายเนื้อหา',
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width *
                                  0.7, // ปรับความสูงตามที่ต้องการ
                              child: Expanded(
                                child: TabBarView(
                                  controller: tapController,
                                  children: [
                                    Singlecontent(),
                                    Multiplecontent(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
