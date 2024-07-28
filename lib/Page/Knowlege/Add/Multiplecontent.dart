import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogCancle.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watalygold_admin/service/screen_unit.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart'
    as pickerImageSource;

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

class ExpansionPanelData {
  TextEditingController nameController;
  QuillController detailController;
  List<Widget> itemPhotosWidgetList;
  // final List<List<Widget>> itemPhotosWidgetList;

  ExpansionPanelData({
    required this.nameController,
    required this.detailController,
    required this.itemPhotosWidgetList,
  });
}

List<ExpansionPanelData> _panelData = [];

class Multiplecontent extends StatefulWidget {
  const Multiplecontent({super.key});

  @override
  _MultiplecontentState createState() => _MultiplecontentState();
}

class _MultiplecontentState extends State<Multiplecontent> {
  IconData? selectedIconData;
  String? _selectedValue;
  final CarouselController _controller = CarouselController();
  int _currentExpandedIndex = -1;
  bool addedContent = false;
  TextEditingController contentcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController contentdetailcontroller = TextEditingController();
  TextEditingController contentnamecontroller = TextEditingController();
  List<TextEditingController> contentNameControllers = [];
  List<TextEditingController> contentDetailControllers = [];
  List<List<XFile>> expansionPanelImagesList = [];
  int _current = 0;
  // final QuillController _contentController = QuillController.basic();
  final List<QuillController> _contentController = [QuillController.basic()];

  String _html = '';
  List<String> htmlList = [];
  List<List<String>> htmlLists = [];

  final List<Widget> _displayedContentWidgets =
      List.filled(_panelData.length, Container());

