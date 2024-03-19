import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:watalygold_admin/Page/Knowlege/Knowledgecolumn.dart';
import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/DeletedialogContent.dart';
import 'package:watalygold_admin/Widgets/dialogEdit.dart';
import 'package:watalygold_admin/Widgets/knowlege.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:watalygold_admin/service/knowledge.dart';

Map<String, IconData> icons = {
  'บ้าน': Icons.home,
  'ดอกไม้': Icons.yard,
  'บุคคล': Icons.person,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded
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
  final List<Product> _products = Product.generateItems(8);

  String? _selectedValue;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

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
      contentController.text = widget.knowledge!.knowledgeDetail;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColor,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(left: 70),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Column(
                children: [
                  Center(
                    child: Container(
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Container(
                              width: 500,
                              height: 120,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 140,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.16,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  child: Container(
                                  decoration: ShapeDecoration(
                                      color: GPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      
                                    ),
                                    child: Padding(padding: EdgeInsets.only(top: 20,left:70),
                                    child: Text(
                                      'เนื้อหาเดี่ยว',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    )
                                     
                                    
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Container(
                                  decoration: ShapeDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      
                                    ),
                                   child: Padding(padding: EdgeInsets.only(top: 30,left:70),
                                    child: Text(
                                      'หลายเนื้อหา',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    )
                                     
                                    
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),],),
                  SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Icon(
                        Icons.create_outlined,
                        size: 30,
                        color: GPrimaryColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "แก้ไขคลังความรู้ ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontFamily: 'IBM Plex Sans Thai',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Container(
                      width: 490,
                      height: 900,
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
                                  "แก้ไขคลังความรู้",
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
                                          SizedBox(width: 25),
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
                                      // ไอคอนที่ต้องการเพิ่ม
                                      SizedBox(
                                          width:
                                              10), // ระยะห่างระหว่างไอคอนและข้อความ
                                      Row(
                                        children: [
                                          Icon(
                                              widget.icons ??
                                                  Icons.question_mark_rounded,
                                              color: GPrimaryColor,
                                              size: 24),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "${widget.icons != null ? icons.keys.firstWhere((key) => icons[key] == widget.icons, orElse: () => '') : ''}",
                                            style:
                                                TextStyle(color: GPrimaryColor),
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
                                  controller: nameController,
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
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
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffCFD3D4)),
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextField(
                                  controller: contentController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.white))),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
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
                            SizedBox(
                              height: 30.0,
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
                                                widget.knowledge != null
                                                    ? widget
                                                        .knowledge!.knowledgeImg
                                                    : widget.contents!.ImageURL,
                                                fit: BoxFit.cover,
                                                height: 200,
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
                                pickPhotoFromGallery().then((newImageUrl) {
                                  if (newImageUrl != null) {
                                    setState(() {
                                      addImage(); // เพิ่มภาพใหม่
                                    });
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: G2PrimaryColor,
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
                              height: 10,
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
                      height: 900,
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
                            Container(
                              width: 390,
                              height: 630,
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
                                    child:
                                        _displayedcontentWidget ?? Container(),
                                  )
                                ],
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
                          onPressed: () async {
                            upload();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
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
    );
  }

  void addImage() {
    removeImage(); // ลบภาพเดิมก่อนที่จะเพิ่มภาพใหม่
    for (var bytes in photo!) {
      itemPhotosWidgetList.add(Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: 200.0,
          child: Container(
            child: kIsWeb
                ? Image.network(File(bytes.path).path)
                : Image.file(
                    File(bytes.path),
                    fit: BoxFit.cover,
                    height: 200,
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
    if (itemImagesList.isNotEmpty) {
      String knowledgetId = await uplaodImageAndSaveItemInfo();
      setState(() {
        uploading = false;
      });
    } else {
      // updateKnowledges(widget.knowledge != null
      //     ? widget.knowledge!.knowledgeImg
      //     : widget.contents!.ImageURL);
    }
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
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
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await uploadImageToStorage(pickedFile, knowledgetId);
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
      "KnowledgeDetail": contentController.text,
      "KnowledgeIcons": _selectedValue ??
          icons.keys.firstWhere((key) => icons[key].toString() == selectedValue,
              orElse: () => ''),
      "KnowledgeImg": imageUrl, // ใช้ imageUrl หรือค่าอื่น ๆ ที่ต้องการอัปเดต
      "deleted_at": null,
      "update_at": Timestamp.now(),
      "Content": [],
    };

    await Databasemethods().updateKnowledge(updateknowledge, Id).then((value) {
      showDialog(
        context: context,
        builder: (context) => const DialogEdit(),
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
            itemCount: itemPhotosWidgetList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 390, // กำหนดความกว้างของรูปภาพ
                height: 253, // กำหนดความสูงของรูปภาพ
                child: itemPhotosWidgetList[index], // ใส่รูปภาพลงใน Container
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          contentController.text,
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
      _displayedcontentWidget = _displaycontentWidget();
    });
  }
}
