import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Singlecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditMutiple.dart';

import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:web/helpers.dart';


Map<String, IconData> icons = {
  'บ้าน': Icons.home,
  'ดอกไม้': Icons.yard,
  'บุคคล': Icons.person,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded
}; 

class TabBar_View extends StatefulWidget {

  final Knowledge? knowledge;
  final IconData? icons;
  final Contents? contents;

  const TabBar_View({super.key, this.knowledge, this.contents, this.icons});

  // const Add_Knowlege({super.key});
 @override
   _TabBar_ViewState createState() => _TabBar_ViewState();
}



class _TabBar_ViewState extends State<TabBar_View>

    with SingleTickerProviderStateMixin {
    late TabController tapController;

  @override
  void initState() {
    tapController = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    // height: 140,
                    width: 1000,
                    // width: MediaQuery.of(context).size.height,
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
                                fontSize: 20,
                                fontFamily: 'IBM Plex Sans Thai',
                                color: Colors.white),
                            dividerColor: Colors.transparent,
                            // indicatorWeight: 10,
                            indicator: BoxDecoration(
                              color: Color(0xFF42BD41),
                              // color: tapController.index == 1 ? Colors.blue : Color(0xFF42BD41),
                              borderRadius: BorderRadius.circular(10),
                            )
                            tabs: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 80, right: 80),
                                // padding: EdgeInsets.symmetri60c(horizontal: 60),
                                child: Tab(
                                  text: 'เนื้อหาเดียว',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 80, right: 80),
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
                SizedBox(height: 50,),
                // Expanded(
                  
                //     child: TabBarView(
                //       controller: tapController,
                     
                //   children: [
                   
                //     EditKnowlege(),
                //     EditMutiple(),
                    
                //   ],
                // )),
                SizedBox(height: 0,),
                
              ],
              
            ),
          ),
          
        ),
      ),
    );
  }
}
