import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/database.dart';

Map<String, IconData> iconDataMap = {
  'บ้าน': Icons.home,
  'ติดตั้ง': Icons.settings,
  'บุคคล': Icons.person,
};

// List<String> iconNames = iconDataMap.keys.toList();

class Multiplecontent extends StatefulWidget {
  const Multiplecontent({Key? key}) : super(key: key);

  @override
  _SinglecontentState createState() => _SinglecontentState();
}

class _SinglecontentState extends State<Multiplecontent> {
  IconData? selectedIconData;
  TextEditingController contentcontroller = new TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  List<Widget> itemPhotosWidgetList = <Widget>[];
  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];
  List<String> downloadUrl = <String>[];
  bool uploading = false;

  // String getIconName(IconData iconData) {
  //   return iconDataMap.entries
  //       .firstWhere((entry) => entry.value == iconData,
  //           orElse: () => MapEntry("", Icons.error))
  //       .key;
  // }

  // String getIconName(IconData iconData) {
  //   return iconData.toString(); // แปลง IconData เป็น String
  // }
  String getIconDataString(IconData iconData) {
    // ใช้ .codePoint และ .fontFamily เพื่อสร้างค่าที่ unique สำหรับ IconData
    return "${iconData.codePoint}-${iconData.fontFamily}";
  }

  String iconName = 'บ้าน'; // เลือกชื่อ icon ที่ต้องการ

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
                            DropdownButton<IconData>(
                              value: selectedIconData,
                              onChanged: (IconData? newValue) {
                                setState(() {
                                  selectedIconData = newValue;
                                });
                              },
                              items: iconDataMap.entries.map((entry) {
                                String iconName = entry.key;
                                IconData iconData = entry.value;
                                return DropdownMenuItem<IconData>(
                                  value: iconData,
                                  child: Row(
                                    children: [
                                      Icon(
                                        iconData,
                                        color: GPrimaryColor,
                                      ),
                                      SizedBox(width: 8),
                                      Text(iconName),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.0, right: 0),
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
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(left: 0.0, right: 0),
                            //   child: Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text(
                            //       "เนื้อหา",
                            //       style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 18,
                            //         fontFamily: 'IBM Plex Sans Thai',
                            //       ),
                            //     ),
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
                            //       controller: contentcontroller,
                            //       keyboardType: TextInputType.multiline,
                            //       maxLines: 5,
                            //       decoration: InputDecoration(
                            //           focusedBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(
                            //                   width: 1, color: Colors.white))),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 30),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 0, right: 0),
                            //   child: Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text(
                            //       "รูปภาพ",
                            //       style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 18,
                            //         fontFamily: 'IBM Plex Sans Thai',
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(12.0),
                            //       color: Colors.white70,
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.shade200,
                            //           offset: const Offset(0.0, 0.5),
                            //           blurRadius: 30.0,
                            //         )
                            //       ]),
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 200.0,
                            //   child: Center(
                            //     child: itemPhotosWidgetList.isEmpty
                            //         ? Center(
                            //             child: MaterialButton(
                            //               onPressed: pickPhotoFromGallery,
                            //               child: Container(
                            //                 alignment: Alignment.bottomCenter,
                            //                 child: Center(
                            //                   child: Image.network(
                            //                     "https://static.thenounproject.com/png/3322766-200.png",
                            //                     height: 100.0,
                            //                     width: 100.0,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           )
                            //         : SingleChildScrollView(
                            //             scrollDirection: Axis.vertical,
                            //             child: Wrap(
                            //               spacing: 5.0,
                            //               direction: Axis.horizontal,
                            //               children: itemPhotosWidgetList,
                            //               alignment: WrapAlignment.spaceEvenly,
                            //               runSpacing: 10.0,
                            //             ),
                            //           ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 20.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                               updateText() ;
                              },
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
                              height: 120,
                              decoration: ShapeDecoration(
                                color: Color(0xFFE7E7E7),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 5, color: Color(0xFF42BD41)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  yourText,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // Container(
                            //   width: 390,
                            //   height: 550,
                            //   decoration: ShapeDecoration(
                            //     color: Color(0xFFE7E7E7),
                            //     shape: RoundedRectangleBorder(
                            //       side: BorderSide(
                            //           width: 5, color: Color(0xFF42BD41)),
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //   ),
                            // ),
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

  addImage() {
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(1.0),
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

  // Future<String> uplaodImageAndSaveItemInfo() async {
  //   setState(() {
  //     uploading = true;
  //   });
  //   PickedFile? pickedFile;
  //   String? knowledgetId = '';
  //   for (int i = 0; i < itemImagesList.length; i++) {
  //     knowledgetId = 'knowledgeimg${i.toString().padLeft(10, '0')}';
  //     file = File(itemImagesList[i].path);
  //     pickedFile = PickedFile(file!.path);

  //     await uploadImageToStorage(pickedFile, knowledgetId);
  //   }
  //   return knowledgetId!;
  // }

  Future<String> uplaodImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? knowledgetId = const Uuid().v4().substring(0, 10);
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, knowledgetId);
    }
    return knowledgetId;
  }

  // uploadImageToStorage(PickedFile? pickedFile, String knowledgetId) async {
  //   String? kId = const Uuid().v4();
  //   Reference reference = FirebaseStorage.instance
  //       .ref()
  //       .child('Knowledge/$knowledgetId/knowledImg_$kId');
  //   await reference.putData(
  //     await pickedFile!.readAsBytes(),
  //     SettableMetadata(contentType: 'image/jpeg'),
  //   );
  //   String imageUrl = await reference.getDownloadURL();
  //   // downloadUrl.add(imageUrl); // เพิ่ม URL ลงในรายการ downloadUrl
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
    addKnowlege(imageUrl);
  }

  void addKnowlege(String imageUrl) async {
    if (selectedIconData != null &&
        namecontroller.text.isNotEmpty &&
        contentcontroller.text.isNotEmpty) {
      String Id = namecontroller.text;
      IconData selectedIconData = iconDataMap[iconName]!;
      String iconDataString = getIconDataString(selectedIconData);

      Map<String, dynamic> knowledgeMap = {
        "KnowledgeName": namecontroller.text,
        "KnowledgeDetail": contentcontroller.text,
        "KnowledgeImg": imageUrl,
        "KnowledgeIcons": iconDataString,
      };
      await Databasemethods().addKnowlege(knowledgeMap, Id).then((value) {
        Fluttertoast.showToast(
          msg: "เพิ่มความรู้เรียบร้อยแล้ว",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      Fluttertoast.showToast(
        msg: "กรุณากรอกข้อมูลให้ครบ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
  
  String yourText = "";

  void updateText() {
  setState(() {
    // เปลี่ยนค่าของ Text Widget เมื่อกดปุ่ม "แสดงผล"
    yourText = "Your Updated Text";
  });
}
}
