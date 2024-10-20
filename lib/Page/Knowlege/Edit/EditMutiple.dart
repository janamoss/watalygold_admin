import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/htmltodelta.dart';
import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
import 'package:watalygold_admin/Widgets/Appbarmain.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Dialog/Deleteddialogknowledge.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart'
    as pickerImageSource;
import 'package:watalygold_admin/Widgets/Dialog/DeleteknowledgeSuccess.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogEdit.dart';
import 'package:watalygold_admin/Widgets/Dialog/dialogcancleEdit.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:watalygold_admin/service/flushbar_uit.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

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
  final sidebarController = Get.put(SidebarController());

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
  List<TextEditingController> contentNameAdd = [];
  List<QuillController> _contentAddController = [];
  List<QuillController> contentDetailControllers = [];
  QuillController _contentController = QuillController.basic();
  String _html = '';
  List<String> htmlUpdateList = [];
  List<String> htmlAddList = [];
  int _current = 0;
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
  final CarouselController _controller = CarouselController();
  List<List<XFile>> expansionPanelImagesList = [];
  List<List<XFile>> updatedImageFiles = [];
  Map<String, List<String>> localImageUrls = {};
  Map<String, List<XFile>> updatedImageFilesMap = {};
  List<List<String>> newImageUrlsList = [];

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
      debugPrint("Error getting knowledge: $error");
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
        ImageURL: (data['image_url'] as List).cast<String>().toList(),
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

  Future<void> deleteContentAndUpdateUI(String documentId, int index) async {
    // String documentId = widget.knowledge!.contents[index].id; // สมมติว่ามี id
    try {
      await Databasemethods().deleteContent(documentId);
      setState(() {
        contentList.removeAt(index);
        widget.knowledge!.contents.removeAt(index);
        displayedContentWidgets!.removeAt(index);
      });
      showDialog(
        context: context,
        builder: (context) => DeleteknowledgeSuccess(),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop(); // ปิด Dialog ประสบความสำเร็จ
      });
    } catch (e) {
      debugPrint('Error deleting content: $e');
      // อาจจะแสดง error dialog ที่นี่
    }
  }

  // void deleteContentById(String documentId) async {
  //   try {
  //     await Databasemethods().deleteContent(documentId);
  //     showDialog(
  //       context: context,
  //       builder: (context) => DeleteknowledgeSuccess(),
  //     );
  //     Future.delayed(Duration(seconds: 1), () {
  //       Navigator.pop(context); // ปิด Dialog ประสบความสำเร็จ
  //     });
  //   } catch (e) {
  //     debugPrint('Error deleting content: $e');
  //   }
  // }

  Future<void> updateContent(List<List<String>> newImageUrlsList,
      List<List<String>> updatedImageUrlsList) async {
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

      // อัปเดตข้อมูลทั่วไป
      await knowledgeDocRef.update({
        'KnowledgeName': namecontroller.text,
        'KnowledgeIcons': _selectedValue ??
            icons.keys.firstWhere(
                (key) => icons[key].toString() == selectedValue,
                orElse: () => ''),
        'update_at': Timestamp.now()
      });

      List<String> updatedContentIds = [];

      // อัปเดต content ที่มีอยู่
      for (int index = 0; index < contentList.length; index++) {
        String contentId = contentList[index].id;
        String contentName = contentNameControllers[index].text;
        String contentDetail = htmlUpdateList[index];
        List<String> imageUrl = contentList[index].ImageURL;

        updatedContentIds.add(
            await upContent(contentId, contentName, contentDetail, imageUrl));
      }

      // เพิ่ม content ใหม่
      for (int index = 0; index < newImageUrlsList.length; index++) {
        String contentNamenew = contentNameAdd[index].text;
        String contentdetailnew = htmlAddList[index];
        List<String> imageUrls = newImageUrlsList[index];

        String newContentId =
            await addContent(contentNamenew, contentdetailnew, imageUrls);
        updatedContentIds.add(newContentId);
      }

      // อัปเดตรายการ Content ID ใน Knowledge document
      await knowledgeDocRef.update({'Content': updatedContentIds});

      // แสดง dialog และ navigate
      showDialog(
        context: context,
        builder: (context) => DialogEdit(),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        context.goNamed(
          "/mainKnowledge",
          extra: {
            'showSuccessFlushbar': true,
            'message': "แก้ไขคลังความรู้เสร็จสิ้น",
            'description': "คุณได้ทำแก้ไขคลังความรู้เสร็จสิ้นเรียบร้อย"
          },
        );
      });
    } catch (error) {
      showErrorFlushbar(context, "แก้ไขคลังความรู้ล้มเหลว",
          "เกิดข้อผิดพลาดบางอย่าง กรุณาลองใหม่อีกครั้ง");
    }
  }

  Future<String> upContent(
    String contentId,
    String contentName,
    String contentDetail,
    List<String> imageUrls,
  ) async {
    try {
      Map<String, dynamic> updateContent = {
        'ContentName': contentName,
        'ContentDetail': contentDetail,
        'image_url': imageUrls,
        'update_at': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('Content')
          .doc(contentId)
          .update(updateContent);

      debugPrint('Updating content with ID: $contentId');
      debugPrint('Content updated successfully');

      return contentId;
    } catch (e) {
      debugPrint('Error updating content: $e');
      rethrow;
    }
  }

  List<String> contentIds = [];

  Future<String> addContent(String contentNamenew, String contentdetailnew,
      List<String> imageUrls) async {
    Map<String, dynamic> contentMap = {
      "ContentName": contentNamenew,
      "ContentDetail": contentdetailnew,
      "image_url": imageUrls,
      "create_at": Timestamp.now(),
      "deleted_at": null,
      "update_at": null,
    };
    debugPrint(" contentNamenew ${contentNamenew}");
    debugPrint('addContent successfully');
    String contentId = const Uuid().v4().substring(0, 10);
    await Databasemethods().addContent(contentMap, contentId);

    return contentId;
  }

  Future<void> editImage(int contentIndex, int imageIndex) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: pickerImageSource.ImageSource.gallery);
    if (image != null) {
      String contentId = contentList[contentIndex].id;
      // แปลง XFile เป็น PickedFile
      PickedFile pickedFile = PickedFile(image.path);
      // อัปโหลดรูปภาพโดยใช้ฟังก์ชันที่มีอยู่
      List<String> uploadedUrls =
          await uploadImagesToStorage([pickedFile], contentId);
      if (uploadedUrls.isNotEmpty) {
        String newImageUrl =
            uploadedUrls[0]; // เราอัปโหลดเพียงรูปเดียว จึงใช้ index 0
        setState(() {
          if (localImageUrls[contentId] == null) {
            localImageUrls[contentId] =
                List.from(contentList[contentIndex].ImageURL);
          }
          // แทนที่หรือเพิ่ม URL ใหม่
          if (imageIndex < localImageUrls[contentId]!.length) {
            localImageUrls[contentId]![imageIndex] = newImageUrl;
          } else {
            localImageUrls[contentId]!.add(newImageUrl);
          }
          // อัปเดต contentList เพื่อสะท้อนการเปลี่ยนแปลง
          if (imageIndex < contentList[contentIndex].ImageURL.length) {
            contentList[contentIndex].ImageURL[imageIndex] = newImageUrl;
          } else {
            contentList[contentIndex].ImageURL.add(newImageUrl);
          }
        });
      }
    }
  }

  Future<void> pickPhotoFromGallery(int index) async {
    debugPrint("srr");
    List<XFile>? newPhotos = await _picker.pickMultiImage();
    if (newPhotos != null) {
      setState(() {
        debugPrint("srr11");
        if (expansionPanelImagesList.length <= index) {
          expansionPanelImagesList.add(newPhotos);
          debugPrint("expansionPanelImagesList");
        } else {
          expansionPanelImagesList[index].addAll(newPhotos);
        }
        debugPrint("${expansionPanelImagesList[index]}");
      });
    }
  }

  Future<void> pickPhotoFromGallers(String contentId) async {
    List<XFile>? newPhotos = await _picker.pickMultiImage();
    if (newPhotos != null && newPhotos.isNotEmpty) {
      List<PickedFile> pickedFiles =
          newPhotos.map((xFile) => PickedFile(xFile.path)).toList();
      List<String> uploadedUrls =
          await uploadImagesToStorage(pickedFiles, contentId);

      setState(() {
        if (contentId == 'new') {
          expansionPanelImagesList.add(newPhotos);
        } else {
          int index =
              contentList.indexWhere((content) => content.id == contentId);
          if (index != -1) {
            contentList[index].ImageURL.addAll(uploadedUrls);
            localImageUrls[contentId] = List.from(contentList[index].ImageURL);
          }
        }
      });
    }
  }

  void deleteImage(int contentIndex, int imageIndex) {
    setState(() {
      String contentId = contentList[contentIndex].id;
      debugPrint(
          "Before deletion: localImageUrls[$contentId] = ${localImageUrls[contentId]}");
      debugPrint(
          "Before deletion: contentList[$contentIndex].ImageURL = ${contentList[contentIndex].ImageURL}");

      if (localImageUrls.containsKey(contentId)) {
        if (imageIndex < localImageUrls[contentId]!.length) {
          localImageUrls[contentId]!.removeAt(imageIndex);
          debugPrint("Removed image from localImageUrls");
        } else {
          debugPrint("imageIndex out of range for localImageUrls");
        }
        if (localImageUrls[contentId]!.isEmpty) {
          localImageUrls.remove(contentId);
          debugPrint("Removed empty entry from localImageUrls");
        }
      }
      if (imageIndex < contentList[contentIndex].ImageURL.length) {
        contentList[contentIndex].ImageURL.removeAt(imageIndex);
        debugPrint("Removed image from contentList");
      } else {
        debugPrint("imageIndex out of range for contentList");
      }
      debugPrint(
          "After deletion: localImageUrls[$contentId] = ${localImageUrls[contentId]}");
      debugPrint(
          "After deletion: contentList[$contentIndex].ImageURL = ${contentList[contentIndex].ImageURL}");
    });
  }

  Future<void> editImageAdd(int panelIndex, int imageIndex) async {
    final editedPhoto =
        await _picker.pickImage(source: pickerImageSource.ImageSource.gallery);
    if (editedPhoto != null) {
      setState(() {
        expansionPanelImagesList[panelIndex][imageIndex] = editedPhoto;
      });
    }
  }

  void deleteImageAdd(int panelIndex, int imageIndex) {
    setState(() {
      expansionPanelImagesList[panelIndex].removeAt(imageIndex);
      if (expansionPanelImagesList[panelIndex].isEmpty) {
        expansionPanelImagesList.removeAt(panelIndex);
      }
    });
  }

  Future<List<String>> uploadImagesToStorage(
      List<PickedFile> pickedFiles, String contentId) async {
    List<String> imageUrls = [];
    for (PickedFile pickedFile in pickedFiles) {
      try {
        String kId = const Uuid().v4().substring(0, 10);
        Reference reference = FirebaseStorage.instance
            .ref()
            .child('Content/$contentId/contentImg_$kId');
        UploadTask uploadTask = reference.putData(
          await pickedFile.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'),
        );
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        imageUrls.add(imageUrl);
      } catch (e) {
        debugPrint("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

  Future<void> uploadImageAndSaveItemInfo() async {
    List<List<String>> updatedImageUrlsList = [];
    for (var entry in updatedImageFilesMap.entries) {
      String contentId = entry.key;
      List<XFile> updatedImageFileList = entry.value;
      List<PickedFile> pickedFiles =
          updatedImageFileList.map((xFile) => PickedFile(xFile.path)).toList();
      List<String> updatedImageUrls =
          await uploadImagesToStorage(pickedFiles, contentId);

      int index = contentList.indexWhere((content) => content.id == contentId);
      if (index != -1) {
        // แทนที่รูปภาพเดิมด้วยรูปภาพที่อัปเดต
        contentList[index].ImageURL = updatedImageUrls;
        updatedImageUrlsList.add(updatedImageUrls);
      }
    }
    // จัดการกับรูปภาพใหม่
    for (var newImages in expansionPanelImagesList) {
      String newContentId = const Uuid().v4().substring(0, 10);
      List<PickedFile> pickedFiles =
          newImages.map((xFile) => PickedFile(xFile.path)).toList();
      List<String> newImageUrls =
          await uploadImagesToStorage(pickedFiles, newContentId);
      newImageUrlsList.add(newImageUrls);
    }
    // เรียกใช้ updateContent เพื่ออัปเดตข้อมูลใน Firebase
    await updateContent(newImageUrlsList, updatedImageUrlsList);
    // เคลียร์ข้อมูลหลังอัปโหลด
    setState(() {
      uploading = false;
      updatedImageFilesMap.clear();
      expansionPanelImagesList.clear();
      localImageUrls.clear(); // เคลียร์ URLs ท้องถิ่นที่ใช้สำหรับแสดงผล
    });
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
      debugPrint("$expansionPanelImagesList");
    });
  }

  Future<void> loadData() async {
    if (widget.knowledge != null) {
      namecontroller.text = widget.knowledge!.knowledgeName;
      contentcontroller.text = widget.knowledge!.knowledgeDetail;
      _selectedValue = widget.knowledge!.knowledgeIconString;
    }
    setState(() {
      _isLoading = true;
    });
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

          String htmlString = contents.ContentDetail;
          var delta = HtmlToDeltaConverter.htmlToDelta(htmlString);

          _contentController = QuillController(
            document: Document.fromDelta(delta),
            selection: const TextSelection.collapsed(offset: 0),
          );
          contentDetailControllers.add(_contentController);
          debugPrint("$contentDetailControllers");
        });
      }

      debugPrint("${contents.deleted_at}");
      debugPrint("$contentList");
      debugPrint(contents.ContentName);
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
      debugPrint("displayedContentWidgets ${displayedContentWidgets}");
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
      List<String> tempImageURLlist = [];
      for (var knowledge in value) {
        String imageUrl = '';
        if (knowledge.knowledgeImg.isNotEmpty) {
          imageUrl = knowledge.knowledgeImg[0];
        } else if (knowledge.contents.isNotEmpty) {
          try {
            final firstContent = knowledge.contents[0].toString();
            final contents = await getContentsById(firstContent);
            if (contents.ImageURL.isNotEmpty) {
              imageUrl = contents.ImageURL[0];
            }
          } catch (e) {
            debugPrint("Error fetching content: $e");
          }
        }
        tempImageURLlist.add(imageUrl);
      }

      setState(() {
        knowledgelist = value;
        imageURLlist = tempImageURLlist;
        _isLoading = false;
      });

      debugPrint("$knowledgelist");
      debugPrint("$imageURLlist");
      debugPrint("${imageURLlist.length}");
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
                      child: Center(
                        // padding:
                        //     EdgeInsets.only(top: 22, bottom: 10, left: 80, right: 80),
                        child: Text(
                          'เนื้อหาเดียว',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.18,
                      height: MediaQuery.of(context).size.width * 0.05,
                      decoration: BoxDecoration(
                        color: GPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'หลายเนื้อหา',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }

  Widget buildImageStack(BuildContext context, String imagePath,
      {bool isLocal = false}) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          child: isLocal
              ? Image.file(File(imagePath), fit: BoxFit.cover)
              : Image.network(imagePath, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 8.0,
          right: 8.0,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
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
                onPressed: () {},
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
                        status: sidebarController.index.value == 1
                            ? sidebarController.index.value = 1
                            : sidebarController.index.value = 1,
                        dropdown: sidebarController.dropdown.value == true
                            ? sidebarController.dropdown.value == true
                            : sidebarController.dropdown.value == true,
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
                          status: sidebarController.index.value == 1
                              ? sidebarController.index.value = 1
                              : sidebarController.index.value = 1,
                          dropdown: sidebarController.dropdown.value == true
                              ? sidebarController.dropdown.value == true
                              : sidebarController.dropdown.value == true,
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
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                items: <String>[
                                                                  'ใบไม้',
                                                                  'ต้นกล้า',
                                                                  'ไวรัส',
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
                                                                ].map<
                                                                    DropdownMenuItem<
                                                                        String>>((String
                                                                    value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        value,
                                                                    child: Row(
                                                                      children: [
                                                                        icons[value] !=
                                                                                null
                                                                            ? Icon(
                                                                                icons[value]!,
                                                                                color: GPrimaryColor,
                                                                              )
                                                                            : const SizedBox(),
                                                                        const SizedBox(
                                                                            width:
                                                                                15),
                                                                        Text(
                                                                          value,
                                                                          style:
                                                                              const TextStyle(color: GPrimaryColor),
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
                                                                hint: const Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .image_outlined,
                                                                      color:
                                                                          GPrimaryColor,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Text(
                                                                      "เลือกไอคอนสำหรับคลังความรู้",
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            GPrimaryColor,
                                                                        fontSize:
                                                                            17,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                value:
                                                                    _selectedValue,
                                                                dropdownStyleData:
                                                                    DropdownStyleData(
                                                                  maxHeight:
                                                                      300,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14),
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
                                                        SizedBox(height: 30),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
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
                                                                  20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                items: <String>[
                                                                  'ใบไม้',
                                                                  'ต้นกล้า',
                                                                  'ไวรัส',
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
                                                                ].map<
                                                                    DropdownMenuItem<
                                                                        String>>((String
                                                                    value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        value,
                                                                    child: Row(
                                                                      children: [
                                                                        icons[value] !=
                                                                                null
                                                                            ? Icon(
                                                                                icons[value]!,
                                                                                color: GPrimaryColor,
                                                                              )
                                                                            : const SizedBox(),
                                                                        const SizedBox(
                                                                            width:
                                                                                15),
                                                                        Text(
                                                                          value,
                                                                          style:
                                                                              const TextStyle(color: GPrimaryColor),
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
                                                                hint: const Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .image_outlined,
                                                                      color:
                                                                          GPrimaryColor,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Text(
                                                                      "เลือกไอคอนสำหรับคลังความรู้",
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            GPrimaryColor,
                                                                        fontSize:
                                                                            17,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                value:
                                                                    _selectedValue,
                                                                dropdownStyleData:
                                                                    DropdownStyleData(
                                                                  maxHeight:
                                                                      300,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14),
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
                                                        SizedBox(height: 30),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
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
                                                                  20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                          debugPrint("$index");

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
                                                              .width,
                                                          height: 1100,
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
                                                                          20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
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
                                                                SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    QuillToolbar.simple(
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        showFontFamily: false,
                                        showFontSize: false,
                                        showInlineCode: false,
                                        showSubscript: false,
                                        showSuperscript: false,
                                        showSearchButton: false,
                                        showQuote: false,
                                        showLink: false,
                                        showIndent: false,
                                        showCodeBlock: false,
                                        showColorButton: false,
                                        showBackgroundColorButton: false,
                                        controller: _contentAddController[index],
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                    QuillEditor.basic(
                                      configurations: QuillEditorConfigurations(
                                        controller: _contentAddController[index],
                                        placeholder: 'เขียนข้อความที่นี่...',
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                    boxShadow: [
                                                                      // ... (boxShadow properties)
                                                                    ],
                                                                  ),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.5,
                                                                  height: 250.0,
                                                                  child: Center(
                                                                    child: expansionPanelData
                                                                            .itemPhotosWidgetList
                                                                            .isEmpty
                                                                        ? SizedBox(
                                                                            child: expansionPanelImagesList.length > index && expansionPanelImagesList[index].isNotEmpty
                                                                                ? Column(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: CarouselSlider(
                                                                                          options: CarouselOptions(
                                                                                            height: 200.0,
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
                                                                                              .map<Widget>((XFile xFile) => Stack(
                                                                                                    fit: StackFit.expand,
                                                                                                    children: [
                                                                                                      Container(
                                                                                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                                                        child: ClipRRect(
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
                                                                                                      Positioned(
                                                                                                        bottom: 8.0,
                                                                                                        right: 8.0,
                                                                                                        child: Row(
                                                                                                          children: [
                                                                                                            IconButton(
                                                                                                              onPressed: () {
                                                                                                                debugPrint("Edit button pressed");
                                                                                                                editImageAdd(index, _current);
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
                                                                                                              onPressed: () {
                                                                                                                debugPrint("Delete button pressed");
                                                                                                                deleteImageAdd(index, _current);
                                                                                                              },
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
                                                                                                  ))
                                                                                              .toList(),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: expansionPanelImagesList[index].asMap().entries.map((entry) {
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
                                                                                    height: 250.0,
                                                                                    onPressed: () => pickPhotoFromGallery(index),
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                                                      child: Image.network(
                                                                                        "https://static.thenounproject.com/png/3322766-200.png",
                                                                                        height: 100.0,
                                                                                        width: 100.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                          )
                                                                        : Container(),
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
                                                              .width,
                                                          height: 1200,
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
                                                                        SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 2,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: _previewWidget(expansionPanelData, index),
                                                                                // _displayedcontentWidget ??
                                                                                //     Container(),
                                                                              ),
                                                                            ],
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
                                                          height: 1100,
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
                                                                          20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
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
                                                                          SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    QuillToolbar.simple(
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        showFontFamily: false,
                                        showFontSize: false,
                                        showInlineCode: false,
                                        showSubscript: false,
                                        showSuperscript: false,
                                        showSearchButton: false,
                                        showQuote: false,
                                        showLink: false,
                                        showIndent: false,
                                        showCodeBlock: false,
                                        showColorButton: false,
                                        showBackgroundColorButton: false,
                                        controller: _contentAddController[index],
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                    QuillEditor.basic(
                                      configurations: QuillEditorConfigurations(
                                        controller: _contentAddController[index],
                                        placeholder: 'เขียนข้อความที่นี่...',
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12.0),
                                                                    boxShadow: [
                                                                      // ... (boxShadow properties)
                                                                    ],
                                                                  ),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.5,
                                                                  height: 250.0,
                                                                  child: Center(
                                                                    child: expansionPanelData
                                                                            .itemPhotosWidgetList
                                                                            .isEmpty
                                                                        ? SizedBox(
                                                                            child: expansionPanelImagesList.length > index && expansionPanelImagesList[index].isNotEmpty
                                                                                ? Column(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: CarouselSlider(
                                                                                          options: CarouselOptions(
                                                                                            height: 200.0,
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
                                                                                              .map<Widget>((XFile xFile) => Stack(
                                                                                                    fit: StackFit.expand,
                                                                                                    children: [
                                                                                                      Container(
                                                                                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                                                        child: ClipRRect(
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
                                                                                                      Positioned(
                                                                                                        bottom: 8.0,
                                                                                                        right: 8.0,
                                                                                                        child: Row(
                                                                                                          children: [
                                                                                                            IconButton(
                                                                                                              onPressed: () {
                                                                                                                debugPrint("Edit button pressed");
                                                                                                                editImageAdd(index, _current);
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
                                                                                                              onPressed: () {
                                                                                                                debugPrint("Delete button pressed");
                                                                                                                deleteImageAdd(index, _current);
                                                                                                              },
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
                                                                                                  ))
                                                                                              .toList(),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: expansionPanelImagesList[index].asMap().entries.map((entry) {
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
                                                                                    height: 250.0,
                                                                                    onPressed: () => pickPhotoFromGallery(index),
                                                                                    child: Container(
                                                                                      width: MediaQuery.of(context).size.width * 0.5,
                                                                                      child: Image.network(
                                                                                        "https://static.thenounproject.com/png/3322766-200.png",
                                                                                        height: 100.0,
                                                                                        width: 100.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                          )
                                                                        : Container(),
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
                                                                        SizedBox(
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 2,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Expanded(
                                                                                child: _previewWidget(expansionPanelData, index),
                                                                                // _displayedcontentWidget ??
                                                                                //     Container(),
                                                                              ),
                                                                            ],
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
                                              debugPrint("$deltaJson");

                                              final converter =
                                                  QuillDeltaToHtmlConverter(
                                                List.castFrom(deltaJson),
                                              );
                                              _html = converter.convert();

                                              htmlAddList.add(_html);
                                              debugPrint("$htmlAddList");
                                            }

                                            // htmlLists.add(htmlList);
                                            // debugPrint(htmlLists);

                                            for (int index = 0;
                                                index < contentList.length;
                                                index++) {
                                              final deltaJson =
                                                  contentDetailControllers[
                                                          index]
                                                      .document
                                                      .toDelta()
                                                      .toJson();
                                              debugPrint("$deltaJson");

                                              final converter =
                                                  QuillDeltaToHtmlConverter(
                                                List.castFrom(deltaJson),
                                              );
                                              _html = converter.convert();

                                              htmlUpdateList.add(_html);
                                              debugPrint(_html);
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
                        contentNameAdd[index].text,
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
          Container(
            // width: MediaQuery.of(context).size.width * 1,
            height: 250,
            child: Center(
              child: Builder(
                builder: (BuildContext context) {
                  String contentId = contentList[index].id;
                  List<String> imageUrls =
                      localImageUrls[contentId] ?? contentList[index].ImageURL;

                  if (imageUrls.isEmpty) {
                    return const Center(child: Text('No images'));
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 250.0,
                            viewportFraction: 1.0,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: imageUrls.asMap().entries.map((entry) {
                            final url = entry.value;
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print("Error loading image: $error");
                                      return Center(
                                          child: Text('Error loading image'));
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
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
                      child: displayedContentWidgets![index],
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
      print(html);

      // }
    });
  }

  int _selectedIndex = 0;
  void deleteContent(int index) {
    setState(() {
      widget.knowledge!.contents.removeAt(index);
      displayedContentWidgets!.removeAt(index);
    });
  }

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
                                              // deleteContentById(widget
                                              //     .knowledge!.contents[index]);
                                              Navigator.pop(context);
                                              deleteContentAndUpdateUI(
                                                  widget.knowledge!
                                                      .contents[index],
                                                  index);
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
                          ).then((value) => Navigator.popUntil(context,
                              ModalRoute.withName("/editmultiKnowledge")));
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
                                        height: 1100,
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
                                              const Padding(
                                                padding: EdgeInsets.only(
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
                                                        20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                               SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    QuillToolbar.simple(
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        showFontFamily: false,
                                        showFontSize: false,
                                        showInlineCode: false,
                                        showSubscript: false,
                                        showSuperscript: false,
                                        showSearchButton: false,
                                        showQuote: false,
                                        showLink: false,
                                        showIndent: false,
                                        showCodeBlock: false,
                                        showColorButton: false,
                                        showBackgroundColorButton: false,
                                        controller: contentDetailControllers[
                                                                  index],
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                    QuillEditor.basic(
                                      configurations: QuillEditorConfigurations(
                                        controller: contentDetailControllers[
                                            index],
                                        placeholder: 'เขียนข้อความที่นี่...',
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: 250.0,
                                                child: Center(
                                                  child: Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      String contentId =
                                                          contentList[index].id;
                                                      List<String> imageUrls =
                                                          localImageUrls[
                                                                  contentId] ??
                                                              contentList[index]
                                                                  .ImageURL;

                                                      if (imageUrls.isEmpty) {
                                                        return const Center(
                                                            child: Text(
                                                                'No images'));
                                                      }

                                                      return Column(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                height: 200.0,
                                                                viewportFraction:
                                                                    1.0,
                                                                enlargeCenterPage:
                                                                    true,
                                                                autoPlay: false,
                                                                onPageChanged:
                                                                    (index,
                                                                        reason) {
                                                                  setState(() {
                                                                    _current =
                                                                        index;
                                                                  });
                                                                },
                                                              ),
                                                              items: imageUrls
                                                                  .asMap()
                                                                  .entries
                                                                  .map((entry) {
                                                                final url =
                                                                    entry.value;
                                                                return Builder(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Stack(
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 5.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          child:
                                                                              Image.network(
                                                                            url,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) {
                                                                              print("Error loading image: $error");
                                                                              return Center(child: Text('Error loading image'));
                                                                            },
                                                                            loadingBuilder: (context,
                                                                                child,
                                                                                loadingProgress) {
                                                                              if (loadingProgress == null)
                                                                                return child;
                                                                              return Center(child: CircularProgressIndicator());
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          bottom:
                                                                              8.0,
                                                                          right:
                                                                              8.0,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () => editImage(index, entry.key),
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
                                                                                onPressed: () => deleteImage(index, entry.key),
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
                                                                  },
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: imageUrls
                                                                .asMap()
                                                                .entries
                                                                .map((entry) {
                                                              return GestureDetector(
                                                                onTap: () => _controller
                                                                    .animateToPage(
                                                                        entry
                                                                            .key),
                                                                child:
                                                                    Container(
                                                                  width: 8.0,
                                                                  height: 8.0,
                                                                  margin: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          4.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: (Theme.of(context).brightness == Brightness.dark
                                                                            ? Colors
                                                                                .white
                                                                            : GPrimaryColor)
                                                                        .withOpacity(_current ==
                                                                                entry.key
                                                                            ? 0.9
                                                                            : 0.4),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                // onPressed: () =>
                                                //     pickPhotoFromGallers(
                                                //         contentId),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      GPrimaryColor,
                                                  shape: RoundedRectangleBorder(
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
                                        height: 1100,
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
                                                        20, // จำกัดจำนวนตัวอักษรไม่เกิน 30
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
                                               SizedBox(
                              height: 400,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    QuillToolbar.simple(
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        showFontFamily: false,
                                        showFontSize: false,
                                        showInlineCode: false,
                                        showSubscript: false,
                                        showSuperscript: false,
                                        showSearchButton: false,
                                        showQuote: false,
                                        showLink: false,
                                        showIndent: false,
                                        showCodeBlock: false,
                                        showColorButton: false,
                                        showBackgroundColorButton: false,
                                        controller: contentDetailControllers[
                                                                  index],
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                    QuillEditor.basic(
                                      configurations: QuillEditorConfigurations(
                                        controller: contentDetailControllers[
                                            index],
                                        placeholder: 'เขียนข้อความที่นี่...',
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: 250.0,
                                                child: Center(
                                                  child: Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      String contentId =
                                                          contentList[index].id;
                                                      List<String> imageUrls =
                                                          localImageUrls[
                                                                  contentId] ??
                                                              contentList[index]
                                                                  .ImageURL;

                                                      if (imageUrls.isEmpty) {
                                                        return const Center(
                                                            child: Text(
                                                                'No images'));
                                                      }

                                                      return Column(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                height: 200.0,
                                                                viewportFraction:
                                                                    1.0,
                                                                enlargeCenterPage:
                                                                    true,
                                                                autoPlay: false,
                                                                onPageChanged:
                                                                    (index,
                                                                        reason) {
                                                                  setState(() {
                                                                    _current =
                                                                        index;
                                                                  });
                                                                },
                                                              ),
                                                              items: imageUrls
                                                                  .asMap()
                                                                  .entries
                                                                  .map((entry) {
                                                                final url =
                                                                    entry.value;
                                                                return Builder(
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Stack(
                                                                      children: [
                                                                        Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 5.0),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          child:
                                                                              Image.network(
                                                                            url,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) {
                                                                              print("Error loading image: $error");
                                                                              return Center(child: Text('Error loading image'));
                                                                            },
                                                                            loadingBuilder: (context,
                                                                                child,
                                                                                loadingProgress) {
                                                                              if (loadingProgress == null)
                                                                                return child;
                                                                              return Center(child: CircularProgressIndicator());
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          bottom:
                                                                              8.0,
                                                                          right:
                                                                              8.0,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () => editImage(index, entry.key),
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
                                                                                onPressed: () => deleteImage(index, entry.key),
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
                                                                  },
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: imageUrls
                                                                .asMap()
                                                                .entries
                                                                .map((entry) {
                                                              return GestureDetector(
                                                                onTap: () => _controller
                                                                    .animateToPage(
                                                                        entry
                                                                            .key),
                                                                child:
                                                                    Container(
                                                                  width: 8.0,
                                                                  height: 8.0,
                                                                  margin: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          4.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: (Theme.of(context).brightness == Brightness.dark
                                                                            ? Colors
                                                                                .white
                                                                            : GPrimaryColor)
                                                                        .withOpacity(_current ==
                                                                                entry.key
                                                                            ? 0.9
                                                                            : 0.4),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    pickPhotoFromGallers(
                                                        contentId),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      GPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "เพิ่มรูปภาพ",
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