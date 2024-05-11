import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:quill_delta/quill_delta.dart';
import 'package:uuid/uuid.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:watalygold_admin/Page/Knowlege/htmltodelta.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogEdit.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogcancleEdit.dart';
import 'package:watalygold_admin/Widgets/knowlege.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

Map<String, IconData> icons = {
  'สถิติ': Icons.analytics_outlined,
  'ดอกไม้': Icons.yard,
  'หนังสือ': Icons.book,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded,
  'คำถาม': Icons.quiz_outlined,
};

class EditKnowlege extends StatefulWidget {
  final Knowledge? knowledge;
  final IconData? icons;
  final Contents? contents;

  const EditKnowlege({super.key, this.knowledge, this.contents, this.icons});

  @override
  _EditKnowlegeState createState() => _EditKnowlegeState();
}

class _EditKnowlegeState extends State<EditKnowlege> {
  String? _selectedValue;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  QuillController _contentController = QuillController.basic();
  // late QuillController _contentController;
  String _html = '';
  // String htmlString = '<h1 class="ql-indent-1"><strong>1232121444</strong></h1>';
  List<XFile?> latestPickedPhotos = [];
  List<Widget> itemPhotosWidgetList = <Widget>[];
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  List<String> downloadUrl = <String>[];

  bool uploading = false;

