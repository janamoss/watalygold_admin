import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/service/knowlege.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MainKnowlege extends StatefulWidget {
  const MainKnowlege({super.key});

  @override
  State<MainKnowlege> createState() => _MainKnowlegeState();
}

class _MainKnowlegeState extends State<MainKnowlege> {
  List<Knowledge> knowledgelist = [];

  Future<List<Knowledge>> getKnowledges() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('Knowledge').get();
      return querySnapshot.docs
          .map((doc) => Knowledge.fromFirestore(doc))
          .toList();
    } catch (error) {
      print("Error getting knowledge: $error");
      return []; // Or handle the error in another way
    }
  }

  String timestampToDateThai(Timestamp timestamp) {
    initializeDateFormatting("th");
    if (timestamp == null) {
      return "";
    }
    final dateTime =
        DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
    final thaiDateFormat = DateFormat.yMMMMd('th');
    return thaiDateFormat.format(dateTime);
  }

  @override
  void initState() {
    super.initState();

    getKnowledges().then((value) {
      setState(() {
        knowledgelist = value;
      });

      for (var knowledge in knowledgelist) {
        print('contents : ${knowledge.contents}');
      }
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Row(
      children: [
        Expanded(
          child: Container(
            color: GPrimaryColor,
            child: SideNav(),
          ),
        ),
        Expanded(
            flex: 4,
            child: Scaffold(
              backgroundColor: Color(0xffF1F1F1),
              appBar: Appbarmain(),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 60),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "หน้าหลักคลังความรู้",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            "มีคลังความรู้ทั้งหมด",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff1D1D1D).withOpacity(0.43)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "${knowledgelist.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: G2PrimaryColor),
                            ),
                          ),
                          Text(
                            "เรื่อง",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff1D1D1D).withOpacity(0.43)),
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            onHover: (value) {
                              ElevatedButton.styleFrom(
                                  backgroundColor: GPrimaryColor);
                            },
                            icon: Icon(
                              Icons.add_circle_outline_rounded,
                              color: WhiteColor,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: G2PrimaryColor,
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shadowColor: Colors.black,
                                elevation: 5),
                            label: Text(
                              "เพิ่มคลังความรู้",
                              style: TextStyle(color: WhiteColor, fontSize: 20),
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            for (var knowledge in knowledgelist)
                              KnowledgeContainer(
                                title: knowledge.knowledgeName,
                                icons: knowledge.knowledgeIcons,
                                date: timestampToDateThai(knowledge.create_at!),
                                image: knowledge.knowledgeImg,
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
      ],
    ));
  }
}

class KnowledgeContainer extends StatelessWidget {
  final title;
  final icons;
  final image;
  final ontap;
  final date;
  const KnowledgeContainer(
      {super.key, this.title, this.icons, this.image, this.ontap, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width * 0.3,
      height: 200,
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), //New
            blurRadius: 2.0,
            spreadRadius: 2.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  image: DecorationImage(
                    image: NetworkImage(
                      image,
                    ),
                    fit: BoxFit.cover,
                  )),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xffECFFEB),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    icons,
                    color: G2PrimaryColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "วันที่ $date",
                          style: TextStyle(color: G2PrimaryColor, fontSize: 15),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: WhiteColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow.shade400,
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 1),
                                label: Text(
                                  "แก้ไข",
                                  style: TextStyle(color: WhiteColor),
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  color: WhiteColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 1),
                                label: Text("ลบ",
                                    style: TextStyle(color: WhiteColor)))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
