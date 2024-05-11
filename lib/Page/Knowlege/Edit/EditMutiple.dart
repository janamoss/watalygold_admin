import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/htmltodelta.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Dialog/Deleteddialogknowledge.dart';
import 'package:watalygold_admin/Widgets/Dialog/DeleteknowledgeSuccess.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogEdit.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogcancleEdit.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

Map<String, IconData> icons = {
  'สถิติ': Icons.analytics_outlined,
  'ดอกไม้': Icons.yard,
  'หนังสือ': Icons.book,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded,
  'คำถาม': Icons.quiz_outlined,
};

class ExpansionPanelData {
  TextEditingController nameController;
  QuillController detailController;
  List<Widget> itemPhotosWidgetList;

  ExpansionPanelData({
    required this.nameController,
    required this.detailController,
    required this.itemPhotosWidgetList,
  });
}

List<ExpansionPanelData> _panelData = [];

class EditMutiple extends StatefulWidget {
  final Knowledge? knowledge;
  final IconData? icons;
  final Contents? contents;

  const EditMutiple({super.key, this.knowledge, this.contents, this.icons});

  @override
  State<EditMutiple> createState() => _EditMutipleState();
}

class _EditMutipleState extends State<EditMutiple> {
  List<List<String>> allKnowledgeContents = [];
  TextEditingController contentNameController = TextEditingController();
  String? message;
  IconData? selectedIconData;
  String? _selectedValue;
  List<bool> _showPreview = [];
  int _currentExpandedIndex = -1;
  bool addedContent = false;
  TextEditingController contentcontroller = new TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController contentdetailcontroller = TextEditingController();
  TextEditingController contentnamecontroller = TextEditingController();
  List<TextEditingController> contentNameControllers = [];
  // List<TextEditingController> contentDetailControllers = [];
  List<TextEditingController> contentNameAdd = [];
  // List<TextEditingController> contentDetailupdate = [];
  List<QuillController> _contentAddController = [];
  List<QuillController> contentDetailControllers = [];
  QuillController _contentController = QuillController.basic();
  String _html = '';
  List<String> htmlUpdateList = [];
  List<String> htmlAddList = [];

