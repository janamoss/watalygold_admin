import 'dart:io';

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
import 'package:watalygold_admin/Page/test.dart';
import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogCancle.dart';
import 'package:watalygold_admin/Widgets/knowlege.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'dart:ui_web';

Map<String, IconData> icons = {
  'สถิติ': Icons.analytics_outlined,
  'ดอกไม้': Icons.yard,
  'หนังสือ': Icons.book,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded,
  'คำถาม': Icons.quiz_outlined,
};

class Singlecontent extends StatefulWidget {
  const Singlecontent({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColor,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: 1200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            Row(
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
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0),
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
                                              : SizedBox(),
                                          SizedBox(width: 15),
                                          Text(
                                            value,
                                            style:
                                                TextStyle(color: GPrimaryColor),
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
                                  hint: Row(
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
                                            color: GPrimaryColor, fontSize: 17),
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
                                  const EdgeInsets.only(left: 0.0, right: 0),
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
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0),
                              child: Container(
                                padding: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffCFD3D4)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  controller: nameController,
                                  maxLength: 30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0),
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
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0),
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
                            Container(
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
                                        configurations: QuillEditorConfigurations(
                                          controller: _contentController,
                                          placeholder: 'เขียนข้อความที่นี่...',
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
                            // Container(
                            //   color: Colors.white38,
                            //   child: Expanded(
                            //     child: testss(),
                            //   ),
                            // ),

                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(left: 0.0, right: 0),
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //         border:
                            //             Border.all(color: Color(0xffCFD3D4)),
                            //         borderRadius: BorderRadius.circular(5)),
                            //     child: TextField(
                            //       controller: contentController,
                            //       keyboardType: TextInputType.multiline,
                            //       maxLines: 5,
                            //       decoration: InputDecoration(
                            //           focusedBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(
                            //                   width: 1, color: Colors.white))),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
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
                                  borderRadius: BorderRadius.circular(12.0),
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
                                            alignment: Alignment.bottomCenter,
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
                                          children: itemPhotosWidgetList,
                                          alignment: WrapAlignment.spaceEvenly,
                                          runSpacing: 10.0,
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "เพิ่มรูปภาพ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            ElevatedButton(
                              onPressed: display,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffE69800),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "แสดงผล",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // SizedBox
                    Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: 1200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            Row(
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
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: 390,
                              height: 100,
                              decoration: ShapeDecoration(
                                color: Color(0xFFE7E7E7),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 5, color: GPrimaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: _displayedWidget ?? Container(),
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
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 5, color: GPrimaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
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
                            backgroundColor: Color(0xC5C5C5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                          onPressed: () {
                            final deltaJson =
                                _contentController.document.toDelta().toJson();
                            print(deltaJson);

                            final converter = QuillDeltaToHtmlConverter(
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
                                horizontal: 20.0, vertical: 15.0),
                            backgroundColor: GPrimaryColor,
                          ),
                          child: uploading
                              ? SizedBox(
                                  child: CircularProgressIndicator(),
                                  height: 15.0,
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

  void addImage() {
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

  List<XFile?> latestPickedPhotos = [];

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

  Future<String> uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? knowledgetId = const Uuid().v4().substring(0, 10);

    // ใช้ latestPickedPhotos เพื่อเลือกรูปภาพที่เพิ่มล่าสุดเท่านั้น
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

  upload() async {
    final deltaJson = _contentController.document.toDelta().toJson();
    print(deltaJson);

    final converter = QuillDeltaToHtmlConverter(
      List.castFrom(deltaJson),
    );
    _html = converter.convert();
    print(_html);
    String knowledgetId = await uploadImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
  }

  // Future<String> uploadImageAndSaveItemInfo() async {
  //   setState(() {
  //     uploading = true;
  //   });
  //   PickedFile? pickedFile;
  //   String? knowledgetId = const Uuid().v4().substring(0, 10);
  //   for (int i = 0; i < itemImagesList.length; i++) {
  //     file = File(itemImagesList[i].path);
  //     pickedFile = PickedFile(file!.path);

  //     await uploadImageToStorage(pickedFile, knowledgetId);
  //   }
  //   return knowledgetId;
  // }

  uploadImageToStorage(PickedFile? pickedFile, String knowledgetId) async {
    String? kId = const Uuid().v4().substring(0, 10);
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Knowledge/$knowledgetId/knowledImg_$kId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String imageUrl = await reference.getDownloadURL();
    addKnowledge(imageUrl);
  }

  bool _isKnowledgeAdded = false;

  Future<void> addKnowledge(String imageUrl) async {
    // ตรวจสอบความสมบูรณ์ของข้อมูล
    if (nameController.text.isEmpty ||
        _selectedValue == null ||
        imageUrl == null) {
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
      _isKnowledgeAdded =
          true; // กำหนดให้ไม่สามารถเพิ่มความรู้อีกได้ระหว่างการดำเนินการ

      // สร้าง ID ใหม่
      String Id = const Uuid().v4().substring(0, 10);

      // สร้างข้อมูล Knowledge
      Map<String, dynamic> knowledgeMap = {
        "KnowledgeName": nameController.text,
        "KnowledgeDetail": _html,
        "KnowledgeIcons": _selectedValue,
        "KnowledgeImg": imageUrl,
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

  void clearAllFields() {
    nameController.clear();
    _contentController.clear();

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
                SizedBox(
                  width: 20,
                ),
                Icon(
                  icons[_selectedValue] ??
                      Icons.error, // ระบุไอคอนตามค่าที่เลือก
                  size: 24, // ขนาดของไอคอน
                  color: GPrimaryColor, // สีของไอคอน
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  nameController.text,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Spacer(),
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
            itemCount: itemPhotosWidgetList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 390,
                child: itemPhotosWidgetList[index],
                // ใส่รูปภาพลงใน Container
              );
            },
          ),
          Positioned(
            // ใช้ตัวแปร _positionY แทนค่า top
            bottom: 0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
            left: 0.0,
            right: 0.0,
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
                    ],
                  ),
                  SizedBox(
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
