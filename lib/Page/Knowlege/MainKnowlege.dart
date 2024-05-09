import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditMutiple.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Deleteddialogknowledge.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

class MainKnowlege extends StatefulWidget {
  final User? users;
  const MainKnowlege({super.key, this.users});

  @override
  State<MainKnowlege> createState() => _MainKnowlegeState();
}

class _MainKnowlegeState extends State<MainKnowlege> {
  final logger = Logger();
  // late User? _user;

  final sidebarController = Get.put(SidebarController());

  bool _isLoading = true;
  List<Knowledge> knowledgelist = [];
  List<String> imageURLlist = [];

  Future<List<Knowledge>> getKnowledges() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('Knowledge')
          .where('deleted_at', isNull: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Knowledge.fromFirestore(doc))
          .toList();
    } catch (error) {
      logger.d("Error getting knowledge: $error");
      return []; // Or handle the error in another way
    }
  }

  Future<Contents> getContentsById(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('Content').doc(documentId);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data();
      return Contents(
        ContentName: data!['ContentName'].toString(),
        ContentDetail: data['ContentDetail'].toString(),
        ImageURL: data['image_url'].toString(),
        id: doc.id,
        create_at: data['create_at'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now()),
      );
    } else {
      throw Exception('Document not found with ID: $documentId');
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

    setState(() {
      _isLoading = true; // Set loading state to true
    });

    getKnowledges().then((value) async {
      setState(() {
        knowledgelist = value;
      });
      if (knowledgelist.length == 0) {
        setState(() {
          _isLoading = false;
        });
      }
      for (var knowledge in knowledgelist) {
        if (knowledge.knowledgeImg.isEmpty) {
          // แสดง Loading indicator
          final firstContent = knowledge.contents[0].toString();
          final contents = await getContentsById(firstContent);
          imageURLlist.add(contents.ImageURL);
          setState(() {
            _isLoading = false;
          });
          // ซ่อน Loading indicator
        } else {
          imageURLlist.add(knowledge.knowledgeImg);
        }
      }
    });
  }

  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);

    if (screenSize == ScreenSize.minidesktop) {
      return Scaffold(
        body: SafeArea(
            child: Row(
          children: [
            Expanded(
                flex: 4,
                child: Scaffold(
                  drawer: Container(
                    width: 300,
                    color: GPrimaryColor,
                    child: SideNav(
                      status: 1,
                      dropdown: true,
                    ),
                  ),
                  backgroundColor: Color(0xffF1F1F1),
                  appBar: Appbarmain(
                    users: widget.users,
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 60),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${knowledgelist.length}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: GPrimaryColor),
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
                                onPressed: () {
                                  sidebarController.index.value = 2;
                                  context.goNamed("/addKnowledge");
                                },
                                onHover: (value) {
                                  ElevatedButton.styleFrom(
                                      backgroundColor: GPrimaryColor);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: WhiteColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: GPrimaryColor,
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 5),
                                label: Text(
                                  "เพิ่มคลังความรู้",
                                  style: TextStyle(
                                      color: WhiteColor, fontSize: 20),
                                ),
                              )),
                          _isLoading
                              ? Center(
                                  child: LoadingAnimationWidget.discreteCircle(
                                    color: WhiteColor,
                                    secondRingColor: GPrimaryColor,
                                    thirdRingColor: YPrimaryColor,
                                    size: 200,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      for (var i = 0;
                                          i < knowledgelist.length;
                                          i++)
                                        KnowledgeContainer(
                                          knowledge: knowledgelist[i],
                                          sidebarController: sidebarController,
                                          id: knowledgelist[i].id,
                                          title: knowledgelist[i].knowledgeName,
                                          icons:
                                              knowledgelist[i].knowledgeIcons,
                                          date: timestampToDateThai(
                                              knowledgelist[i].create_at!),
                                          image: i < imageURLlist.length
                                              ? imageURLlist[i].toString()
                                              : '', // ตรวจสอบขนาดของ imageURLlist ก่อนเข้าถึงค่า
                                          status: knowledgelist[i]
                                                  .knowledgeImg
                                                  .isEmpty
                                              ? "หลายเนื้อหา"
                                              : "เนื้อหาเดียว",
                                        ),
                                      knowledgelist.length == 0
                                          ? Text(
                                              "ไม่มีเนื้อหา",
                                              style: TextStyle(
                                                  color: GPrimaryColor,
                                                  fontSize: 18),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        )),
      );
    } else {
      return Scaffold(
        body: SafeArea(
            child: Row(
          children: [
            Expanded(
              child: Container(
                color: GPrimaryColor,
                child: SideNav(
                  status: 1,
                  dropdown: true,
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Scaffold(
                  backgroundColor: Color(0xffF1F1F1),
                  appBar: Appbarmain(
                    users: widget.users,
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 60),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${knowledgelist.length}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: GPrimaryColor),
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
                                onPressed: () {
                                  sidebarController.index.value = 2;
                                  context.goNamed("/addKnowledge");
                                },
                                onHover: (value) {
                                  ElevatedButton.styleFrom(
                                      backgroundColor: GPrimaryColor);
                                },
                                icon: Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: WhiteColor,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: GPrimaryColor,
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 5),
                                label: Text(
                                  "เพิ่มคลังความรู้",
                                  style: TextStyle(
                                      color: WhiteColor, fontSize: 20),
                                ),
                              )),
                          _isLoading
                              ? Center(
                                  child: LoadingAnimationWidget.discreteCircle(
                                    color: WhiteColor,
                                    secondRingColor: GPrimaryColor,
                                    thirdRingColor: YPrimaryColor,
                                    size: 200,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      for (var i = 0;
                                          i < knowledgelist.length;
                                          i++)
                                        KnowledgeContainer(
                                          knowledge: knowledgelist[i],
                                          sidebarController: sidebarController,
                                          id: knowledgelist[i].id,
                                          title: knowledgelist[i].knowledgeName,
                                          icons:
                                              knowledgelist[i].knowledgeIcons,
                                          date: timestampToDateThai(
                                              knowledgelist[i].create_at!),
                                          image: i < imageURLlist.length
                                              ? imageURLlist[i].toString()
                                              : '', // ตรวจสอบขนาดของ imageURLlist ก่อนเข้าถึงค่า
                                          status: knowledgelist[i]
                                                  .knowledgeImg
                                                  .isEmpty
                                              ? "หลายเนื้อหา"
                                              : "เนื้อหาเดียว",
                                        ),
                                      knowledgelist.length == 0
                                          ? Text(
                                              "ไม่มีเนื้อหา",
                                              style: TextStyle(
                                                  color: GPrimaryColor,
                                                  fontSize: 18),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        )),
      );
    }
  }
}

class KnowledgeContainer extends StatefulWidget {
  final Knowledge? knowledge;
  final id;
  final title;
  final icons;
  final image;
  final ontap;
  final date;
  final status;
  final SidebarController? sidebarController;
  const KnowledgeContainer(
      {super.key,
      this.id,
      this.title,
      this.icons,
      this.image,
      this.ontap,
      this.date,
      this.status,
      this.sidebarController,
      this.knowledge});

  @override
  State<KnowledgeContainer> createState() => _KnowledgeContainerState();
}

class _KnowledgeContainerState extends State<KnowledgeContainer> {
  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);

    return Container(
      margin: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width * 0.3,
      height: screenSize == ScreenSize.minidesktop ? 300 : 200,
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
                      widget.image,
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
                    widget.icons,
                    color: GPrimaryColor,
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
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            )),
                            Text(
                              widget.status,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: GPrimaryColor,
                              ),
                            ),
                          ],
                        )),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "วันที่ ${widget.date}",
                        style: TextStyle(color: GPrimaryColor, fontSize: 15),
                      ),
                    ),
                    screenSize == ScreenSize.minidesktop
                        ? Column(children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                  if (widget.status != "เนื้อหาเดียว") {
                                    // หากมีข้อมูล content ให้เปิดหน้า ExpansionTileExample
                                    context.goNamed(
                                      '/editmultiKnowledge',
                                      extra: {
                                        'knowledge': widget.knowledge,
                                        'icon': widget.icons,
                                      },
                                    );
                                  } else {
                                    // ถ้าไม่มีข้อมูล content ให้เปิดหน้า EditKnowlege
                                    context.goNamed(
                                      '/editKnowledge',
                                      extra: {
                                        'knowledge': widget.knowledge,
                                        'icon': widget.icons,
                                      },
                                    );
                                  }
                                },
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
                              height: 15,
                            ),
                            ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        Deleteddialogknowledge(
                                      knowledgeName: widget.title,
                                      id: widget.id,
                                    ),
                                  ).then((value) => Navigator.popUntil(context,
                                      ModalRoute.withName("/mainKnowledge")));
                                },
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
                                    style: TextStyle(color: WhiteColor))),
                          ])
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    if (widget.status != "เนื้อหาเดียว") {
                                      // หากมีข้อมูล content ให้เปิดหน้า ExpansionTileExample
                                      context.goNamed(
                                        '/editmultiKnowledge',
                                        extra: {
                                          'knowledge': widget.knowledge,
                                          'icon': widget.icons,
                                        },
                                      );
                                    } else {
                                      // ถ้าไม่มีข้อมูล content ให้เปิดหน้า EditKnowlege
                                      context.goNamed(
                                        '/editKnowledge',
                                        extra: {
                                          'knowledge': widget.knowledge,
                                          'icon': widget.icons,
                                        },
                                      );
                                    }
                                  },
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
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          Deleteddialogknowledge(
                                        knowledgeName: widget.title,
                                        id: widget.id,
                                      ),
                                    ).then((value) => Navigator.popUntil(
                                        context,
                                        ModalRoute.withName("/mainKnowledge")));
                                  },
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
                          )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
