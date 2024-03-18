import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/DeletedialogContent.dart';
import 'package:watalygold_admin/Widgets/knowlege.dart';
import 'package:watalygold_admin/service/database.dart';

Map<String, IconData> icons = {
  'บ้าน': Icons.home,
  'ดอกไม้': Icons.yard,
  'บุคคล': Icons.person,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded
};

class ExpansionPanelData {
  TextEditingController nameController;
  TextEditingController detailController;
  List<Widget> itemPhotosWidgetList;

  ExpansionPanelData({
    required this.nameController,
    required this.detailController,
    required this.itemPhotosWidgetList,
  });
}

List<ExpansionPanelData> _panelData = [];

class Multiplecontent extends StatefulWidget {
  const Multiplecontent({Key? key}) : super(key: key);

  @override
  _MultiplecontentState createState() => _MultiplecontentState();
}

class _MultiplecontentState extends State<Multiplecontent> {
  IconData? selectedIconData;
  String? _selectedValue;

  int _currentExpandedIndex = -1;
  bool addedContent = false;
  TextEditingController contentcontroller = new TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController contentdetailcontroller = TextEditingController();
  TextEditingController contentnamecontroller = TextEditingController();
  List<TextEditingController> contentNameControllers = [];
  List<TextEditingController> contentDetailControllers = [];
  final List<List<XFile>> _imagesForPanels = [];

  List<Widget> _displayedContentWidgets =
      List.filled(_panelData.length, Container());

