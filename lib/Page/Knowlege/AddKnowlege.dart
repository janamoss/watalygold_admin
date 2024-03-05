import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold_admin/Page/Knowlege/Multiplecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/Singlecontent.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:web/helpers.dart';

class Add_Knowlege extends StatefulWidget {
  // const Add_Knowlege({super.key});
  @override
  _Add_KnowlegeState createState() => _Add_KnowlegeState();
}

class _Add_KnowlegeState extends State<Add_Knowlege>
    with SingleTickerProviderStateMixin {
  late TabController tapController;

  @override
  void initState() {
    tapController = TabController(length: 2, vsync: this);
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
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                Expanded(
                  
                    child: TabBarView(
                      controller: tapController,
                     
                  children: [
                   
                    Singlecontent(),
                    Multiplecontent(),
                  ],
                )),
                SizedBox(height: 0,),
                
              ],
              
            ),
          ),
          
        ),
      ),
    );
  }
}
