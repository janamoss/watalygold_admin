import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditMutiple.dart';
import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Deleteddialogknowledge.dart';
import 'package:watalygold_admin/Widgets/DeletedialogContent.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

class EditMutiple extends StatefulWidget {
  final Knowledge? knowledge;
  final IconData? icons;
  final Contents? contents;

  const EditMutiple({super.key, this.knowledge, this.contents, this.icons});

  @override
  State<EditMutiple> createState() => _EditMutipleState();
}

class _EditMutipleState extends State<EditMutiple> {
  bool _customTileExpanded = false;
  List<List<String>> allKnowledgeContents = [];
  TextEditingController contentNameController = TextEditingController();
  String? message;

// ภายใน Widget build หรือส่วนอื่น ๆ ที่เกี่ยวข้อง

  IconData? selectedIconData;
  String? _selectedValue;
  List<ExpansionPanelData> _panelData = [];
  int _currentExpandedIndex = -1;
  bool addedContent = false;
  TextEditingController contentcontroller = new TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController contentdetailcontroller = TextEditingController();
  TextEditingController contentnamecontroller = TextEditingController();
  List<TextEditingController> contentNameControllers = [];
  List<TextEditingController> contentDetailControllers = [];
  final List<List<XFile>> _imagesForPanels = [];
  List<Knowledge> knowledgelist = [];
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
  bool _isLoading = true;
  List<Contents> contentList = [];
  List<String> imageURLlist = [];
  List<String> ContentDetaillist = [];
  List<String> ContentNamelist = [];
  List? itemContent;
  List<String> ListimageUrl = [];

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
      print("Error getting knowledge: $error");
      return []; // Or handle the error in another way
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void deleteContentById(String documentId) async {
    try {
      await Databasemethods().deleteContent(documentId);
      showToast("ลบข้อมูลเสร็จสิ้น");
    } catch (e) {
      print('Error deleting content: $e');
    }
  }

  Future<Contents> getContentsById(String documentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('Content').doc(documentId);
    final doc = await docRef.get();

    if (doc.exists) {
      final data = doc.data();
      return Contents(
        id: doc.id,
        ContentName: data!['ContentName'].toString(),
        ContentDetail: data['ContentDetail'].toString(),
        ImageURL: data['image_url'].toString(),
        deleted_at: doc['deleted_at'],
        create_at: data['create_at'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now()),
      );
    } else {
      throw Exception('Document not found with ID: $documentId');
    }
  }

  Future<void> updateContent(List<String> imageUrl) async {
    String? selectedValue;
    print("start");
    selectedValue = widget.knowledge!.knowledgeIcons != null
        ? widget.knowledge!.knowledgeIcons.toString()
        : widget.icons != null
            ? icons.keys.firstWhere(
                (key) => icons[key] == widget.icons,
                orElse: () => '',
              )
            : null;
    try {
      print("start loop");
      final knowledgeDocRef = FirebaseFirestore.instance
          .collection('Knowledge')
          .doc(widget.knowledge!.id);
      // ใช้ ID ของ Knowledge ที่กำลังแก้ไข

      await knowledgeDocRef.update({
        'KnowledgeName': namecontroller.text,
        'KnowledgeIcons': _selectedValue ??
            icons.keys.firstWhere(
                (key) => icons[key].toString() == selectedValue,
                orElse: () => ''),
        'update_at': Timestamp.now()
      });
      print(contentList);
      print(ListimageUrl);
      print(contentNameControllers.length);
      print(contentDetailControllers.length);
      List<String> contentIds = [];
      for (int index = 0; index < contentList.length; index++) {
        String contentName = contentNameControllers[index].text;
        String contentDetail = contentDetailControllers[index].text;
        String imageUrl = ListimageUrl[index].toString();
        String contentId = contentList[index].id;

        print(" id ${contentId}");
        print(" name ${contentName}");
        print(" detail ${contentDetail}");
        print(" url ${imageUrl}");

        await upContent(contentId, contentName, contentDetail, imageUrl);
      }
      print("3");
// Check if there are new contents to be added
      if (itemImagesList.isNotEmpty) {
        for (int index = contentList.length;
            index < contentList.length + itemImagesList.length;
            index++) {
          String contentName = contentNameControllers[index].text;
          String contentDetail = contentDetailControllers[index].text;
          String imageUrl = ListimageUrl[index].toString();
          String? contentId;

          // Generate a new contentId if it's a new content
          if (index >= contentList.length) {
            contentId = await addContent(contentName, contentDetail, imageUrl);
            contentIds.add(contentId);
          } else {
            contentId = contentList[index].id;
            await upContent(contentId, contentName, contentDetail, imageUrl);
            contentIds.add(contentId);
          }

          print(" id ${contentId}");
          print(" name ${contentName}");
          print(" detail ${contentDetail}");
          print(" url ${imageUrl}");
        }
      }
      print(contentIds);
      await knowledgeDocRef
          .update({'Content': contentIds, 'update_at': Timestamp.now()});
    } catch (error) {
      print("Error getting knowledge: $error");
      // Or handle the error in another way
    }
  }

