import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:random_string/random_string.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Deletedialog.dart';

import 'package:watalygold_admin/service/database.dart';

class AddKnowlege extends StatefulWidget {
  const AddKnowlege({super.key});

  @override
  State<AddKnowlege> createState() => _AddKnowlegeState();
}

class _AddKnowlegeState extends State<AddKnowlege> {
  List<Widget> itemPhotosWidgetList = <Widget>[];

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];

  bool uploading = false;

  String? selectedValue;

  final List<String> genderItems = [
    'Male',
    'Female',
    'Male1',
    'Female1',
    'Male2',
    'Female2',
  ];

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController contentcontroller = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width,
        _screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey,
        body: Container(
            margin: EdgeInsets.only(top: 20.0, left: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.95,
                            child: Container(
                              width: 1000,
                              height: 120,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 75,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // โค้ดเมื่อกดปุ่ม
                                    },
                                    child: Text(
                                      'เนื้อหาเดี่ยว',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'IBM Plex Sans Thai',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF42BD41),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // โค้ดเมื่อกดปุ่ม
                                    },
                                    child: Text(
                                      'หลายเนื้อหา',
                                      style: TextStyle(
                                        color: Color(0x7F000000),
                                        fontSize: 20,
                                        fontFamily: 'IBM Plex Sans Thai',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            // height: MediaQuery.of(context).size.height * 1,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
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
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "ไอคอน",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'IBM Plex Sans Thai',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        children: [
                                          DropdownButtonFormField2<String>(
                                            isExpanded: true,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons
                                                    .add_photo_alternate_outlined,
                                                color: Color(0xffCFD3D4),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xffCFD3D4),
                                                ),
                                              ),
                                            ),
                                            hint: const Text(
                                              'เลือกไอคอน',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            items: genderItems
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                            validator: (value) {
                                              if (value == null) {
                                                return 'กรุณาเลือกไอคอน';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              //Do something when selected item is changed.
                                            },
                                            onSaved: (value) {
                                              selectedValue = value.toString();
                                            },
                                            buttonStyleData:
                                                const ButtonStyleData(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Color(0xffCFD3D4),
                                              ),
                                              iconSize: 24,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffCFD3D4)),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness:
                                                    MaterialStateProperty.all(
                                                        6),
                                                thumbVisibility:
                                                    MaterialStateProperty.all(
                                                        true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "ชื่อ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'IBM Plex Sans Thai',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffCFD3D4)),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextField(
                                        controller: namecontroller,
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "เนื้อหา",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'IBM Plex Sans Thai',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffCFD3D4)),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextField(
                                        controller: contentcontroller,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "รูปภาพ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontFamily: 'IBM Plex Sans Thai',
                                        ),
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
                                    width: _screenwidth * 0.3,
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
                                                children: itemPhotosWidgetList,
                                                alignment:
                                                    WrapAlignment.spaceEvenly,
                                                runSpacing: 10.0,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {},
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
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.9,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50.0, bottom: 50.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
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
                            onPressed: uploading ? null : () => upload(),
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
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     String Id = randomAlphaNumeric(10);
                          //     Map<String, dynamic> knowledgeMap = {
                          //       "KnowledgeName": namecontroller.text
                          //     };
                          //     await Databasemethods()
                          //         .addKnowlege(knowledgeMap, Id)
                          //         .then((value) {
                          //       Fluttertoast.showToast(
                          //           msg: "add knowlege successfully",
                          //           toastLength: Toast.LENGTH_SHORT,
                          //           gravity: ToastGravity.CENTER,
                          //           timeInSecForIosWeb: 1,
                          //           backgroundColor: Colors.red,
                          //           textColor: Colors.white,
                          //           fontSize: 16.0);
                          //     });
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: GPrimaryColor,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   child: Text(
                          //     "เพิ่ม",
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  addImage() {
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          height: 90.0,
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
      ));
    }
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        addImage();
        photo!.clear();
      });
    }
  }

  upload() async {
    String knowledgetId = await uplaodImageAndSaveItemInfo();
    setState(() {
      uploading = false;
    });
    // showToast("Image Uploaded Successfully");
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? knowledgetId = const Uuid().v4();
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, knowledgetId);
    }
    return knowledgetId;
  }

  uploadImageToStorage(PickedFile? pickedFile, String knowledgetId) async {
    String? kId = const Uuid().v4();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Knowledge/$knowledgetId/knowledImg_$kId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl.add(value);
  }
}