  @override
  void initState() {
    super.initState();

    if (widget.knowledge != null) {
      nameController.text = widget.knowledge!.knowledgeName;

      String htmlString = widget.knowledge!.knowledgeDetail;
      var delta = HtmlToDeltaConverter.htmlToDelta(htmlString);

      _contentController = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  Widget _buildTabBar() {
    // ตัวแปรที่เอาไว้วัดขนาดหน้าจอว่าตอนนี้เท่าไหร่แล้ว
    ScreenSize screenSize = getScreenSize(context);
    return Center(
      child: Container(
          height: 140,
          width: MediaQuery.of(context).size.width * 0.67,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: screenSize == ScreenSize.minidesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.07,
                      decoration: BoxDecoration(
                        color: GPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: screenSize == ScreenSize.minidesktop
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  'เนื้อหาเดียว',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'เนื้อหาเดียว',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: screenSize == ScreenSize.minidesktop
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  'หลายเนื้อหา',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'หลายเนื้อหา',
                                  style: TextStyle(
                                    fontSize: 20,
                                   color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.width * 0.05,
                      decoration: BoxDecoration(
                        color: GPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'เนื้อหาเดียว',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: Center(
                        // padding:
                        //     EdgeInsets.only(top: 22, bottom: 10, left: 80, right: 80),
                        child: Text(
                          'หลายเนื้อหา',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }

  Widget build(BuildContext context) {
    // ตัวแปรที่เอาไว้วัดขนาดหน้าจอว่าตอนนี้เท่าไหร่แล้ว
    ScreenSize screensize = getScreenSize(context);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            screensize == ScreenSize.minidesktop
                ? SizedBox.shrink()
                : Expanded(
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
                appBar: Appbarmain(
                    // users: widget.users,
                    ),
                drawer: screensize == ScreenSize.minidesktop
                    ? Container(
                        color: GPrimaryColor,
                        width: 300,
                        child: SideNav(
                          status: 2,
                          dropdown: true,
                        ),
                      )
                    : null,
                backgroundColor: GrayColor,
                body: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: _buildTabBar(),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.68,
                              child: screensize == ScreenSize.minidesktop
                                  ? Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.create_outlined,
                                            size: 24,
                                            color: GPrimaryColor,
                                          ),
                                          Text(
                                            "แก้ไขคลังความรู้ ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.create_outlined,
                                            size: 24,
                                            color: GPrimaryColor,
                                          ),
                                          Text(
                                            "แก้ไขคลังความรู้ ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.68,
                            child: Column(
                              children: [
                                screensize == ScreenSize.minidesktop
                                    ? Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 1300,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          "assets/images/knowlege.png"),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "แก้ไขคลังความรู้",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "ไอคอน ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      child: DropdownButton(
                                                        items: <String>[
                                                          'สถิติ',
                                                          'ดอกไม้',
                                                          'หนังสือ',
                                                          'น้ำ',
                                                          'ระวัง',
                                                          'คำถาม'
                                                        ].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Row(
                                                              children: [
                                                                icons[value] !=
                                                                        null
                                                                    ? Icon(
                                                                        icons[
                                                                            value]!,
                                                                        color:
                                                                            GPrimaryColor,
                                                                      )
                                                                    : SizedBox(),
                                                                SizedBox(
                                                                    width: 25),
                                                                Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                      color:
                                                                          GPrimaryColor),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedValue =
                                                                value;
                                                          });
                                                        },
                                                        hint: Row(
                                                          children: [
                                                            // ไอคอนที่ต้องการเพิ่ม
                                                            SizedBox(
                                                                width:
                                                                    10), // ระยะห่างระหว่างไอคอนและข้อความ
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    widget.icons ??
                                                                        Icons
                                                                            .question_mark_rounded,
                                                                    color:
                                                                        GPrimaryColor,
                                                                    size: 24),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "${widget.icons != null ? icons.keys.firstWhere((key) => icons[key] == widget.icons, orElse: () => '') : ''}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          GPrimaryColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        value: _selectedValue,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "ชื่อ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffCFD3D4)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            nameController,
                                                        maxLength:
                                                            30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "กรอกชื่อคลังความรู้ได้ไม่เกิน 30 ตัวอักษร",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "เนื้อหา",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 400,
                                                    child: Expanded(
                                                        child: Container(
                                                      child: Column(
                                                        children: [
                                                          QuillToolbar.simple(
                                                            configurations:
                                                                QuillSimpleToolbarConfigurations(
                                                              controller:
                                                                  _contentController,
                                                              sharedConfigurations:
                                                                  const QuillSharedConfigurations(
                                                                locale: Locale(
                                                                    'de'),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      238,
                                                                      238,
                                                                      238),
                                                              child: QuillEditor
                                                                  .basic(
                                                                configurations:
                                                                    QuillEditorConfigurations(
                                                                  controller:
                                                                      _contentController,
                                                                  readOnly:
                                                                      false,
                                                                  sharedConfigurations:
                                                                      const QuillSharedConfigurations(
                                                                    locale:
                                                                        Locale(
                                                                            'de'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0, right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "รูปภาพ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        color: Colors.white70,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            offset:
                                                                const Offset(
                                                                    0.0, 0.5),
                                                            blurRadius: 30.0,
                                                          )
                                                        ]),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 250.0,
                                                    child: Center(
                                                      child: itemPhotosWidgetList
                                                              .isEmpty
                                                          ? Center(
                                                              child:
                                                                  MaterialButton(
                                                                onPressed:
                                                                    pickPhotoFromGallery,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  child: Center(
                                                                    child: Image
                                                                        .network(
                                                                      widget.knowledge !=
                                                                              null
                                                                          ? widget
                                                                              .knowledge!
                                                                              .knowledgeImg
                                                                          : widget
                                                                              .contents!
                                                                              .ImageURL,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              child: Wrap(
                                                                spacing: 5.0,
                                                                direction: Axis
                                                                    .horizontal,
                                                                children:
                                                                    itemPhotosWidgetList,
                                                                alignment:
                                                                    WrapAlignment
                                                                        .spaceEvenly,
                                                                runSpacing:
                                                                    10.0,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      pickPhotoFromGallery();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          YPrimaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "แก้ไขรูปภาพ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: display,
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          YellowColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "แสดงผล",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20), // SizedBox
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 1300,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .light_mode_rounded,
                                                        color:
                                                            Color(0xffFFEE58),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "แสดงผล",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Container(
                                                    width: 390,
                                                    height: 100,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFFE7E7E7),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 5,
                                                            color:
                                                                GPrimaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              _displayedWidget ??
                                                                  Container(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    width: 390,
                                                    height: 750,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFFE7E7E7),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 5,
                                                            color:
                                                                GPrimaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                2, // กำหนดความสูงของ Container ให้มากกว่าหรือเท่ากับขนาดที่ต้องการเลื่อน

                                                            child:
                                                                _displayedcontentWidget ??
                                                                    Container(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Container
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.33,
                                            height: 1300,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          "assets/images/knowlege.png"),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "แก้ไขคลังความรู้",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "ไอคอน ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      child: DropdownButton(
                                                        items: <String>[
                                                          'สถิติ',
                                                          'ดอกไม้',
                                                          'หนังสือ',
                                                          'น้ำ',
                                                          'ระวัง',
                                                          'คำถาม'
                                                        ].map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Row(
                                                              children: [
                                                                icons[value] !=
                                                                        null
                                                                    ? Icon(
                                                                        icons[
                                                                            value]!,
                                                                        color:
                                                                            GPrimaryColor,
                                                                      )
                                                                    : SizedBox(),
                                                                SizedBox(
                                                                    width: 25),
                                                                Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                      color:
                                                                          GPrimaryColor),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedValue =
                                                                value;
                                                          });
                                                        },
                                                        hint: Row(
                                                          children: [
                                                            // ไอคอนที่ต้องการเพิ่ม
                                                            SizedBox(
                                                                width:
                                                                    10), // ระยะห่างระหว่างไอคอนและข้อความ
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    widget.icons ??
                                                                        Icons
                                                                            .question_mark_rounded,
                                                                    color:
                                                                        GPrimaryColor,
                                                                    size: 24),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "${widget.icons != null ? icons.keys.firstWhere((key) => icons[key] == widget.icons, orElse: () => '') : ''}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          GPrimaryColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        value: _selectedValue,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "ชื่อ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffCFD3D4)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            nameController,
                                                        maxLength:
                                                            30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "กรอกชื่อคลังความรู้ได้ไม่เกิน 30 ตัวอักษร",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0.0,
                                                            right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "เนื้อหา",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 400,
                                                    child: Expanded(
                                                        child: Container(
                                                      child: Column(
                                                        children: [
                                                          QuillToolbar.simple(
                                                            configurations:
                                                                QuillSimpleToolbarConfigurations(
                                                              controller:
                                                                  _contentController,
                                                              sharedConfigurations:
                                                                  const QuillSharedConfigurations(
                                                                locale: Locale(
                                                                    'de'),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      238,
                                                                      238,
                                                                      238),
                                                              child: QuillEditor
                                                                  .basic(
                                                                configurations:
                                                                    QuillEditorConfigurations(
                                                                  controller:
                                                                      _contentController,
                                                                  readOnly:
                                                                      false,
                                                                  sharedConfigurations:
                                                                      const QuillSharedConfigurations(
                                                                    locale:
                                                                        Locale(
                                                                            'de'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                  SizedBox(height: 30),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0, right: 0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "รูปภาพ",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                            "*",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        color: Colors.white70,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade200,
                                                            offset:
                                                                const Offset(
                                                                    0.0, 0.5),
                                                            blurRadius: 30.0,
                                                          )
                                                        ]),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 250.0,
                                                    child: Center(
                                                      child: itemPhotosWidgetList
                                                              .isEmpty
                                                          ? Center(
                                                              child:
                                                                  MaterialButton(
                                                                onPressed:
                                                                    pickPhotoFromGallery,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomCenter,
                                                                  child: Center(
                                                                    child: Image
                                                                        .network(
                                                                      widget.knowledge !=
                                                                              null
                                                                          ? widget
                                                                              .knowledge!
                                                                              .knowledgeImg
                                                                          : widget
                                                                              .contents!
                                                                              .ImageURL,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              child: Wrap(
                                                                spacing: 5.0,
                                                                direction: Axis
                                                                    .horizontal,
                                                                children:
                                                                    itemPhotosWidgetList,
                                                                alignment:
                                                                    WrapAlignment
                                                                        .spaceEvenly,
                                                                runSpacing:
                                                                    10.0,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      pickPhotoFromGallery();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          YPrimaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "แก้ไขรูปภาพ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: display,
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          YellowColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "แสดงผล",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20), // SizedBox
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.33,
                                            height: 1300,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .light_mode_rounded,
                                                        color:
                                                            Color(0xffFFEE58),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "แสดงผล",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Container(
                                                    width: 390,
                                                    height: 100,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFFE7E7E7),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 5,
                                                            color:
                                                                GPrimaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              _displayedWidget ??
                                                                  Container(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    width: 390,
                                                    height: 750,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFFE7E7E7),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            width: 5,
                                                            color:
                                                                GPrimaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                2, // กำหนดความสูงของ Container ให้มากกว่าหรือเท่ากับขนาดที่ต้องการเลื่อน

                                                            child:
                                                                _displayedcontentWidget ??
                                                                    Container(),
                                                          ),
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

                                // Container
                              ],
                            ),
                          ),
                          Padding(
                            // padding: const EdgeInsets.all(25.0),
                            padding: const EdgeInsets.only(
                                right: 70.0, top: 50.0, bottom: 50),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            DialogCancleEdit(),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xC5C5C5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 18.0),
                                    ),
                                    child: Text(
                                      "ยกเลิก",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final deltaJson = _contentController
                                          .document
                                          .toDelta()
                                          .toJson();
                                      print(deltaJson);

                                      final converter =
                                          QuillDeltaToHtmlConverter(
                                        List.castFrom(deltaJson),
                                      );
                                      _html = converter.convert();
                                      print(_html);
                                      upload();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 18.0),
                                      backgroundColor: YellowColor,
                                    ),
                                    child: uploading
                                        ? SizedBox(
                                            child: CircularProgressIndicator(),
                                            height: 15.0,
                                          )
                                        : const Text(
                                            "แก้ไข",
                                            style: TextStyle(
                                              color: Colors.white,
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
                  ),
                ),
              ),
            ),
            // Container(width: 100, child: TabEdit()),
          ],
        ),
      ),
    );
  }

  void addImage() {
    removeImage();
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: 390,
          child: Container(
            child: kIsWeb
                ? Image.network(
                    File(bytes.path).path,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(bytes.path),
                  ),
          ),
        ),
      ));
    }
  }

  Future<void> pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null && photo!.isNotEmpty) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        latestPickedPhotos.addAll(photo!); // เพิ่มรูปภาพล่าสุดเข้าไปในรายการ
        addImage();
        photo!.clear();
      });
    }
  }

  upload() async {
    if (itemImagesList.isNotEmpty) {
      String knowledgetId = await uploadImageAndSaveItemInfo();
      setState(() {
        uploading = false;
      });
    } else {
      updateKnowledges(widget.knowledge != null
          ? widget.knowledge!.knowledgeImg
          : widget.contents!.ImageURL);
    }
  }

  Future<String> uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    if (itemImagesList.isEmpty) {
      // ไม่มีการเพิ่มรูปภาพใหม่ ส่ง imageUrl เดิมไปยัง updateKnowledges
      updateKnowledges(widget.knowledge != null
          ? widget.knowledge!.knowledgeImg
          : widget.contents!.ImageURL);
      return ''; // คืนค่าว่างหรือค่า null เพราะไม่มีรูปภาพใหม่ที่อัปโหลด
    }
    PickedFile? pickedFile;
    String? knowledgetId = const Uuid().v4().substring(0, 10);
    if (latestPickedPhotos.isNotEmpty) {
      XFile? latestPickedPhoto = latestPickedPhotos.last;
      if (latestPickedPhoto != null) {
        file = File(latestPickedPhoto.path);
        pickedFile = PickedFile(file!.path);
        await uploadImageToStorage(pickedFile, knowledgetId);
      }
    }
    return knowledgetId;
  }

  void removeImage() {
    setState(() {
      itemPhotosWidgetList.clear(); // ลบภาพเดิมทั้งหมด
    });
  }

  uploadImageToStorage(PickedFile? pickedFile, String knowledgetId) async {
    if (pickedFile != null) {
      String? kId = const Uuid().v4().substring(0, 10);
      Reference reference = FirebaseStorage.instance
          .ref()
          .child('Knowledge/$knowledgetId/knowledImg_$kId');
      await reference.putData(
        await pickedFile.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      String imageUrl = await reference.getDownloadURL();
      updateKnowledges(imageUrl);
    }
  }

  void updateKnowledges(String? imageUrl) async {
    String Id = widget.knowledge!.id;

    String? selectedValue;

    selectedValue = widget.knowledge!.knowledgeIcons != null
        ? widget.knowledge!.knowledgeIcons.toString()
        : widget.icons != null
            ? icons.keys.firstWhere(
                (key) => icons[key] == widget.icons,
                orElse: () => '',
              )
            : null;

    Map<String, dynamic> updateknowledge = {
      "KnowledgeName": nameController.text,
      "KnowledgeDetail": _html,
      "KnowledgeIcons": _selectedValue ??
          icons.keys.firstWhere((key) => icons[key].toString() == selectedValue,
              orElse: () => ''),
      "KnowledgeImg": imageUrl,
      "deleted_at": null,
      "update_at": Timestamp.now(),
      "Content": [],
    };

    await Databasemethods().updateKnowledge(updateknowledge, Id).then((value) {
      showDialog(
        context: context,
        builder: (context) => DialogEdit(),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        context.goNamed("/mainKnowledge");
      });
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "เกิดข้อผิดพลาดในการเพิ่มความรู้: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void clearAllFields() {
    nameController.clear();
    contentController.clear();

    setState(() {
      _selectedValue = null;
    });

    setState(() {
      itemImagesList.clear();
      itemPhotosWidgetList.clear();
    });
  }

  Widget _displayedWidget = Container();
  Widget _displayedcontentWidget = Container();
  Widget _displayedWidgetHtmlWidget = Container();

  Widget _displaycoverWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: WhiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  icons[_selectedValue] ??
                      Icons.error, // ระบุไอคอนตามค่าที่เลือก
                  size: 15, // ขนาดของไอคอน
                  color: GPrimaryColor, // สีของไอคอน
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    nameController.text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: Icon(
                    Icons
                        .keyboard_arrow_right_rounded, // ระบุไอคอนตามค่าที่เลือก
                    size: 24, // ขนาดของไอคอน
                    color: GPrimaryColor, // สีของไอคอน
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _displaycontentWidget() {
    return Scaffold(
      appBar: Appbarmain_no_botton(
        name: nameController.text,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: itemPhotosWidgetList.length > 0
                ? itemPhotosWidgetList.length
                : 1,
            itemBuilder: (BuildContext context, int index) {
              if (itemPhotosWidgetList.length > 0) {
                return Container(
                  // กำหนดความกว้างของรูปภาพ
                  child: itemPhotosWidgetList[index], // ใส่รูปภาพลงใน Container
                );
              } else {
                // หากไม่มี itemPhotosWidgetList ให้แสดงรูปภาพจาก knowledgeImg
                return Container(
                  // กำหนดความกว้างของรูปภาพ
                  child: Image.network(
                    widget.knowledge != null
                        ? widget.knowledge!.knowledgeImg
                        : widget.contents!.ImageURL,
                    fit: BoxFit.cover,
                  ),
                );
              }
            },
          ),

          // ListView.builder(
          //   itemCount: itemPhotosWidgetList.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return Container(
          //     // กำหนดความกว้างของรูปภาพ
          //       child: itemPhotosWidgetList[index], // ใส่รูปภาพลงใน Container
          //     );
          //   },
          // ),

          Positioned(
            // ใช้ตัวแปร _positionY แทนค่า top
            bottom: 0.0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
            left: 0.0,
            right: 0.0,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.width * 1.85,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          icons[_selectedValue] ??
                              Icons.error, // ระบุไอคอนตามค่าที่เลือก
                          size: 24, // ขนาดของไอคอน
                          color: GPrimaryColor, // สีของไอคอน
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          nameController.text,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: _displayedWidgetHtmlWidget,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _displayedWidgetWidget() {
  //   final deltaJson = _contentController.document.toDelta().toJson();
  //     final converter = QuillDeltaToHtmlConverter(List.castFrom(deltaJson));
  //     final html = converter.convert();
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Align(alignment: Alignment.centerLeft, child:HtmlWidget(
  //       html,
  //       textStyle: TextStyle(color: Colors.black, fontSize: 15),
  //       renderMode: RenderMode.column,
  //       customStylesBuilder: (element) {
  //         if (element.classes.contains('p')) {
  //           return {'color': 'red'};
  //         }
  //         return null;
  //       },),)
  //     ],
  //   );
  // }

  void display() {
    // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
    setState(() {
      final deltaJson = _contentController.document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(List.castFrom(deltaJson));
      final html = converter.convert();

      _displayedWidgetHtmlWidget = HtmlWidget(
        html,
        textStyle: TextStyle(color: Colors.black, fontSize: 15),
        renderMode: RenderMode.column,
        customStylesBuilder: (element) {
          if (element.classes.contains('p')) {
            return {'color': 'red'};
          }
          return null;
        },
      );
      // เรียกใช้งาน Widget ที่จะแสดงผล
      _displayedWidget = _displaycoverWidget();
      _displayedcontentWidget = _displaycontentWidget();
      // _displayedWidgetHtmlWidget = _displayedWidgetWidget();
    });
  }
}