  final List<bool> _showPreview = [];
  final List<int> _deletedPanels = [];
// List<Widget> itemPhotosWidgetList = [];
  List<Widget> itemPhotosWidgetList = <Widget>[]; //แสดงตัวอย่างรูปภาพ
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo =
      <XFile>[]; //เป็นรายการของ XFile ที่ใช้ในการเก็บรูปภาพที่เลือกจากแกล
  List<XFile> itemImagesList =
      <XFile>[]; //ใช้ในการเก็บรูปภาพที่ผู้ใช้เลือกเพื่ออัปโหลด
  List<String> downloadUrl = <String>[]; //เก็บ url ภาพ
  bool uploading = false;
  List<String> ListimageUrl = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ตัวแปรที่เอาไว้วัดขนาดหน้าจอว่าตอนนี้เท่าไหร่แล้ว
    ScreenSize screenSize = getScreenSize(context);
    return Scaffold(
      backgroundColor: GrayColor,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              children: [
                // เอาไว้เปลี่ยน layout จากตอนแรก Row เป็น Column ถ้าหน้าจอย่อลง
                screenSize == ScreenSize.minidesktop
                    ? Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.bookOpen,
                                        color: GPrimaryColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "เพิ่มคลังความรู้",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "ไอคอน ",
                                            style: TextStyle(
                                              color: Colors.black,
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
                                  // Align(
                                  //   alignment: Alignment.topLeft,
                                  //   child: Container(
                                  //     child: DropdownButton(
                                  //       items: <String>[
                                  //         'สถิติ',
                                  //         'ดอกไม้',
                                  //         'หนังสือ',
                                  //         'น้ำ',
                                  //         'ระวัง',
                                  //         'คำถาม'
                                  //       ].map<DropdownMenuItem<String>>(
                                  //           (String value) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: value,
                                  //           child: Row(
                                  //             children: [
                                  //               icons[value] != null
                                  //                   ? Icon(
                                  //                       icons[value]!,
                                  //                       color: GPrimaryColor,
                                  //                     )
                                  //                   : const SizedBox(),
                                  //               const SizedBox(width: 15),
                                  //               Text(
                                  //                 value,
                                  //                 style: const TextStyle(
                                  //                     color: GPrimaryColor),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         );
                                  //       }).toList(),
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           _selectedValue = value;
                                  //         });
                                  //       },
                                  //       hint: const Row(
                                  //         children: [
                                  //           Icon(
                                  //             Icons.image_outlined,
                                  //             color: GPrimaryColor,
                                  //           ), // ไอคอนที่ต้องการเพิ่ม
                                  //           SizedBox(
                                  //               width:
                                  //                   10), // ระยะห่างระหว่างไอคอนและข้อความ
                                  //           Text(
                                  //             "เลือกไอคอนสำหรับคลังความรู้",
                                  //             style: TextStyle(
                                  //                 color: GPrimaryColor,
                                  //                 fontSize: 17),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       value: _selectedValue,
                                  //     ),
                                  //   ),
                                  // ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          items: <String>[
                                            'ใบไม้',
                                            'ต้นกล้า',
                                            'สถิติ',
                                            'ดอกไม้',
                                            'หนังสือ',
                                            'น้ำ',
                                            'ระวัง',
                                            'คำถาม',
                                            'รูปภาพ',
                                            'ระฆัง',
                                            'ความคิดเห็น',
                                            'ตำแหน่ง',
                                            'กล้อง',
                                            'ปฏิทิน',
                                            'ไวรัส'
                                            
                                        
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  icons[value] != null
                                                      ? Icon(
                                                          icons[value]!,
                                                          color: GPrimaryColor,
                                                        )
                                                      : const SizedBox(),
                                                  const SizedBox(width: 15),
                                                  Text(
                                                    value,
                                                    style: const TextStyle(
                                                        color: GPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value;
                                            });
                                          },
                                          hint: const Row(
                                            children: [
                                              Icon(
                                                Icons.image_outlined,
                                                color: GPrimaryColor,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "เลือกไอคอนสำหรับคลังความรู้",
                                                style: TextStyle(
                                                  color: GPrimaryColor,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: _selectedValue,
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 300,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          // scrollbarProps: ScrollbarProps(
                                          //   radius: const Radius.circular(40),
                                          //   thickness: 6,
                                          //   thumbVisibility: true,
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "ชื่อ",
                                            style: TextStyle(
                                              color: Colors.black,
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
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffCFD3D4)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextField(
                                        controller: namecontroller,
                                        maxLength:
                                            20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
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
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: display,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffE69800),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "แสดงผล",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20), // SizedBox
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.light_mode_rounded,
                                        color: Color(0xffFFEE58),
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
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    width: 390,
                                    height: 100,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFE7E7E7),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 5, color: GPrimaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child:
                                              _displayedWidget ?? Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
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
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.bookOpen,
                                        color: GPrimaryColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "เพิ่มคลังความรู้",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "ไอคอน ",
                                            style: TextStyle(
                                              color: Colors.black,
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
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          items: <String>[
                                            'ใบไม้',
                                            'ต้นกล้า',
                                            'สถิติ',
                                            'ดอกไม้',
                                            'หนังสือ',
                                            'น้ำ',
                                            'ระวัง',
                                            'คำถาม',
                                            'รูปภาพ',
                                            'ระฆัง',
                                            'ความคิดเห็น',
                                            'ตำแหน่ง',
                                            'กล้อง',
                                            'ปฏิทิน',
                                            'ไวรัส'
                                            
                                        
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Row(
                                                children: [
                                                  icons[value] != null
                                                      ? Icon(
                                                          icons[value]!,
                                                          color: GPrimaryColor,
                                                        )
                                                      : const SizedBox(),
                                                  const SizedBox(width: 15),
                                                  Text(
                                                    value,
                                                    style: const TextStyle(
                                                        color: GPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value;
                                            });
                                          },
                                          hint: const Row(
                                            children: [
                                              Icon(
                                                Icons.image_outlined,
                                                color: GPrimaryColor,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "เลือกไอคอนสำหรับคลังความรู้",
                                                style: TextStyle(
                                                  color: GPrimaryColor,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: _selectedValue,
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 300,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          // scrollbarProps: ScrollbarProps(
                                          //   radius: const Radius.circular(40),
                                          //   thickness: 6,
                                          //   thumbVisibility: true,
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Align(
                                  //   alignment: Alignment.topLeft,
                                  //   child: Container(
                                  //     child: DropdownButton(
                                  //       items: <String>[
                                  //         'สถิติ',
                                  //         'ดอกไม้',
                                  //         'หนังสือ',
                                  //         'น้ำ',
                                  //         'ระวัง',
                                  //         'คำถาม'
                                  //       ].map<DropdownMenuItem<String>>(
                                  //           (String value) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: value,
                                  //           child: Row(
                                  //             children: [
                                  //               icons[value] != null
                                  //                   ? Icon(
                                  //                       icons[value]!,
                                  //                       color: GPrimaryColor,
                                  //                     )
                                  //                   : const SizedBox(),
                                  //               const SizedBox(width: 15),
                                  //               Text(
                                  //                 value,
                                  //                 style: const TextStyle(
                                  //                     color: GPrimaryColor),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         );
                                  //       }).toList(),
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           _selectedValue = value;
                                  //         });
                                  //       },
                                  //       hint: const Row(
                                  //         children: [
                                  //           Icon(
                                  //             Icons.image_outlined,
                                  //             color: GPrimaryColor,
                                  //           ), // ไอคอนที่ต้องการเพิ่ม
                                  //           SizedBox(
                                  //               width:
                                  //                   10), // ระยะห่างระหว่างไอคอนและข้อความ
                                  //           Text(
                                  //             "เลือกไอคอนสำหรับคลังความรู้",
                                  //             style: TextStyle(
                                  //                 color: GPrimaryColor,
                                  //                 fontSize: 17),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       value: _selectedValue,
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(height: 30),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "ชื่อ",
                                            style: TextStyle(
                                              color: Colors.black,
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
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffCFD3D4)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextField(
                                        controller: namecontroller,
                                        maxLength:
                                            20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
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
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: display,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffE69800),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "แสดงผล",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20), // SizedBox
                          Container(
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.light_mode_rounded,
                                        color: Color(0xffFFEE58),
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
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    width: 390,
                                    height: 100,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFE7E7E7),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 5, color: GPrimaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child:
                                              _displayedWidget ?? Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Container
                        ],
                      ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: ExpansionPanelList.radio(
                      expansionCallback: (int index, bool isExpanded) {
                        if (_deletedPanels.contains(index)) {
                          return;
                        }
                        setState(() {
                          if (isExpanded) {
                            _currentExpandedIndex = index;
                          }
                        });
                      },
                      children: _panelData.map<ExpansionPanelRadio>(
                          (ExpansionPanelData expansionPanelData) {
                        final int index =
                            _panelData.indexOf(expansionPanelData);
                        _showPreview.add(false);
                        print("$index");
                        // สร้าง TextEditingController สำหรับชื่อเนื้อหาและรายละเอียดเนื้อหา
                        contentNameControllers.add(TextEditingController());
                        _contentController.add(QuillController.basic());
                        return ExpansionPanelRadio(
                          backgroundColor: Colors.white,
                          value: index,
                          canTapOnHeader: true,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              tileColor: Colors.white,
                              leading: IconButton(
                                onPressed: () {
                                  setState(() {
                                    clearAndRemoveData(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Color(0xFFFF543E),
                                ),
                              ),
                              title: Text(
                                'เนื้อหาย่อยที่ ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          },
                          body: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // เอาไว้เปลี่ยน layout จากตอนแรก Row เป็น Column ถ้าหน้าจอย่อลง
                                screenSize == ScreenSize.minidesktop
                                    ? Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 1100,
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
                                                  const SizedBox(height: 20),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0, right: 0),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffCFD3D4)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            contentNameControllers[
                                                                index],
                                                        maxLength: 20,
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0, right: 0),
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
                                                  const SizedBox(height: 30),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0, right: 0),
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
                                                  SizedBox(
                                                    height: 400,
                                                    child: Expanded(
                                                        child: Container(
                                                      child: Column(
                                                        children: [
                                                          QuillToolbar.simple(
                                                            configurations:
                                                                QuillSimpleToolbarConfigurations(
                                                              controller:
                                                                  _contentController[
                                                                      index],
                                                              sharedConfigurations:
                                                                  const QuillSharedConfigurations(
                                                                locale: Locale(
                                                                    'de'),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: QuillEditor
                                                                .basic(
                                                              configurations:
                                                                  QuillEditorConfigurations(
                                                                controller:
                                                                    _contentController[
                                                                        index],
                                                                placeholder:
                                                                    'เขียนข้อความที่นี่...',
                                                                readOnly: false,
                                                                sharedConfigurations:
                                                                    const QuillSharedConfigurations(
                                                                  locale:
                                                                      Locale(
                                                                          'de'),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
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
                                                  Container(
                                                   
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    height: 250.0,
                                                    child: Center(
                                                      child: expansionPanelData
                                                              .itemPhotosWidgetList
                                                              .isEmpty
                                                          ? SizedBox(
                                                              child: expansionPanelImagesList
                                                                              .length >
                                                                          index &&
                                                                      expansionPanelImagesList[
                                                                              index]
                                                                          .isNotEmpty
                                                                  ? Column(
                                                                      children: [
                                                                        CarouselSlider(
                                                                          options:
                                                                              CarouselOptions(
                                                                            height:
                                                                                200.0,
                                                                            viewportFraction:
                                                                                1,
                                                                            enlargeCenterPage:
                                                                                true,
                                                                            enableInfiniteScroll:
                                                                                false,
                                                                            onPageChanged:
                                                                                (index, reason) {
                                                                              setState(() {
                                                                                _current = index;
                                                                              });
                                                                            },
                                                                          ),
                                                                          items: expansionPanelImagesList[index]
                                                                              .asMap()
                                                                              .entries
                                                                              .map<Widget>((entry) {
                                                                            int imageIndex =
                                                                                entry.key;
                                                                            XFile
                                                                                xFile =
                                                                                entry.value;
                                                                            return Stack(
                                                                              children: [
                                                                                Container(
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                                  child: ClipRRect(
                                                                                    child: SizedBox(
                                                                                      height: 200.0,
                                                                                      child: kIsWeb
                                                                                          ? Image.network(
                                                                                              xFile.path,
                                                                                              fit: BoxFit.cover,
                                                                                            )
                                                                                          : Image.file(
                                                                                              File(xFile.path),
                                                                                              fit: BoxFit.cover,
                                                                                            ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Positioned(
                                                                                  bottom: 8.0,
                                                                                  right: 8.0,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      IconButton(
                                                                                        onPressed: () {
                                                                                          editImage(index, imageIndex);
                                                                                        },
                                                                                        icon: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          padding: EdgeInsets.all(8.0),
                                                                                          child: const Icon(
                                                                                            Icons.edit,
                                                                                            color: Colors.yellow,
                                                                                            size: 20.0,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      IconButton(
                                                                                        onPressed: () => deleteImage(index, imageIndex),
                                                                                        icon: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          padding: EdgeInsets.all(8.0),
                                                                                          child: const Icon(
                                                                                            Icons.delete_forever_rounded,
                                                                                            color: Colors.red,
                                                                                            size: 20.0,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: expansionPanelImagesList[index]
                                                                              .asMap()
                                                                              .entries
                                                                              .map((entry) {
                                                                            return GestureDetector(
                                                                              onTap: () => _controller.animateToPage(entry.key),
                                                                              child: Container(
                                                                                width: 8.0,
                                                                                height: 8.0,
                                                                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : GPrimaryColor).withOpacity(_current == entry.key ? 0.9 : 0.4),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : MaterialButton(
                                                                      height:
                                                                          250.0,
                                                                      onPressed:
                                                                          () =>
                                                                              pickPhotoFromGallery(index),
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.5, // Set width of Container to half of screen width
                                                                        child: Image
                                                                            .network(
                                                                          "https://static.thenounproject.com/png/3322766-200.png",
                                                                          height:
                                                                              100.0,
                                                                          width:
                                                                              100.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            )
                                                          : Container(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        pickPhotoFromGallery(
                                                            index),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          GPrimaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "เพิ่มรูปภาพ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      displaycontent(
                                                          expansionPanelData,
                                                          index);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xffE69800),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "แสดงผล",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 1100,
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
                                                  const SizedBox(height: 20),
                                                  Container(
                                                    width: 390,
                                                    height: 750,
                                                    decoration: ShapeDecoration(
                                                      color: const Color(
                                                          0xFFE7E7E7),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
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
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                2,
                                                            child: Expanded(
                                                              child: _previewWidget(
                                                                  expansionPanelData,
                                                                  index),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.34,
                                            height: 1100,
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
                                                  const SizedBox(height: 20),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0, right: 0),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffCFD3D4)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: TextField(
                                                        controller:
                                                            contentNameControllers[
                                                                index],
                                                        maxLength: 20,
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0, right: 0),
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
                                                  const SizedBox(height: 30),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0, right: 0),
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
                                                  SizedBox(
                                                    height: 400,
                                                    child: Expanded(
                                                        child: Container(
                                                      child: Column(
                                                        children: [
                                                          QuillToolbar.simple(
                                                            configurations:
                                                                QuillSimpleToolbarConfigurations(
                                                              controller:
                                                                  _contentController[
                                                                      index],
                                                              sharedConfigurations:
                                                                  const QuillSharedConfigurations(
                                                                locale: Locale(
                                                                    'de'),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: QuillEditor
                                                                .basic(
                                                              configurations:
                                                                  QuillEditorConfigurations(
                                                                controller:
                                                                    _contentController[
                                                                        index],
                                                                placeholder:
                                                                    'เขียนข้อความที่นี่...',
                                                                readOnly: false,
                                                                sharedConfigurations:
                                                                    const QuillSharedConfigurations(
                                                                  locale:
                                                                      Locale(
                                                                          'de'),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
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
                                                    height: 20.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      // color: Colors.red,
                                                      boxShadow: [
                                                        // BoxShadow(
                                                        //   color: Colors.grey.shade200,
                                                        //   offset: const Offset(0.0, 0.5),
                                                        // )
                                                      ],
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height: 250.0,
                                                    child: Center(
                                                      child: expansionPanelData
                                                              .itemPhotosWidgetList
                                                              .isEmpty
                                                          ? SizedBox(
                                                              child: expansionPanelImagesList
                                                                              .length >
                                                                          index &&
                                                                      expansionPanelImagesList[
                                                                              index]
                                                                          .isNotEmpty
                                                                  ? Column(
                                                                      children: [
                                                                        CarouselSlider(
                                                                          options:
                                                                              CarouselOptions(
                                                                            height:
                                                                                200.0,
                                                                            viewportFraction:
                                                                                1,
                                                                            enlargeCenterPage:
                                                                                true,
                                                                            enableInfiniteScroll:
                                                                                false,
                                                                            onPageChanged:
                                                                                (index, reason) {
                                                                              setState(() {
                                                                                _current = index;
                                                                              });
                                                                            },
                                                                          ),
                                                                          items: expansionPanelImagesList[index]
                                                                              .asMap()
                                                                              .entries
                                                                              .map<Widget>((entry) {
                                                                            int imageIndex =
                                                                                entry.key;
                                                                            XFile
                                                                                xFile =
                                                                                entry.value;
                                                                            return Stack(
                                                                              children: [
                                                                                Container(
                                                                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                                  child: ClipRRect(
                                                                                    child: SizedBox(
                                                                                      height: 200.0,
                                                                                      child: kIsWeb
                                                                                          ? Image.network(
                                                                                              xFile.path,
                                                                                              fit: BoxFit.cover,
                                                                                            )
                                                                                          : Image.file(
                                                                                              File(xFile.path),
                                                                                              fit: BoxFit.cover,
                                                                                            ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Positioned(
                                                                                  bottom: 8.0,
                                                                                  right: 8.0,
                                                                                  child: Row(
                                                                                    children: [
                                                                                      IconButton(
                                                                                        onPressed: () {
                                                                                          editImage(index, imageIndex);
                                                                                        },
                                                                                        icon: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          padding: EdgeInsets.all(8.0),
                                                                                          child: const Icon(
                                                                                            Icons.edit,
                                                                                            color: Colors.yellow,
                                                                                            size: 20.0,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      IconButton(
                                                                                        onPressed: () => deleteImage(index, imageIndex),
                                                                                        icon: Container(
                                                                                          decoration: const BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          padding: EdgeInsets.all(8.0),
                                                                                          child: const Icon(
                                                                                            Icons.delete_forever_rounded,
                                                                                            color: Colors.red,
                                                                                            size: 20.0,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: expansionPanelImagesList[index]
                                                                              .asMap()
                                                                              .entries
                                                                              .map((entry) {
                                                                            return GestureDetector(
                                                                              onTap: () => _controller.animateToPage(entry.key),
                                                                              child: Container(
                                                                                width: 8.0,
                                                                                height: 8.0,
                                                                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : GPrimaryColor).withOpacity(_current == entry.key ? 0.9 : 0.4),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : MaterialButton(
                                                                      height:
                                                                          250.0,
                                                                      onPressed:
                                                                          () =>
                                                                              pickPhotoFromGallery(index),
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.5, // Set width of Container to half of screen width
                                                                        child: Image
                                                                            .network(
                                                                          "https://static.thenounproject.com/png/3322766-200.png",
                                                                          height:
                                                                              100.0,
                                                                          width:
                                                                              100.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            )
                                                          : Container(),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        pickPhotoFromGallery(
                                                            index),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          GPrimaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "เพิ่มรูปภาพ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      displaycontent(
                                                          expansionPanelData,
                                                          index);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xffE69800),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "แสดงผล",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.34,
                                            height: 1100,
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
                                                  const SizedBox(height: 20),
                                                  Container(
                                                    width: 390,
                                                    height: 750,
                                                    decoration: ShapeDecoration(
                                                      color: const Color(
                                                          0xFFE7E7E7),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        side: const BorderSide(
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
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                2,
                                                            child: Expanded(
                                                              child: _previewWidget(
                                                                  expansionPanelData,
                                                                  index),
                                                              // _displayedcontentWidget ??
                                                              //     Container(),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final nameController = TextEditingController();
                        
                          final detailController = QuillController.basic();

                          List<Widget> expansionPanelImagesList =
                              []; // สร้างรายการว่างสำหรับรูปภาพ

                          // List<List<Widget>> expansionPanelImagesList = [];
                          // contentNameControllers.add(TextEditingController());
                          // _contentController.add(QuillController.basic());

                          _panelData.add(ExpansionPanelData(
                            nameController: nameController,
                            detailController: detailController,
                            itemPhotosWidgetList:
                                expansionPanelImagesList, // ให้รายการรูปภาพใน ExpansionPanelData เป็นรายการว่าง
                          ));
                          debugPrint(
                              "_panelData.length = ${_panelData.length}");
                          debugPrint(
                              "expansionPanelImagesList = $expansionPanelImagesList");
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        elevation: 3,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.add_box_rounded, color: GPrimaryColor),
                            SizedBox(width: 8),
                            Text(
                              "เพิ่มเนื้อหาย่อย",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 70.0, top: 50.0, bottom: 50),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => DialogCancle(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0x00c5c5c5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "ยกเลิก",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            for (int i = 0;
                                i < expansionPanelImagesList.length;
                                i++) {
                              final deltaJson = _contentController[i]
                                  .document
                                  .toDelta()
                                  .toJson();
                              print("$deltaJson");

                              final converter = QuillDeltaToHtmlConverter(
                                List.castFrom(deltaJson),
                              );
                              _html = converter.convert();

                              htmlList.add(_html);
                              print("$htmlList");
                            }

                            print("$htmlLists");
                    
                            uploadImageAndSaveItemInfo();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            backgroundColor: GPrimaryColor,
                          ),
                          child: uploading
                              ? const SizedBox(
                                  height: 15.0,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text(
                                  "เพิ่ม",
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
    );
  }

  
  Future<void> pickPhotoFromGallery(int index) async {
    print("srr");
    List<XFile>? newPhotos = await _picker.pickMultiImage();
    setState(() {
      print("srr11");
      if (expansionPanelImagesList.length <= index) {
        expansionPanelImagesList.add(newPhotos);
        print("$expansionPanelImagesList");
      } else {
        expansionPanelImagesList[index].addAll(newPhotos);
      }
      print("${expansionPanelImagesList[index]}");
    });
  }

  Future<void> editImage(int panelIndex, int imageIndex) async {
    final editedPhoto =
        await _picker.pickImage(source: pickerImageSource.ImageSource.gallery);
    if (editedPhoto != null) {
      setState(() {
        expansionPanelImagesList[panelIndex][imageIndex] = editedPhoto;
      });
    }
  }

  void deleteImage(int panelIndex, int imageIndex) {
    setState(() {
      expansionPanelImagesList[panelIndex].removeAt(imageIndex);
      if (expansionPanelImagesList[panelIndex].isEmpty) {
        expansionPanelImagesList.removeAt(panelIndex);
      }
    });
  }

  Future<void> uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    for (int panelIndex = 0;
        panelIndex < expansionPanelImagesList.length;
        panelIndex++) {
      List<XFile> panelImages = expansionPanelImagesList[panelIndex];
      debugPrint("$panelImages");
      String? contentId = const Uuid().v4().substring(0, 10);

      for (int i = 0; i < panelImages.length; i++) {
        PickedFile pickedFile = PickedFile(panelImages[i].path);
        await uploadImageToStorage(pickedFile, contentId, i, panelIndex);
      }
    }

    await addAllContent(ListimageUrl);
    setState(() {
      uploading = false;
    });
  }

  uploadImageToStorage(PickedFile pickedFile, String contentId, int index,
      int panelIndex) async {
    String? kId = const Uuid().v4().substring(0, 10);
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Content/$contentId/contentImg_$kId');

    await reference.putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );

    String imageUrl = await reference.getDownloadURL();
    debugPrint(imageUrl);
    debugPrint("$ListimageUrl");
    setState(() {
      ListimageUrl.add(imageUrl);
      // debugPrint(ListimageUrl);
    });
  }

  // Future<String> addContent(
  //     String contentName, String contentDetail, String imageUrl) async {
  //   Map<String, dynamic> contentMap = {
  //     "ContentName": contentName,
  //     "ContentDetail": contentDetail,
  //     "image_url": imageUrl,
  //     "create_at": Timestamp.now(),
  //     "deleted_at": null,
  //     "update_at": null,
  //   };
  //   String contentId = const Uuid().v4().substring(0, 10);
  //   await Databasemethods().addContent(contentMap, contentId);
  //   debugPrint("addContent success");
  //   debugPrint("contentName $contentName");
  //   debugPrint("ContentDetail $contentDetail");
  //   return contentId;
  // }

  Future<String> addContent(
      String contentName, String contentDetail, List<String> imageUrls) async {
    Map<String, dynamic> contentMap = {
      "ContentName": contentName,
      "ContentDetail": contentDetail,
      "image_url": imageUrls, // เปลี่ยนเป็น List
      "create_at": Timestamp.now(),
      "deleted_at": null,
      "update_at": null,
    };
    String contentId = const Uuid().v4().substring(0, 10);
    await Databasemethods().addContent(contentMap, contentId);
    print("addContent success");
    print("contentName $contentName");
    print("ContentDetail $contentDetail");
    print("imageUrls $imageUrls");
    return contentId;
  }

  Future<void> addAllContent(List<String> imageUrl) async {
    if (namecontroller.text.isEmpty || _selectedValue == null) {
      Fluttertoast.showToast(
        msg: "กรุณากรอกข้อมูลให้ครบ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    List<String> contentIds = [];
    print("list ${itemImagesList.length}");


    for (int panelIndex = 0;
        panelIndex < expansionPanelImagesList.length;
        panelIndex++) {
      List<XFile> panelImages = expansionPanelImagesList[panelIndex];
      String contentName = contentNameControllers[panelIndex].text;
      String contentDetail = htmlList[panelIndex];

      // สร้าง List ของ URL สำหรับแต่ละ panel
      List<String> panelImageUrls = [];
      for (int i = 0; i < panelImages.length; i++) {
        panelImageUrls.add(ListimageUrl[panelIndex * panelImages.length + i]);
      }

      // เรียกใช้ addContent ด้วย List ของ URL
      String contentId =
          await addContent(contentName, contentDetail, panelImageUrls);
      contentIds.add(contentId);
    }

    if (contentIds.isEmpty) {
      Fluttertoast.showToast(
        msg: "กรุณาเพิ่มข้อมูลของเนื้อหา",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    // Generate a knowledge ID
    String knowledgeId = const Uuid().v4().substring(0, 10);
    // Prepare knowledge data
    Map<String, dynamic> knowledgeMap = {
      "KnowledgeName": namecontroller.text,
      "KnowledgeIcons": _selectedValue,
      "create_at": Timestamp.now(),
      "deleted_at": null,
      "update_at": null,
      "Content": contentIds,
    };
    debugPrint("addKnowledge success");
    debugPrint("KnowledgeName ${namecontroller.text}");
    debugPrint("contentId $contentIds");

    // Add knowledge to Firebase
    await Databasemethods()
        .addKnowlege(knowledgeMap, knowledgeId)
        .then((value) {
      showDialog(
        context: context,
        builder: (context) => const Addknowledgedialog(),
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

  void clearAndRemoveData(int index) {
    setState(() {
      contentNameControllers[index].clear();
      _contentController[index].clear();
      if (expansionPanelImagesList.isNotEmpty &&
          expansionPanelImagesList[index].isNotEmpty) {
        expansionPanelImagesList[index].clear();
        expansionPanelImagesList.removeAt(index);
      }
      _deletedPanels.add(index);
      _panelData.removeAt(index);
      contentNameControllers.removeAt(index);
      _contentController.removeAt(index);
      _showPreview.removeAt(index);
      debugPrint("$expansionPanelImagesList");
    });
  }

  Widget _displayedWidget = Container();
  Widget _displayedcontentWidget = Container();
  List<Widget> _displayedWidgetHtmlWidget =
      List.generate(_panelData.length, (_) => Container());

  Widget _displaycontentWidget(
      ExpansionPanelData expansionPanelData, int index) {
    return Scaffold(
      appBar: Appbarmain_no_botton(
        name: contentNameControllers.isNotEmpty
            ? contentNameControllers[index].text
            : '',
      ),
      body: Stack(
        children: [
          if (expansionPanelImagesList.length > index &&
              expansionPanelImagesList[index].isNotEmpty)
            Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.3,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                  items: expansionPanelImagesList[index]
                      .asMap()
                      .entries
                      .map<Widget>((entry) {
                    XFile xFile = entry.value;
                    return Stack(
                      children: [
                        Container(
                          child: ClipRRect(
                            child: SizedBox(
                              child: kIsWeb
                                  ? Image.network(
                                      xFile.path,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    )
                                  : Image.file(
                                      File(xFile.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: itemPhotosWidgetList.map((url) {
                    int index = itemPhotosWidgetList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            )
          else
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.grey[200], // สีพื้นหลังเมื่อไม่มีรูปภาพ
              child: Center(
                child: Text(
                  'ไม่มีรูปภาพ',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: 200),
            height: MediaQuery.of(context).size.width * 1.85,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            decoration: const BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
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
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        contentNameControllers[index].text,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _displayedWidgetHtmlWidget[index],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewWidget(ExpansionPanelData expansionPanelData, int index) {
    return _showPreview[index]
        ? Container(
            child: Column(
              children: [
                Expanded(
                  child: _displayedcontentWidget,
                )
              ],
            ),
          )
        : Container(); // แสดงเป็น Container เปล่าถ้า _showPreview[index] เป็น false
  }

  void displaycontent(ExpansionPanelData expansionPanelData, int index) {
    setState(() {
      if (_displayedWidgetHtmlWidget.length != _panelData.length) {
        _displayedWidgetHtmlWidget =
            List.generate(_panelData.length, (_) => Container());
      }
      final deltaJson = _contentController[index].document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(List.castFrom(deltaJson));
      final html = converter.convert();

      _displayedWidgetHtmlWidget[index] = HtmlWidget(
        html,
        textStyle: const TextStyle(color: Colors.black, fontSize: 15),
        renderMode: RenderMode.column,
        customStylesBuilder: (element) {
          if (element.classes.contains('p')) {
            return {'color': 'red'};
          }
          return null;
        },
      );

      _displayedcontentWidget =
          _displaycontentWidget(expansionPanelData, index);
      _showPreview[index] =
          true; // อัปเดตค่า _showPreview ของ index นั้นเป็น true
    });
  }

  Widget _displaycoverWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: WhiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Icon(
                  icons[_selectedValue] ??
                      Icons.error, // ระบุไอคอนตามค่าที่เลือก
                  size: 24, // ขนาดของไอคอน
                  color: GPrimaryColor, // สีของไอคอน
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  namecontroller.text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 9),
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

  void display() {
    // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
    setState(() {
      // เรียกใช้งาน Widget ที่จะแสดงผล
      _displayedWidget = _displaycoverWidget();
    });
  }
}
