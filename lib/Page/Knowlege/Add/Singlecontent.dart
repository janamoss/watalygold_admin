import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogCancle.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:watalygold_admin/service/screen_unit.dart';
import 'package:flutter_widget_from_html_core/src/core_data.dart'
    as htmlImageSource;
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

class Singlecontent extends StatefulWidget {
  const Singlecontent({super.key});

  @override
  _SinglecontentState createState() => _SinglecontentState();
}

class _SinglecontentState extends State<Singlecontent> {
  IconData? selectedIconData;
  String? _selectedValue;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final QuillController _contentController = QuillController.basic();
  String _html = '';
  List<Widget> itemPhotosWidgetList = <Widget>[];
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  List<String> downloadUrl = <String>[];
  bool uploading = false;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    // ตัวแปรที่เอาไว้วัดขนาดหน้าจอว่าตอนนี้เท่าไหร่แล้ว
    ScreenSize screensize = getScreenSize(context);
    return Scaffold(
      backgroundColor: GrayColor,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              children: [
                // เอาไว้เปลี่ยน layout จากตอนแรก Row เป็น Column ถ้าหน้าจอย่อลง
                screensize == ScreenSize.minidesktop
                    ? Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1200,
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
                                      child: DropdownButton(
                                        items: <String>[
                                          'สถิติ',
                                          'ดอกไม้',
                                          'หนังสือ',
                                          'น้ำ',
                                          'ระวัง',
                                          'คำถาม'
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
                                            ), // ไอคอนที่ต้องการเพิ่ม
                                            SizedBox(
                                                width:
                                                    10), // ระยะห่างระหว่างไอคอนและข้อความ
                                            Text(
                                              "เลือกไอคอนสำหรับคลังความรู้",
                                              style: TextStyle(
                                                  color: GPrimaryColor,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        value: _selectedValue,
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
                                        controller: nameController,
                                        maxLength:
                                            30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                  const SizedBox(height: 30),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "เนื้อหา",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            "*",
                                            style: TextStyle(
                                              color: Colors.red,
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
                                              controller: _contentController,
                                              sharedConfigurations:
                                                  const QuillSharedConfigurations(
                                                locale: Locale('de'),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: QuillEditor.basic(
                                              configurations:
                                                  QuillEditorConfigurations(
                                                controller: _contentController,
                                                placeholder:
                                                    'เขียนข้อความที่นี่...',
                                                readOnly: false,
                                                sharedConfigurations:
                                                    const QuillSharedConfigurations(
                                                  locale: Locale('de'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                  const SizedBox(height: 50),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "รูปภาพ",
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
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.white70,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            offset: const Offset(0.0, 0.5),
                                            blurRadius: 30.0,
                                          )
                                        ]),
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    child: Center(
                                      child: itemPhotosWidgetList.isEmpty
                                          ? Center(
                                              child: MaterialButton(
                                                onPressed: pickPhotoFromGallery,
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Center(
                                                    child: Image.network(
                                                      "https://static.thenounproject.com/png/3322766-200.png",
                                                      height: 100.0,
                                                      width: 100.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Wrap(
                                                spacing: 5.0,
                                                direction: Axis.horizontal,
                                                alignment:
                                                    WrapAlignment.spaceEvenly,
                                                runSpacing: 10.0,
                                                children: itemPhotosWidgetList,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      pickPhotoFromGallery();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: GPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "เพิ่มรูปภาพ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50.0,
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
                            height: 1200,
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
                                  Container(
                                    width: 390,
                                    height: 750,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFE7E7E7),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 5, color: GPrimaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                2, // กำหนดความสูงของ Container ให้มากกว่าหรือเท่ากับขนาดที่ต้องการเลื่อน

                                            child: _displayedcontentWidget ??
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
                            width: MediaQuery.of(context).size.width * 0.34,
                            height: 1300,
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
                                      child: DropdownButton(
                                        items: <String>[
                                          'สถิติ',
                                          'ดอกไม้',
                                          'หนังสือ',
                                          'น้ำ',
                                          'ระวัง',
                                          'คำถาม'
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
                                            ), // ไอคอนที่ต้องการเพิ่ม
                                            SizedBox(
                                                width:
                                                    10), // ระยะห่างระหว่างไอคอนและข้อความ
                                            Text(
                                              "เลือกไอคอนสำหรับคลังความรู้",
                                              style: TextStyle(
                                                  color: GPrimaryColor,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        value: _selectedValue,
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
                                        controller: nameController,
                                        maxLength:
                                            30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                  const SizedBox(height: 30),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 0.0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "เนื้อหา",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            "*",
                                            style: TextStyle(
                                              color: Colors.red,
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
                                              controller: _contentController,
                                              sharedConfigurations:
                                                  const QuillSharedConfigurations(
                                                locale: Locale('de'),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: QuillEditor.basic(
                                              configurations:
                                                  QuillEditorConfigurations(
                                                controller: _contentController,
                                                placeholder:
                                                    'เขียนข้อความที่นี่...',
                                                readOnly: false,
                                                sharedConfigurations:
                                                    const QuillSharedConfigurations(
                                                  locale: Locale('de'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                  const SizedBox(height: 50),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 0, right: 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "รูปภาพ",
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
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          // BoxShadow(
                                          //   color: Colors.red,
                                          //   offset: const Offset(0.0, 0.5),
                                          //   blurRadius: 30.0,
                                          // )
                                        ]),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: 250.0,
                                    child: Center(
                                        child: itemPhotosWidgetList.isEmpty
                                            ? Center(
                                                child: MaterialButton(
                                                  onPressed:
                                                      pickPhotoFromGallery,
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Center(
                                                      child: Image.network(
                                                        "https://static.thenounproject.com/png/3322766-200.png",
                                                        height: 100.0,
                                                        width: 100.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  Expanded(
                                                    child: CarouselSlider(
                                                      items:
                                                          itemPhotosWidgetList
                                                              .map((photo) {
                                                        return Builder(
                                                          builder: (BuildContext
                                                              context) {
                                                            return Stack(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  height: 250.0,
                                                                  child: photo,
                                                                ),
                                                                Positioned(
                                                                  bottom: 8.0,
                                                                  right: 8.0,
                                                                  child: Row(
                                                                    children: [
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          int index =
                                                                              itemPhotosWidgetList.indexOf(photo);
                                                                          if (index !=
                                                                              -1) {
                                                                            editImage(index);
                                                                          }
                                                                          // editImage(
                                                                          //     itemPhotosWidgetList.indexOf(imageWidget));
                                                                        },
                                                                        icon:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          child:
                                                                              Icon(
                                                                            Icons.edit,
                                                                            color:
                                                                                YellowColor,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          int index =
                                                                              itemPhotosWidgetList.indexOf(photo);
                                                                          if (index !=
                                                                              -1) {
                                                                            deleteImage(index);
                                                                          }
                                                                        },
                                                                        icon:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          padding:
                                                                              EdgeInsets.all(8.0),
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete_forever_rounded,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }).toList(),
                                                      options: CarouselOptions(
                                                        height: 250.0,
                                                        viewportFraction: 1,
                                                        enlargeCenterPage: true,
                                                        enableInfiniteScroll:
                                                            false,
                                                        onPageChanged:
                                                            (index, reason) {
                                                          setState(() {
                                                            _current = index;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children:
                                                        itemPhotosWidgetList
                                                            .asMap()
                                                            .entries
                                                            .map((entry) {
                                                      return GestureDetector(
                                                        onTap: () => _controller
                                                            .animateToPage(
                                                                entry.key),
                                                        child: Container(
                                                          width: 8.0,
                                                          height: 8.0,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      4.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: (Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                    : GPrimaryColor)
                                                                .withOpacity(
                                                                    _current ==
                                                                            entry.key
                                                                        ? 0.9
                                                                        : 0.4),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              )),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      pickPhotoFromGallery();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: GPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "เพิ่มรูปภาพ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50.0,
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
                            height: 1300,
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
                                  Container(
                                    width: 390,
                                    height: 750,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFE7E7E7),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 5, color: GPrimaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                2,
                                            child: _displayedcontentWidget ??
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
                      ),
                Padding(
                  // padding: const EdgeInsets.all(25.0),
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
                            final deltaJson =
                                _contentController.document.toDelta().toJson();
                            debugPrint("$deltaJson");

                            final converter = QuillDeltaToHtmlConverter(
                              List.castFrom(deltaJson),
                            );
                            _html = converter.convert();
                            debugPrint(_html);

                            upload();
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

  int _current = 0;

  void addImage() {
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 200,
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

  Future<void> editImage(int index) async {
    final pickedFile =
        await _picker.pickImage(source: pickerImageSource.ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        itemPhotosWidgetList[index] = SizedBox(
          height: 200,
          child: kIsWeb
              ? Image.network(
                  File(pickedFile.path).path,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(pickedFile.path),
                ),
        );
        itemImagesList[index] = XFile(pickedFile.path);
      });
    }
  }

  void deleteImage(int index) {
    setState(() {
      itemPhotosWidgetList.removeAt(index);
      itemImagesList.removeAt(index); // ลบรูปภาพออกจาก itemImagesList ด้วย
    });
  }

  Future<void> pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null && photo!.isNotEmpty) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        debugPrint("itemImagesList ${itemImagesList}");
        addImage();
      });
    }
  }

  Future<String> uploadImageToStorage(
      PickedFile pickedFile, String knowledgetId) async {
    String kId = const Uuid().v4().substring(0, 10);
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Knowledge/$knowledgetId/knowledImg_$kId');
    await reference.putData(
      await pickedFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String imageUrl = await reference.getDownloadURL();
    return imageUrl; // คืนค่า URL ของรูปภาพที่อัปโหลดสำเร็จ
  }

  upload() async {
    final deltaJson = _contentController.document.toDelta().toJson();
    debugPrint("$deltaJson");

    final converter = QuillDeltaToHtmlConverter(
      List.castFrom(deltaJson),
    );
    _html = converter.convert();
    debugPrint(_html);
    String knowledgetId = await uploadImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
  }

  bool _isKnowledgeAdded = false;

  Future<String> uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String knowledgetId = '';
    List<String> imageUrls = [];

    for (XFile? photo in itemImagesList) {
      if (photo != null) {
        file = File(photo.path);
        pickedFile = PickedFile(file!.path);
        knowledgetId = const Uuid().v4().substring(0, 10);
        String imageUrl = await uploadImageToStorage(pickedFile, knowledgetId);
        imageUrls.add(imageUrl); // เพิ่ม URL รูปภาพลงใน List
      }
    }

    // เรียกใช้งานฟังก์ชัน addKnowledge โดยส่ง List ของ URL รูปภาพ
    await addKnowledge(imageUrls);

    setState(() {
      uploading = false;
    });
    return knowledgetId;
  }

  Future<void> addKnowledge(List<String> imageUrls) async {
    // ตรวจสอบความสมบูรณ์ของข้อมูล
    if (nameController.text.isEmpty || _selectedValue == null) {
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

    // ตรวจสอบว่ามีความรู้หรือยัง
    if (!_isKnowledgeAdded) {
      _isKnowledgeAdded = true;
      // สร้าง ID ใหม่
      String Id = const Uuid().v4().substring(0, 10);
      // สร้างข้อมูล Knowledge
      Map<String, dynamic> knowledgeMap = {
        "KnowledgeName": nameController.text,
        "KnowledgeDetail": _html,
        "KnowledgeIcons": _selectedValue,
        "KnowledgeImg": imageUrls, // ใช้ Map ของ URL รูปภาพที่ได้รับเข้ามา
        "create_at": Timestamp.now(),
        "deleted_at": null,
        "update_at": null,
        "Content": [],
      };

      // เรียกใช้งานฟังก์ชัน addKnowledge จากคลาส DatabaseMethods
      await Databasemethods().addKnowlege(knowledgeMap, Id).then((value) {
        // แสดงกล่องโต้ตอบหลังการเพิ่มความรู้สำเร็จ
        showDialog(
          context: context,
          builder: (context) => const Addknowledgedialog(),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
          context.goNamed("/mainKnowledge");
        });
      }).catchError((error) {
        // แสดงข้อความเตือนเมื่อเกิดข้อผิดพลาดในการเพิ่มความรู้
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
  }

  Widget _displayedWidget = Container();
  Widget _displayedcontentWidget = Container();

  Widget _displaycoverWidget() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        width: 320,
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
                  nameController.text,
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

  Widget _displaycontentWidget() {
    return Scaffold(
      appBar: Appbarmain_no_botton(
        name: nameController.text,
      ),
      body: Stack(
        children: [
          itemPhotosWidgetList.isNotEmpty
              ? itemPhotosWidgetList.length > 1
                  ? Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: itemPhotosWidgetList.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              child: itemPhotosWidgetList[index],
                            );
                          },
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.3,
                            viewportFraction: 1.0,
                            autoPlay: false,
                            enlargeCenterPage: false,
                            // onPageChanged: (index, reason) {
                            //   setState(() {
                            //     _current = index;
                            //   });
                            // },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: itemPhotosWidgetList.map((url) {
                            int index = itemPhotosWidgetList.indexOf(url);
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 2.0),
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
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: itemPhotosWidgetList[0],
                    )
              : Container(
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
                        nameController.text,
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
                        child: _displayedWidgetHtmlWidget),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayedWidgetHtmlWidget = Container();

  void display() {
    // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
    setState(() {
      final deltaJson = _contentController.document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(List.castFrom(deltaJson));
      final html = converter.convert();

      _displayedWidgetHtmlWidget = HtmlWidget(
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
      // เรียกใช้งาน Widget ที่จะแสดงผล
      _displayedWidget = _displaycoverWidget();
      _displayedcontentWidget = _displaycontentWidget();
      // _displayedWidgetHtmlWidget = _displayedWidgetWidget();
    });
  }
}