  Future<void> upContent(String contentId, String contentName,
      String contentDetail, String imageUrl) async {
    Map<String, dynamic> updatecontent = {
      "ContentName": contentName,
      "ContentDetail": contentDetail,
      "image_url": imageUrl,
      "deleted_at": null,
      "update_at": Timestamp.now(),
    };
    print(" id ${contentId}");
    print(" name ${contentName}");
    print(" detail ${contentDetail}");
    print(" url ${imageUrl}");
    // Update the existing content document with the provided contentId
    await Databasemethods().updateContent(
        updatecontent, contentId, contentName, contentDetail, imageUrl);
  }

  Future<void> loadData() async {
    if (widget.knowledge != null) {
      namecontroller.text = widget.knowledge!.knowledgeName;
      contentcontroller.text = widget.knowledge!.knowledgeDetail;
      // contentNameController.text = widget.knowledge!.contents.ContentName;
    }
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    // ใช้ลูป for ในการวนลูปผ่านทุกๆ document ID ใน widget.knowledge!.contents
    for (var documentId in widget.knowledge!.contents) {
      // ดึงข้อมูล Contents จาก Firestore โดยใช้ document ID แต่ละตัว
      var contents = await getContentsById(documentId);

      if (contents.deleted_at == null) {
        setState(() {
          contentList.add(contents);
        });
      }

      print(contents.deleted_at);
      print(contentList);
      print(contents.ContentName);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColor,
      body: SingleChildScrollView(
        child: _isLoading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: WhiteColor,
                  secondRingColor: Colors.green,
                  thirdRingColor: Colors.yellow,
                  size: 200,
                ),
              )
            : Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 70),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 1000,
                            height: 140,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 1065,
                                    height: 140,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                Positioned(
                                  left: 210,
                                  top: 70,
                                  child: Text(
                                    'เนื้อหาเดี่ยว',
                                    style: TextStyle(
                                      color: Colors.black
                                          .withOpacity(0.44999998807907104),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 600,
                                  top: 35,
                                  child: Container(
                                    width: 250,
                                    height: 65,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF42BD41),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      
                                    ),

                                  ),
                                ),
                                Positioned(
                                  left: 670,
                                  top: 70,
                                  child: Text(
                                    'หลายเนื้อหา',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0),
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
                                                  style: TextStyle(
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
                                                    color: GPrimaryColor,
                                                    size: 24),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  "${widget.icons != null ? icons.keys.firstWhere((key) => icons[key] == widget.icons, orElse: () => '') : ''}",
                                                  style: TextStyle(
                                                      color: GPrimaryColor),
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
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffCFD3D4)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextField(
                                        controller: namecontroller,
                                        decoration: InputDecoration(
                                            border: InputBorder.none),
                                      ),
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
                                          child:
                                              _displayedWidget ?? Container(),
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
                        padding: EdgeInsets.only(right: 40),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: buildList(),
                        ),
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
                            final int index =
                                _panelData.indexOf(expansionPanelData);
                            // สร้าง TextEditingController สำหรับชื่อเนื้อหาและรายละเอียดเนื้อหา
                            contentNameControllers.add(TextEditingController());
                            contentDetailControllers
                                .add(TextEditingController());

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
                                        _deletedPanels.add(index);
                                      });
                                      // final deleteDialogContent =
                                      //     (String id) => DeletedialogContent(
                                      //           id: id,
                                      //         );

                                      // for (var knowledge in knowledgelist) {
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (context) =>
                                      //       deleteDialogContent(
                                      //           knowledge.contents),
                                      // );
                                      // }
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(25.0),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0, right: 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0, right: 0),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffCFD3D4)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: TextField(
                                                      controller:
                                                          contentNameControllers[
                                                              index],
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 30),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0, right: 0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0, right: 0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                0xffCFD3D4)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: TextField(
                                                      controller:
                                                          contentDetailControllers[
                                                              index],
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 5,
                                                      decoration: InputDecoration(
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              Colors.white))),
                                                    ),
                                                  ),
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
                                                          BorderRadius.circular(
                                                              12.0),
                                                      color: Colors.white70,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade200,
                                                          offset: const Offset(
                                                              0.0, 0.5),
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
                                                            child:
                                                                MaterialButton(
                                                              onPressed: () {
                                                                pickPhotoFromGallery(
                                                                    _panelData[
                                                                        index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
                                                              },
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Center(
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
                                                                  expansionPanelData
                                                                      .itemPhotosWidgetList,
                                                              alignment:
                                                                  WrapAlignment
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
                                                    // pickPhotoFromGallery()
                                                    //     .then((newImageUrl) {
                                                    //   if (newImageUrl != null) {
                                                    //     setState(() {
                                                    //       addImage(); // เพิ่มภาพใหม่
                                                    //     });
                                                    //   }
                                                    // });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        G2PrimaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                                    displaycontent(); // เรียกใช้งานเมื่อคลิกปุ่ม "แสดงผล"
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xffE69800),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 5,
                                                          color: Color(
                                                              0xFF42BD41)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                Icon(Icons.add_box_rounded,
                                    color: Color(0xFF42BD41)),
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
                        // padding: const EdgeInsets.all(25.0),
                        padding: const EdgeInsets.only(
                            right: 70.0, top: 50.0, bottom: 50),
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
                                  uploadImageAndSaveItemInfo();
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
    // print(imageUrl);
    // print(ListimageUrl);
    setState(() {
      ListimageUrl.add(imageUrl);
      // print(ListimageUrl);
    });
  }

  Future<void> uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? contentIdnew = const Uuid().v4().substring(0, 10);
    for (int i = 0; i < contentList.length + itemImagesList.length; i++) {
      if (itemImagesList.length == 0) {
        ListimageUrl.add(contentList[i].ImageURL);
        print(ListimageUrl);
      } else {
        for (int i = 0; i < itemImagesList.length; i++) {
          file = File(itemImagesList[i].path);
          print(itemImagesList[i].path);
          pickedFile = PickedFile(file!.path);
          await uploadImageToStorage(pickedFile, contentIdnew, i);
        }
        ListimageUrl.add(contentList[i].ImageURL);
        print(ListimageUrl);
      }
    }
    await updateContent(ListimageUrl);
    // เรียกใช้ addAllContentOnce เพื่อเพิ่มข้อมูลลง Firebase Firestore ครั้งเดียวเท่านั้น
    setState(() {
      uploading = false;
    });
  }

  // Future<void> updateContent(List<String> imageUrl) async {
  //   ตรวจสอบว่า addAllContent ถูกเรียกใช้ครั้งแรกหรือไม่
  //   // ตั้งค่าให้ addedContent เป็น true เพื่อบอกว่า addAllContent ถูกเรียกใช้แล้วครั้งแรก

  //   Validate user input
  //   if (namecontroller.text.isEmpty ||
  //       _selectedValue == null ||
  //       imageUrl == null) {
  //     Fluttertoast.showToast(
  //       msg: "กรุณากรอกข้อมูลให้ครบ",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //     return;
  //   }

  //   String? selectedValue;

  //   selectedValue = widget.knowledge!.knowledgeIcons != null
  //       ? widget.knowledge!.knowledgeIcons.toString()
  //       : widget.icons != null
  //           ? icons.keys.firstWhere(
  //               (key) => icons[key] == widget.icons,
  //               orElse: () => '',
  //             )
  //           : null;

  //   List<String> contentIds = [];
  //   print("list ${contentNameControllers.length}");
  //   // Loop through content and add them to Firebase
  //   for (int index = 0; index < itemImagesList.length; index++) {
  //     String contentName = contentNameControllers[index].text;
  //     print(contentName);
  //     String contentDetail = contentDetailControllers[index].text;
  //     print(contentDetail);
  //     String imageurl = ListimageUrl[index].toString();
  //     print(" img ${imageurl}");

  //     String contentId = await addContents(contentName, contentDetail, imageurl);
  //     print("id ${contentId}");
  //     contentIds.add(contentId);
  //   }

  //   // Generate a knowledge ID
  //   String knowledgeId = const Uuid().v4().substring(0, 10);

  //   // Prepare knowledge data
  //   Map<String, dynamic> updateknowledge = {
  //     "KnowledgeName": namecontroller.text,
  //    "KnowledgeIcons": _selectedValue ??
  //         icons.keys.firstWhere((key) => icons[key].toString() == selectedValue,
  //             orElse: () => ''),
  //     "deleted_at": null,
  //     "update_at": Timestamp.now(),
  //     "Content": contentIds,
  //   };

  //   // Add knowledge to Firebase
  //   await Databasemethods()
  //       .addKnowlege(updateknowledge, knowledgeId)
  //       .then((value) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => const Addknowledgedialog(),
  //     );
  //   }).catchError((error) {
  //     Fluttertoast.showToast(
  //       msg: "เกิดข้อผิดพลาดในการเพิ่มความรู้: $error",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   });
  // }

  // Future<String> addContents(
  //     String contentName, String contentDetail, String imageUrl) async {
  //   Map<String, dynamic> updatecontent = {
  //     "ContentName": contentName,
  //     "ContentDetail": contentDetail,
  //     "image_url": imageUrl,

  //     "deleted_at": null,
  //     "update_at": Timestamp.now(),
  //   };

  //   // Generate a unique ID (replace with your preferred method)
  //   String contentId = const Uuid().v4().substring(0, 10);

  //   // Add data using addKnowlege, passing both contentMap and generated ID
  //   await Databasemethods().updateContent(updatecontent, contentId);
  //   return contentId;
  // }

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
                  size: 24, // ขนาดของไอคอน
                  color: GPrimaryColor, // สีของไอคอน
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    namecontroller.text,
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
        name: contentNameControllers.isNotEmpty
            ? contentNameControllers[0].text
            : '',
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
                      for (int index = 0;
                          index < contentNameControllers.length;
                          index++)
                        Text(
                          contentNameControllers[index].text,
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
                      for (int index = 0;
                          index < contentDetailControllers.length;
                          index++)
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

  void displaycontent() {
    // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
    setState(() {
      _displayedcontentWidget = _displaycontentWidget();
    });
  }

  Widget buildList() => ListView.builder(
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          return buildListItem(index);
        },
      );

  int _selectedIndex = 0;
  Widget buildListItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 70),
      child: Material(
        elevation: 3, // กำหนดค่า elevation ที่ต้องการ
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              ExpansionTile(
                key: Key(index.toString()),
                initiallyExpanded: index == _selectedIndex,
                onExpansionChanged: (bool expanded) {},
                // onExpansionChanged: (expanded) {
                //   if (expanded) {
                //     setState(() {
                //       _selectedIndex = index;
                //     });
                //   }
                // },
                title: Text(
                  'เนื้อหาย่อยที่ ${index + 1}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            width: 500,
                            padding: const EdgeInsets.symmetric(
                                vertical: 32, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 100,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'ต้องการลบข้อมูลเนื้อหาย่อยที่ ${index + 1}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: 32,
                                        ),
                                        foregroundColor: Colors.red,
                                        side: BorderSide(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("ยกเลิก"),
                                    ),
                                    SizedBox(width: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: G2PrimaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20,
                                          horizontal: 32,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        deleteContentById(
                                            widget.knowledge!.contents[index]);

                                        Navigator.pop(context);
                                      },
                                      child: const Text("ยืนยัน"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                        // return AlertDialog(
                        //   title: Text("ยืนยันการลบ"),
                        //   content: Text("ต้องการลบข้อมูลเนื้อหาย่อยที่ ${index + 1}"),
                        //   actions: [
                        //     TextButton(
                        //       onPressed: () {
                        //         Navigator.of(context).pop(); // ปิด Dialog
                        //       },
                        //       child: Text("ยกเลิก"),
                        //     ),
                        //     TextButton(
                        //       onPressed: () {
                        //         deleteContentById(
                        //             widget.knowledge!.contents[index]);
                        //         Navigator.of(context).pop(); // ปิด Dialog
                        //       },
                        //       child: Text("ยืนยัน"),
                        //     ),
                        //   ],
                        // );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Color(0xFFFF543E),
                  ),
                ),
                children: [
                  Container(
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
                                        padding: EdgeInsets.only(left: 10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffCFD3D4)),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: TextField(
                                          controller: TextEditingController(
                                              text: contentList[index]
                                                  .ContentName),
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
                                          controller: TextEditingController(
                                              text: contentList[index]
                                                  .ContentDetail),
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
                                                  onPressed: () {
                                                    pickPhotoFromGallery(_panelData[
                                                        index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Center(
                                                      child: Image.network(
                                                        contentList[index]
                                                            .ImageURL,
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
                                                  children:
                                                      itemPhotosWidgetList,
                                                  alignment:
                                                      WrapAlignment.spaceEvenly,
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
                                        // pickPhotoFromGallery(expansionPanelData);
                                        // setState(() {
                                        //   // เรียกใช้ addImage เพื่อเพิ่มรูปภาพใหม่
                                        //   addImage(expansionPanelData);
                                        // });
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
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    ElevatedButton(
                                      onPressed: () {
                                        // displaycontent(); // เรียกใช้งานเมื่อคลิกปุ่ม "แสดงผล"
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xffE69800),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                      // child: Column(
                                      //   children: [
                                      //     Expanded(
                                      //       child:
                                      //           _displayedcontentWidget ??
                                      //               Container(),
                                      //     )
                                      //   ],
                                      // ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