  List<Widget>? displayedContentWidgets;
  List<Knowledge> knowledgelist = [];
  List<int> _deletedPanels = [];
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
      showDialog(
        context: context,
        builder: (context) => DeleteknowledgeSuccess(),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context); // ปิด Dialog ประสบความสำเร็จ
      });
    } catch (e) {
      print('Error deleting content: $e');
    }
  }

  Future<void> updateContent(
      List<String> newImageUrls, List<String> updatedImageUrls) async {
    String? selectedValue;
    selectedValue = widget.knowledge!.knowledgeIcons != null
        ? widget.knowledge!.knowledgeIcons.toString()
        : widget.icons != null
            ? icons.keys.firstWhere(
                (key) => icons[key] == widget.icons,
                orElse: () => '',
              )
            : null;

    try {
      final knowledgeDocRef = FirebaseFirestore.instance
          .collection('Knowledge')
          .doc(widget.knowledge!.id);

      // Update general data except Content and image_url
      await knowledgeDocRef.update({
        'KnowledgeName': namecontroller.text,
        'KnowledgeIcons': _selectedValue ??
            icons.keys.firstWhere(
                (key) => icons[key].toString() == selectedValue,
                orElse: () => ''),
        "Content": contentIds,
        'update_at': Timestamp.now()
      });

      List<String> existingContentIds =
          contentList.map((content) => content.id).toList();
      // Update existing contents with new image URLs
      // Update existing contents with new image URLs
      List<String> updatedContentIds = [];
      Map<String, int> contentIdIndexMap = {};

      for (int i = 0; i < contentList.length; i++) {
        contentIdIndexMap[contentList[i].id] = i;
      }
      for (int index = 0; index < contentList.length; index++) {
        String contentName = contentNameControllers[index].text;
        String contentDetail =
            htmlUpdateList[contentIdIndexMap[contentList[index].id]!];
        String contentId = contentList[index].id;
        String imageUrl;

        // Check if the current contentId exists in updatedImageFilesMap
        if (updatedImageFilesMap.containsKey(contentId)) {
          // If the contentId exists, get the first updated image URL for that contentId
          List<XFile> updatedImageFiles = updatedImageFilesMap[contentId]!;
          if (updatedImageFiles.isNotEmpty) {
            XFile updatedImageFile = updatedImageFiles[0];
            PickedFile pickedFile = PickedFile(updatedImageFile.path);
            imageUrl = await uploadImageToStorage(pickedFile, contentId, 0);
          } else {
            // If there are no updated images for this contentId, use the existing ImageURL
            imageUrl = contentList[index].ImageURL;
          }
        } else {
          // If the contentId doesn't exist in updatedImageFilesMap, use the existing ImageURL
          imageUrl = contentList[index].ImageURL;
        }

        updatedContentIds.add(
            await upContent(contentId, contentName, contentDetail, imageUrl));
      }

      // Add new contents for new images
      for (int index = 0; index < newImageUrls.length; index++) {
        String contentNamenew =
            index < contentNameAdd.length ? contentNameAdd[index].text : '';
        // String contentdetailnew = index < contentDetailupdate.length
        //     ? contentDetailupdate[index].text
        //     : '';
        String contentdetailnew =
            index < htmlAddList.length ? htmlAddList[index] : '';
        //  String contentdetailnew = htmlList[index];
        String imageUrl = newImageUrls[index];
        String newContentId =
            await addContent(contentNamenew, contentdetailnew, imageUrl);
        updatedContentIds.add(newContentId);
      }

      await knowledgeDocRef
          .update({'Content': updatedContentIds, 'update_at': Timestamp.now()});
      showDialog(
        context: context,
        builder: (context) => DialogEdit(),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        context.goNamed("/mainKnowledge");
      });
    } catch (error) {
      print("Error getting knowledge updateContent: $error");
    }
  }

  Future<String> upContent(
    String contentId,
    String contentName,
    String contentDetail,
    String imageUrl,
  ) async {
    try {
      Map<String, dynamic> updateContent = {
        'ContentName': contentName,
        'ContentDetail': contentDetail,
        'image_url': imageUrl, // Update image_url with the new URL
        'update_at': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('Content')
          .doc(contentId)
          .update(updateContent);

      print('Updating content with ID: $contentId');
      print('Content updated successfully');

      return contentId;
    } catch (e) {
      print('Error updating content: $e');
      rethrow;
    }
  }

  List<String> contentIds = [];

  Future<String> addContent(
      String contentNamenew, String contentdetailnew, String imageUrl) async {
    Map<String, dynamic> contentMap = {
      "ContentName": contentNamenew,
      "ContentDetail": contentdetailnew,
      "image_url": imageUrl,
      "create_at": Timestamp.now(),
      "deleted_at": null,
      "update_at": null,
    };
    print(" contentNamenew ${contentNamenew}");
    print('addContent successfully');
    // Generate a unique ID (replace with your preferred method)
    String contentId = const Uuid().v4().substring(0, 10);

    // Add data using addKnowlege, passing both contentMap and generated ID
    await Databasemethods().addContent(contentMap, contentId);

    return contentId;
  }

  List<List<XFile>> expansionPanelImagesList = [];

  // Future<void> pickPhotoFromGallers(int index) async {
  //   print("เริ่มการเลือกรูปภาพ pickPhotoFromGallers");
  //   List<XFile>? newPhotos = await _picker.pickMultiImage();
  //   if (newPhotos != null) {
  //     setState(() {
  //       print("Loop");
  //       if (expansionPanelImagesList.length <= index) {
  //         expansionPanelImagesList.add(newPhotos);
  //         print("รายการรูปภาพใหม่ if: $expansionPanelImagesList");
  //       }
  //     });
  //   }
  // }
  // List<List<XFile>> expansionPanelImagesList = [];

// สำหรับรูปภาพที่ต้องการเพิ่ม
  // List<XFile> newImageFiles = [];

// สำหรับรูปภาพที่ต้องการอัปเดต
  List<List<XFile>> updatedImageFiles = [];

  Map<String, List<XFile>> updatedImageFilesMap = {};

  Future<void> pickPhotoFromGallers(String contentId) async {
    List<XFile>? newPhotos = await _picker.pickMultiImage();

    if (newPhotos != null) {
      print("Loop");
      setState(() {
        print("Loop");
        updatedImageFilesMap[contentId] = newPhotos;
        print(
            "updatedImageFilesMap[contentId]: ${updatedImageFilesMap[contentId]}");
      });
    }
  }

  Future<void> pickPhotoFromGallery(int index) async {
    print("srr");
    List<XFile>? newPhotos = await _picker.pickMultiImage();
    if (newPhotos != null) {
      setState(() {
        print("srr11");
        if (expansionPanelImagesList.length <= index) {
          expansionPanelImagesList.add(newPhotos);
          print(expansionPanelImagesList);
        } else {
          expansionPanelImagesList[index] = newPhotos;
        }
        print(expansionPanelImagesList[index]);
      });
    }
  }
  // Future<void> pickPhotoFromGallers(int index) async {
  //   print("เริ่มการเลือกรูปภาพ pickPhotoFromGallers");
  //   List<XFile>? newPhotos = await _picker.pickMultiImage();

  //   if (newPhotos != null) {
  //     setState(() {
  //       print("Loop");
  //       print("รายการรูปภาพที่ต้องการอัปเดต 1: $updatedImageFiles");
  //       print("index ${index}");
  //       // แทนที่รูปภาพในตำแหน่ง index ของ updatedImageFiles ด้วยรูปภาพใหม่
  //       if (updatedImageFiles.length <= index) {
  //         updatedImageFiles.add(newPhotos);
  //       } else {
  //         updatedImageFiles[index] = newPhotos;
  //       }

  //       print("รายการรูปภาพที่ต้องการอัปเดต 3: $updatedImageFiles");
  //     });
  //   }
  // }
  // Future<void> pickPhotoFromGallers(int index) async {
  //   print("เริ่มการเลือกรูปภาพ pickPhotoFromGallers");
  //   List<XFile>? newPhotos = await _picker.pickMultiImage();
  //   if (newPhotos != null) {
  //     setState(() {
  //       print("Loop");
  //        print("รายการรูปภาพที่ต้องการอัปเดต 1: $updatedImageFiles");
  //       if (updatedImageFiles.length <= index) {
  //         updatedImageFiles.add(
  //             newPhotos);
  //              print("รายการรูปภาพที่ต้องการอัปเดต 2: $updatedImageFiles"); // เพิ่ม List ของ XFile เข้าไปในรายการ updatedImageFiles
  //       } else {
  //         updatedImageFiles[index] =
  //             newPhotos; // กำหนด List ของ XFile ให้กับตำแหน่งที่ระบุในรายการ updatedImageFiles
  //       }
  //       print("รายการรูปภาพที่ต้องการอัปเดต 3: $updatedImageFiles");
  //     });
  //   }
  // }

  // Future<void> pickPhotoFromGallery(
  //   int index,
  //   ExpansionPanelData expansionPanelData,
  // ) async {
  //   print("เริ่มการเลือกรูปภาพ");
  //   List<XFile>? newPhotos = await _picker.pickMultiImage();
  //   if (newPhotos != null) {
  //     setState(() {
  //       newImageFiles
  //           .addAll(newPhotos); // เพิ่มรูปภาพใหม่ลงในรายการ newImageFiles

  //     });
  //     // addImage(expansionPanelData);
  //     print("รายการรูปภาพใหม่: $newImageFiles");
  //   }
  // }

  Future<void> uploadImageAndSaveItemInfo() async {
    print('star uploadImageAndSaveItemInfo ');
    setState(() {
      uploading = true;
    });

    PickedFile? pickedFile;
    String? contentIdnew = const Uuid().v4().substring(0, 10);

// Create a new list to store URLs of new images
    List<String> newImageUrls = [];

    // Upload and save new images
    for (List<XFile> panelImages in expansionPanelImagesList) {
      for (XFile newImageFile in panelImages) {
        file = File(newImageFile.path);
        pickedFile = PickedFile(file!.path);
        print('เริ่มการอัปโหลดรูปภาพ');
        String imageUrl =
            await uploadImageToStorage(pickedFile, contentIdnew, newImageFile);
        newImageUrls.add(imageUrl); // เพิ่ม URL ของรูปภาพใหม่ลงในรายการ
      }
    }

    // for (XFile newImageFile in newImageFiles) {
    //   file = File(newImageFile.path);
    //   pickedFile = PickedFile(file!.path);
    //   print('star uploadImageToStorage 1');
    //   String imageUrl =
    //       await uploadImageToStorage(pickedFile, contentIdnew, newImageFile);
    //   newImageUrls.add(imageUrl); // Add the new image URL to the list
    // }

    // Upload and update existing images
    List<String> updatedImageUrls = [];
    for (var entry in updatedImageFilesMap.entries) {
      String contentId = entry.key;
      List<XFile> updatedImageFileList = entry.value;

      for (int j = 0; j < updatedImageFileList.length; j++) {
        XFile updatedImageFile = updatedImageFileList[j];
        file = File(updatedImageFile.path);
        pickedFile = PickedFile(file!.path);

        print("updatedImageFilesMap: ${updatedImageFilesMap}");
        // // ลบรูปภาพเดิมออกจาก Storage
        // Reference reference = FirebaseStorage.instance.refFromURL(contentList.firstWhere((content) => content.id == contentId).ImageURL);
        // await reference.delete();
        // print(contentId);
        // print('ลบรูปภาพเดิมออกจาก Storage ');

        String imageUrl = await uploadImageToStorage(pickedFile, contentId, j);
        updatedImageUrls.add(imageUrl); // Add the updated image URL to the list
        print('star uploadImageToStorage ');
      }
    }

//   await updateContent(newImageUrls, updatedImageUrls); // Pass the new and updated image URLs to updateContent

    await updateContent(newImageUrls,
        updatedImageUrls); // Pass the new image URLs to updateContent

    setState(() {
      uploading = false;
    });
  }

  // void addImage(ExpansionPanelData expansionPanelData) {
  //   // เพิ่มรูปภาพใหม่จากรายการ newImageFiles
  //   for (var file in newImageFiles) {
  //     expansionPanelData.itemPhotosWidgetList.add(
  //       Padding(
  //         padding: const EdgeInsets.all(0),
  //         child: Container(
  //           height: 200.0,
  //           child: AspectRatio(
  //             aspectRatio: 16 / 9,
  //             child: Container(
  //               child: kIsWeb
  //                   ? Image.network(file.path)
  //                   : Image.file(
  //                       File(file.path),
  //                     ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Future<String> uploadImageToStorage(
      PickedFile? pickedFile, String contentId, index) async {
    String? kId = const Uuid().v4().substring(0, 10);
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('Content/$contentId/contentImg_$kId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String imageUrl = await reference.getDownloadURL();
    print("uploadImageToStorage imageUrl ${imageUrl}");
    return imageUrl; // Return the image URL instead of adding it to ListimageUrl
  }

  void clearAndRemoveData(int index) {
    setState(() {
      contentNameAdd[index].clear();
      _contentAddController[index].clear();

      if (expansionPanelImagesList.isNotEmpty &&
          expansionPanelImagesList[index].isNotEmpty) {
        expansionPanelImagesList[index].clear();
        expansionPanelImagesList.removeAt(index);
      }
      _deletedPanels.add(index);
      _panelData.removeAt(index);
      contentNameAdd.removeAt(index);
      _contentAddController.removeAt(index);
      _showPreview.removeAt(index);
      print(expansionPanelImagesList);
    });
  }

  Future<void> loadData() async {
    if (widget.knowledge != null) {
      namecontroller.text = widget.knowledge!.knowledgeName;
      contentcontroller.text = widget.knowledge!.knowledgeDetail;
    }

    setState(() {
      _isLoading = true; // Set loading state to true
    });

    // Clear the existing controllers
    contentNameControllers.clear();
    contentDetailControllers.clear();

    // ใช้ลูป for ในการวนลูปผ่านทุกๆ document ID ใน widget.knowledge!.contents
    for (var documentId in widget.knowledge!.contents) {
      // ดึงข้อมูล Contents จาก Firestore โดยใช้ document ID แต่ละตัว
      var contents = await getContentsById(documentId);

      if (contents.deleted_at == null) {
        setState(() {
          contentList.add(contents);
          contentNameControllers
              .add(TextEditingController(text: contents.ContentName));
          // _contentUpdateController.add(QuillController(
          //   document: QuillDocument.fromJson(jsonDecode(contents
          //       .ContentDetail)), // สร้างเอกสารในรูปแบบ Delta จากสตริง ContentDetail
          //   selection: TextSelection.collapsed(
          //       offset: 0), // ระบุตำแหน่งเริ่มต้นของการเลือก
          // ));
          String htmlString = contents.ContentDetail;
          var delta = HtmlToDeltaConverter.htmlToDelta(htmlString);

          _contentController = QuillController(
            document: Document.fromDelta(delta),
            selection: const TextSelection.collapsed(offset: 0),
          );
          contentDetailControllers.add(_contentController);
          // updatedImageFiles.add(contents.ImageURL);
        });
      }
      print(contents.deleted_at);
      print(contentList);
      print(contents.ContentName);
    }
    createDisplayedContentWidgets();
    setState(() {
      _isLoading = false;
    });
  }

  void createDisplayedContentWidgets() {
    setState(() {
      displayedContentWidgets =
          List.generate(contentList.length, (index) => Container());
      print("displayedContentWidgets ${displayedContentWidgets}");
    });
  }

  @override
  void initState() {
    super.initState();
    displayedContentWidgets =
        List.generate(contentList.length, (index) => Container());
    loadData();
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

  @override
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
                            padding: EdgeInsets.only(left: 0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Center(
                                  child: _buildTabBar(),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.68,
                                  child: screensize == ScreenSize.minidesktop
                                      ? Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.create_outlined,
                                                size: 30,
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
                                                size: 30,
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
                                        ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.68,
                                  child: Column(
                                    children: [
                                      screensize == ScreenSize.minidesktop
                                          ? Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            25.0),
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
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 30),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "ไอคอน ",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "*",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        18,
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
                                                            child:
                                                                DropdownButton(
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
                                                                              icons[value]!,
                                                                              color: GPrimaryColor,
                                                                            )
                                                                          : SizedBox(),
                                                                      SizedBox(
                                                                          width:
                                                                              25),
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
                                                              onChanged:
                                                                  (value) {
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
                                                                          size:
                                                                              24),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
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
                                                              value:
                                                                  _selectedValue,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 30),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "ชื่อ",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "*",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xffCFD3D4)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: TextField(
                                                              controller:
                                                                  namecontroller,
                                                              maxLength:
                                                                  30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "กรอกชื่อคลังความรู้ได้ไม่เกิน 30 ตัวอักษร",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: display,
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xffE69800),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "แสดงผล",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                                  height: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            25.0),
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
                                                              color: Color(
                                                                  0xffFFEE58),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              "แสดงผล",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Color(
                                                                0xFFE7E7E7),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 5,
                                                                  color:
                                                                      GPrimaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: _displayedWidget ??
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
                                                  height: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            25.0),
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
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 30),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "ไอคอน ",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "*",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        18,
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
                                                            child:
                                                                DropdownButton(
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
                                                                              icons[value]!,
                                                                              color: GPrimaryColor,
                                                                            )
                                                                          : SizedBox(),
                                                                      SizedBox(
                                                                          width:
                                                                              25),
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
                                                              onChanged:
                                                                  (value) {
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
                                                                          size:
                                                                              24),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
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
                                                              value:
                                                                  _selectedValue,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 30),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "ชื่อ",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "*",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xffCFD3D4)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: TextField(
                                                              controller:
                                                                  namecontroller,
                                                              maxLength:
                                                                  30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 0.0,
                                                                  right: 0),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "กรอกชื่อคลังความรู้ได้ไม่เกิน 30 ตัวอักษร",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: display,
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xffE69800),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "แสดงผล",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
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
                                                  height: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            25.0),
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
                                                              color: Color(
                                                                  0xffFFEE58),
                                                            ),
                                                            SizedBox(width: 10),
                                                            Text(
                                                              "แสดงผล",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: Color(
                                                                0xFFE7E7E7),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                  width: 5,
                                                                  color:
                                                                      GPrimaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: _displayedWidget ??
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
                                                // Container
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.67,
                                  child: buildList(),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.67,
                                  child: ExpansionPanelList.radio(
                                    expansionCallback:
                                        (int index, bool isExpanded) {
                                      if (_deletedPanels.contains(index)) {
                                        return;
                                      }
                                      setState(() {
                                        if (isExpanded) {
                                          _currentExpandedIndex = index;
                                        }
                                      });
                                    },
                                    children: _panelData
                                        .map<ExpansionPanelRadio>(
                                            (ExpansionPanelData
                                                expansionPanelData) {
                                      final int index = _panelData
                                          .indexOf(expansionPanelData);
                                      _showPreview.add(false);
                                      contentNameAdd
                                          .add(TextEditingController());
                                      _contentAddController
                                          .add(QuillController.basic());
                                      // contentDetailupdate
                                      //     .add(TextEditingController());

                                      return ExpansionPanelRadio(
                                        backgroundColor: Colors.white,
                                        value: index,
                                        canTapOnHeader: true,
                                        headerBuilder: (BuildContext context,
                                            bool isExpanded) {
                                          final int index = _panelData
                                              .indexOf(expansionPanelData);
                                          print(index);

                                          return ListTile(
                                            tileColor: Colors.white,
                                            leading: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  clearAndRemoveData(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.cancel,
                                                color: Color(0xFFFF543E),
                                              ),
                                            ),
                                            title: Text(
                                              'เนื้อหาย่อยที่ ${contentList.length + index + 1}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          );
                                        },
                                        body: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // เอาไว้เปลี่ยน layout จากตอนแรก Row เป็น Column ถ้าหน้าจอย่อลง
                                              screensize ==
                                                      ScreenSize.minidesktop
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width ,
                                                          height: 1000,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(25.0),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "ชื่อ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "*",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Color(0xffCFD3D4)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          contentNameAdd[
                                                                              index],
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
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "กรอกชื่อคลังความรู้ได้ไม่เกิน 30 ตัวอักษร",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 30),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "เนื้อหา",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "*",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 400,
                                                                  child:
                                                                      Expanded(
                                                                          child:
                                                                              Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        QuillToolbar
                                                                            .simple(
                                                                          configurations:
                                                                              QuillSimpleToolbarConfigurations(
                                                                            controller:
                                                                                _contentAddController[index],
                                                                            sharedConfigurations:
                                                                                const QuillSharedConfigurations(
                                                                              locale: Locale('de'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                QuillEditor.basic(
                                                                              configurations: QuillEditorConfigurations(
                                                                                controller: _contentAddController[index],
                                                                                placeholder: 'เขียนข้อความที่นี่...',
                                                                                readOnly: false,
                                                                                sharedConfigurations: const QuillSharedConfigurations(
                                                                                  locale: Locale('de'),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "รูปภาพ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "*",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                18,
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
                                                                      color: Colors
                                                                          .white70,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200,
                                                                          offset: const Offset(
                                                                              0.0,
                                                                              0.5),
                                                                          blurRadius:
                                                                              30.0,
                                                                        )
                                                                      ]),
                                                                  width: MediaQuery.of(
                                                                          context)
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
                                                                              onPressed: () => pickPhotoFromGallery(index),
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                height: 200.0,
                                                                                child: AspectRatio(
                                                                                  aspectRatio: 1.0, // กำหนดสัดส่วนเป็น 1:1 เพื่อให้รูปภาพเต็มพื้นที่ของ Container
                                                                                  child: expansionPanelImagesList.length > index && expansionPanelImagesList[index].isNotEmpty
                                                                                      ? kIsWeb
                                                                                          ? Image.network(
                                                                                              expansionPanelImagesList[index].first.path,
                                                                                              fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
                                                                                            )
                                                                                          : Image.file(
                                                                                              File(expansionPanelImagesList[index].first.path),
                                                                                              fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
                                                                                            )
                                                                                      : Image.network(
                                                                                          "https://static.thenounproject.com/png/3322766-200.png",
                                                                                          width: MediaQuery.of(context).size.width * 0.01,
                                                                                          height: 200.0,
                                                                                        ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.vertical,
                                                                            child:
                                                                                Wrap(
                                                                              spacing: 5.0,
                                                                              direction: Axis.horizontal,
                                                                              alignment: WrapAlignment.spaceEvenly,
                                                                              runSpacing: 10.0,
                                                                              children: (expansionPanelImagesList.length > index && expansionPanelImagesList[index].isNotEmpty)
                                                                                  ? expansionPanelImagesList[index]
                                                                                      .map<Widget>(
                                                                                        (XFile xFile) => Padding(
                                                                                          padding: const EdgeInsets.all(0),
                                                                                          child: Container(
                                                                                            height: 200.0,
                                                                                            child: AspectRatio(
                                                                                              aspectRatio: 16 / 9,
                                                                                              child: kIsWeb ? Image.network(xFile.path) : Image.file(File(xFile.path)),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                      .toList()
                                                                                  : itemPhotosWidgetList,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                SizedBox(
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
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "เพิ่มรูปภาพ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 30),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    displaycontentAdd(
                                                                        expansionPanelData,
                                                                        index);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        YellowColor,
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
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width ,
                                                          height: 1000,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(25.0),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Container(
                                                                  width: 390,
                                                                  height: 750,
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    color: Color(
                                                                        0xFFE7E7E7),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5,
                                                                          color:
                                                                              GPrimaryColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 2,
                                                                          child:
                                                                              Expanded(
                                                                            child:
                                                                                _previewWidget(expansionPanelData, index),
                                                                            // _displayedcontentWidget ??
                                                                            //     Container(),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
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
                                                    )
                                                  : Row(
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.33,
                                                          height: 1000,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(25.0),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "ชื่อ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "*",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Color(0xffCFD3D4)),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          contentNameAdd[
                                                                              index],
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
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "กรอกชื่อคลังความรู้ได้ไม่เกิน 30 ตัวอักษร",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 30),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0.0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "เนื้อหา",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "*",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 400,
                                                                  child:
                                                                      Expanded(
                                                                          child:
                                                                              Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        QuillToolbar
                                                                            .simple(
                                                                          configurations:
                                                                              QuillSimpleToolbarConfigurations(
                                                                            controller:
                                                                                _contentAddController[index],
                                                                            sharedConfigurations:
                                                                                const QuillSharedConfigurations(
                                                                              locale: Locale('de'),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                QuillEditor.basic(
                                                                              configurations: QuillEditorConfigurations(
                                                                                controller: _contentAddController[index],
                                                                                placeholder: 'เขียนข้อความที่นี่...',
                                                                                readOnly: false,
                                                                                sharedConfigurations: const QuillSharedConfigurations(
                                                                                  locale: Locale('de'),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                                ),
                                                                const SizedBox(
                                                                    height: 20),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "รูปภาพ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "*",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.red,
                                                                            fontSize:
                                                                                18,
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
                                                                      color: Colors
                                                                          .white70,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200,
                                                                          offset: const Offset(
                                                                              0.0,
                                                                              0.5),
                                                                          blurRadius:
                                                                              30.0,
                                                                        )
                                                                      ]),
                                                                  width: MediaQuery.of(
                                                                          context)
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
                                                                              onPressed: () => pickPhotoFromGallery(index),
                                                                              child: Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                height: 200.0,
                                                                                child: AspectRatio(
                                                                                  aspectRatio: 1.0, // กำหนดสัดส่วนเป็น 1:1 เพื่อให้รูปภาพเต็มพื้นที่ของ Container
                                                                                  child: expansionPanelImagesList.length > index && expansionPanelImagesList[index].isNotEmpty
                                                                                      ? kIsWeb
                                                                                          ? Image.network(
                                                                                              expansionPanelImagesList[index].first.path,
                                                                                              fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
                                                                                            )
                                                                                          : Image.file(
                                                                                              File(expansionPanelImagesList[index].first.path),
                                                                                              fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
                                                                                            )
                                                                                      : Image.network(
                                                                                          "https://static.thenounproject.com/png/3322766-200.png",
                                                                                          width: MediaQuery.of(context).size.width * 0.01,
                                                                                          height: 200.0,
                                                                                        ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.vertical,
                                                                            child:
                                                                                Wrap(
                                                                              spacing: 5.0,
                                                                              direction: Axis.horizontal,
                                                                              alignment: WrapAlignment.spaceEvenly,
                                                                              runSpacing: 10.0,
                                                                              children: (expansionPanelImagesList.length > index && expansionPanelImagesList[index].isNotEmpty)
                                                                                  ? expansionPanelImagesList[index]
                                                                                      .map<Widget>(
                                                                                        (XFile xFile) => Padding(
                                                                                          padding: const EdgeInsets.all(0),
                                                                                          child: Container(
                                                                                            height: 200.0,
                                                                                            child: AspectRatio(
                                                                                              aspectRatio: 16 / 9,
                                                                                              child: kIsWeb ? Image.network(xFile.path) : Image.file(File(xFile.path)),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                      .toList()
                                                                                  : itemPhotosWidgetList,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                SizedBox(
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
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "เพิ่มรูปภาพ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 30),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    displaycontentAdd(
                                                                        expansionPanelData,
                                                                        index);
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        YellowColor,
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
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.33,
                                                          height: 1000,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(25.0),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Container(
                                                                  width: 390,
                                                                  height: 750,
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    color: Color(
                                                                        0xFFE7E7E7),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          width:
                                                                              5,
                                                                          color:
                                                                              GPrimaryColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 2,
                                                                          child:
                                                                              Expanded(
                                                                            child:
                                                                                _previewWidget(expansionPanelData, index),
                                                                            // _displayedcontentWidget ??
                                                                            //     Container(),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
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
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.67,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        final nameController =
                                            TextEditingController();
                                        final detailController =
                                            QuillController.basic();
                                        List<Widget> expansionPanelImagesList =
                                            []; // สร้างรายการว่างสำหรับรูปภาพ

                                        _panelData.add(ExpansionPanelData(
                                          nameController: nameController,
                                          detailController: detailController,
                                          itemPhotosWidgetList:
                                              expansionPanelImagesList, // ให้รายการรูปภาพใน ExpansionPanelData เป็นรายการว่าง
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.add_box_rounded,
                                              color: GPrimaryColor),
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
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DialogCancleEdit(),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xC5C5C5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25.0,
                                                vertical: 18.0),
                                          ),
                                          child: Text(
                                            "ยกเลิก",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            for (int i = 0;
                                                i <
                                                    expansionPanelImagesList
                                                        .length;
                                                i++) {
                                              final deltaJson =
                                                  _contentAddController[i]
                                                      .document
                                                      .toDelta()
                                                      .toJson();
                                              print(deltaJson);

                                              final converter =
                                                  QuillDeltaToHtmlConverter(
                                                List.castFrom(deltaJson),
                                              );
                                              _html = converter.convert();

                                              htmlAddList.add(_html);
                                              print(htmlAddList);
                                            }

                                            // htmlLists.add(htmlList);
                                            // print(htmlLists);

                                            for (int index = 0;
                                                index < contentList.length;
                                                index++) {
                                              final deltaJson =
                                                  contentDetailControllers[
                                                          index]
                                                      .document
                                                      .toDelta()
                                                      .toJson();
                                              print(deltaJson);

                                              final converter =
                                                  QuillDeltaToHtmlConverter(
                                                List.castFrom(deltaJson),
                                              );
                                              _html = converter.convert();

                                              htmlUpdateList.add(_html);
                                              print(_html);
                                            }

                                            uploadImageAndSaveItemInfo();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25.0,
                                                vertical: 18.0),
                                            backgroundColor: YellowColor,
                                          ),
                                          child: uploading
                                              ? SizedBox(
                                                  height: 15.0,
                                                  child:
                                                      CircularProgressIndicator(),
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
          ],
        ),
      ),
    );
  }

  Widget _displayedWidget = Container();
  void display() {
    // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
    setState(() {
      // เรียกใช้งาน Widget ที่จะแสดงผล
      _displayedWidget = _displaycoverWidget();
    });
  }

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

  Widget _displayedcontentAddWidget = Container();

  Widget _displaycontentAddWidget(
      ExpansionPanelData expansionPanelData, int index) {
    return Scaffold(
      appBar: Appbarmain_no_botton(
        name: contentNameAdd.isNotEmpty ? contentNameAdd[index].text : '',
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: expansionPanelImagesList.length,
            itemBuilder: (BuildContext context, int panelIndex) {
              List<XFile> panelImages = expansionPanelImagesList[panelIndex];

              return SizedBox(
                height: 253, // กำหนดความสูงของ Container สำหรับแสดงรูปภาพ
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: panelImages.length,
                  itemBuilder: (BuildContext context, int photoIndex) {
                    return Container(
                      width: 390, // กำหนดความกว้างของรูปภาพ
                      child: kIsWeb
                          ? Image.network(
                              expansionPanelImagesList[index].first.path,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(panelImages[photoIndex].path),
                            ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
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
                      // for (int index = 0;
                      //     index < contentNameupdate.length;
                      //     index++)
                      Text(
                        contentNameAdd[index].text,
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
                        child: _displayedWidgetHtmlWidget[index],
                      ),
                    ],
                  )
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     // for (int index = 0;
                  //     //     index < contentDetailupdate.length;
                  //     //     index++)
                  //       Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Text(
                  //           contentDetailupdate[index].text,
                  //           style: TextStyle(color: Colors.black, fontSize: 15),
                  //           textAlign: TextAlign.left,
                  //           maxLines: null,
                  //         ),
                  //       ),
                  //   ],
                  // )
                ],
              ),
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
                  child: _displayedcontentAddWidget,
                )
              ],
            ),
          )
        : Container(); // แสดงเป็น Container เปล่าถ้า _showPreview[index] เป็น false
  }

  List<Widget> _displayedWidgetHtmlWidget =
      List.generate(_panelData.length, (_) => Container());

  void displaycontentAdd(ExpansionPanelData expansionPanelData, int index) {
    setState(() {
      if (_displayedWidgetHtmlWidget.length != _panelData.length) {
        _displayedWidgetHtmlWidget =
            List.generate(_panelData.length, (_) => Container());
      }
      final deltaJson =
          _contentAddController[index].document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(List.castFrom(deltaJson));
      final html = converter.convert();

      _displayedWidgetHtmlWidget[index] = HtmlWidget(
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
      _displayedcontentAddWidget =
          _displaycontentAddWidget(expansionPanelData, index);
      _showPreview[index] =
          true; // อัปเดตค่า _showPreview ของ index นั้นเป็น true
    });
  }

  Widget _displaycontentWidget(int index) {
    String contentId = contentList[index].id;

    print(index);
    return Scaffold(
      appBar: Appbarmain_no_botton(
        name: contentNameControllers.isNotEmpty
            ? contentNameControllers[index].text
            : '',
      ),
      body: Stack(
        children: [
          ListView.builder(
            // itemCount: expansionPanelImagesList.length,
            itemBuilder: (BuildContext context, int panelIndex) {
              // List<XFile> panelImages = expansionPanelImagesList[panelIndex];

              return SizedBox(
                height: 253, // กำหนดความสูงของ Container สำหรับแสดงรูปภาพ
                child: ListView.builder(
                  // itemCount: panelImages.length,
                  itemBuilder: (BuildContext context, int photoIndex) {
                    return Center(
                      child: (updatedImageFilesMap[contentId] ?? []).isNotEmpty
                          ? Container(
                              child: Row(
                                children: updatedImageFilesMap[contentId]!
                                    .map(
                                      (xFile) => Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Image.network(
                                          xFile.path,
                                          fit: BoxFit.cover,
                                          height: 253,
                                          width: 380,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : Container(
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                child: contentList.isNotEmpty &&
                                        contentList.length > index
                                    ? Image.network(
                                        contentList[index].ImageURL,
                                        fit: BoxFit.cover,
                                      )
                                    : SizedBox(),
                              ),
                            ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.width * 1.85,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              decoration: const BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        icons[_selectedValue] ?? Icons.error,
                        size: 24,
                        color: GPrimaryColor,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        contentNameControllers[index].text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
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
                        child: displayedContentWidgets![index],
                      ),
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

  void displaycontents(int index) {
    setState(() {
      final deltaJson =
          contentDetailControllers[index].document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(List.castFrom(deltaJson));
      final html = converter.convert();

      displayedContentWidgets![index] = HtmlWidget(
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
      // if (displayedContentWidgets != null &&
      //     index < displayedContentWidgets!.length) {
      displayedContentWidgets![index] = _displaycontentWidget(index);

      // }
    });
  }

  int _selectedIndex = 0;

  Widget buildList() {
    return displayedContentWidgets != null
        ? ExpansionPanelList.radio(
            expansionCallback: (
              int index,
              bool isExpanded,
            ) {
              setState(() {
                _selectedIndex = isExpanded ? -1 : index;
              });
            },
            children: List.generate(
              displayedContentWidgets!.length,
              (index) => ExpansionPanelRadio(
                backgroundColor: Colors.white,
                value: index,
                headerBuilder: (
                  BuildContext context,
                  bool isExpanded,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: ListTile(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal: 32,
                                              ),
                                              foregroundColor: Colors.red,
                                              side:
                                                  BorderSide(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("ยกเลิก"),
                                          ),
                                          SizedBox(width: 20),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: GPrimaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20,
                                                horizontal: 32,
                                              ),
                                              foregroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              deleteContentById(widget
                                                  .knowledge!.contents[index]);
                                              Navigator.pop(context);

                                              // showDialog(
                                              //   context: context,
                                              //   builder: (context) =>
                                              //       DeleteknowledgeSuccess(),

                                              // );
                                            },
                                            child: const Text("ยืนยัน"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Color(0xFFFF543E),
                        ),
                      ),
                    ),
                  );
                },
                body: buildListItemBody(index),
                canTapOnHeader: true,
              ),
            ),
          )
        : Container();
  }

  Widget buildListItemBody(int index) {
    String contentId = contentList[index].id;
    ScreenSize screenSize = getScreenSize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            screenSize == ScreenSize.minidesktop
                                ? Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 1000,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
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
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xffCFD3D4)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: TextField(
                                                    controller:
                                                        contentNameControllers[
                                                            index],
                                                    maxLength:
                                                        30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                                padding: const EdgeInsets.only(
                                                    left: 0.0, right: 0),
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
                                                            locale:
                                                                Locale('de'),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color: Color.fromARGB(
                                                              255,
                                                              238,
                                                              238,
                                                              238),
                                                          child:
                                                              QuillEditor.basic(
                                                            configurations:
                                                                QuillEditorConfigurations(
                                                              controller:
                                                                  _contentController,
                                                              readOnly: false,
                                                              sharedConfigurations:
                                                                  const QuillSharedConfigurations(
                                                                locale: Locale(
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
                                                  child: (updatedImageFilesMap[
                                                                  contentId] ??
                                                              [])
                                                          .isNotEmpty
                                                      ? SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children:
                                                                updatedImageFilesMap[
                                                                        contentId]!
                                                                    .map(
                                                                      (xFile) =>
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        child: Image
                                                                            .network(
                                                                          xFile
                                                                              .path,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                          ),
                                                        )
                                                      : Center(
                                                          child: MaterialButton(
                                                            onPressed: () =>
                                                                pickPhotoFromGallers(
                                                                    contentId),
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Center(
                                                                child: contentList
                                                                            .isNotEmpty &&
                                                                        contentList.length >
                                                                            index
                                                                    ? Image
                                                                        .network(
                                                                        contentList[index]
                                                                            .ImageURL,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : SizedBox(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    pickPhotoFromGallers(
                                                        contentId),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.yellow,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Text(
                                                  "แก้ไขรูปภาพ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // display();
                                                  displaycontents(index);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xffE69800),
                                                  shape: RoundedRectangleBorder(
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 1000,
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
                                                height: 750,
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFFE7E7E7),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 5,
                                                        color: GPrimaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            2,
                                                        child: Expanded(
                                                          child: displayedContentWidgets !=
                                                                      null &&
                                                                  displayedContentWidgets!
                                                                          .length >
                                                                      index
                                                              ? displayedContentWidgets![
                                                                  index]!
                                                              : Container(),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        height: 1000,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
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
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xffCFD3D4)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: TextField(
                                                    controller:
                                                        contentNameControllers[
                                                            index],
                                                    maxLength:
                                                        30, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                                padding: const EdgeInsets.only(
                                                    left: 0.0, right: 0),
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
                                                            locale:
                                                                Locale('de'),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          color: Color.fromARGB(
                                                              255,
                                                              238,
                                                              238,
                                                              238),
                                                          child:
                                                              QuillEditor.basic(
                                                            configurations:
                                                                QuillEditorConfigurations(
                                                              controller:
                                                                  _contentController,
                                                              readOnly: false,
                                                              sharedConfigurations:
                                                                  const QuillSharedConfigurations(
                                                                locale: Locale(
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
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       left: 0.0, right: 0),
                                              //   child: Container(
                                              //     decoration: BoxDecoration(
                                              //         border: Border.all(
                                              //             color: Color(0xffCFD3D4)),
                                              //         borderRadius:
                                              //             BorderRadius.circular(5)),
                                              //     child: TextField(
                                              //       controller:
                                              //           contentDetailControllers[
                                              //               index],

                                              //       // controller: TextEditingController(
                                              //       //     text: contentList[index]
                                              //       //         .ContentDetail),
                                              //       keyboardType:
                                              //           TextInputType.multiline,
                                              //       maxLines: 5,
                                              //       decoration: InputDecoration(
                                              //           focusedBorder:
                                              //               OutlineInputBorder(
                                              //                   borderSide:
                                              //                       BorderSide(
                                              //                           width: 1,
                                              //                           color: Colors
                                              //                               .white))),
                                              //     ),
                                              //   ),
                                              // ),
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
                                                  child: (updatedImageFilesMap[
                                                                  contentId] ??
                                                              [])
                                                          .isNotEmpty
                                                      ? SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children:
                                                                updatedImageFilesMap[
                                                                        contentId]!
                                                                    .map(
                                                                      (xFile) =>
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        child: Image
                                                                            .network(
                                                                          xFile
                                                                              .path,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                          ),
                                                        )
                                                      : Center(
                                                          child: MaterialButton(
                                                            onPressed: () =>
                                                                pickPhotoFromGallers(
                                                                    contentId),
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Center(
                                                                child: contentList
                                                                            .isNotEmpty &&
                                                                        contentList.length >
                                                                            index
                                                                    ? Image
                                                                        .network(
                                                                        contentList[index]
                                                                            .ImageURL,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : SizedBox(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    pickPhotoFromGallers(
                                                        contentId),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.yellow,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Text(
                                                  "แก้ไขรูปภาพ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // display();
                                                  displaycontents(index);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xffE69800),
                                                  shape: RoundedRectangleBorder(
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        height: 1000,
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
                                                height: 750,
                                                decoration: ShapeDecoration(
                                                  color: Color(0xFFE7E7E7),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 5,
                                                        color: GPrimaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            2,
                                                        child: Expanded(
                                                          child: displayedContentWidgets !=
                                                                      null &&
                                                                  displayedContentWidgets!
                                                                          .length >
                                                                      index
                                                              ? displayedContentWidgets![
                                                                  index]!
                                                              : Container(),
                                                        ),
                                                      )
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