  List<int> _deletedPanels = [];
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColor,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 70),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 490,
                      height: 400,
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
                                Image.asset("assets/images/knowlege.png"),
                                SizedBox(width: 10),
                                Text(
                                  "เพิ่มคลังความรู้",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'IBM Plex Sans Thai',
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
                                        fontFamily: 'IBM Plex Sans Thai',
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontFamily: 'IBM Plex Sans Thai',
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
                                    'บ้าน',
                                    'ดอกไม้',
                                    'บุคคล',
                                    'น้ำ',
                                    'ระวัง'
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
                                        color: G2PrimaryColor,
                                      ), // ไอคอนที่ต้องการเพิ่ม
                                      SizedBox(
                                          width:
                                              10), // ระยะห่างระหว่างไอคอนและข้อความ
                                      Text(
                                        "เลือกไอคอนสำหรับคลังความรู้",
                                        style: TextStyle(
                                            color: G2PrimaryColor,
                                            fontSize: 17),
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
                                        fontFamily: 'IBM Plex Sans Thai',
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontFamily: 'IBM Plex Sans Thai',
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
                                  controller: namecontroller,
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              height: 20.0,
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
                      width: 490,
                      height: 400,
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
                                    fontFamily: 'IBM Plex Sans Thai',
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
                                      width: 5, color: Color(0xFF42BD41)),
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
                          ],
                        ),
                      ),
                    ),
                    // Container
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 70),
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
                      final int index = _panelData.indexOf(expansionPanelData);
                      
                      // สร้าง TextEditingController สำหรับชื่อเนื้อหาและรายละเอียดเนื้อหา
                      contentNameControllers.add(TextEditingController());
                      contentDetailControllers.add(TextEditingController());

                      return ExpansionPanelRadio(
                        backgroundColor: Colors.white,
                        value: index,
                        canTapOnHeader: true,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            tileColor: Colors.white,
                            leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  _deletedPanels.add(index);
                                  _panelData.removeAt(index);
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Color(0xFFFF543E),
                              ),
                            ),
                            title: Text(
                              'เนื้อหาย่อยที่${index + 1}',
                              style: TextStyle(
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 490,
                                    height: 750,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "ชื่อ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'IBM Plex Sans Thai',
                                                    ),
                                                  ),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'IBM Plex Sans Thai',
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
                                                  EdgeInsets.only(left: 10.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffCFD3D4)),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: TextField(
                                                controller:
                                                    contentNameControllers[
                                                        index],
                                                decoration: InputDecoration(
                                                    border: InputBorder.none),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "เนื้อหา",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'IBM Plex Sans Thai',
                                                    ),
                                                  ),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'IBM Plex Sans Thai',
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
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xffCFD3D4)),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: TextField(
                                                controller:
                                                    contentDetailControllers[
                                                        index],
                                                keyboardType:
                                                    TextInputType.multiline,
                                                maxLines: 5,
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .white))),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0, right: 0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "รูปภาพ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'IBM Plex Sans Thai',
                                                    ),
                                                  ),
                                                  Text(
                                                    "*",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18,
                                                      fontFamily:
                                                          'IBM Plex Sans Thai',
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
                                                    offset:
                                                        const Offset(0.0, 0.5),
                                                    blurRadius: 30.0,
                                                  )
                                                ]),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 200.0,
                                            child: Center(
                                              child: expansionPanelData
                                                      .itemPhotosWidgetList
                                                      .isEmpty
                                                  ? Center(
                                                      child: MaterialButton(
                                                        onPressed: () {
                                                          pickPhotoFromGallery(
                                                              _panelData[
                                                                  index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
                                                        },
                                                        child: Container(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Center(
                                                            child:
                                                                Image.network(
                                                              "https://static.thenounproject.com/png/3322766-200.png",
                                                              height: 100.0,
                                                              width: 100.0,
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
                                                        direction:
                                                            Axis.horizontal,
                                                        children: expansionPanelData
                                                            .itemPhotosWidgetList,
                                                        alignment: WrapAlignment
                                                            .spaceEvenly,
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
                                              pickPhotoFromGallery(
                                                  expansionPanelData);
                                              setState(() {
                                                // เรียกใช้ addImage เพื่อเพิ่มรูปภาพใหม่
                                                addImage(expansionPanelData);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: G2PrimaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              "เพิ่มรูปภาพ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          ElevatedButton(
                                            onPressed: () {
                                              displaycontent(
                                                  expansionPanelData, index);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffE69800),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                  Container(
                                    width: 490,
                                    height: 700,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: 390,
                                            height: 600,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFE7E7E7),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 5,
                                                    color: Color(0xFF42BD41)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child:
                                                      _displayedcontentWidget ??
                                                          Container(),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 70),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        final nameController = TextEditingController();
                        final detailController = TextEditingController();
                        List<Widget> itemPhotosWidgetList =
                            []; // สร้างรายการว่างสำหรับรูปภาพ

                        _panelData.add(ExpansionPanelData(
                          nameController: nameController,
                          detailController: detailController,
                          itemPhotosWidgetList:
                              itemPhotosWidgetList, // ให้รายการรูปภาพใน ExpansionPanelData เป็นรายการว่าง
                        ));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 3,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.add_box_rounded, color: Color(0xFF42BD41)),
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
                Padding(
                  padding:
                      const EdgeInsets.only(right: 70.0, top: 50.0, bottom: 50),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            clearAllFields();
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
                            // addKnowlege();
                            uplaodImageAndSaveItemInfo();
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

  void removeImage() {
    setState(() {
      itemPhotosWidgetList.clear(); // ลบภาพเดิมทั้งหมด
    });
  }

  // pickPhotoFromGallery() async {
  //   photo = await _picker.pickMultiImage();
  //   if (photo != null) {
  //     setState(() {
  //       itemImagesList = itemImagesList + photo!;
  //       addImage();
  //       photo!.clear();
  //     });
  //   }
  // }

  Future<void> pickPhotoFromGallery(
      ExpansionPanelData expansionPanelData) async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        addImage(expansionPanelData);
        photo!.clear();
      });
      // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
    }
  }

  void addImage(ExpansionPanelData expansionPanelData) {
    // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
    expansionPanelData.itemPhotosWidgetList.clear();

    // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
    for (var bytes in photo!) {
      expansionPanelData.itemPhotosWidgetList.add(
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: 200.0,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                child: kIsWeb
                    ? Image.network(File(bytes.path).path)
                    : Image.file(
                        File(bytes.path),
                      ),
              ),
            ),
          ),
        ),
      );
    }
  }

  // void addImage() {
  //   removeImage(); // ลบภาพเดิมก่อนที่จะเพิ่มภาพใหม่
  //   for (var bytes in photo!) {
  //     itemPhotosWidgetList.add(Padding(
  //       padding: const EdgeInsets.all(0),
  //       child: Container(
  //         height: 200.0,
  //         child: AspectRatio(
  //           aspectRatio: 16 / 9,
  //           child: Container(
  //             child: kIsWeb
  //                 ? Image.network(File(bytes.path).path)
  //                 : Image.file(
  //                     File(bytes.path),
  //                   ),
  //           ),
  //         ),
  //       ),
  //     ));
  //   }
  // }

  Future<void> uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? contentId = const Uuid().v4().substring(0, 10);
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      print(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);
      await uploadImageToStorage(pickedFile, contentId, i);
    }
    await addAllContent(ListimageUrl);
    // เรียกใช้ addAllContentOnce เพื่อเพิ่มข้อมูลลง Firebase Firestore ครั้งเดียวเท่านั้น
    setState(() {
      uploading = false;
    });
  }

  // upload() async {
  //   String contentId = await uplaodImageAndSaveItemInfo();
  //   setState(() {
  //     uploading = false;
  //   });
  // }

  uploadImageToStorage(PickedFile? pickedFile, String contentId, index) async {
    String? kId = const Uuid().v4().substring(0, 10);
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Content/$contentId/contentImg_$kId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String imageUrl = await reference.getDownloadURL();
    print(imageUrl);
    print(ListimageUrl);
    setState(() {
      ListimageUrl.add(imageUrl);
      print(ListimageUrl);
    });
  }

  Future<void> addAllContent(List<String> imageUrl) async {
    // ตรวจสอบว่า addAllContent ถูกเรียกใช้ครั้งแรกหรือไม่
    //// ตั้งค่าให้ addedContent เป็น true เพื่อบอกว่า addAllContent ถูกเรียกใช้แล้วครั้งแรก

    // Validate user input
    if (namecontroller.text.isEmpty ||
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

    List<String> contentIds = [];
    print("list ${ itemImagesList.length}");
    // Loop through content and add them to Firebase
    for (int index = 0; index < itemImagesList.length; index++) {
      String contentName = contentNameControllers[index].text;
      print(contentName);
      String contentDetail = contentDetailControllers[index].text;
      print(contentDetail);
      String imageurl = ListimageUrl[index].toString();
      print(" img ${imageurl}");

      String contentId = await addContent(contentName, contentDetail, imageurl);
      print("id ${contentId}");
      contentIds.add(contentId);
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

    // Add knowledge to Firebase
    await Databasemethods()
        .addKnowlege(knowledgeMap, knowledgeId)
        .then((value) {
      showDialog(
        context: context,
        builder: (context) => const Addknowledgedialog(),
      );
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
    namecontroller.clear();
    contentcontroller.clear();

    setState(() {
      selectedIconData = null;
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
                  namecontroller.text,
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
          ListView.builder(
            itemCount: expansionPanelData.itemPhotosWidgetList.length,
            itemBuilder: (BuildContext context, int photoIndex) {
              return Container(
                width: 390, // กำหนดความกว้างของรูปภาพ
                height: 253, // กำหนดความสูงของรูปภาพ
                child: expansionPanelData.itemPhotosWidgetList[
                    photoIndex], // ใส่รูปภาพลงใน Container
              );
            },
          ),
          Positioned(
            // ใช้ตัวแปร _positionY แทนค่า top
            bottom: 0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 400,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              decoration: BoxDecoration(
                  color: WhiteColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40))),
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
                        contentNameControllers[index].text,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
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
                        child: Text(
                          contentDetailControllers[index].text,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          textAlign: TextAlign.left,
                          maxLines: null,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
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

  void displaycontent(ExpansionPanelData expansionPanelData, int index) {
    // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
    setState(() {
      if (index < _displayedContentWidgets.length) {
        _displayedContentWidgets[index] =
            _displaycontentWidget(expansionPanelData, index);
      }
    });
  }
}

Future<String> addContent(
      String contentName, String contentDetail, String imageUrl) async {
    Map<String, dynamic> contentMap = {
      "ContentName": contentName,
      "ContentDetail": contentDetail,
      "image_url": imageUrl,
      "create_at": Timestamp.now(),
      "deleted_at": null,
      "update_at": null,
    };

    // Generate a unique ID (replace with your preferred method)
    String contentId = const Uuid().v4().substring(0, 10);

    // Add data using addKnowlege, passing both contentMap and generated ID
    await Databasemethods().addContent(contentMap, contentId);
    return contentId;
  }