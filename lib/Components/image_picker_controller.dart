// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:uuid/uuid.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
// import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
// import 'package:watalygold_admin/Widgets/Appbarmain.dart';
// import 'package:watalygold_admin/Widgets/Color.dart';
// import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
// import 'package:watalygold_admin/service/content.dart';
// import 'package:watalygold_admin/service/database.dart';
// import 'package:watalygold_admin/service/knowledge.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// Map<String, IconData> icons = {
//   'สถิติ': Icons.analytics_outlined,
//   'ดอกไม้': Icons.yard,
//   'หนังสือ': Icons.book,
//   'น้ำ': Icons.water_drop_outlined,
//   'ระวัง': Icons.warning_rounded,
//   'คำถาม': Icons.quiz_outlined,
// };

// class ExpansionPanelData {
//   TextEditingController nameController;
//   TextEditingController detailController;
//   List<Widget> itemPhotosWidgetList;

//   ExpansionPanelData({
//     required this.nameController,
//     required this.detailController,
//     required this.itemPhotosWidgetList,
//   });
// }

// List<ExpansionPanelData> _panelData = [];

// class EditMutiple extends StatefulWidget {
//   final Knowledge? knowledge;
//   final IconData? icons;
//   final Contents? contents;

//   const EditMutiple({super.key, this.knowledge, this.contents, this.icons});

//   @override
//   State<EditMutiple> createState() => _EditMutipleState();
// }

// class _EditMutipleState extends State<EditMutiple> {
//   bool _customTileExpanded = false;
//   List<List<String>> allKnowledgeContents = [];
//   TextEditingController contentNameController = TextEditingController();
//   String? message;
//   List<Widget> _displayedContentWidgets =
//       List.filled(_panelData.length, Container());

//   IconData? selectedIconData;
//   String? _selectedValue;

//   int _currentExpandedIndex = -1;
//   bool addedContent = false;
//   TextEditingController contentcontroller = new TextEditingController();
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController contentdetailcontroller = TextEditingController();
//   TextEditingController contentnamecontroller = TextEditingController();
//   List<TextEditingController> contentNameControllers = [];
//   List<TextEditingController> contentDetailControllers = [];
//   List<TextEditingController> contentNameupdate = [];
//   List<TextEditingController> contentDetailupdate = [];
//   List<Knowledge> knowledgelist = [];
//   List<int> _deletedPanels = [];
// // List<Widget> itemPhotosWidgetList = [];
//   List<Widget> itemPhotosWidgetList = <Widget>[]; //แสดงตัวอย่างรูปภาพ
//   final ImagePicker _picker = ImagePicker();
//   File? file;
//   List<XFile>? photo =
//       <XFile>[]; //เป็นรายการของ XFile ที่ใช้ในการเก็บรูปภาพที่เลือกจากแกล
//   List<XFile> itemImagesList =
//       <XFile>[]; //ใช้ในการเก็บรูปภาพที่ผู้ใช้เลือกเพื่ออัปโหลด
//   List<String> downloadUrl = <String>[]; //เก็บ url ภาพ
//   bool uploading = false;
//   bool _isLoading = true;
//   List<Contents> contentList = [];
//   List<String> imageURLlist = [];
//   List<String> ContentDetaillist = [];
//   List<String> ContentNamelist = [];
//   List? itemContent;
//   List<String> ListimageUrl = [];

//   Future<List<Knowledge>> getKnowledges() async {
//     try {
//       final FirebaseFirestore firestore = FirebaseFirestore.instance;
//       final querySnapshot = await firestore
//           .collection('Knowledge')
//           .where('deleted_at', isNull: true)
//           .get();
//       return querySnapshot.docs
//           .map((doc) => Knowledge.fromFirestore(doc))
//           .toList();
//     } catch (error) {
//       print("Error getting knowledge: $error");
//       return []; // Or handle the error in another way
//     }
//   }

//   Future<Contents> getContentsById(String documentId) async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final docRef = firestore.collection('Content').doc(documentId);
//     final doc = await docRef.get();

//     if (doc.exists) {
//       final data = doc.data();
//       return Contents(
//         id: doc.id,
//         ContentName: data!['ContentName'].toString(),
//         ContentDetail: data['ContentDetail'].toString(),
//         ImageURL: data['image_url'].toString(),
//         deleted_at: doc['deleted_at'],
//         create_at: data['create_at'] as Timestamp? ??
//             Timestamp.fromDate(DateTime.now()),
//       );
//     } else {
//       throw Exception('Document not found with ID: $documentId');
//     }
//   }

//   void showToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.grey[800],
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   void deleteContentById(String documentId) async {
//     try {
//       await Databasemethods().deleteContent(documentId);
//       showToast("ลบข้อมูลเสร็จสิ้น");
//     } catch (e) {
//       print('Error deleting content: $e');
//     }
//   }

// //   Future<void> uploadImageAndSaveItemInfo() async {
// //     setState(() {
// //       uploading = true;
// //     });
// //     PickedFile? pickedFile;
// //     String? contentIdnew = const Uuid().v4().substring(0, 10);
// //     for (int i = 0; i < contentList.length + itemImagesList.length; i++) {
// //       if (itemImagesList.length == 0) {
// //         ListimageUrl.add(contentList[i].ImageURL);
// //         print(ListimageUrl);
// //       } else {
// //         for (int i = 0; i < itemImagesList.length; i++) {
// //           file = File(itemImagesList[i].path);
// //           print(itemImagesList[i].path);
// //           pickedFile = PickedFile(file!.path);
// //           await uploadImageToStorage(pickedFile, contentIdnew, i);
// //         }
// //         ListimageUrl.add(contentList[i].ImageURL);
// //         print(ListimageUrl);
// //       }
// //     }
// //     await updateContent(ListimageUrl);
// //     // เรียกใช้ addAllContentOnce เพื่อเพิ่มข้อมูลลง Firebase Firestore ครั้งเดียวเท่านั้น
// //     setState(() {
// //       uploading = false;
// //     });
// //   }

// //   Future<void> updateContent(List<String> imageUrl) async {
// //     String? selectedValue;
// //     print("start");
// //     selectedValue = widget.knowledge!.knowledgeIcons != null
// //         ? widget.knowledge!.knowledgeIcons.toString()
// //         : widget.icons != null
// //             ? icons.keys.firstWhere(
// //                 (key) => icons[key] == widget.icons,
// //                 orElse: () => '',
// //               )
// //             : null;
// //     try {
// //       print("start loop");
// //       final knowledgeDocRef = FirebaseFirestore.instance
// //           .collection('Knowledge')
// //           .doc(widget.knowledge!.id);
// //       // ใช้ ID ของ Knowledge ที่กำลังแก้ไข

// //       await knowledgeDocRef.update({
// //         'KnowledgeName': namecontroller.text,
// //         'KnowledgeIcons': _selectedValue ??
// //             icons.keys.firstWhere(
// //                 (key) => icons[key].toString() == selectedValue,
// //                 orElse: () => ''),
// //         'update_at': Timestamp.now()
// //       });
// //       print(contentList);
// //       print(ListimageUrl);
// //       print(contentNameControllers.length);
// //       print(contentDetailControllers.length);

// //       List<String> contentIds = [];

// //       for (int index = 0; index < contentList.length; index++) {
// //         String contentName = contentNameControllers[index].text;
// //         String contentDetail = contentDetailControllers[index].text;
// //         String imageUrl = ListimageUrl[index].toString();
// //         String contentId = contentList[index].id;

// //         print(" id ${contentId}");
// //         print(" name ${contentName}");
// //         print(" detail ${contentDetail}");
// //         print(" url ${imageUrl}");

// //         await upContent(contentId, contentName, contentDetail, imageUrl);
// //       }
// //       print("3");
// // // Check if there are new contents to be added
// //       if (itemImagesList.isNotEmpty) {
// //         for (int index = contentList.length;
// //             index < contentList.length + itemImagesList.length;
// //             index++) {
// //           String contentName = contentNameControllers[index].text;
// //           String contentDetail = contentDetailControllers[index].text;
// //           String imageUrl = ListimageUrl[index].toString();
// //           String? contentId;

// //           // Generate a new contentId if it's a new content
// //           if (index >= contentList.length) {
// //             contentId = await addContent(contentName, contentDetail, imageUrl);
// //             contentIds.add(contentId);
// //           } else {
// //             contentId = contentList[index].id;
// //             await upContent(contentId, contentName, contentDetail, imageUrl);
// //             contentIds.add(contentId);
// //           }

// //           print(" id ${contentId}");
// //           print(" name ${contentName}");
// //           print(" detail ${contentDetail}");
// //           print(" url ${imageUrl}");
// //         }
// //       }
// //       print(contentIds);
// //       await knowledgeDocRef
// //           .update({'Content': contentIds, 'update_at': Timestamp.now()});
// //     } catch (error) {
// //       print("Error getting knowledge: $error");
// //       // Or handle the error in another way
// //     }
// //   }

//   Future<void> uploadImageAndSaveItemInfo() async {
//     print('star uploadImageAndSaveItemInfo ');

//     setState(() {
//       uploading = true;
//     });

//     PickedFile? pickedFile;
//     String? contentIdnew = const Uuid().v4().substring(0, 10);

//     for (int i = 0; i < contentList.length + itemImagesList.length; i++) {
//       if (itemImagesList.length == 0) {
//         ListimageUrl.add(contentList[i].ImageURL);
//         print(ListimageUrl);
//       } else {
//         for (int i = 0; i < itemImagesList.length; i++) {
//           file = File(itemImagesList[i].path);
//           print(itemImagesList[i].path);
//           pickedFile = PickedFile(file!.path);
//           await uploadImageToStorage(pickedFile, contentIdnew, i);
//         }
//         ListimageUrl.add(contentList[i].ImageURL);
//         print(ListimageUrl);
//       }
//     }

//     await updateContent(ListimageUrl);

//     // Update Content data
//     for (int index = 0; index < contentList.length; index++) {
//       updateContentData(index);
//     }

//     setState(() {
//       uploading = false;
//     });
//   }

//   void updateContentData(int index) async {
//     String contentName = contentNameControllers[index].text;
//     String contentDetail = contentDetailControllers[index].text;
//     String contentId = contentList[index].id;
//     String imageUrl = contentList[index].ImageURL;

//     try {
//       await upContent(contentId, contentName, contentDetail, imageUrl, index);
//       contentIds.add(contentId);
//       // ซ่อนตัวควบคุม TextField หรือทำการดำเนินการอื่นๆ หลังจากอัปเดตข้อมูลสำเร็จ
//     } catch (e) {
//       print('Error updating content late: $e');
//     }
//   }

//   List<String> contentIds = [];

//   Future<void> updateContent(List<String> imageUrl) async {
//     String? selectedValue;
//     print("start");
//     selectedValue = widget.knowledge!.knowledgeIcons != null
//         ? widget.knowledge!.knowledgeIcons.toString()
//         : widget.icons != null
//             ? icons.keys.firstWhere(
//                 (key) => icons[key] == widget.icons,
//                 orElse: () => '',
//               )
//             : null;

//     try {
//       print("start loop");
//       final knowledgeDocRef = FirebaseFirestore.instance
//           .collection('Knowledge')
//           .doc(widget.knowledge!.id);

//       await knowledgeDocRef.update({
//         'KnowledgeName': namecontroller.text,
//         'KnowledgeIcons': _selectedValue ??
//             icons.keys.firstWhere(
//                 (key) => icons[key].toString() == selectedValue,
//                 orElse: () => ''),
//         // "Content": contentIds,
//         'update_at': Timestamp.now()
//       });
//       print("contentIds = ${contentIds}");
//       print("contentList = ${contentList}");
//       print(ListimageUrl);
//       print(contentNameControllers.length);
//       print(contentDetailControllers.length);

//       for (int index = 0; index < contentList.length; index++) {
//         String contentName = contentNameControllers[index].text;
//         String contentDetail = contentDetailControllers[index].text;
//         String imageUrl = ListimageUrl[index].toString();
//         String contentId = contentList[index].id;

//         print(" id ${contentId}");
//         print(" name ${contentName}");
//         print(" detail ${contentDetail}");
//         print(" url ${imageUrl}");

//         await upContent(contentId, contentName, contentDetail, imageUrl, index);
//       }

//       print("3");
//       contentIds.clear();
//       // Check if there are new contents to be added
//       if (itemImagesList.isNotEmpty) {
//         for (int index = contentList.length;
//             index < contentList.length + itemImagesList.length;
//             index++) {
//           String contentName = contentNameControllers[index].text;
//           String contentNamenew = contentNameupdate[index].text;
//           String contentdetailnew = contentDetailupdate[index].text;

//           String contentDetail = contentDetailControllers[index].text;
//           String imageUrl = ListimageUrl[index].toString();
//           String? contentId;

//           // Generate a new contentId if it's a new content
//           if (index >= contentList.length) {
//             contentId =
//                 await addContent(contentNamenew, contentdetailnew, imageUrl);
//             contentIds.add(contentId);
//           } else {
//             contentId = contentList[index].id;
//             await upContent(
//                 contentId, contentName, contentDetail, imageUrl, index);
//             contentIds.add(contentId);
//           }

//           print(" id ${contentId}");
//           print(" name ${contentName}");
//           print(" detail ${contentDetail}");
//           print(" url ${imageUrl}");
//         }
//       }
//       print("contentIds ${contentIds}");
//       print("contentNameControllers ${contentNameControllers}");
//       await knowledgeDocRef.update({'update_at': Timestamp.now()});
//     } catch (error) {
//       print("Error getting knowledge: $error");
//     }
//   }

//   Future<String> addContent(
//       String contentNamenew, String contentdetailnew, String imageUrl) async {
//     Map<String, dynamic> contentMap = {
//       "ContentName": contentNamenew,
//       "ContentDetail": contentdetailnew,
//       "image_url": imageUrl,
//       "create_at": Timestamp.now(),
//       "deleted_at": null,
//       "update_at": null,
//     };

//     // Generate a unique ID (replace with your preferred method)
//     String contentId = const Uuid().v4().substring(0, 10);

//     // Add data using addKnowlege, passing both contentMap and generated ID
//     await Databasemethods().addContent(contentMap, contentId);
//     return contentId;
//   }

//   Future<void> upContent(String contentId, String contentName,
//       String contentDetail, String imageUrl, int index) async {
//     try {
//       Map<String, dynamic> updateContent = {
//         'ContentName': contentName,
//         'ContentDetail': contentDetail,
//         'image_url': imageUrl,
//         'update_at': Timestamp.now(),
//       };

//       print('contentIds: $contentIds');
//       print('contentId: $contentId');
//       // Update the existing content document with the provided contentId
//       await FirebaseFirestore.instance
//           .collection('Content')
//           .doc(contentId)
//           .update(updateContent);
//       print('Updating content with ID: $contentId');

//       print('Content updated successfully');
//     } catch (e) {
//       print('Error updating content new: $e');
//     }
//   }

//   // void removeImage() {
//   //   setState(() {
//   //     itemPhotosWidgetList.clear(); // ลบภาพเดิมทั้งหมด
//   //   });
//   // }

//   // Future<void> pickPhotoFromGallery(
//   //     ExpansionPanelData expansionPanelData) async {
//   //   photo = await _picker.pickMultiImage();
//   //   if (photo != null) {
//   //     setState(() {
//   //       List<XFile> tempImageList =
//   //           photo!; // เก็บรูปภาพที่เลือกล่าสุดไว้ใน tempImageList
//   //       addImage(expansionPanelData,
//   //           tempImageList); // ส่ง tempImageList ไปยังฟังก์ชัน addImage
//   //       photo!.clear();
//   //     });
//   //   }
//   // }

//   Future<void> pickPhotoFromGallery(
//       ExpansionPanelData expansionPanelData) async {
//     photo = await _picker.pickMultiImage();
//     if (photo != null) {
//       setState(() {
//         itemImagesList = itemImagesList + photo!;
//         addImage(expansionPanelData);
//         photo!.clear();
//       });
//       // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
//     }
//   }

//   void addImage(ExpansionPanelData expansionPanelData) {
//     // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
//     expansionPanelData.itemPhotosWidgetList.clear();

//     // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
//     for (var bytes in photo!) {
//       expansionPanelData.itemPhotosWidgetList.add(
//         Padding(
//           padding: const EdgeInsets.all(0),
//           child: Container(
//             height: 200.0,
//             child: AspectRatio(
//               aspectRatio: 16 / 9,
//               child: Container(
//                 child: kIsWeb
//                     ? Image.network(File(bytes.path).path)
//                     : Image.file(
//                         File(bytes.path),
//                       ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }
//   // void addImage(
//   //     ExpansionPanelData expansionPanelData, List<XFile> tempImageList) {
//   //   // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
//   //   expansionPanelData.itemPhotosWidgetList.clear();
//   //   itemImagesList.clear(); // ล้าง itemImagesList ก่อนเพิ่มรูปภาพใหม่

//   //   // เพิ่มรูปภาพใหม่จาก tempImageList ลงใน itemPhotosWidgetList และ itemImagesList
//   //   for (var bytes in tempImageList) {
//   //     expansionPanelData.itemPhotosWidgetList.add(
//   //       Padding(
//   //         padding: const EdgeInsets.all(0),
//   //         child: Container(
//   //           height: 200.0,
//   //           child: AspectRatio(
//   //             aspectRatio: 16 / 9,
//   //             child: Container(
//   //               child: kIsWeb
//   //                   ? Image.network(File(bytes.path).path)
//   //                   : Image.file(
//   //                       File(bytes.path),
//   //                     ),
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //     itemImagesList.add(bytes); // เพิ่มรูปภาพใหม่เข้าไปใน itemImagesList
//   //   }
//   // }

//   uploadImageToStorage(PickedFile? pickedFile, String contentId, index) async {
//     String? kId = const Uuid().v4().substring(0, 10);
//     Reference reference = FirebaseStorage.instance
//         .ref()
//         .child('Content/$contentId/contentImg_$kId');
//     await reference.putData(
//       await pickedFile!.readAsBytes(),
//       SettableMetadata(contentType: 'image/jpeg'),
//     );
//     String imageUrl = await reference.getDownloadURL();

//     // print(imageUrl);
//     // print(ListimageUrl);
//     setState(() {
//       ListimageUrl.add(imageUrl);
//       // print(ListimageUrl);
//     });
//   }

//   void clearAllFields() {
//     namecontroller.clear();
//     contentcontroller.clear();

//     setState(() {
//       selectedIconData = null;
//     });

//     setState(() {
//       itemImagesList.clear();
//       itemPhotosWidgetList.clear();
//     });
//   }

//   // Future<void> loadData() async {
//   //   if (widget.knowledge != null) {
//   //     namecontroller.text = widget.knowledge!.knowledgeName;
//   //     contentcontroller.text = widget.knowledge!.knowledgeDetail;
//   //     // contentNameController.text = widget.knowledge!.contents.ContentName;
//   //   }
//   //   setState(() {
//   //     _isLoading = true; // Set loading state to true
//   //   });
//   //   // ใช้ลูป for ในการวนลูปผ่านทุกๆ document ID ใน widget.knowledge!.contents
//   //   for (var documentId in widget.knowledge!.contents) {
//   //     // ดึงข้อมูล Contents จาก Firestore โดยใช้ document ID แต่ละตัว
//   //     var contents = await getContentsById(documentId);

//   //     if (contents.deleted_at == null) {
//   //       setState(() {
//   //         contentList.add(contents);
//   //       });
//   //     }

//   //     print(contents.deleted_at);
//   //     print(contentList);
//   //     print(contents.ContentName);
//   //   }
//   //   setState(() {
//   //     _isLoading = false;
//   //   });
//   // }
//   Future<void> loadData() async {
//     if (widget.knowledge != null) {
//       namecontroller.text = widget.knowledge!.knowledgeName;
//       contentcontroller.text = widget.knowledge!.knowledgeDetail;
//     }

//     setState(() {
//       _isLoading = true; // Set loading state to true
//     });

//     // Clear the existing controllers
//     contentNameControllers.clear();
//     contentDetailControllers.clear();

//     // ใช้ลูป for ในการวนลูปผ่านทุกๆ document ID ใน widget.knowledge!.contents
//     for (var documentId in widget.knowledge!.contents) {
//       // ดึงข้อมูล Contents จาก Firestore โดยใช้ document ID แต่ละตัว
//       var contents = await getContentsById(documentId);

//       if (contents.deleted_at == null) {
//         setState(() {
//           contentList.add(contents);
//           contentNameControllers
//               .add(TextEditingController(text: contents.ContentName));
//           contentDetailControllers
//               .add(TextEditingController(text: contents.ContentDetail));
//         });
//       }

//       print(contents.deleted_at);
//       print(contentList);
//       print(contents.ContentName);
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//     setState(() {
//       _isLoading = true; // Set loading state to true
//     });

//     getKnowledges().then((value) async {
//       setState(() {
//         knowledgelist = value;
//       });
//       if (knowledgelist.length == 0) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//       for (var knowledge in knowledgelist) {
//         if (knowledge.knowledgeImg.isEmpty) {
//           // แสดง Loading indicator
//           final firstContent = knowledge.contents[0].toString();
//           final contents = await getContentsById(firstContent);
//           imageURLlist.add(contents.ImageURL);
//           setState(() {
//             _isLoading = false;
//           });
//           // ซ่อน Loading indicator
//         } else {
//           imageURLlist.add(knowledge.knowledgeImg);
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 color: GPrimaryColor,
//                 child: SideNav(
//                   status: 1,
//                   dropdown: true,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: Scaffold(
//                 appBar: Appbarmain(),
//                 backgroundColor: GrayColor,
//                 body: SingleChildScrollView(
//                   child: _isLoading
//                       ? Center(
//                           child: LoadingAnimationWidget.discreteCircle(
//                             color: WhiteColor,
//                             secondRingColor: Colors.green,
//                             thirdRingColor: Colors.yellow,
//                             size: 200,
//                           ),
//                         )
//                       : Container(
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 70),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 50,
//                                 ),
//                                 Column(
//                                   children: [
//                                     Center(
//                                       child: Container(
//                                         child: Stack(
//                                           children: [
//                                             FractionallySizedBox(
//                                               widthFactor: 0.9,
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 height: 120,
//                                                 decoration: ShapeDecoration(
//                                                   color: Colors.white,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(20.0),
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 140,
//                                                   ),
//                                                   Container(
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width *
//                                                             0.16,
//                                                     height:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .height *
//                                                             0.08,
//                                                     child: Container(
//                                                         decoration:
//                                                             ShapeDecoration(
//                                                           color: Color.fromARGB(
//                                                               255,
//                                                               255,
//                                                               255,
//                                                               255),
//                                                           shape:
//                                                               RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10),
//                                                           ),
//                                                         ),
//                                                         child: Padding(
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                                   top: 20,
//                                                                   left: 70),
//                                                           child: Text(
//                                                             'เนื้อหาเดี่ยว',
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.grey,
//                                                               fontSize: 20,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                             ),
//                                                           ),
//                                                         )),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 150,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 15),
//                                                     child: Container(
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width *
//                                                               0.16,
//                                                       height:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .height *
//                                                               0.08,
//                                                       child: Container(
//                                                           decoration:
//                                                               ShapeDecoration(
//                                                             color:
//                                                                 GPrimaryColor,
//                                                             shape:
//                                                                 RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                             ),
//                                                           ),
//                                                           child: Padding(
//                                                             padding:
//                                                                 EdgeInsets.only(
//                                                                     top: 16,
//                                                                     left: 70),
//                                                             child: Text(
//                                                               'หลายเนื้อหา',
//                                                               style: TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontSize: 20,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 50,
//                                 ),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.create_outlined,
//                                         size: 30,
//                                         color: GPrimaryColor,
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                         "แก้ไขคลังความรู้ ",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 32,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 50,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 490,
//                                       height: 400,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(25.0),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Image.asset(
//                                                     "assets/images/knowlege.png"),
//                                                 SizedBox(width: 10),
//                                                 Text(
//                                                   "แก้ไขคลังความรู้",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: 30),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0.0, right: 0),
//                                               child: Align(
//                                                 alignment: Alignment.topLeft,
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       "ไอคอน ",
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "*",
//                                                       style: TextStyle(
//                                                         color: Colors.red,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Container(
//                                                 child: DropdownButton(
//                                                   items: <String>[
//                                                     'สถิติ',
//                                                     'ดอกไม้',
//                                                     'หนังสือ',
//                                                     'น้ำ',
//                                                     'ระวัง',
//                                                     'คำถาม'
//                                                   ].map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Row(
//                                                         children: [
//                                                           icons[value] != null
//                                                               ? Icon(
//                                                                   icons[value]!,
//                                                                   color:
//                                                                       GPrimaryColor,
//                                                                 )
//                                                               : SizedBox(),
//                                                           SizedBox(width: 25),
//                                                           Text(
//                                                             value,
//                                                             style: TextStyle(
//                                                                 color:
//                                                                     GPrimaryColor),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   }).toList(),
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       _selectedValue = value;
//                                                     });
//                                                   },
//                                                   hint: Row(
//                                                     children: [
//                                                       // ไอคอนที่ต้องการเพิ่ม
//                                                       SizedBox(
//                                                           width:
//                                                               10), // ระยะห่างระหว่างไอคอนและข้อความ
//                                                       Row(
//                                                         children: [
//                                                           Icon(
//                                                               widget.icons ??
//                                                                   Icons
//                                                                       .question_mark_rounded,
//                                                               color:
//                                                                   GPrimaryColor,
//                                                               size: 24),
//                                                           SizedBox(
//                                                             width: 20,
//                                                           ),
//                                                           Text(
//                                                             "${widget.icons != null ? icons.keys.firstWhere((key) => icons[key] == widget.icons, orElse: () => '') : ''}",
//                                                             style: TextStyle(
//                                                                 color:
//                                                                     GPrimaryColor),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   value: _selectedValue,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(height: 30),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0.0, right: 0),
//                                               child: Align(
//                                                 alignment: Alignment.topLeft,
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       "ชื่อ",
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "*",
//                                                       style: TextStyle(
//                                                         color: Colors.red,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0.0, right: 0),
//                                               child: Container(
//                                                 padding:
//                                                     EdgeInsets.only(left: 10.0),
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: Color(0xffCFD3D4)),
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                 ),
//                                                 child: TextField(
//                                                   controller: namecontroller,
//                                                   decoration: InputDecoration(
//                                                       border: InputBorder.none),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             ElevatedButton(
//                                               onPressed: display,
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     Color(0xffE69800),
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                               ),
//                                               child: Text(
//                                                 "แสดงผล",
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 20), // SizedBox
//                                     Container(
//                                       width: 490,
//                                       height: 400,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(25.0),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons.light_mode_rounded,
//                                                   color: Color(0xffFFEE58),
//                                                 ),
//                                                 SizedBox(width: 10),
//                                                 Text(
//                                                   "แสดงผล",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 40,
//                                             ),
//                                             Container(
//                                               width: 390,
//                                               height: 100,
//                                               decoration: ShapeDecoration(
//                                                 color: Color(0xFFE7E7E7),
//                                                 shape: RoundedRectangleBorder(
//                                                   side: BorderSide(
//                                                       width: 5,
//                                                       color: Color(0xFF42BD41)),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                               ),
//                                               child: Column(
//                                                 children: [
//                                                   Expanded(
//                                                     child: _displayedWidget ??
//                                                         Container(),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     // Container
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 70),
//                                   child: buildList(),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 70),
//                                   child: ExpansionPanelList.radio(
//                                     expansionCallback:
//                                         (int index, bool isExpanded) {
//                                       if (_deletedPanels.contains(index)) {
//                                         return;
//                                       }
//                                       setState(() {
//                                         if (isExpanded) {
//                                           _currentExpandedIndex = index;
//                                         }
//                                       });
//                                     },
//                                     children: _panelData
//                                         .map<ExpansionPanelRadio>(
//                                             (ExpansionPanelData
//                                                 expansionPanelData) {
//                                       final int index = _panelData
//                                           .indexOf(expansionPanelData);

//                                       // สร้าง TextEditingController สำหรับชื่อเนื้อหาและรายละเอียดเนื้อหา

//                                       contentNameupdate
//                                           .add(TextEditingController());
//                                       contentDetailupdate
//                                           .add(TextEditingController());

//                                       return ExpansionPanelRadio(
//                                         backgroundColor: Colors.white,
//                                         value: index,
//                                         canTapOnHeader: true,
//                                         headerBuilder: (BuildContext context,
//                                             bool isExpanded) {
//                                           final int index = _panelData
//                                               .indexOf(expansionPanelData);
//                                           print(index);

//                                           return ListTile(
//                                             tileColor: Colors.white,
//                                             leading: IconButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   setState(() {
//                                                     _deletedPanels.add(index);
//                                                     _panelData.removeAt(index);
//                                                   });
//                                                 });
//                                                 // final deleteDialogContent =
//                                                 //     (String id) => DeletedialogContent(
//                                                 //           id: id,
//                                                 //         );

//                                                 // for (var knowledge in knowledgelist) {
//                                                 // showDialog(
//                                                 //   context: context,
//                                                 //   builder: (context) =>
//                                                 //       deleteDialogContent(
//                                                 //           knowledge.contents),
//                                                 // );
//                                                 // }
//                                               },
//                                               icon: Icon(
//                                                 Icons.cancel,
//                                                 color: Color(0xFFFF543E),
//                                               ),
//                                             ),
//                                             title: Text(
//                                               'เนื้อหาย่อยที่ ${index + 1}',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 18,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         body: Container(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     bottom: 0),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Container(
//                                                     width: 490,
//                                                     height: 750,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       color: Colors.white,
//                                                     ),
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               25.0),
//                                                       child: Column(
//                                                         children: [
//                                                           SizedBox(height: 20),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topLeft,
//                                                               child: Row(
//                                                                 children: [
//                                                                   Text(
//                                                                     "ชื่อ",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                   Text(
//                                                                     "*",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Container(
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       left:
//                                                                           10.0),
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 border: Border.all(
//                                                                     color: Color(
//                                                                         0xffCFD3D4)),
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5),
//                                                               ),
//                                                               child: TextField(
//                                                                 controller:
//                                                                     contentNameupdate[
//                                                                         index],
//                                                                 decoration:
//                                                                     InputDecoration(
//                                                                         border:
//                                                                             InputBorder.none),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 30),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topLeft,
//                                                               child: Row(
//                                                                 children: [
//                                                                   Text(
//                                                                     "เนื้อหา",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                   Text(
//                                                                     "*",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Container(
//                                                               decoration: BoxDecoration(
//                                                                   border: Border.all(
//                                                                       color: Color(
//                                                                           0xffCFD3D4)),
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               5)),
//                                                               child: TextField(
//                                                                 controller:
//                                                                     contentDetailupdate[
//                                                                         index],
//                                                                 keyboardType:
//                                                                     TextInputType
//                                                                         .multiline,
//                                                                 maxLines: 5,
//                                                                 decoration: InputDecoration(
//                                                                     focusedBorder: OutlineInputBorder(
//                                                                         borderSide: BorderSide(
//                                                                             width:
//                                                                                 1,
//                                                                             color:
//                                                                                 Colors.white))),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 30),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0,
//                                                                     right: 0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topLeft,
//                                                               child: Row(
//                                                                 children: [
//                                                                   Text(
//                                                                     "รูปภาพ",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                   Text(
//                                                                     "*",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Container(
//                                                             decoration: BoxDecoration(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             12.0),
//                                                                 color: Colors
//                                                                     .white70,
//                                                                 boxShadow: [
//                                                                   BoxShadow(
//                                                                     color: Colors
//                                                                         .grey
//                                                                         .shade200,
//                                                                     offset:
//                                                                         const Offset(
//                                                                             0.0,
//                                                                             0.5),
//                                                                     blurRadius:
//                                                                         30.0,
//                                                                   )
//                                                                 ]),
//                                                             width:
//                                                                 MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width,
//                                                             height: 200.0,
//                                                             child: Center(
//                                                               child: expansionPanelData
//                                                                       .itemPhotosWidgetList
//                                                                       .isEmpty
//                                                                   ? Center(
//                                                                       child:
//                                                                           MaterialButton(
//                                                                         onPressed:
//                                                                             () {
//                                                                           pickPhotoFromGallery(
//                                                                               _panelData[index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
//                                                                         },
//                                                                         child:
//                                                                             Container(
//                                                                           alignment:
//                                                                               Alignment.bottomCenter,
//                                                                           child:
//                                                                               Center(
//                                                                             child:
//                                                                                 Image.network(
//                                                                               "https://static.thenounproject.com/png/3322766-200.png",
//                                                                               height: 100.0,
//                                                                               width: 100.0,
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     )
//                                                                   : SingleChildScrollView(
//                                                                       scrollDirection:
//                                                                           Axis.vertical,
//                                                                       child:
//                                                                           Wrap(
//                                                                         spacing:
//                                                                             5.0,
//                                                                         direction:
//                                                                             Axis.horizontal,
//                                                                         children:
//                                                                             expansionPanelData.itemPhotosWidgetList,
//                                                                         alignment:
//                                                                             WrapAlignment.spaceEvenly,
//                                                                         runSpacing:
//                                                                             10.0,
//                                                                       ),
//                                                                     ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                           ElevatedButton(
//                                                             onPressed: () {
//                                                               pickPhotoFromGallery(
//                                                                   _panelData[
//                                                                       index]);
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               backgroundColor:
//                                                                   G2PrimaryColor,
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                               ),
//                                                             ),
//                                                             child: Text(
//                                                               "เพิ่มรูปภาพ",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 30),
//                                                           ElevatedButton(
//                                                             onPressed: () {
//                                                               displaycontent(
//                                                                   expansionPanelData,
//                                                                   index);
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               backgroundColor:
//                                                                   Color(
//                                                                       0xffE69800),
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                               ),
//                                                             ),
//                                                             child: Text(
//                                                               "แสดงผล",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     width: 490,
//                                                     height: 700,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       color: Colors.white,
//                                                     ),
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               25.0),
//                                                       child: Column(
//                                                         children: [
//                                                           SizedBox(
//                                                             height: 20,
//                                                           ),
//                                                           Container(
//                                                             width: 390,
//                                                             height: 600,
//                                                             decoration:
//                                                                 ShapeDecoration(
//                                                               color: Color(
//                                                                   0xFFE7E7E7),
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 side: BorderSide(
//                                                                     width: 5,
//                                                                     color: Color(
//                                                                         0xFF42BD41)),
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                               ),
//                                                             ),
//                                                             child: Column(
//                                                               children: [
//                                                                 Expanded(
//                                                                   child: _displayedContentWidgets[
//                                                                           index] ??
//                                                                       Container(),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 20,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 75),
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         final nameController =
//                                             TextEditingController();
//                                         final detailController =
//                                             TextEditingController();
//                                         List<Widget> itemPhotosWidgetList =
//                                             []; // สร้างรายการว่างสำหรับรูปภาพ

//                                         _panelData.add(ExpansionPanelData(
//                                           nameController: nameController,
//                                           detailController: detailController,
//                                           itemPhotosWidgetList:
//                                               itemPhotosWidgetList, // ให้รายการรูปภาพใน ExpansionPanelData เป็นรายการว่าง
//                                         ));
//                                       });
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: WhiteColor,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(0),
//                                       ),
//                                       elevation: 3,
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 10),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Icon(Icons.add_box_rounded,
//                                               color: Color(0xFF42BD41)),
//                                           SizedBox(width: 8),
//                                           Text(
//                                             "เพิ่มเนื้อหาย่อย",
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 18,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   // padding: const EdgeInsets.all(25.0),
//                                   padding: const EdgeInsets.only(
//                                       right: 70.0, top: 50.0, bottom: 50),
//                                   child: Container(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             clearAllFields();
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Color(0xC5C5C5),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "ยกเลิก",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20.0,
//                                         ),
//                                         ElevatedButton(
//                                           onPressed: () async {
//                                             uploadImageAndSaveItemInfo();
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20.0,
//                                                 vertical: 15.0),
//                                             backgroundColor: YellowColor,
//                                           ),
//                                           child: uploading
//                                               ? SizedBox(
//                                                   child:
//                                                       CircularProgressIndicator(),
//                                                   height: 15.0,
//                                                 )
//                                               : const Text(
//                                                   "แก้ไข",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _displayedWidget = Container();

//   Widget _displaycoverWidget() {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Container(
//         width: 350,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: WhiteColor,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Icon(
//                   icons[_selectedValue] ??
//                       Icons.error, // ระบุไอคอนตามค่าที่เลือก
//                   size: 24, // ขนาดของไอคอน
//                   color: GPrimaryColor, // สีของไอคอน
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: Text(
//                     namecontroller.text,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 9),
//                   child: Icon(
//                     Icons
//                         .keyboard_arrow_right_rounded, // ระบุไอคอนตามค่าที่เลือก
//                     size: 24, // ขนาดของไอคอน
//                     color: GPrimaryColor, // สีของไอคอน
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _displaycontentWidget(
//       ExpansionPanelData expansionPanelData, int index) {
//     return Scaffold(
//       appBar: Appbarmain_no_botton(
//         name: contentNameControllers.isNotEmpty
//             ? contentNameControllers[0].text
//             : '',
//       ),
//       body: Stack(
//         children: [
//           ListView.builder(
//             itemCount: itemPhotosWidgetList.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                 width: 390, // กำหนดความกว้างของรูปภาพ
//                 height: 253, // กำหนดความสูงของรูปภาพ
//                 child: itemPhotosWidgetList[index], // ใส่รูปภาพลงใน Container
//               );
//             },
//           ),
//           Positioned(
//             // ใช้ตัวแปร _positionY แทนค่า top
//             bottom: 0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
//             left: 0.0,
//             right: 0.0,
//             child: Container(
//               height: 400,
//               padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//               decoration: BoxDecoration(
//                   color: WhiteColor,
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(40))),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         icons[_selectedValue] ??
//                             Icons.error, // ระบุไอคอนตามค่าที่เลือก
//                         size: 24, // ขนาดของไอคอน
//                         color: GPrimaryColor, // สีของไอคอน
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       for (int index = 0;
//                           index < contentNameControllers.length;
//                           index++)
//                         Text(
//                           contentNameControllers[index].text,
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18),
//                         )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       for (int index = 0;
//                           index < contentDetailControllers.length;
//                           index++)
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             contentDetailControllers[index].text,
//                             style: TextStyle(color: Colors.black, fontSize: 15),
//                             textAlign: TextAlign.left,
//                             maxLines: null,
//                           ),
//                         ),
//                     ],
//                   )
//                 ],
//               ),
//               width: MediaQuery.of(context).size.width,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   int _selectedIndex = 0;

//   Widget buildList() {
//     return ExpansionPanelList.radio(
//       expansionCallback: (
//         int index,
//         bool isExpanded,
//       ) {
//         setState(() {
//           _selectedIndex = isExpanded ? -1 : index;
//         });
//       },
//       children: List.generate(
//         contentList.length,
//         (index) => ExpansionPanelRadio(
//           backgroundColor: Colors.white,
//           value: index,
//           headerBuilder: (
//             BuildContext context,
//             bool isExpanded,
//           ) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 40),
//               child: ListTile(
//                 title: Text(
//                   'เนื้อหาย่อยที่ ${index + 1}',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                   ),
//                 ),
//                 leading: IconButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Dialog(
//                           child: Container(
//                             width: 500,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 32, horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.info_outline,
//                                   size: 100,
//                                   color: Colors.red,
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Text(
//                                   'ต้องการลบข้อมูลเนื้อหาย่อยที่ ${index + 1}',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     OutlinedButton(
//                                       style: OutlinedButton.styleFrom(
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 20,
//                                           horizontal: 32,
//                                         ),
//                                         foregroundColor: Colors.red,
//                                         side: BorderSide(color: Colors.red),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text("ยกเลิก"),
//                                     ),
//                                     SizedBox(width: 20),
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: G2PrimaryColor,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 20,
//                                           horizontal: 32,
//                                         ),
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       onPressed: () {
//                                         deleteContentById(
//                                             widget.knowledge!.contents[index]);

//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text("ยืนยัน"),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   icon: Icon(
//                     Icons.cancel,
//                     color: Color(0xFFFF543E),
//                   ),
//                 ),
//               ),
//             );
//           },
//           body: buildListItemBody(index),
//           canTapOnHeader: true,
//         ),
//       ),
//     );
//   }

//   Widget buildListItemBody(int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 0),
//                             ),
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 490,
//                                   height: 750,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(25.0),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(height: 20),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "ชื่อ",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Container(
//                                             padding:
//                                                 EdgeInsets.only(left: 10.0),
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Color(0xffCFD3D4)),
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             child: TextField(
//                                               controller:
//                                                   contentNameControllers[index],
//                                               // controller: TextEditingController(
//                                               //     text: contentList[index]
//                                               //         .ContentName),

//                                               decoration: InputDecoration(
//                                                   hintText: contentList[index]
//                                                       .ContentName,
//                                                   border: InputBorder.none),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "เนื้อหา",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                     color: Color(0xffCFD3D4)),
//                                                 borderRadius:
//                                                     BorderRadius.circular(5)),
//                                             child: TextField(
//                                               controller:
//                                                   contentDetailControllers[
//                                                       index],

//                                               // controller: TextEditingController(
//                                               //     text: contentList[index]
//                                               //         .ContentDetail),
//                                               keyboardType:
//                                                   TextInputType.multiline,
//                                               maxLines: 5,
//                                               decoration: InputDecoration(
//                                                   hintText: contentList[index]
//                                                       .ContentDetail,
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                           borderSide:
//                                                               BorderSide(
//                                                                   width: 1,
//                                                                   color: Colors
//                                                                       .white))),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "รูปภาพ",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12.0),
//                                               color: Colors.white70,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.grey.shade200,
//                                                   offset:
//                                                       const Offset(0.0, 0.5),
//                                                   blurRadius: 30.0,
//                                                 )
//                                               ]),
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 200.0,
//                                           child: Center(
//                                             child: itemPhotosWidgetList.isEmpty
//                                                 ? Center(
//                                                     child: MaterialButton(
//                                                       onPressed: () {
//                                                         pickPhotoFromGallery(
//                                                             _panelData[
//                                                                 index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
//                                                       },
//                                                       child: Container(
//                                                         alignment: Alignment
//                                                             .bottomCenter,
//                                                         child: Center(
//                                                           child: Image.network(
//                                                             contentList[index]
//                                                                 .ImageURL,
//                                                             fit: BoxFit.cover,
//                                                             height: 200,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : SingleChildScrollView(
//                                                     scrollDirection:
//                                                         Axis.vertical,
//                                                     child: Wrap(
//                                                       spacing: 5.0,
//                                                       direction:
//                                                           Axis.horizontal,
//                                                       children:
//                                                           itemPhotosWidgetList,
//                                                       alignment: WrapAlignment
//                                                           .spaceEvenly,
//                                                       runSpacing: 10.0,
//                                                     ),
//                                                   ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             pickPhotoFromGallery(
//                                                 _panelData[index]);
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: G2PrimaryColor,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "เพิ่มรูปภาพ",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             // displaycontent(
//                                             //     expansionPanelData, index);
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Color(0xffE69800),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "แสดงผล",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 490,
//                                   height: 700,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(25.0),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 20,
//                                         ),
//                                         Container(
//                                           width: 390,
//                                           height: 600,
//                                           decoration: ShapeDecoration(
//                                             color: Color(0xFFE7E7E7),
//                                             shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                   width: 5,
//                                                   color: Color(0xFF42BD41)),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           // child: Column(
//                                           //   children: [
//                                           //     Expanded(
//                                           //       child: _displayedContentWidgets[
//                                           //               index] ??
//                                           //           Container(),
//                                           //     )
//                                           //   ],
//                                           // ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   void display() {
//     // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
//     setState(() {
//       // เรียกใช้งาน Widget ที่จะแสดงผล
//       _displayedWidget = _displaycoverWidget();
//     });
//   }

//   // void displaycontent() {
//   //   // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
//   //   setState(() {
//   //     _displayedcontentWidget = _displaycontentWidget();
//   //   });
//   // }

//   void displaycontent(ExpansionPanelData expansionPanelData, int index) {
//     setState(() {
//       _displayedContentWidgets[index] =
//           _displaycontentWidget(expansionPanelData, index);
//     });
//   }
// }


//    // if (itemImagesList.length == 0) {
//       //   ListimageUrl.add(contentList[i].ImageURL);
//       //   print('contentList: ${contentList.length}');
//       //   print('ListimageUrl: $ListimageUrl');
//       //   print('itemImagesList: ${itemImagesList.length}');
//       // } else {
//       //   for (int i = 0; i < itemImagesList.length; i++) {
//       //     file = File(itemImagesList[i].path);
//       //     print(itemImagesList[i].path);
//       //     pickedFile = PickedFile(file!.path);
//       //     print('star uploadImageToStorage ');
//       //     await uploadImageToStorage(pickedFile, contentIdnew, i);
//       //   }
//       //   ListimageUrl.add(contentList[i].ImageURL);
//       //   print('itemImagesList2: ${itemImagesList.length}');
//       //   print('itemImagesList2: ${itemImagesList}');
//       //   print('ListimageUrl: $ListimageUrl');
//       // }

//   // Future<void> updateContent(List<String> imageUrl) async {
//   //   String? selectedValue;
//   //   print("start");
//   //   selectedValue = widget.knowledge!.knowledgeIcons != null
//   //       ? widget.knowledge!.knowledgeIcons.toString()
//   //       : widget.icons != null
//   //           ? icons.keys.firstWhere(
//   //               (key) => icons[key] == widget.icons,
//   //               orElse: () => '',
//   //             )
//   //           : null;

//   //   try {
//   //     print("start loop");
//   //     final knowledgeDocRef = FirebaseFirestore.instance
//   //         .collection('Knowledge')
//   //         .doc(widget.knowledge!.id);

//   //     await knowledgeDocRef.update({
//   //       'KnowledgeName': namecontroller.text,
//   //       'KnowledgeIcons': _selectedValue ??
//   //           icons.keys.firstWhere(
//   //               (key) => icons[key].toString() == selectedValue,
//   //               orElse: () => ''),
//   //       "Content": contentIds,
//   //       'update_at': Timestamp.now()
//   //     });
//   //     print("contentIds = ${contentIds}");
//   //     print("contentList = ${contentList}");
//   //     print(ListimageUrl);
//   //     print("contentDetailControllers = ${contentDetailControllers.length}");
//   //     print("contentNameControllers = ${contentNameControllers.length}");
//   //     for (int index = 0; index < contentList.length; index++) {
//   //       print("start loop");
//   //       String contentName = contentNameControllers[index].text;
//   //       String contentDetail = contentDetailControllers[index].text;
//   //       String imageUrl = ListimageUrl[index].toString();
//   //       String contentId = contentList[index].id;
//   //       print(" index ${index}");
//   //       print(" id ${contentId}");
//   //       print(" name ${contentName}");
//   //       print(" detail ${contentDetail}");
//   //       print(" url ${imageUrl}");

//   //       await upContent(contentId, contentName, contentDetail, imageUrl, index);
//   //     }
//   //     print('itemImagesList: ${itemImagesList.length}');
//   //     print('contentList: ${contentList.length}');
//   //     print("3");

//   //     contentIds = contentList.map((content) => content.id).toList();
//   //     if (itemImagesList.isNotEmpty) {
//   //       print('start if');

//   //       for (int index = contentList.length;
//   //           index < contentList.length + itemImagesList.length;
//   //           index++) {
//   //         String contentName = index < contentNameControllers.length
//   //             ? contentNameControllers[index].text
//   //             : '';
//   //         String contentNamenew = index < contentNameupdate.length
//   //             ? contentNameupdate[index].text
//   //             : '';
//   //         String contentdetailnew = index < contentDetailupdate.length
//   //             ? contentDetailupdate[index].text
//   //             : '';
//   //         String contentDetail = index < contentDetailControllers.length
//   //             ? contentDetailControllers[index].text
//   //             : '';
//   //         String imageUrl = ListimageUrl[index].toString();
//   //         String? contentId;
//   //         print('start loop addContent');
//   //         if (index >= contentList.length) {
//   //           print(" index ${index}");
//   //           print(" contentList ${contentList.length}");
//   //           contentId =
//   //               await addContent(contentNamenew, contentdetailnew, imageUrl);
//   //           contentIds.add(contentId);
//   //            print(" contentId ${contentId}");
//   //            print(" contentIds ${contentIds}");
//   //           print(" url ${imageUrl}");
//   //         } else {
//   //           contentId = contentList[index].id;
//   //           await upContent(
//   //               contentId, contentName, contentDetail, imageUrl, index);
//   //           contentIds.add(contentId);
//   //         }
//   //         print(" contentNamenew ${contentNameupdate.length}");
//   //         print(" contentNamenew ${contentNameupdate[index].text}");
//   //         print(" contentNamenew ${contentNameupdate}");
//   //         print(" id ${contentId}");
//   //         print(" name ${contentName}");
//   //         print(" detail ${contentDetail}");
//   //         print(" url ${imageUrl}");
//   //       }
//   //     }
//   //     // print("contentIds ${contentIds}");

//   //     await knowledgeDocRef.update({'Content': contentIds,'update_at': Timestamp.now()});
//   //   } catch (error) {
//   //     print("Error getting knowledge updateContent: $error");
//   //   }
//   // }

      

//       // // import 'dart:io';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/foundation.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:fluttertoast/fluttertoast.dart';
// // // import 'package:go_router/go_router.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:loading_animation_widget/loading_animation_widget.dart';
// // // import 'package:uuid/uuid.dart';
// // // import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
// // // import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
// // // import 'package:watalygold_admin/Widgets/Color.dart';
// // // import 'package:watalygold_admin/service/database.dart';
// // // import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// // // Map<String, IconData> icons = {
// // //   'สถิติ': Icons.analytics_outlined,
// // //   'ดอกไม้': Icons.yard,
// // //   'หนังสือ': Icons.book,
// // //   'น้ำ': Icons.water_drop_outlined,
// // //   'ระวัง': Icons.warning_rounded,
// // //   'คำถาม': Icons.quiz_outlined,
// // // };

// // // class ExpansionPanelData {
// // //   TextEditingController nameController;
// // //   TextEditingController detailController;
// // //   List<Widget> itemPhotosWidgetList;

// // //   ExpansionPanelData({
// // //     required this.nameController,
// // //     required this.detailController,
// // //     required this.itemPhotosWidgetList,
// // //   });
// // // }

// // // List<ExpansionPanelData> _panelData = [];

// // // class Multiplecontent extends StatefulWidget {
// // //   const Multiplecontent({Key? key}) : super(key: key);

// // //   @override
// // //   _MultiplecontentState createState() => _MultiplecontentState();
// // // }

// // // class _MultiplecontentState extends State<Multiplecontent> {
// // //   IconData? selectedIconData;
// // //   String? _selectedValue;
// // //   bool _isLoading = true;
// // //   int _currentExpandedIndex = -1;
// // //   bool addedContent = false;
// // //   TextEditingController contentcontroller = new TextEditingController();
// // //   TextEditingController namecontroller = TextEditingController();
// // //   TextEditingController contentdetailcontroller = TextEditingController();
// // //   TextEditingController contentnamecontroller = TextEditingController();
// // //   List<TextEditingController> contentNameControllers = [];
// // //   List<TextEditingController> contentDetailControllers = [];
// // //   List<Widget> _displayedContentWidgets =
// // //       List.filled(_panelData.length, Container());
// // //   List<int> _deletedPanels = [];
// // //   List<Widget> itemPhotosWidgetList = <Widget>[]; //แสดงตัวอย่างรูปภาพ
// // //   final ImagePicker _picker = ImagePicker();
// // //   File? file;
// // //   List<XFile>? photo =
// // //       <XFile>[]; //เป็นรายการของ XFile ที่ใช้ในการเก็บรูปภาพที่เลือกจากแกล
// // //   List<XFile> itemImagesList =
// // //       <XFile>[]; //ใช้ในการเก็บรูปภาพที่ผู้ใช้เลือกเพื่ออัปโหลด

// // //   bool uploading = false;

// // //   List<String> ListimageUrl = [];

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     setState(() {
// // //       _isLoading = true; // Set loading state to true
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: GrayColor,
// // //       body: SingleChildScrollView(
// // //         child: Container(
// // //           child: Padding(
// // //             padding: EdgeInsets.only(left: 70),
// // //             child: Column(
// // //               children: [
// // //                 Row(
// // //                   children: [
// // //                     Container(
// // //                       width: 490,
// // //                       height: 400,
// // //                       decoration: BoxDecoration(
// // //                         borderRadius: BorderRadius.circular(10),
// // //                         color: Colors.white,
// // //                       ),
// // //                       child: Padding(
// // //                         padding: const EdgeInsets.all(25.0),
// // //                         child: Column(
// // //                           children: [
// // //                             Row(
// // //                               children: [
// // //                                 FaIcon(
// // //                                   FontAwesomeIcons.bookOpen,
// // //                                   color: GPrimaryColor,
// // //                                 ),
// // //                                 SizedBox(width: 10),
// // //                                 Text(
// // //                                   "เพิ่มคลังความรู้",
// // //                                   style: TextStyle(
// // //                                     color: Colors.black,
// // //                                     fontSize: 18,
// // //                                     fontFamily: 'IBM Plex Sans Thai',
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                             SizedBox(height: 30),
// // //                             Padding(
// // //                               padding:
// // //                                   const EdgeInsets.only(left: 0.0, right: 0),
// // //                               child: Align(
// // //                                 alignment: Alignment.topLeft,
// // //                                 child: Row(
// // //                                   children: [
// // //                                     Text(
// // //                                       "ไอคอน ",
// // //                                       style: TextStyle(
// // //                                         color: Colors.black,
// // //                                         fontSize: 18,
// // //                                         fontFamily: 'IBM Plex Sans Thai',
// // //                                       ),
// // //                                     ),
// // //                                     Text(
// // //                                       "*",
// // //                                       style: TextStyle(
// // //                                         color: Colors.red,
// // //                                         fontSize: 18,
// // //                                         fontFamily: 'IBM Plex Sans Thai',
// // //                                       ),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             Align(
// // //                               alignment: Alignment.topLeft,
// // //                               child: Container(
// // //                                 child: DropdownButton(
// // //                                   items: <String>[
// // //                                     'สถิติ',
// // //                                     'ดอกไม้',
// // //                                     'หนังสือ',
// // //                                     'น้ำ',
// // //                                     'ระวัง',
// // //                                     'คำถาม'
// // //                                   ].map<DropdownMenuItem<String>>(
// // //                                       (String value) {
// // //                                     return DropdownMenuItem<String>(
// // //                                       value: value,
// // //                                       child: Row(
// // //                                         children: [
// // //                                           icons[value] != null
// // //                                               ? Icon(
// // //                                                   icons[value]!,
// // //                                                   color: GPrimaryColor,
// // //                                                 )
// // //                                               : SizedBox(),
// // //                                           SizedBox(width: 15),
// // //                                           Text(
// // //                                             value,
// // //                                             style:
// // //                                                 TextStyle(color: GPrimaryColor),
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     );
// // //                                   }).toList(),
// // //                                   onChanged: (value) {
// // //                                     setState(() {
// // //                                       _selectedValue = value;
// // //                                     });
// // //                                   },
// // //                                   hint: Row(
// // //                                     children: [
// // //                                       Icon(
// // //                                         Icons.image_outlined,
// // //                                         color: GPrimaryColor,
// // //                                       ), // ไอคอนที่ต้องการเพิ่ม
// // //                                       SizedBox(
// // //                                           width:
// // //                                               10), // ระยะห่างระหว่างไอคอนและข้อความ
// // //                                       Text(
// // //                                         "เลือกไอคอนสำหรับคลังความรู้",
// // //                                         style: TextStyle(
// // //                                             color: GPrimaryColor, fontSize: 17),
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                   value: _selectedValue,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             SizedBox(height: 30),
// // //                             Padding(
// // //                               padding:
// // //                                   const EdgeInsets.only(left: 0.0, right: 0),
// // //                               child: Align(
// // //                                 alignment: Alignment.topLeft,
// // //                                 child: Row(
// // //                                   children: [
// // //                                     Text(
// // //                                       "ชื่อ",
// // //                                       style: TextStyle(
// // //                                         color: Colors.black,
// // //                                         fontSize: 18,
// // //                                         fontFamily: 'IBM Plex Sans Thai',
// // //                                       ),
// // //                                     ),
// // //                                     Text(
// // //                                       "*",
// // //                                       style: TextStyle(
// // //                                         color: Colors.red,
// // //                                         fontSize: 18,
// // //                                         fontFamily: 'IBM Plex Sans Thai',
// // //                                       ),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             Padding(
// // //                               padding:
// // //                                   const EdgeInsets.only(left: 0.0, right: 0),
// // //                               child: Container(
// // //                                 padding: EdgeInsets.only(left: 10.0),
// // //                                 decoration: BoxDecoration(
// // //                                   border: Border.all(color: Color(0xffCFD3D4)),
// // //                                   borderRadius: BorderRadius.circular(5),
// // //                                 ),
// // //                                 child: TextField(
// // //                                   controller: namecontroller,
// // //                                   decoration:
// // //                                       InputDecoration(border: InputBorder.none),
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             SizedBox(height: 30),
// // //                             SizedBox(
// // //                               height: 20.0,
// // //                             ),
// // //                             ElevatedButton(
// // //                               onPressed: display,
// // //                               style: ElevatedButton.styleFrom(
// // //                                 backgroundColor: Color(0xffE69800),
// // //                                 shape: RoundedRectangleBorder(
// // //                                   borderRadius: BorderRadius.circular(10),
// // //                                 ),
// // //                               ),
// // //                               child: Text(
// // //                                 "แสดงผล",
// // //                                 style: TextStyle(color: Colors.white),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     SizedBox(width: 20), // SizedBox
// // //                     Container(
// // //                       width: 490,
// // //                       height: 400,
// // //                       decoration: BoxDecoration(
// // //                         borderRadius: BorderRadius.circular(10),
// // //                         color: Colors.white,
// // //                       ),
// // //                       child: Padding(
// // //                         padding: const EdgeInsets.all(25.0),
// // //                         child: Column(
// // //                           children: [
// // //                             Row(
// // //                               mainAxisAlignment: MainAxisAlignment.center,
// // //                               children: [
// // //                                 Icon(
// // //                                   Icons.light_mode_rounded,
// // //                                   color: Color(0xffFFEE58),
// // //                                 ),
// // //                                 SizedBox(width: 10),
// // //                                 Text(
// // //                                   "แสดงผล",
// // //                                   style: TextStyle(
// // //                                     color: Colors.black,
// // //                                     fontSize: 18,
// // //                                     fontFamily: 'IBM Plex Sans Thai',
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                             SizedBox(
// // //                               height: 40,
// // //                             ),
// // //                             Container(
// // //                               width: 390,
// // //                               height: 100,
// // //                               decoration: ShapeDecoration(
// // //                                 color: Color(0xFFE7E7E7),
// // //                                 shape: RoundedRectangleBorder(
// // //                                   side: BorderSide(
// // //                                       width: 5, color: GPrimaryColor),
// // //                                   borderRadius: BorderRadius.circular(10),
// // //                                 ),
// // //                               ),
// // //                               child: Column(
// // //                                 children: [
// // //                                   Expanded(
// // //                                     child: _displayedWidget ?? Container(),
// // //                                   )
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                             SizedBox(
// // //                               height: 20,
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     // Container
// // //                   ],
// // //                 ),
// // //                 SizedBox(
// // //                   height: 30,
// // //                 ),
// // //                   // _isLoading
// // //                   //     ? Center(
// // //                   //         child: LoadingAnimationWidget.discreteCircle(
// // //                   //           color: WhiteColor,
// // //                   //           secondRingColor: Colors.green,
// // //                   //           thirdRingColor: Colors.yellow,
// // //                   //           size: 200,
// // //                   //         ),
// // //                   //       )
// // //                   //     :
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(right: 70),
// // //                   child: ExpansionPanelList.radio(
// // //                     expansionCallback: (int index, bool isExpanded) {
// // //                       if (_deletedPanels.contains(index)) {
// // //                         return;
// // //                       }
// // //                       setState(() {
// // //                         if (isExpanded) {
// // //                           _currentExpandedIndex = index;
// // //                         }
// // //                       });
// // //                     },
// // //                     children: _panelData.map<ExpansionPanelRadio>(
// // //                         (ExpansionPanelData expansionPanelData) {
// // //                       final int index = _panelData.indexOf(expansionPanelData);

// // //                       // สร้าง TextEditingController สำหรับชื่อเนื้อหาและรายละเอียดเนื้อหา
// // //                       contentNameControllers.add(TextEditingController());
// // //                       contentDetailControllers.add(TextEditingController());

// // //                       return ExpansionPanelRadio(
// // //                         backgroundColor: Colors.white,
// // //                         value: index,
// // //                         canTapOnHeader: true,
// // //                         headerBuilder: (BuildContext context, bool isExpanded) {
// // //                           return ListTile(
// // //                             tileColor: Colors.white,
// // //                             leading: IconButton(
// // //                               onPressed: () {
// // //                                 setState(() {
// // //                                   _deletedPanels.add(index);
// // //                                   _panelData.removeAt(index);
// // //                                 });
// // //                               },
// // //                               icon: Icon(
// // //                                 Icons.cancel,
// // //                                 color: Color(0xFFFF543E),
// // //                               ),
// // //                             ),
// // //                             title: Text(
// // //                               'เนื้อหาย่อยที่ ${index + 1}',
// // //                               style: TextStyle(
// // //                                 color: Colors.black,
// // //                                 fontSize: 18,
// // //                               ),
// // //                             ),
// // //                           );
// // //                         },
// // //                         body: Container(
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               Padding(
// // //                                 padding: const EdgeInsets.only(bottom: 0),
// // //                               ),
// // //                               Row(
// // //                                 children: [
// // //                                   Container(
// // //                                     width: 490,
// // //                                     height: 750,
// // //                                     decoration: BoxDecoration(
// // //                                       borderRadius: BorderRadius.circular(10),
// // //                                       color: Colors.white,
// // //                                     ),
// // //                                     child: Padding(
// // //                                       padding: const EdgeInsets.all(25.0),
// // //                                       child: Column(
// // //                                         children: [
// // //                                           SizedBox(height: 20),
// // //                                           Padding(
// // //                                             padding: const EdgeInsets.only(
// // //                                                 left: 0.0, right: 0),
// // //                                             child: Align(
// // //                                               alignment: Alignment.topLeft,
// // //                                               child: Row(
// // //                                                 children: [
// // //                                                   Text(
// // //                                                     "ชื่อ",
// // //                                                     style: TextStyle(
// // //                                                       color: Colors.black,
// // //                                                       fontSize: 18,
// // //                                                       fontFamily:
// // //                                                           'IBM Plex Sans Thai',
// // //                                                     ),
// // //                                                   ),
// // //                                                   Text(
// // //                                                     "*",
// // //                                                     style: TextStyle(
// // //                                                       color: Colors.red,
// // //                                                       fontSize: 18,
// // //                                                       fontFamily:
// // //                                                           'IBM Plex Sans Thai',
// // //                                                     ),
// // //                                                   ),
// // //                                                 ],
// // //                                               ),
// // //                                             ),
// // //                                           ),
// // //                                           Padding(
// // //                                             padding: const EdgeInsets.only(
// // //                                                 left: 0.0, right: 0),
// // //                                             child: Container(
// // //                                               padding:
// // //                                                   EdgeInsets.only(left: 10.0),
// // //                                               decoration: BoxDecoration(
// // //                                                 border: Border.all(
// // //                                                     color: Color(0xffCFD3D4)),
// // //                                                 borderRadius:
// // //                                                     BorderRadius.circular(5),
// // //                                               ),
// // //                                               child: TextField(
// // //                                                 controller:
// // //                                                     contentNameControllers[
// // //                                                         index],
// // //                                                 decoration: InputDecoration(
// // //                                                     border: InputBorder.none),
// // //                                               ),
// // //                                             ),
// // //                                           ),
// // //                                           SizedBox(height: 30),
// // //                                           Padding(
// // //                                             padding: const EdgeInsets.only(
// // //                                                 left: 0.0, right: 0),
// // //                                             child: Align(
// // //                                               alignment: Alignment.topLeft,
// // //                                               child: Row(
// // //                                                 children: [
// // //                                                   Text(
// // //                                                     "เนื้อหา",
// // //                                                     style: TextStyle(
// // //                                                       color: Colors.black,
// // //                                                       fontSize: 18,
// // //                                                       fontFamily:
// // //                                                           'IBM Plex Sans Thai',
// // //                                                     ),
// // //                                                   ),
// // //                                                   Text(
// // //                                                     "*",
// // //                                                     style: TextStyle(
// // //                                                       color: Colors.red,
// // //                                                       fontSize: 18,
// // //                                                       fontFamily:
// // //                                                           'IBM Plex Sans Thai',
// // //                                                     ),
// // //                                                   ),
// // //                                                 ],
// // //                                               ),
// // //                                             ),
// // //                                           ),
// // //                                           Padding(
// // //                                             padding: const EdgeInsets.only(
// // //                                                 left: 0.0, right: 0),
// // //                                             child: Container(
// // //                                               decoration: BoxDecoration(
// // //                                                   border: Border.all(
// // //                                                       color: Color(0xffCFD3D4)),
// // //                                                   borderRadius:
// // //                                                       BorderRadius.circular(5)),
// // //                                               child: TextField(
// // //                                                 controller:
// // //                                                     contentDetailControllers[
// // //                                                         index],
// // //                                                 keyboardType:
// // //                                                     TextInputType.multiline,
// // //                                                 maxLines: 5,
// // //                                                 decoration: InputDecoration(
// // //                                                     focusedBorder:
// // //                                                         OutlineInputBorder(
// // //                                                             borderSide: BorderSide(
// // //                                                                 width: 1,
// // //                                                                 color: Colors
// // //                                                                     .white))),
// // //                                               ),
// // //                                             ),
// // //                                           ),
// // //                                           SizedBox(height: 30),
// // //                                           Padding(
// // //                                             padding: const EdgeInsets.only(
// // //                                                 left: 0, right: 0),
// // //                                             child: Align(
// // //                                               alignment: Alignment.topLeft,
// // //                                               child: Row(
// // //                                                 children: [
// // //                                                   Text(
// // //                                                     "รูปภาพ",
// // //                                                     style: TextStyle(
// // //                                                       color: Colors.black,
// // //                                                       fontSize: 18,
// // //                                                       fontFamily:
// // //                                                           'IBM Plex Sans Thai',
// // //                                                     ),
// // //                                                   ),
// // //                                                   Text(
// // //                                                     "*",
// // //                                                     style: TextStyle(
// // //                                                       color: Colors.red,
// // //                                                       fontSize: 18,
// // //                                                       fontFamily:
// // //                                                           'IBM Plex Sans Thai',
// // //                                                     ),
// // //                                                   ),
// // //                                                 ],
// // //                                               ),
// // //                                             ),
// // //                                           ),
// // //                                           Container(
// // //                                             decoration: BoxDecoration(
// // //                                                 borderRadius:
// // //                                                     BorderRadius.circular(12.0),
// // //                                                 color: Colors.white70,
// // //                                                 boxShadow: [
// // //                                                   BoxShadow(
// // //                                                     color: Colors.grey.shade200,
// // //                                                     offset:
// // //                                                         const Offset(0.0, 0.5),
// // //                                                     blurRadius: 30.0,
// // //                                                   )
// // //                                                 ]),
// // //                                             width: MediaQuery.of(context)
// // //                                                 .size
// // //                                                 .width,
// // //                                             height: 200.0,
// // //                                             child: Center(
// // //                                               child: expansionPanelData
// // //                                                       .itemPhotosWidgetList
// // //                                                       .isEmpty
// // //                                                   ? Center(
// // //                                                       child: MaterialButton(
// // //                                                         onPressed: () {
// // //                                                           pickPhotoFromGallery(
// // //                                                               _panelData[
// // //                                                                   index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
// // //                                                         },
// // //                                                         child: Container(
// // //                                                           alignment: Alignment
// // //                                                               .bottomCenter,
// // //                                                           child: Center(
// // //                                                             child:
// // //                                                                 Image.network(
// // //                                                               "https://static.thenounproject.com/png/3322766-200.png",
// // //                                                               height: 100.0,
// // //                                                               width: 100.0,
// // //                                                             ),
// // //                                                           ),
// // //                                                         ),
// // //                                                       ),
// // //                                                     )
// // //                                                   : SingleChildScrollView(
// // //                                                       scrollDirection:
// // //                                                           Axis.vertical,
// // //                                                       child: Wrap(
// // //                                                         spacing: 5.0,
// // //                                                         direction:
// // //                                                             Axis.horizontal,
// // //                                                         children: expansionPanelData
// // //                                                             .itemPhotosWidgetList,
// // //                                                         alignment: WrapAlignment
// // //                                                             .spaceEvenly,
// // //                                                         runSpacing: 10.0,
// // //                                                       ),
// // //                                                     ),
// // //                                             ),
// // //                                           ),
// // //                                           SizedBox(
// // //                                             height: 10,
// // //                                           ),
// // //                                           ElevatedButton(
// // //                                             onPressed: () {
// // //                                               pickPhotoFromGallery(
// // //                                                   expansionPanelData);
// // //                                               // setState(() {
// // //                                               //   // เรียกใช้ addImage เพื่อเพิ่มรูปภาพใหม่
// // //                                               //   addImage(expansionPanelData);
// // //                                               // });
// // //                                             },
// // //                                             style: ElevatedButton.styleFrom(
// // //                                               backgroundColor: GPrimaryColor,
// // //                                               shape: RoundedRectangleBorder(
// // //                                                 borderRadius:
// // //                                                     BorderRadius.circular(10),
// // //                                               ),
// // //                                             ),
// // //                                             child: Text(
// // //                                               "เพิ่มรูปภาพ",
// // //                                               style: TextStyle(
// // //                                                   color: Colors.white),
// // //                                             ),
// // //                                           ),
// // //                                           SizedBox(height: 30),
// // //                                           ElevatedButton(
// // //                                             onPressed: () {
// // //                                               displaycontent(
// // //                                                   expansionPanelData, index);
// // //                                             },
// // //                                             style: ElevatedButton.styleFrom(
// // //                                               backgroundColor:
// // //                                                   Color(0xffE69800),
// // //                                               shape: RoundedRectangleBorder(
// // //                                                 borderRadius:
// // //                                                     BorderRadius.circular(10),
// // //                                               ),
// // //                                             ),
// // //                                             child: Text(
// // //                                               "แสดงผล",
// // //                                               style: TextStyle(
// // //                                                   color: Colors.white),
// // //                                             ),
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                   Container(
// // //                                     width: 450,
// // //                                     height: 700,
// // //                                     decoration: BoxDecoration(
// // //                                       borderRadius: BorderRadius.circular(10),
// // //                                       color: Colors.white,
// // //                                     ),
// // //                                     child: Padding(
// // //                                       padding: const EdgeInsets.all(25.0),
// // //                                       child: Column(
// // //                                         children: [
// // //                                           SizedBox(
// // //                                             height: 20,
// // //                                           ),
// // //                                           Container(
// // //                                             width: 390,
// // //                                             height: 600,
// // //                                             decoration: ShapeDecoration(
// // //                                               color: Color(0xFFE7E7E7),
// // //                                               shape: RoundedRectangleBorder(
// // //                                                 side: BorderSide(
// // //                                                     width: 5,
// // //                                                     color: GPrimaryColor),
// // //                                                 borderRadius:
// // //                                                     BorderRadius.circular(10),
// // //                                               ),
// // //                                             ),
// // //                                             child: Column(
// // //                                               children: [
// // //                                                 Expanded(
// // //                                                   child:
// // //                                                       _displayedContentWidgets[
// // //                                                               index] ??
// // //                                                           Container(),
// // //                                                 )
// // //                                               ],
// // //                                             ),
// // //                                           ),
// // //                                           SizedBox(
// // //                                             height: 20,
// // //                                           ),
// // //                                         ],
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       );
// // //                     }).toList(),
// // //                   ),
// // //                 ),

// // //                 SizedBox(height: 20),

// // //                 Padding(
// // //                   padding: const EdgeInsets.only(right: 70),
// // //                   child: ElevatedButton(
// // //                     onPressed: () {
// // //                       setState(() {
// // //                         final nameController = TextEditingController();
// // //                         final detailController = TextEditingController();
// // //                         List<Widget> itemPhotosWidgetList =
// // //                             []; // สร้างรายการว่างสำหรับรูปภาพ

// // //                         _panelData.add(ExpansionPanelData(
// // //                           nameController: nameController,
// // //                           detailController: detailController,
// // //                           itemPhotosWidgetList:
// // //                               itemPhotosWidgetList, // ให้รายการรูปภาพใน ExpansionPanelData เป็นรายการว่าง
// // //                         ));
// // //                       });
// // //                     },
// // //                     style: ElevatedButton.styleFrom(
// // //                       backgroundColor: WhiteColor,
// // //                       shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(0),
// // //                       ),
// // //                       elevation: 3,
// // //                     ),
// // //                     child: Padding(
// // //                             padding: const EdgeInsets.symmetric(vertical: 10),
// // //                             child: Row(
// // //                               mainAxisAlignment: MainAxisAlignment.start,
// // //                               children: [
// // //                                 Icon(Icons.add_box_rounded,
// // //                                     color: GPrimaryColor),
// // //                                 SizedBox(width: 8),
// // //                                 Text(
// // //                                   "เพิ่มเนื้อหาย่อย",
// // //                                   style: TextStyle(
// // //                                     color: Colors.black,
// // //                                     fontSize: 18,
// // //                                   ),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                   ),
// // //                 ),

// // //                 Padding(
// // //                   padding:
// // //                       const EdgeInsets.only(right: 70.0, top: 50.0, bottom: 50),
// // //                   child: Container(
// // //                     child: Row(
// // //                       mainAxisAlignment: MainAxisAlignment.end,
// // //                       children: [
// // //                         ElevatedButton(
// // //                           onPressed: () {
// // //                             clearAllFields();
// // //                           },
// // //                           style: ElevatedButton.styleFrom(
// // //                             backgroundColor: Color(0xC5C5C5),
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                           ),
// // //                           child: Text(
// // //                             "ยกเลิก",
// // //                             style: TextStyle(color: Colors.white),
// // //                           ),
// // //                         ),
// // //                         SizedBox(
// // //                           width: 20.0,
// // //                         ),
// // //                         ElevatedButton(
// // //                           onPressed: () {
// // //                             // addKnowlege();
// // //                             uploadImageAndSaveItemInfo();
// // //                           },
// // //                           style: ElevatedButton.styleFrom(
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                             padding: const EdgeInsets.symmetric(
// // //                                 horizontal: 20.0, vertical: 15.0),
// // //                             backgroundColor: GPrimaryColor,
// // //                           ),
// // //                           child: uploading
// // //                               ? SizedBox(
// // //                                   child: CircularProgressIndicator(),
// // //                                   height: 15.0,
// // //                                 )
// // //                               : const Text(
// // //                                   "เพิ่ม",
// // //                                   style: TextStyle(
// // //                                     color: Colors.white,
// // //                                   ),
// // //                                 ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Future<void> pickPhotoFromGallery(
// // //       ExpansionPanelData expansionPanelData) async {
// // //     photo = await _picker.pickMultiImage();
// // //     if (photo != null) {
// // //       setState(() {
// // //         itemImagesList = itemImagesList + photo!;
// // //         addImage(expansionPanelData);
// // //         photo!.clear();
// // //       });
// // //       // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
// // //     }
// // //   }

// // //   // Future<void> pickPhotoFromGallery(
// // //   //     ExpansionPanelData expansionPanelData) async {
// // //   //   photo = await _picker.pickMultiImage();
// // //   //   if (photo != null) {
// // //   //     setState(() {
// // //   //       List<XFile> tempImageList =
// // //   //           photo!; // เก็บรูปภาพที่เลือกล่าสุดไว้ใน tempImageList
// // //   //       addImage(expansionPanelData,
// // //   //           tempImageList); // ส่ง tempImageList ไปยังฟังก์ชัน addImage
// // //   //       photo!.clear();
// // //   //     });
// // //   //   }
// // //   // }

// // //   // void addImage(
// // //   //     ExpansionPanelData expansionPanelData, List<XFile> tempImageList) {
// // //   //   // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
// // //   //   expansionPanelData.itemPhotosWidgetList.clear();
// // //   //   itemImagesList.clear(); // ล้าง itemImagesList ก่อนเพิ่มรูปภาพใหม่

// // //   //   // เพิ่มรูปภาพใหม่จาก tempImageList ลงใน itemPhotosWidgetList และ itemImagesList
// // //   //   for (var bytes in tempImageList) {
// // //   //     expansionPanelData.itemPhotosWidgetList.add(
// // //   //       Padding(
// // //   //         padding: const EdgeInsets.all(0),
// // //   //         child: Container(
// // //   //           height: 200.0,
// // //   //           child: AspectRatio(
// // //   //             aspectRatio: 16 / 9,
// // //   //             child: Container(
// // //   //               child: kIsWeb
// // //   //                   ? Image.network(File(bytes.path).path)
// // //   //                   : Image.file(
// // //   //                       File(bytes.path),
// // //   //                     ),
// // //   //             ),
// // //   //           ),
// // //   //         ),
// // //   //       ),
// // //   //     );
// // //   //     itemImagesList.add(bytes); // เพิ่มรูปภาพใหม่เข้าไปใน itemImagesList
// // //   //   }
// // //   //    print(" img ${tempImageList}");

// // //   // }

// // //    void addImage(ExpansionPanelData expansionPanelData) {
// // //     // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
// // //     expansionPanelData.itemPhotosWidgetList.clear();

// // //     // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
// // //     for (var bytes in photo!) {
// // //       expansionPanelData.itemPhotosWidgetList.add(
// // //         Padding(
// // //           padding: const EdgeInsets.all(0),
// // //           child: Container(
// // //             height: 200.0,
// // //             child: AspectRatio(
// // //               aspectRatio: 16 / 9,
// // //               child: Container(
// // //                 child: kIsWeb
// // //                     ? Image.network(File(bytes.path).path)
// // //                     : Image.file(
// // //                         File(bytes.path),
// // //                       ),
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       );
// // //     }
// // //   }

// // //   // Future<void> uploadImageAndSaveItemInfo() async {
// // //   //   setState(() {
// // //   //     uploading = true;
// // //   //   });
// // //   //   PickedFile? pickedFile;
// // //   //   String? contentId = const Uuid().v4().substring(0, 10);
// // //   //   for (int i = 0; i < itemImagesList.length; i++) {
// // //   //     file = File(itemImagesList[i].path);
// // //   //     pickedFile = PickedFile(file!.path);
// // //   //     await uploadImageToStorage(pickedFile, contentId, i);
// // //   //   }
// // //   //   await addAllContent(ListimageUrl);
// // //   //   setState(() {
// // //   //     uploading = false;
// // //   //   });
// // //   // }

// // //   Future<void> uploadImageAndSaveItemInfo() async {
// // //     setState(() {
// // //       uploading = true;
// // //     });
// // //     PickedFile? pickedFile;
// // //     String? contentId = const Uuid().v4().substring(0, 10);
// // //     for (int i = 0; i < itemImagesList.length; i++) {
// // //       file = File(itemImagesList[i].path);
// // //       print(itemImagesList[i].path);
// // //       pickedFile = PickedFile(file!.path);
// // //       await uploadImageToStorage(pickedFile, contentId, i);
// // //     }
// // //     await addAllContent(ListimageUrl);
// // //     // เรียกใช้ addAllContentOnce เพื่อเพิ่มข้อมูลลง Firebase Firestore ครั้งเดียวเท่านั้น
// // //     setState(() {
// // //       uploading = false;
// // //     });
// // //   }

// // //   uploadImageToStorage(PickedFile? pickedFile, String contentId, index) async {
// // //     String? kId = const Uuid().v4().substring(0, 10);
// // //     Reference reference = FirebaseStorage.instance
// // //         .ref()
// // //         .child('Content/$contentId/contentImg_$kId');
// // //     await reference.putData(
// // //       await pickedFile!.readAsBytes(),
// // //       SettableMetadata(contentType: 'image/jpeg'),
// // //     );
// // //     String imageUrl = await reference.getDownloadURL();
// // //     print(imageUrl);
// // //     print(ListimageUrl);
// // //     setState(() {
// // //       ListimageUrl.add(imageUrl);
// // //       print(ListimageUrl);
// // //     });
// // //   }

// // //   Future<void> addAllContent(List<String> imageUrl) async {
// // //     if (namecontroller.text.isEmpty ||
// // //         _selectedValue == null ||
// // //         imageUrl == null) {
// // //       Fluttertoast.showToast(
// // //         msg: "กรุณากรอกข้อมูลให้ครบ",
// // //         toastLength: Toast.LENGTH_SHORT,
// // //         gravity: ToastGravity.CENTER,
// // //         timeInSecForIosWeb: 1,
// // //         backgroundColor: Colors.red,
// // //         textColor: Colors.white,
// // //         fontSize: 16.0,
// // //       );
// // //       return;
// // //     }

// // //     List<String> contentIds = [];
// // //     print("list ${itemImagesList.length}");
// // //     // Loop through content and add them to Firebase
// // //     for (int index = 0; index < itemImagesList.length; index++) {
// // //       String contentName = contentNameControllers[index].text;
// // //       print(contentName);

// // //       String contentDetail = contentDetailControllers[index].text;
// // //       print(contentDetail);

// // //       String imageurl = ListimageUrl[index].toString();
// // //       print(" img ${imageurl}");

// // //       String contentId = await addContent(contentName, contentDetail, imageurl);
// // //       print("id ${contentId}");

// // //       contentIds.add(contentId);
// // //     }

// // //     // Generate a knowledge ID
// // //     String knowledgeId = const Uuid().v4().substring(0, 10);

// // //     // Prepare knowledge data
// // //     Map<String, dynamic> knowledgeMap = {
// // //       "KnowledgeName": namecontroller.text,
// // //       "KnowledgeIcons": _selectedValue,
// // //       "create_at": Timestamp.now(),
// // //       "deleted_at": null,
// // //       "update_at": null,
// // //       "Content": contentIds,
// // //     };

// // //     // Add knowledge to Firebase
// // //     await Databasemethods()
// // //         .addKnowlege(knowledgeMap, knowledgeId)
// // //         .then((value) {
// // //       // แสดงกล่องโต้ตอบหลังการเพิ่มความรู้สำเร็จ
// // //       showDialog(
// // //         context: context,
// // //         builder: (context) => const Addknowledgedialog(),
// // //       );
// // //       Future.delayed(const Duration(seconds: 2), () {
// // //         Navigator.pop(context);
// // //         context.goNamed("/mainKnowledge");
// // //       });
// // //     }).catchError((error) {
// // //       Fluttertoast.showToast(
// // //         msg: "เกิดข้อผิดพลาดในการเพิ่มความรู้: $error",
// // //         toastLength: Toast.LENGTH_SHORT,
// // //         gravity: ToastGravity.CENTER,
// // //         timeInSecForIosWeb: 1,
// // //         backgroundColor: Colors.red,
// // //         textColor: Colors.white,
// // //         fontSize: 16.0,
// // //       );
// // //     });
// // //   }

// // //   Future<String> addContent(
// // //       String contentName, String contentDetail, String imageUrl) async {
// // //     Map<String, dynamic> contentMap = {
// // //       "ContentName": contentName,
// // //       "ContentDetail": contentDetail,
// // //       "image_url": imageUrl,
// // //       "create_at": Timestamp.now(),
// // //       "deleted_at": null,
// // //       "update_at": null,
// // //     };

// // //     // Generate a unique ID (replace with your preferred method)
// // //     String contentId = const Uuid().v4().substring(0, 10);

// // //     // Add data using addKnowlege, passing both contentMap and generated ID
// // //     await Databasemethods().addContent(contentMap, contentId);
// // //     return contentId;
// // //   }

// // //   void clearAllFields() {
// // //     namecontroller.clear();
// // //     contentcontroller.clear();

// // //     setState(() {
// // //       selectedIconData = null;
// // //     });

// // //     setState(() {
// // //       itemImagesList.clear();
// // //       itemPhotosWidgetList.clear();
// // //     });
// // //   }

// // //   Widget _displayedWidget = Container();

// // //   Widget _displaycoverWidget() {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(15),
// // //       child: Container(
// // //         width: 300,
// // //         decoration: BoxDecoration(
// // //           borderRadius: BorderRadius.circular(10),
// // //           color: WhiteColor,
// // //         ),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Row(
// // //               children: [
// // //                 SizedBox(
// // //                   width: 20,
// // //                 ),
// // //                 Icon(
// // //                   icons[_selectedValue] ??
// // //                       Icons.error, // ระบุไอคอนตามค่าที่เลือก
// // //                   size: 24, // ขนาดของไอคอน
// // //                   color: GPrimaryColor, // สีของไอคอน
// // //                 ),
// // //                 SizedBox(
// // //                   width: 20,
// // //                 ),
// // //                 Text(
// // //                   namecontroller.text,
// // //                   style: TextStyle(
// // //                     fontSize: 18,
// // //                     color: Colors.black,
// // //                   ),
// // //                 ),
// // //                 SizedBox(
// // //                   width: 20,
// // //                 ),
// // //                 Spacer(),
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(right: 9),
// // //                   child: Icon(
// // //                     Icons
// // //                         .keyboard_arrow_right_rounded, // ระบุไอคอนตามค่าที่เลือก
// // //                     size: 24, // ขนาดของไอคอน
// // //                     color: GPrimaryColor, // สีของไอคอน
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _displaycontentWidget(
// // //       ExpansionPanelData expansionPanelData, int index) {
// // //     return Scaffold(
// // //       appBar: Appbarmain_no_botton(
// // //         name: contentNameControllers.isNotEmpty
// // //             ? contentNameControllers[index].text
// // //             : '',
// // //       ),
// // //       body: Stack(
// // //         children: [
// // //           ListView.builder(
// // //             itemCount: expansionPanelData.itemPhotosWidgetList.length,
// // //             itemBuilder: (BuildContext context, int photoIndex) {
// // //               return Container(
// // //                 width: 390, // กำหนดความกว้างของรูปภาพ
// // //                 height: 253, // กำหนดความสูงของรูปภาพ
// // //                 child: expansionPanelData.itemPhotosWidgetList[
// // //                     photoIndex], // ใส่รูปภาพลงใน Container
// // //               );
// // //             },
// // //           ),
// // //           Positioned(
// // //             // ใช้ตัวแปร _positionY แทนค่า top
// // //             bottom: 0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
// // //             left: 0.0,
// // //             right: 0.0,
// // //             child: Container(
// // //               height: 400,
// // //               padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
// // //               decoration: BoxDecoration(
// // //                   color: WhiteColor,
// // //                   borderRadius:
// // //                       BorderRadius.vertical(top: Radius.circular(40))),
// // //               child: Column(
// // //                 children: [
// // //                   Row(
// // //                     children: [
// // //                       Icon(
// // //                         icons[_selectedValue] ??
// // //                             Icons.error, // ระบุไอคอนตามค่าที่เลือก
// // //                         size: 24, // ขนาดของไอคอน
// // //                         color: GPrimaryColor, // สีของไอคอน
// // //                       ),
// // //                       SizedBox(
// // //                         width: 15,
// // //                       ),
// // //                       Text(
// // //                         contentNameControllers[index].text,
// // //                         style: TextStyle(
// // //                             color: Colors.black,
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 18),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   SizedBox(
// // //                     height: 20,
// // //                   ),
// // //                   Column(
// // //                     mainAxisAlignment: MainAxisAlignment.start,
// // //                     children: [
// // //                       Align(
// // //                         alignment: Alignment.centerLeft,
// // //                         child: Text(
// // //                           contentDetailControllers[index].text,
// // //                           style: TextStyle(color: Colors.black, fontSize: 15),
// // //                           textAlign: TextAlign.left,
// // //                           maxLines: null,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   )
// // //                 ],
// // //               ),
// // //               width: MediaQuery.of(context).size.width,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // // //แสดงผลของชื่อปก
// // //   void display() {
// // //     // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
// // //     setState(() {
// // //       // เรียกใช้งาน Widget ที่จะแสดงผล
// // //       _displayedWidget = _displaycoverWidget();
// // //     });
// // //   }

// // // //แสดงผลของเนื้อหาย่อย
// // //   void displaycontent(ExpansionPanelData expansionPanelData, int index) {
// // //     setState(() {
// // //       _displayedContentWidgets[index] =
// // //           _displaycontentWidget(expansionPanelData, index);
// // //     });
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:uuid/uuid.dart';
// // import 'package:watalygold_admin/Widgets/Addknowledgedialog.dart';
// // import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
// // import 'package:watalygold_admin/Widgets/Color.dart';
// // import 'package:watalygold_admin/service/database.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// // Map<String, IconData> icons = {
// //   'สถิติ': Icons.analytics_outlined,
// //   'ดอกไม้': Icons.yard,
// //   'หนังสือ': Icons.book,
// //   'น้ำ': Icons.water_drop_outlined,
// //   'ระวัง': Icons.warning_rounded,
// //   'คำถาม': Icons.quiz_outlined,
// // };

// // class ExpansionPanelData {
// //   TextEditingController nameController;
// //   TextEditingController detailController;
// //   List<Widget> itemPhotosWidgetList;

// //   ExpansionPanelData({
// //     required this.nameController,
// //     required this.detailController,
// //     required this.itemPhotosWidgetList,
// //   });
// // }

// // List<ExpansionPanelData> _panelData = [];

// // class Multiplecontent extends StatefulWidget {
// //   const Multiplecontent({Key? key}) : super(key: key);

// //   @override
// //   _MultiplecontentState createState() => _MultiplecontentState();
// // }

// // class _MultiplecontentState extends State<Multiplecontent> {
// //   IconData? selectedIconData;
// //   String? _selectedValue;

// //   int _currentExpandedIndex = -1;
// //   bool addedContent = false;
// //   TextEditingController contentcontroller = new TextEditingController();
// //   TextEditingController namecontroller = TextEditingController();
// //   TextEditingController contentdetailcontroller = TextEditingController();
// //   TextEditingController contentnamecontroller = TextEditingController();
// //   List<TextEditingController> contentNameControllers = [];
// //   List<TextEditingController> contentDetailControllers = [];
// //   final List<List<XFile>> _imagesForPanels = [];

// //   List<Widget> _displayedContentWidgets =
// //       List.filled(_panelData.length, Container());

// //   List<int> _deletedPanels = [];
// // // List<Widget> itemPhotosWidgetList = [];
// //   List<Widget> itemPhotosWidgetList = <Widget>[]; //แสดงตัวอย่างรูปภาพ
// //   final ImagePicker _picker = ImagePicker();
// //   File? file;
// //   List<XFile>? photo =
// //       <XFile>[]; //เป็นรายการของ XFile ที่ใช้ในการเก็บรูปภาพที่เลือกจากแกล
// //   List<XFile> itemImagesList =
// //       <XFile>[]; //ใช้ในการเก็บรูปภาพที่ผู้ใช้เลือกเพื่ออัปโหลด
// //   List<String> downloadUrl = <String>[]; //เก็บ url ภาพ
// //   bool uploading = false;

// //   List<String> ListimageUrl = [];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: GrayColor,
// //       body: SingleChildScrollView(
// //         child: Container(
// //           child: Padding(
// //             padding: EdgeInsets.only(left: 70),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     Container(
// //                       width: 490,
// //                       height: 400,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(10),
// //                         color: Colors.white,
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(25.0),
// //                         child: Column(
// //                           children: [
// //                             Row(
// //                               children: [
// //                                 FaIcon(
// //                                   FontAwesomeIcons.bookOpen,
// //                                   color: GPrimaryColor,
// //                                 ),
// //                                 SizedBox(width: 10),
// //                                 Text(
// //                                   "เพิ่มคลังความรู้",
// //                                   style: TextStyle(
// //                                     color: Colors.black,
// //                                     fontSize: 18,
// //                                     fontFamily: 'IBM Plex Sans Thai',
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             SizedBox(height: 30),
// //                             Padding(
// //                               padding:
// //                                   const EdgeInsets.only(left: 0.0, right: 0),
// //                               child: Align(
// //                                 alignment: Alignment.topLeft,
// //                                 child: Row(
// //                                   children: [
// //                                     Text(
// //                                       "ไอคอน ",
// //                                       style: TextStyle(
// //                                         color: Colors.black,
// //                                         fontSize: 18,
// //                                         fontFamily: 'IBM Plex Sans Thai',
// //                                       ),
// //                                     ),
// //                                     Text(
// //                                       "*",
// //                                       style: TextStyle(
// //                                         color: Colors.red,
// //                                         fontSize: 18,
// //                                         fontFamily: 'IBM Plex Sans Thai',
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                             Align(
// //                               alignment: Alignment.topLeft,
// //                               child: Container(
// //                                 child: DropdownButton(
// //                                   items: <String>[
// //                                     'สถิติ',
// //                                                     'ดอกไม้',
// //                                                     'หนังสือ',
// //                                                     'น้ำ',
// //                                                     'ระวัง',
// //                                                     'คำถาม'
// //                                   ].map<DropdownMenuItem<String>>(
// //                                       (String value) {
// //                                     return DropdownMenuItem<String>(
// //                                       value: value,
// //                                       child: Row(
// //                                         children: [
// //                                           icons[value] != null
// //                                               ? Icon(
// //                                                   icons[value]!,
// //                                                   color: GPrimaryColor,
// //                                                 )
// //                                               : SizedBox(),
// //                                           SizedBox(width: 15),
// //                                           Text(
// //                                             value,
// //                                             style:
// //                                                 TextStyle(color: GPrimaryColor),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                   onChanged: (value) {
// //                                     setState(() {
// //                                       _selectedValue = value;
// //                                     });
// //                                   },
// //                                   hint: Row(
// //                                     children: [
// //                                       Icon(
// //                                         Icons.image_outlined,
// //                                         color: GPrimaryColor,
// //                                       ), // ไอคอนที่ต้องการเพิ่ม
// //                                       SizedBox(
// //                                           width:
// //                                               10), // ระยะห่างระหว่างไอคอนและข้อความ
// //                                       Text(
// //                                         "เลือกไอคอนสำหรับคลังความรู้",
// //                                         style: TextStyle(
// //                                             color: GPrimaryColor, fontSize: 17),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   value: _selectedValue,
// //                                 ),
// //                               ),
// //                             ),
// //                             SizedBox(height: 30),
// //                             Padding(
// //                               padding:
// //                                   const EdgeInsets.only(left: 0.0, right: 0),
// //                               child: Align(
// //                                 alignment: Alignment.topLeft,
// //                                 child: Row(
// //                                   children: [
// //                                     Text(
// //                                       "ชื่อ",
// //                                       style: TextStyle(
// //                                         color: Colors.black,
// //                                         fontSize: 18,
// //                                         fontFamily: 'IBM Plex Sans Thai',
// //                                       ),
// //                                     ),
// //                                     Text(
// //                                       "*",
// //                                       style: TextStyle(
// //                                         color: Colors.red,
// //                                         fontSize: 18,
// //                                         fontFamily: 'IBM Plex Sans Thai',
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                             Padding(
// //                               padding:
// //                                   const EdgeInsets.only(left: 0.0, right: 0),
// //                               child: Container(
// //                                 padding: EdgeInsets.only(left: 10.0),
// //                                 decoration: BoxDecoration(
// //                                   border: Border.all(color: Color(0xffCFD3D4)),
// //                                   borderRadius: BorderRadius.circular(5),
// //                                 ),
// //                                 child: TextField(
// //                                   controller: namecontroller,
// //                                   decoration:
// //                                       InputDecoration(border: InputBorder.none),
// //                                 ),
// //                               ),
// //                             ),
// //                             SizedBox(height: 30),
// //                             SizedBox(
// //                               height: 20.0,
// //                             ),
// //                             ElevatedButton(
// //                               onPressed: display,
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Color(0xffE69800),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 ),
// //                               ),
// //                               child: Text(
// //                                 "แสดงผล",
// //                                 style: TextStyle(color: Colors.white),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     SizedBox(width: 20), // SizedBox
// //                     Container(
// //                       width: 490,
// //                       height: 400,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(10),
// //                         color: Colors.white,
// //                       ),
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(25.0),
// //                         child: Column(
// //                           children: [
// //                             Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Icon(
// //                                   Icons.light_mode_rounded,
// //                                   color: Color(0xffFFEE58),
// //                                 ),
// //                                 SizedBox(width: 10),
// //                                 Text(
// //                                   "แสดงผล",
// //                                   style: TextStyle(
// //                                     color: Colors.black,
// //                                     fontSize: 18,
// //                                     fontFamily: 'IBM Plex Sans Thai',
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                             SizedBox(
// //                               height: 40,
// //                             ),
// //                             Container(
// //                               width: 390,
// //                               height: 100,
// //                               decoration: ShapeDecoration(
// //                                 color: Color(0xFFE7E7E7),
// //                                 shape: RoundedRectangleBorder(
// //                                   side: BorderSide(
// //                                       width: 5, color: GPrimaryColor),
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 ),
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Expanded(
// //                                     child: _displayedWidget ?? Container(),
// //                                   )
// //                                 ],
// //                               ),
// //                             ),
// //                             SizedBox(
// //                               height: 20,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     // Container
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: 30,
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.only(right: 70),
// //                   child: ExpansionPanelList.radio(
// //                     expansionCallback: (int index, bool isExpanded) {
// //                       if (_deletedPanels.contains(index)) {
// //                         return;
// //                       }
// //                       setState(() {
// //                         if (isExpanded) {
// //                           _currentExpandedIndex = index;
// //                         }
// //                       });
// //                     },
// //                     children: _panelData.map<ExpansionPanelRadio>(
// //                         (ExpansionPanelData expansionPanelData) {
// //                       final int index = _panelData.indexOf(expansionPanelData);

// //                       // สร้าง TextEditingController สำหรับชื่อเนื้อหาและรายละเอียดเนื้อหา
// //                       contentNameControllers.add(TextEditingController());
// //                       contentDetailControllers.add(TextEditingController());

// //                       return ExpansionPanelRadio(
// //                         backgroundColor: Colors.white,
// //                         value: index,
// //                         canTapOnHeader: true,
// //                         headerBuilder: (BuildContext context, bool isExpanded) {
// //                           return ListTile(
// //                             tileColor: Colors.white,
// //                             leading: IconButton(
// //                               onPressed: () {
// //                                 setState(() {
// //                                   _deletedPanels.add(index);
// //                                   _panelData.removeAt(index);
// //                                 });
// //                               },
// //                               icon: Icon(
// //                                 Icons.cancel,
// //                                 color: Color(0xFFFF543E),
// //                               ),
// //                             ),
// //                             title: Text(
// //                               'เนื้อหาย่อยที่ ${index + 1}',
// //                               style: TextStyle(
// //                                 color: Colors.black,
// //                                 fontSize: 18,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                         body: Container(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Padding(
// //                                 padding: const EdgeInsets.only(bottom: 0),
// //                               ),
// //                               Row(
// //                                 children: [
// //                                   Container(
// //                                     width: 490,
// //                                     height: 750,
// //                                     decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(10),
// //                                       color: Colors.white,
// //                                     ),
// //                                     child: Padding(
// //                                       padding: const EdgeInsets.all(25.0),
// //                                       child: Column(
// //                                         children: [
// //                                           SizedBox(height: 20),
// //                                           Padding(
// //                                             padding: const EdgeInsets.only(
// //                                                 left: 0.0, right: 0),
// //                                             child: Align(
// //                                               alignment: Alignment.topLeft,
// //                                               child: Row(
// //                                                 children: [
// //                                                   Text(
// //                                                     "ชื่อ",
// //                                                     style: TextStyle(
// //                                                       color: Colors.black,
// //                                                       fontSize: 18,
// //                                                       fontFamily:
// //                                                           'IBM Plex Sans Thai',
// //                                                     ),
// //                                                   ),
// //                                                   Text(
// //                                                     "*",
// //                                                     style: TextStyle(
// //                                                       color: Colors.red,
// //                                                       fontSize: 18,
// //                                                       fontFamily:
// //                                                           'IBM Plex Sans Thai',
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           Padding(
// //                                             padding: const EdgeInsets.only(
// //                                                 left: 0.0, right: 0),
// //                                             child: Container(
// //                                               padding:
// //                                                   EdgeInsets.only(left: 10.0),
// //                                               decoration: BoxDecoration(
// //                                                 border: Border.all(
// //                                                     color: Color(0xffCFD3D4)),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(5),
// //                                               ),
// //                                               child: TextField(
// //                                                 controller:
// //                                                     contentNameControllers[
// //                                                         index],
// //                                                 decoration: InputDecoration(
// //                                                     border: InputBorder.none),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           SizedBox(height: 30),
// //                                           Padding(
// //                                             padding: const EdgeInsets.only(
// //                                                 left: 0.0, right: 0),
// //                                             child: Align(
// //                                               alignment: Alignment.topLeft,
// //                                               child: Row(
// //                                                 children: [
// //                                                   Text(
// //                                                     "เนื้อหา",
// //                                                     style: TextStyle(
// //                                                       color: Colors.black,
// //                                                       fontSize: 18,
// //                                                       fontFamily:
// //                                                           'IBM Plex Sans Thai',
// //                                                     ),
// //                                                   ),
// //                                                   Text(
// //                                                     "*",
// //                                                     style: TextStyle(
// //                                                       color: Colors.red,
// //                                                       fontSize: 18,
// //                                                       fontFamily:
// //                                                           'IBM Plex Sans Thai',
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           Padding(
// //                                             padding: const EdgeInsets.only(
// //                                                 left: 0.0, right: 0),
// //                                             child: Container(
// //                                               decoration: BoxDecoration(
// //                                                   border: Border.all(
// //                                                       color: Color(0xffCFD3D4)),
// //                                                   borderRadius:
// //                                                       BorderRadius.circular(5)),
// //                                               child: TextField(
// //                                                 controller:
// //                                                     contentDetailControllers[
// //                                                         index],
// //                                                 keyboardType:
// //                                                     TextInputType.multiline,
// //                                                 maxLines: 5,
// //                                                 decoration: InputDecoration(
// //                                                     focusedBorder:
// //                                                         OutlineInputBorder(
// //                                                             borderSide: BorderSide(
// //                                                                 width: 1,
// //                                                                 color: Colors
// //                                                                     .white))),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           SizedBox(height: 30),
// //                                           Padding(
// //                                             padding: const EdgeInsets.only(
// //                                                 left: 0, right: 0),
// //                                             child: Align(
// //                                               alignment: Alignment.topLeft,
// //                                               child: Row(
// //                                                 children: [
// //                                                   Text(
// //                                                     "รูปภาพ",
// //                                                     style: TextStyle(
// //                                                       color: Colors.black,
// //                                                       fontSize: 18,
// //                                                       fontFamily:
// //                                                           'IBM Plex Sans Thai',
// //                                                     ),
// //                                                   ),
// //                                                   Text(
// //                                                     "*",
// //                                                     style: TextStyle(
// //                                                       color: Colors.red,
// //                                                       fontSize: 18,
// //                                                       fontFamily:
// //                                                           'IBM Plex Sans Thai',
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             decoration: BoxDecoration(
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(12.0),
// //                                                 color: Colors.white70,
// //                                                 boxShadow: [
// //                                                   BoxShadow(
// //                                                     color: Colors.grey.shade200,
// //                                                     offset:
// //                                                         const Offset(0.0, 0.5),
// //                                                     blurRadius: 30.0,
// //                                                   )
// //                                                 ]),
// //                                             width: MediaQuery.of(context)
// //                                                 .size
// //                                                 .width,
// //                                             height: 200.0,
// //                                             child: Center(
// //                                               child: expansionPanelData
// //                                                       .itemPhotosWidgetList
// //                                                       .isEmpty
// //                                                   ? Center(
// //                                                       child: MaterialButton(
// //                                                         onPressed: () {
// //                                                           pickPhotoFromGallery(
// //                                                               _panelData[
// //                                                                   index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
// //                                                         },
// //                                                         child: Container(
// //                                                           alignment: Alignment
// //                                                               .bottomCenter,
// //                                                           child: Center(
// //                                                             child:
// //                                                                 Image.network(
// //                                                               "https://static.thenounproject.com/png/3322766-200.png",
// //                                                               height: 100.0,
// //                                                               width: 100.0,
// //                                                             ),
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     )
// //                                                   : SingleChildScrollView(
// //                                                       scrollDirection:
// //                                                           Axis.vertical,
// //                                                       child: Wrap(
// //                                                         spacing: 5.0,
// //                                                         direction:
// //                                                             Axis.horizontal,
// //                                                         children: expansionPanelData
// //                                                             .itemPhotosWidgetList,
// //                                                         alignment: WrapAlignment
// //                                                             .spaceEvenly,
// //                                                         runSpacing: 10.0,
// //                                                       ),
// //                                                     ),
// //                                             ),
// //                                           ),
// //                                           SizedBox(
// //                                             height: 10,
// //                                           ),
// //                                           ElevatedButton(
// //                                             onPressed: () {
// //                                               pickPhotoFromGallery(
// //                                                   expansionPanelData);
// //                                               setState(() {
// //                                                 // เรียกใช้ addImage เพื่อเพิ่มรูปภาพใหม่
// //                                                 addImage(expansionPanelData);
// //                                               });
// //                                             },
// //                                             style: ElevatedButton.styleFrom(
// //                                               backgroundColor: GPrimaryColor,
// //                                               shape: RoundedRectangleBorder(
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(10),
// //                                               ),
// //                                             ),
// //                                             child: Text(
// //                                               "เพิ่มรูปภาพ",
// //                                               style: TextStyle(
// //                                                   color: Colors.white),
// //                                             ),
// //                                           ),
// //                                           SizedBox(height: 30),
// //                                           ElevatedButton(
// //                                             onPressed: () {
// //                                               displaycontent(
// //                                                   expansionPanelData, index);
// //                                             },
// //                                             style: ElevatedButton.styleFrom(
// //                                               backgroundColor:
// //                                                   Color(0xffE69800),
// //                                               shape: RoundedRectangleBorder(
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(10),
// //                                               ),
// //                                             ),
// //                                             child: Text(
// //                                               "แสดงผล",
// //                                               style: TextStyle(
// //                                                   color: Colors.white),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   Container(
// //                                     width: 450,
// //                                     height: 700,
// //                                     decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(10),
// //                                       color: Colors.white,
// //                                     ),
// //                                     child: Padding(
// //                                       padding: const EdgeInsets.all(25.0),
// //                                       child: Column(
// //                                         children: [
// //                                           SizedBox(
// //                                             height: 20,
// //                                           ),
// //                                           Container(
// //                                             width: 390,
// //                                             height: 600,
// //                                             decoration: ShapeDecoration(
// //                                               color: Color(0xFFE7E7E7),
// //                                               shape: RoundedRectangleBorder(
// //                                                 side: BorderSide(
// //                                                     width: 5,
// //                                                     color: GPrimaryColor),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(10),
// //                                               ),
// //                                             ),
// //                                             child: Column(
// //                                               children: [
// //                                                 Expanded(
// //                                                   child:
// //                                                       _displayedcontentWidget ??
// //                                                           Container(),
// //                                                 )
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           SizedBox(
// //                                             height: 20,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 Padding(
// //                   padding: const EdgeInsets.only(right: 70),
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       setState(() {
// //                         final nameController = TextEditingController();
// //                         final detailController = TextEditingController();
// //                         List<Widget> itemPhotosWidgetList =
// //                             []; // สร้างรายการว่างสำหรับรูปภาพ

// //                         _panelData.add(ExpansionPanelData(
// //                           nameController: nameController,
// //                           detailController: detailController,
// //                           itemPhotosWidgetList:
// //                               itemPhotosWidgetList, // ให้รายการรูปภาพใน ExpansionPanelData เป็นรายการว่าง
// //                         ));
// //                       });
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: WhiteColor,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(0),
// //                       ),
// //                       elevation: 3,
// //                     ),
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 10),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.start,
// //                         children: [
// //                           Icon(Icons.add_box_rounded, color: GPrimaryColor),
// //                           SizedBox(width: 8),
// //                           Text(
// //                             "เพิ่มเนื้อหาย่อย",
// //                             style: TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 18,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding:
// //                       const EdgeInsets.only(right: 70.0, top: 50.0, bottom: 50),
// //                   child: Container(
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.end,
// //                       children: [
// //                         ElevatedButton(
// //                           onPressed: () {
// //                             clearAllFields();
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Color(0xC5C5C5),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                           child: Text(
// //                             "ยกเลิก",
// //                             style: TextStyle(color: Colors.white),
// //                           ),
// //                         ),
// //                         SizedBox(
// //                           width: 20.0,
// //                         ),
// //                         ElevatedButton(
// //                           onPressed: () {
// //                             // addKnowlege();
// //                             uplaodImageAndSaveItemInfo();
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                             padding: const EdgeInsets.symmetric(
// //                                 horizontal: 20.0, vertical: 15.0),
// //                             backgroundColor: GPrimaryColor,
// //                           ),
// //                           child: uploading
// //                               ? SizedBox(
// //                                   child: CircularProgressIndicator(),
// //                                   height: 15.0,
// //                                 )
// //                               : const Text(
// //                                   "เพิ่ม",
// //                                   style: TextStyle(
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void removeImage() {
// //     setState(() {
// //       itemPhotosWidgetList.clear(); // ลบภาพเดิมทั้งหมด
// //     });
// //   }

// //   // pickPhotoFromGallery() async {
// //   //   photo = await _picker.pickMultiImage();
// //   //   if (photo != null) {
// //   //     setState(() {
// //   //       itemImagesList = itemImagesList + photo!;
// //   //       addImage();
// //   //       photo!.clear();
// //   //     });
// //   //   }
// //   // }

// //   Future<void> pickPhotoFromGallery(
// //       ExpansionPanelData expansionPanelData) async {
// //     photo = await _picker.pickMultiImage();
// //     if (photo != null) {
// //       setState(() {
// //         itemImagesList = itemImagesList + photo!;
// //         addImage(expansionPanelData);
// //         photo!.clear();
// //       });
// //       // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
// //     }
// //   }

// //   void addImage(ExpansionPanelData expansionPanelData) {
// //     // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
// //     expansionPanelData.itemPhotosWidgetList.clear();

// //     // เพิ่มรูปภาพใหม่ลงใน itemPhotosWidgetList ของแต่ละ ExpansionPanel
// //     for (var bytes in photo!) {
// //       expansionPanelData.itemPhotosWidgetList.add(
// //         Padding(
// //           padding: const EdgeInsets.all(0),
// //           child: Container(
// //             height: 200.0,
// //             child: AspectRatio(
// //               aspectRatio: 16 / 9,
// //               child: Container(
// //                 child: kIsWeb
// //                     ? Image.network(File(bytes.path).path)
// //                     : Image.file(
// //                         File(bytes.path),
// //                       ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       );
// //     }
// //   }

// //   // void addImage() {
// //   //   removeImage(); // ลบภาพเดิมก่อนที่จะเพิ่มภาพใหม่
// //   //   for (var bytes in photo!) {
// //   //     itemPhotosWidgetList.add(Padding(
// //   //       padding: const EdgeInsets.all(0),
// //   //       child: Container(
// //   //         height: 200.0,
// //   //         child: AspectRatio(
// //   //           aspectRatio: 16 / 9,
// //   //           child: Container(
// //   //             child: kIsWeb
// //   //                 ? Image.network(File(bytes.path).path)
// //   //                 : Image.file(
// //   //                     File(bytes.path),
// //   //                   ),
// //   //           ),
// //   //         ),
// //   //       ),
// //   //     ));
// //   //   }
// //   // }

// //   Future<void> uplaodImageAndSaveItemInfo() async {
// //     setState(() {
// //       uploading = true;
// //     });
// //     PickedFile? pickedFile;
// //     String? contentId = const Uuid().v4().substring(0, 10);
// //     for (int i = 0; i < itemImagesList.length; i++) {
// //       file = File(itemImagesList[i].path);
// //       print(itemImagesList[i].path);
// //       pickedFile = PickedFile(file!.path);
// //       await uploadImageToStorage(pickedFile, contentId, i);
// //     }
// //     await addAllContent(ListimageUrl);
// //     // เรียกใช้ addAllContentOnce เพื่อเพิ่มข้อมูลลง Firebase Firestore ครั้งเดียวเท่านั้น
// //     setState(() {
// //       uploading = false;
// //     });
// //   }

// //   // upload() async {
// //   //   String contentId = await uplaodImageAndSaveItemInfo();
// //   //   setState(() {
// //   //     uploading = false;
// //   //   });
// //   // }

// //   uploadImageToStorage(PickedFile? pickedFile, String contentId, index) async {
// //     String? kId = const Uuid().v4().substring(0, 10);
// //     Reference reference = FirebaseStorage.instance
// //         .ref()
// //         .child('Content/$contentId/contentImg_$kId');
// //     await reference.putData(
// //       await pickedFile!.readAsBytes(),
// //       SettableMetadata(contentType: 'image/jpeg'),
// //     );
// //     String imageUrl = await reference.getDownloadURL();
// //     print(imageUrl);
// //     print(ListimageUrl);
// //     setState(() {
// //       ListimageUrl.add(imageUrl);
// //       print(ListimageUrl);
// //     });
// //   }

// //   Future<void> addAllContent(List<String> imageUrl) async {
// //     // ตรวจสอบว่า addAllContent ถูกเรียกใช้ครั้งแรกหรือไม่
// //     //// ตั้งค่าให้ addedContent เป็น true เพื่อบอกว่า addAllContent ถูกเรียกใช้แล้วครั้งแรก

// //     // Validate user input
// //     if (namecontroller.text.isEmpty ||
// //         _selectedValue == null ||
// //         imageUrl == null) {
// //       Fluttertoast.showToast(
// //         msg: "กรุณากรอกข้อมูลให้ครบ",
// //         toastLength: Toast.LENGTH_SHORT,
// //         gravity: ToastGravity.CENTER,
// //         timeInSecForIosWeb: 1,
// //         backgroundColor: Colors.red,
// //         textColor: Colors.white,
// //         fontSize: 16.0,
// //       );
// //       return;
// //     }

// //     List<String> contentIds = [];
// //     print("list ${itemImagesList.length}");
// //     // Loop through content and add them to Firebase
// //     for (int index = 0; index < itemImagesList.length; index++) {
// //       String contentName = contentNameControllers[index].text;
// //       print(contentName);
// //       String contentDetail = contentDetailControllers[index].text;
// //       print(contentDetail);
// //       String imageurl = ListimageUrl[index].toString();
// //       print(" img ${imageurl}");

// //       String contentId = await addContent(contentName, contentDetail, imageurl);
// //       print("id ${contentId}");
// //       contentIds.add(contentId);
// //     }

// //     // Generate a knowledge ID
// //     String knowledgeId = const Uuid().v4().substring(0, 10);

// //     // Prepare knowledge data
// //     Map<String, dynamic> knowledgeMap = {
// //       "KnowledgeName": namecontroller.text,
// //       "KnowledgeIcons": _selectedValue,
// //       "create_at": Timestamp.now(),
// //       "deleted_at": null,
// //       "update_at": null,
// //       "Content": contentIds,
// //     };

// //     // Add knowledge to Firebase
// //     await Databasemethods()
// //         .addKnowlege(knowledgeMap, knowledgeId)
// //         .then((value) {
// //       showDialog(
// //         context: context,
// //         builder: (context) => const Addknowledgedialog(),
// //       );
// //     }).catchError((error) {
// //       Fluttertoast.showToast(
// //         msg: "เกิดข้อผิดพลาดในการเพิ่มความรู้: $error",
// //         toastLength: Toast.LENGTH_SHORT,
// //         gravity: ToastGravity.CENTER,
// //         timeInSecForIosWeb: 1,
// //         backgroundColor: Colors.red,
// //         textColor: Colors.white,
// //         fontSize: 16.0,
// //       );
// //     });
// //   }

// //   void clearAllFields() {
// //     namecontroller.clear();
// //     contentcontroller.clear();

// //     setState(() {
// //       selectedIconData = null;
// //     });

// //     setState(() {
// //       itemImagesList.clear();
// //       itemPhotosWidgetList.clear();
// //     });
// //   }

// //   Widget _displayedWidget = Container();
// //   Widget _displayedcontentWidget = Container();

// //   Widget _displaycoverWidget() {
// //     return Padding(
// //       padding: const EdgeInsets.all(15),
// //       child: Container(
// //         width: 300,
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10),
// //           color: WhiteColor,
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Row(
// //               children: [
// //                 SizedBox(
// //                   width: 20,
// //                 ),
// //                 Icon(
// //                   icons[_selectedValue] ??
// //                       Icons.error, // ระบุไอคอนตามค่าที่เลือก
// //                   size: 24, // ขนาดของไอคอน
// //                   color: GPrimaryColor, // สีของไอคอน
// //                 ),
// //                 SizedBox(
// //                   width: 20,
// //                 ),
// //                 Text(
// //                   namecontroller.text,
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   width: 20,
// //                 ),
// //                 Spacer(),
// //                 Padding(
// //                   padding: const EdgeInsets.only(right: 9),
// //                   child: Icon(
// //                     Icons
// //                         .keyboard_arrow_right_rounded, // ระบุไอคอนตามค่าที่เลือก
// //                     size: 24, // ขนาดของไอคอน
// //                     color: GPrimaryColor, // สีของไอคอน
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _displaycontentWidget(
// //       ExpansionPanelData expansionPanelData, int index) {
// //     return Scaffold(
// //       appBar: Appbarmain_no_botton(
// //         name: contentNameControllers.isNotEmpty
// //             ? contentNameControllers[index].text
// //             : '',
// //       ),
// //       body: Stack(
// //         children: [
// //           ListView.builder(
// //             itemCount: expansionPanelData.itemPhotosWidgetList.length,
// //             itemBuilder: (BuildContext context, int photoIndex) {
// //               return Container(
// //                 width: 390, // กำหนดความกว้างของรูปภาพ
// //                 height: 253, // กำหนดความสูงของรูปภาพ
// //                 child: expansionPanelData.itemPhotosWidgetList[
// //                     photoIndex], // ใส่รูปภาพลงใน Container
// //               );
// //             },
// //           ),
// //           Positioned(
// //             // ใช้ตัวแปร _positionY แทนค่า top
// //             bottom: 0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
// //             left: 0.0,
// //             right: 0.0,
// //             child: Container(
// //               height: 400,
// //               padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
// //               decoration: BoxDecoration(
// //                   color: WhiteColor,
// //                   borderRadius:
// //                       BorderRadius.vertical(top: Radius.circular(40))),
// //               child: Column(
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Icon(
// //                         icons[_selectedValue] ??
// //                             Icons.error, // ระบุไอคอนตามค่าที่เลือก
// //                         size: 24, // ขนาดของไอคอน
// //                         color: GPrimaryColor, // สีของไอคอน
// //                       ),
// //                       SizedBox(
// //                         width: 15,
// //                       ),
// //                       Text(
// //                         contentNameControllers[index].text,
// //                         style: TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 18),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(
// //                     height: 20,
// //                   ),
// //                   Column(
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     children: [
// //                       Align(
// //                         alignment: Alignment.centerLeft,
// //                         child: Text(
// //                           contentDetailControllers[index].text,
// //                           style: TextStyle(color: Colors.black, fontSize: 15),
// //                           textAlign: TextAlign.left,
// //                           maxLines: null,
// //                         ),
// //                       ),
// //                     ],
// //                   )
// //                 ],
// //               ),
// //               width: MediaQuery.of(context).size.width,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void display() {
// //     // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
// //     setState(() {
// //       // เรียกใช้งาน Widget ที่จะแสดงผล
// //       _displayedWidget = _displaycoverWidget();
// //     });
// //   }

// //   void displaycontent(ExpansionPanelData expansionPanelData, int index) {
// //     // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
// //     setState(() {
// //       if (index < _displayedContentWidgets.length) {
// //         _displayedContentWidgets[index] =
// //             _displaycontentWidget(expansionPanelData, index);
// //       }
// //     });
// //   }
// // }



//   // Future<void> uploadImageAndSaveItemInfo() async {
//   //   print('star uploadImageAndSaveItemInfo ');
//   //   setState(() {
//   //     uploading = true;
//   //   });
//   //   PickedFile? pickedFile;
//   //   String? contentIdnew = const Uuid().v4().substring(0, 10);
//   //   for (int i = 0; i < contentList.length + itemImagesList.length; i++) {
//   //     if (itemImagesList.length == 0) {
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('contentList: ${contentList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //       print('itemImagesList: ${itemImagesList.length}');
//   //     } else {
//   //       for (int i = 0; i < itemImagesList.length; i++) {
//   //         file = File(itemImagesList[i].path);
//   //         print(itemImagesList[i].path);
//   //         pickedFile = PickedFile(file!.path);
//   //         await uploadImageToStorage(pickedFile, contentIdnew, i);
//   //       }
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('itemImagesList2: ${itemImagesList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //     }
//   //   }
//   //   await updateContent(ListimageUrl);
//   //   // Update Content data
//   //   for (int index = 0; index < contentList.length; index++) {
//   //     updateContentData(index);
//   //   }
//   //   setState(() {
//   //     uploading = false;
//   //   });
//   // }

//   // void updateContentData(int index) async {
//   //   String contentName = contentNameControllers[index].text;
//   //   String contentDetail = contentDetailControllers[index].text;
//   //   String contentId = contentList[index].id;
//   //   String imageUrl = contentList[index].ImageURL;
//   //   try {
//   //     await upContent(contentId, contentName, contentDetail, imageUrl, index);
//   //     contentIds.add(contentId);
//   //   } catch (e) {
//   //     print('Error updating content late: $e');
//   //   }
//   // }

//   // Future<void> upContent(String contentId, String contentName,
//   //     String contentDetail, String imageUrl, int index) async {
//   //   try {
//   //     Map<String, dynamic> updateContent = {
//   //       'ContentName': contentName,
//   //       'ContentDetail': contentDetail,
//   //       'image_url': imageUrl,
//   //       'update_at': Timestamp.now(),
//   //     };
//   //     print('contentIds: $contentIds');
//   //     print('contentId: $contentId');
//   //     // Update the existing content document with the provided contentId
//   //     await FirebaseFirestore.instance
//   //         .collection('Content')
//   //         .doc(contentId)
//   //         .update(updateContent);
//   //     print('Updating content with ID: $contentId');
//   //     print('Content updated successfully');
//   //   } catch (e) {
//   //     print('Error updating content new: $e');
//   //   }
//   // }

//   // List<String> contentIds = [];

//   // Future<void> updateContent(List<String> imageUrl) async {
//   //   String? selectedValue;
//   //   print("start");
//   //   selectedValue = widget.knowledge!.knowledgeIcons != null
//   //       ? widget.knowledge!.knowledgeIcons.toString()
//   //       : widget.icons != null
//   //           ? icons.keys.firstWhere(
//   //               (key) => icons[key] == widget.icons,
//   //               orElse: () => '',
//   //             )
//   //           : null;

//   //   try {
//   //     print("start loop");
//   //     final knowledgeDocRef = FirebaseFirestore.instance
//   //         .collection('Knowledge')
//   //         .doc(widget.knowledge!.id);

//   //     await knowledgeDocRef.update({
//   //       'KnowledgeName': namecontroller.text,
//   //       'KnowledgeIcons': _selectedValue ??
//   //           icons.keys.firstWhere(
//   //               (key) => icons[key].toString() == selectedValue,
//   //               orElse: () => ''),
//   //       // "Content": contentIds,
//   //       'update_at': Timestamp.now()
//   //     });
//   //     print("contentIds = ${contentIds}");
//   //     print("contentList = ${contentList}");
//   //     print(ListimageUrl);
//   //     print("contentDetailControllers = ${contentDetailControllers.length}");
//   //     print("contentNameControllers = ${contentNameControllers.length}");

//   //     print("start loop");
//   //     for (int index = 0; index < contentList.length; index++) {
//   //       String contentName = contentNameControllers[index].text;
//   //       String contentDetail = contentDetailControllers[index].text;
//   //       String imageUrl = ListimageUrl[index].toString();
//   //       String contentId = contentList[index].id;
//   //       print(" index ${index}");
//   //       print(" id ${contentId}");
//   //       print(" name ${contentName}");
//   //       print(" detail ${contentDetail}");
//   //       print(" url ${imageUrl}");

//   //       await upContent(contentId, contentName, contentDetail, imageUrl, index);
//   //     }

//   //     print("3");
//   //     print('start if');
//   //     // contentIds.clear();
//   //     if (itemImagesList.isNotEmpty) {
//   //       for (int index = contentList.length;
//   //           index < contentList.length + itemImagesList.length;
//   //           index++) {
//   //         String contentName = contentNameControllers[index].text;
//   //         String contentNamenew = contentNameupdate[index].text;
//   //         String contentdetailnew = contentDetailupdate[index].text;
//   //         String contentDetail = contentDetailControllers[index].text;
//   //         String imageUrl = ListimageUrl[index].toString();
//   //         String? contentId;
//   //         if (index >= contentList.length) {
//   //           print('start loop addContent');
//   //           print(" index ${index}");
//   //           contentId =
//   //               await addContent(contentNamenew, contentdetailnew, imageUrl);
//   //           contentIds.add(contentId);
//   //           print(" url ${imageUrl}");
//   //         } else {
//   //           contentId = contentList[index].id;
//   //           await upContent(
//   //               contentId, contentName, contentDetail, imageUrl, index);
//   //           contentIds.add(contentId);
//   //         }

//   //         print(" id ${contentId}");
//   //         print(" name ${contentName}");
//   //         print(" detail ${contentDetail}");
//   //         print(" url ${imageUrl}");
//   //       }
//   //     }
//   //     print("contentIds ${contentIds}");

//   //     await knowledgeDocRef.update({'update_at': Timestamp.now()});
//   //   } catch (error) {
//   //     print("Error getting knowledge: $error");
//   //   }
//   // }

//   // Future<String> addContent(
//   //     String contentNamenew, String contentdetailnew, String imageUrl) async {
//   //   Map<String, dynamic> contentMap = {
//   //     "ContentName": contentNamenew,
//   //     "ContentDetail": contentdetailnew,
//   //     "image_url": imageUrl,
//   //     "create_at": Timestamp.now(),
//   //     "deleted_at": null,
//   //     "update_at": null,
//   //   };

//   //   // Generate a unique ID (replace with your preferred method)
//   //   String contentId = const Uuid().v4().substring(0, 10);

//   //   // Add data using addKnowlege, passing both contentMap and generated ID
//   //   await Databasemethods().addContent(contentMap, contentId);
//   //   return contentId;
//   // }

//   // Future<void> pickPhotoFromGallery(
//   //     ExpansionPanelData expansionPanelData) async {
//   //   photo = await _picker.pickMultiImage();
//   //   if (photo != null) {
//   //     setState(() {
//   //       itemImagesList = itemImagesList + photo!;
//   //       addImage(expansionPanelData);
//   //       photo!.clear();
//   //     });
//   //   }
//   // }

//   // void addImage(ExpansionPanelData expansionPanelData) {
//   //   // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
//   //   expansionPanelData.itemPhotosWidgetList.clear();
//   //   for (var bytes in photo!) {
//   //     expansionPanelData.itemPhotosWidgetList.add(
//   //       Padding(
//   //         padding: const EdgeInsets.all(0),
//   //         child: Container(
//   //           height: 200.0,
//   //           child: AspectRatio(
//   //             aspectRatio: 16 / 9,
//   //             child: Container(
//   //               child: kIsWeb
//   //                   ? Image.network(File(bytes.path).path)
//   //                   : Image.file(
//   //                       File(bytes.path),
//   //                     ),
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   }
//   // }

//   // uploadImageToStorage(PickedFile? pickedFile, String contentId, index) async {
//   //   String? kId = const Uuid().v4().substring(0, 10);
//   //   Reference reference = FirebaseStorage.instance
//   //       .ref()
//   //       .child('Content/$contentId/contentImg_$kId');
//   //   await reference.putData(
//   //     await pickedFile!.readAsBytes(),
//   //     SettableMetadata(contentType: 'image/jpeg'),
//   //   );
//   //   String imageUrl = await reference.getDownloadURL();
//   //   print("uploadImageToStorage imageUrl ${imageUrl}");

//   //   // print(ListimageUrl);
//   //   setState(() {
//   //     ListimageUrl.add(imageUrl);
//   //     // print(ListimageUrl);
//   //   });
//   // }

//   // Future<void> uploadImageAndSaveItemInfo() async {
//   //   print('star uploadImageAndSaveItemInfo ');
//   //   setState(() {
//   //     uploading = true;
//   //   });
//   //   PickedFile? pickedFile;
//   //   String? contentIdnew = const Uuid().v4().substring(0, 10);
//   //   for (int i = 0; i < contentList.length + itemImagesList.length; i++) {
//   //     if (itemImagesList.length == 0) {
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('contentList: ${contentList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //       print('itemImagesList: ${itemImagesList.length}');
//   //     } else {
//   //       for (int i = 0; i < itemImagesList.length; i++) {
//   //         file = File(itemImagesList[i].path);
//   //         print(itemImagesList[i].path);
//   //         pickedFile = PickedFile(file!.path);
//   //         await uploadImageToStorage(pickedFile, contentIdnew, i);
//   //       }
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('itemImagesList2: ${itemImagesList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //     }
//   //   }
//   //   await updateContent(ListimageUrl);
//   //   // Update Content data
//   //   for (int index = 0; index < contentList.length; index++) {
//   //     updateContentData(index);
//   //   }
//   //   setState(() {
//   //     uploading = false;
//   //   });
//   // }

//   // void updateContentData(int index) async {
//   //   String contentName = contentNameControllers[index].text;
//   //   String contentDetail = contentDetailControllers[index].text;
//   //   String contentId = contentList[index].id;
//   //   String imageUrl = contentList[index].ImageURL;
//   //   try {
//   //     await upContent(contentId, contentName, contentDetail, imageUrl, index);
//   //     contentIds.add(contentId);
//   //   } catch (e) {
//   //     print('Error updating content late: $e');
//   //   }
//   // }
//     // Future<void> uploadImageAndSaveItemInfo() async {
//   //   print('star uploadImageAndSaveItemInfo ');
//   //   setState(() {
//   //     uploading = true;
//   //   });
//   //   PickedFile? pickedFile;
//   //   String? contentIdnew = const Uuid().v4().substring(0, 10);
//   //   for (int i = 0; i < contentList.length + itemImagesList.length; i++) {
//   //     if (itemImagesList.length == 0) {
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('contentList: ${contentList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //       print('itemImagesList: ${itemImagesList.length}');
//   //     } else {
//   //       for (int i = 0; i < itemImagesList.length; i++) {
//   //         file = File(itemImagesList[i].path);
//   //         print(itemImagesList[i].path);
//   //         pickedFile = PickedFile(file!.path);
//   //         await uploadImageToStorage(pickedFile, contentIdnew, i);
//   //       }
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('itemImagesList2: ${itemImagesList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //     }
//   //   }
//   //   await updateContent(ListimageUrl);
//   //   // Update Content data
//   //   for (int index = 0; index < contentList.length; index++) {
//   //     updateContentData(index);
//   //   }
//   //   setState(() {
//   //     uploading = false;
//   //   });
//   // }

//   // void updateContentData(int index) async {
//   //   String contentName = contentNameControllers[index].text;
//   //   String contentDetail = contentDetailControllers[index].text;
//   //   String contentId = contentList[index].id;
//   //   String imageUrl = contentList[index].ImageURL;
//   //   try {
//   //     await upContent(contentId, contentName, contentDetail, imageUrl, index);
//   //     contentIds.add(contentId);
//   //   } catch (e) {
//   //     print('Error updating content late: $e');
//   //   }
//   // }

//   // Future<void> upContent(String contentId, String contentName,
//   //     String contentDetail, String imageUrl, int index) async {
//   //   try {
//   //     Map<String, dynamic> updateContent = {
//   //       'ContentName': contentName,
//   //       'ContentDetail': contentDetail,
//   //       'image_url': imageUrl,
//   //       'update_at': Timestamp.now(),
//   //     };
//   //     print('contentIds: $contentIds');
//   //     print('contentId: $contentId');
//   //     // Update the existing content document with the provided contentId
//   //     await FirebaseFirestore.instance
//   //         .collection('Content')
//   //         .doc(contentId)
//   //         .update(updateContent);
//   //     print('Updating content with ID: $contentId');
//   //     print('Content updated successfully');
//   //   } catch (e) {
//   //     print('Error updating content new: $e');
//   //   }
//   // }

//   // List<String> contentIds = [];

//   // Future<void> updateContent(List<String> imageUrl) async {
//   //   String? selectedValue;
//   //   print("start");
//   //   selectedValue = widget.knowledge!.knowledgeIcons != null
//   //       ? widget.knowledge!.knowledgeIcons.toString()
//   //       : widget.icons != null
//   //           ? icons.keys.firstWhere(
//   //               (key) => icons[key] == widget.icons,
//   //               orElse: () => '',
//   //             )
//   //           : null;

//   //   try {
//   //     print("start loop");
//   //     final knowledgeDocRef = FirebaseFirestore.instance
//   //         .collection('Knowledge')
//   //         .doc(widget.knowledge!.id);

//   //     await knowledgeDocRef.update({
//   //       'KnowledgeName': namecontroller.text,
//   //       'KnowledgeIcons': _selectedValue ??
//   //           icons.keys.firstWhere(
//   //               (key) => icons[key].toString() == selectedValue,
//   //               orElse: () => ''),
//   //       // "Content": contentIds,
//   //       'update_at': Timestamp.now()
//   //     });
//   //     print("contentIds = ${contentIds}");
//   //     print("contentList = ${contentList}");
//   //     print(ListimageUrl);
//   //     print("contentDetailControllers = ${contentDetailControllers.length}");
//   //     print("contentNameControllers = ${contentNameControllers.length}");

//   //     print("start loop");
//   //     for (int index = 0; index < contentList.length; index++) {
//   //       String contentName = contentNameControllers[index].text;
//   //       String contentDetail = contentDetailControllers[index].text;
//   //       String imageUrl = ListimageUrl[index].toString();
//   //       String contentId = contentList[index].id;
//   //       print(" index ${index}");
//   //       print(" id ${contentId}");
//   //       print(" name ${contentName}");
//   //       print(" detail ${contentDetail}");
//   //       print(" url ${imageUrl}");

//   //       await upContent(contentId, contentName, contentDetail, imageUrl, index);
//   //     }

//   //     print("3");
//   //     print('start if');
//   //     // contentIds.clear();
//   //     if (itemImagesList.isNotEmpty) {
//   //       for (int index = contentList.length;
//   //           index < contentList.length + itemImagesList.length;
//   //           index++) {
//   //         String contentName = contentNameControllers[index].text;
//   //         String contentNamenew = contentNameupdate[index].text;
//   //         String contentdetailnew = contentDetailupdate[index].text;
//   //         String contentDetail = contentDetailControllers[index].text;
//   //         String imageUrl = ListimageUrl[index].toString();
//   //         String? contentId;
//   //         if (index >= contentList.length) {
//   //           print('start loop addContent');
//   //           print(" index ${index}");
//   //           contentId =
//   //               await addContent(contentNamenew, contentdetailnew, imageUrl);
//   //           contentIds.add(contentId);
//   //           print(" url ${imageUrl}");
//   //         } else {
//   //           contentId = contentList[index].id;
//   //           await upContent(
//   //               contentId, contentName, contentDetail, imageUrl, index);
//   //           contentIds.add(contentId);
//   //         }

//   //         print(" id ${contentId}");
//   //         print(" name ${contentName}");
//   //         print(" detail ${contentDetail}");
//   //         print(" url ${imageUrl}");
//   //       }
//   //     }
//   //     print("contentIds ${contentIds}");

//   //     await knowledgeDocRef.update({'update_at': Timestamp.now()});
//   //   } catch (error) {
//   //     print("Error getting knowledge: $error");
//   //   }
//   // }

//   // Future<String> addContent(
//   //     String contentNamenew, String contentdetailnew, String imageUrl) async {
//   //   Map<String, dynamic> contentMap = {
//   //     "ContentName": contentNamenew,
//   //     "ContentDetail": contentdetailnew,
//   //     "image_url": imageUrl,
//   //     "create_at": Timestamp.now(),
//   //     "deleted_at": null,
//   //     "update_at": null,
//   //   };

//   //   // Generate a unique ID (replace with your preferred method)
//   //   String contentId = const Uuid().v4().substring(0, 10);

//   //   // Add data using addKnowlege, passing both contentMap and generated ID
//   //   await Databasemethods().addContent(contentMap, contentId);
//   //   return contentId;
//   // }

//   // Future<void> pickPhotoFromGallery(
//   //     ExpansionPanelData expansionPanelData) async {
//   //   photo = await _picker.pickMultiImage();
//   //   if (photo != null) {
//   //     setState(() {
//   //       itemImagesList = itemImagesList + photo!;
//   //       addImage(expansionPanelData);
//   //       photo!.clear();
//   //     });
//   //   }
//   // }

//   // void addImage(ExpansionPanelData expansionPanelData) {
//   //   // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
//   //   expansionPanelData.itemPhotosWidgetList.clear();
//   //   for (var bytes in photo!) {
//   //     expansionPanelData.itemPhotosWidgetList.add(
//   //       Padding(
//   //         padding: const EdgeInsets.all(0),
//   //         child: Container(
//   //           height: 200.0,
//   //           child: AspectRatio(
//   //             aspectRatio: 16 / 9,
//   //             child: Container(
//   //               child: kIsWeb
//   //                   ? Image.network(File(bytes.path).path)
//   //                   : Image.file(
//   //                       File(bytes.path),
//   //                     ),
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   }
//   // }

//   // uploadImageToStorage(PickedFile? pickedFile, String contentId, index) async {
//   //   String? kId = const Uuid().v4().substring(0, 10);
//   //   Reference reference = FirebaseStorage.instance
//   //       .ref()
//   //       .child('Content/$contentId/contentImg_$kId');
//   //   await reference.putData(
//   //     await pickedFile!.readAsBytes(),
//   //     SettableMetadata(contentType: 'image/jpeg'),
//   //   );
//   //   String imageUrl = await reference.getDownloadURL();
//   //   print("uploadImageToStorage imageUrl ${imageUrl}");

//   //   // print(ListimageUrl);
//   //   setState(() {
//   //     ListimageUrl.add(imageUrl);
//   //     // print(ListimageUrl);
//   //   });
//   // }

//   // Future<void> uploadImageAndSaveItemInfo() async {
//   //   print('star uploadImageAndSaveItemInfo ');
//   //   setState(() {
//   //     uploading = true;
//   //   });
//   //   PickedFile? pickedFile;
//   //   String? contentIdnew = const Uuid().v4().substring(0, 10);
//   //   for (int i = 0; i < contentList.length + itemImagesList.length; i++) {
//   //     if (itemImagesList.length == 0) {
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('contentList: ${contentList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //       print('itemImagesList: ${itemImagesList.length}');
//   //     } else {
//   //       for (int i = 0; i < itemImagesList.length; i++) {
//   //         file = File(itemImagesList[i].path);
//   //         print(itemImagesList[i].path);
//   //         pickedFile = PickedFile(file!.path);
//   //         await uploadImageToStorage(pickedFile, contentIdnew, i);
//   //       }
//   //       ListimageUrl.add(contentList[i].ImageURL);
//   //       print('itemImagesList2: ${itemImagesList.length}');
//   //       print('ListimageUrl: $ListimageUrl');
//   //     }
//   //   }
//   //   await updateContent(ListimageUrl);
//   //   // Update Content data
//   //   for (int index = 0; index < contentList.length; index++) {
//   //     updateContentData(index);
//   //   }
//   //   setState(() {
//   //     uploading = false;
//   //   });
//   // }

//   // void updateContentData(int index) async {
//   //   String contentName = contentNameControllers[index].text;
//   //   String contentDetail = contentDetailControllers[index].text;
//   //   String contentId = contentList[index].id;
//   //   String imageUrl = contentList[index].ImageURL;
//   //   try {
//   //     await upContent(contentId, contentName, contentDetail, imageUrl, index);
//   //     contentIds.add(contentId);
//   //   } catch (e) {
//   //     print('Error updating content late: $e');
//   //   }
//   // }


//   Widget buildList() {
//     return ExpansionPanelList.radio(
//       expansionCallback: (
//         int index,
//         bool isExpanded,
//       ) {
//         setState(() {
//           _selectedIndex = isExpanded ? -1 : index;
//         });
//       },
//       children: List.generate(
//         contentList.length,
//         (index) => ExpansionPanelRadio(
//           backgroundColor: Colors.white,
//           value: index,
//           headerBuilder: (
//             BuildContext context,
//             bool isExpanded,
//           ) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 40),
//               child: ListTile(
//                 title: Text(
//                   'เนื้อหาย่อยที่ ${index + 1}',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                   ),
//                 ),
//                 leading: IconButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Dialog(
//                           child: Container(
//                             width: 500,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 32, horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.info_outline,
//                                   size: 100,
//                                   color: Colors.red,
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Text(
//                                   'ต้องการลบข้อมูลเนื้อหาย่อยที่ ${index + 1}',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     OutlinedButton(
//                                       style: OutlinedButton.styleFrom(
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 20,
//                                           horizontal: 32,
//                                         ),
//                                         foregroundColor: Colors.red,
//                                         side: BorderSide(color: Colors.red),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text("ยกเลิก"),
//                                     ),
//                                     SizedBox(width: 20),
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: G2PrimaryColor,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 20,
//                                           horizontal: 32,
//                                         ),
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       onPressed: () {
//                                         deleteContentById(
//                                             widget.knowledge!.contents[index]);
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text("ยืนยัน"),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   icon: Icon(
//                     Icons.cancel,
//                     color: Color(0xFFFF543E),
//                   ),
//                 ),
//               ),
//             );
//           },
//           body: buildListItemBody(index),
//           canTapOnHeader: true,
//         ),
//       ),
//     );
//   }

//   Widget buildListItemBody(int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 0),
//                             ),
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 490,
//                                   height: 750,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(25.0),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(height: 20),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "ชื่อ",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Container(
//                                             padding:
//                                                 EdgeInsets.only(left: 10.0),
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Color(0xffCFD3D4)),
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             child: TextField(
//                                               controller:
//                                                   contentNameControllers[index],
//                                               decoration: InputDecoration(
//                                                   border: InputBorder.none),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "เนื้อหา",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                     color: Color(0xffCFD3D4)),
//                                                 borderRadius:
//                                                     BorderRadius.circular(5)),
//                                             child: TextField(
//                                               controller:
//                                                   contentDetailControllers[
//                                                       index],
//                                               keyboardType:
//                                                   TextInputType.multiline,
//                                               maxLines: 5,
//                                               decoration: InputDecoration(
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                           borderSide:
//                                                               BorderSide(
//                                                                   width: 1,
//                                                                   color: Colors
//                                                                       .white))),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "รูปภาพ",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12.0),
//                                               color: Colors.white70,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.grey.shade200,
//                                                   offset:
//                                                       const Offset(0.0, 0.5),
//                                                   blurRadius: 30.0,
//                                                 )
//                                               ]),
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 200.0,
//                                           child: Center(
//                                             child: SingleChildScrollView(
//                                               scrollDirection: Axis.vertical,
//                                               child: Wrap(
//                                                 spacing: 5.0,
//                                                 direction: Axis.horizontal,
//                                                 children:
//                                                     expansionPanelImagesList
//                                                         .map((photo) => Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(0),
//                                                               child: Container(
//                                                                 height: 200.0,
//                                                                 child:
//                                                                     AspectRatio(
//                                                                   aspectRatio:
//                                                                       16 / 9,
//                                                                   child: kIsWeb
//                                                                       ? Image.network(
//                                                                           photo[0]
//                                                                               .path) // Accessing the path property of the first XFile in the list
//                                                                       : Image
//                                                                           .file(
//                                                                           File(photo[0]
//                                                                               .path), // Accessing the path property of the first XFile in the list
//                                                                         ),
//                                                                 ),
//                                                               ),
//                                                             ))
//                                                         .toList(),
//                                                 alignment:
//                                                     WrapAlignment.spaceEvenly,
//                                                 runSpacing: 10.0,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         ElevatedButton(
//                                           onPressed: () =>
//                                               pickPhotoFromGallery(index),
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: GPrimaryColor,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "แก้ไขรูปภาพ",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             // displaycontent(
//                                             //     expansionPanelData, index);
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Color(0xffE69800),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "แสดงผล",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                     width: 450,
//                                     height: 700,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.white,
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(25.0),
//                                       child: Column(
//                                         children: [
//                                           SizedBox(
//                                             height: 20,
//                                           ),
//                                           Container(
//                                             width: 390,
//                                             height: 600,
//                                             decoration: ShapeDecoration(
//                                               color: Color(0xFFE7E7E7),
//                                               shape: RoundedRectangleBorder(
//                                                 side: BorderSide(
//                                                     width: 5,
//                                                     color: GPrimaryColor),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                             // child: Column(
//                                             //   children: [
//                                             //     Expanded(
//                                             //       child: _previewWidget(
//                                             //           expansionPanelData,
//                                             //           index),
//                                             //       // _displayedcontentWidget ??
//                                             //       //     Container(),
//                                             //     )
//                                             //   ],
//                                             // ),
//                                           ),
//                                           SizedBox(
//                                             height: 20,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }



  
  
//   Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12.0),
//                                               color: Colors.white70,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.grey.shade200,
//                                                   offset:
//                                                       const Offset(0.0, 0.5),
//                                                   blurRadius: 30.0,
//                                                 )
//                                               ]),
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 200.0,
//                                           child: Center(
//                                             child: SingleChildScrollView(
//                                               scrollDirection: Axis.vertical,
//                                               child: expansionPanelImagesList
//                                                       .isNotEmpty
//                                                   ? Wrap(
//                                                       spacing: 5.0,
//                                                       direction:
//                                                           Axis.horizontal,
//                                                       alignment: WrapAlignment
//                                                           .spaceEvenly,
//                                                       runSpacing: 10.0,
//                                                       children: [
//                                                         for (var photo
//                                                             in expansionPanelImagesList)
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(0),
//                                                             child: Container(
//                                                               height: 200.0,
//                                                               child:
//                                                                   AspectRatio(
//                                                                 aspectRatio:
//                                                                     16 / 9,
//                                                                 child: kIsWeb
//                                                                     ? Image.network(
//                                                                         photo[0]
//                                                                             .path)
//                                                                     : Image.file(File(
//                                                                         photo[0]
//                                                                             .path)),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                       ],
//                                                     )
//                                                   : contentList.isNotEmpty
//                                                       ? Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(0),
//                                                           child: Container(
//                                                             height: 200.0,
//                                                             child: AspectRatio(
//                                                               aspectRatio:
//                                                                   16 / 9,
//                                                               child: kIsWeb
//                                                                   ? Image.network(
//                                                                       contentList[
//                                                                               index]
//                                                                           .ImageURL)
//                                                                   : Image.network(
//                                                                       contentList[
//                                                                               index]
//                                                                           .ImageURL),
//                                                             ),
//                                                           ),
//                                                         )
//                                                       : const SizedBox(), // แสดงพื้นที่ว่างหากไม่มีรูปภาพใดๆ
//                                             ),
//                                           ),
//                                         ),

//   // Future<void> upContent(String contentId, String contentName,
//   //     String contentDetail, String imageUrl, int index) async {
//   //   try {
//   //     Map<String, dynamic> updateContent = {
//   //       'ContentName': contentName,
//   //       'ContentDetail': contentDetail,
//   //       'image_url': imageUrl,
//   //       'update_at': Timestamp.now(),
//   //     };
//   //     print('contentIds: $contentIds');
//   //     print('contentId: $contentId');
//   //     // Update the existing content document with the provided contentId
//   //     await FirebaseFirestore.instance
//   //         .collection('Content')
//   //         .doc(contentId)
//   //         .update(updateContent);
//   //     print('Updating content with ID: $contentId');
//   //     print('Content updated successfully');
//   //   } catch (e) {
//   //     print('Error updating content new: $e');
//   //   }
//   // }
//   import 'dart:io';
// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:go_router/go_router.dart';
// import 'package:uuid/uuid.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:watalygold_admin/Page/Knowlege/Add/Multiplecontent.dart';
// import 'package:watalygold_admin/Widgets/Appbar_mains_notbotton.dart';
// import 'package:watalygold_admin/Widgets/Appbarmain.dart';
// import 'package:watalygold_admin/Widgets/Color.dart';
// import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';
// import 'package:watalygold_admin/service/content.dart';
// import 'package:watalygold_admin/service/database.dart';
// import 'package:watalygold_admin/service/knowledge.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// import '../../../Widgets/dialogEdit.dart';

// Map<String, IconData> icons = {
//   'สถิติ': Icons.analytics_outlined,
//   'ดอกไม้': Icons.yard,
//   'หนังสือ': Icons.book,
//   'น้ำ': Icons.water_drop_outlined,
//   'ระวัง': Icons.warning_rounded,
//   'คำถาม': Icons.quiz_outlined,
// };

// class ExpansionPanelData {
//   TextEditingController nameController;
//   TextEditingController detailController;
//   List<Widget> itemPhotosWidgetList;

//   ExpansionPanelData({
//     required this.nameController,
//     required this.detailController,
//     required this.itemPhotosWidgetList,
//   });
// }

// List<ExpansionPanelData> _panelData = [];

// class EditMutiple extends StatefulWidget {
//   final Knowledge? knowledge;
//   final IconData? icons;
//   final Contents? contents;

//   const EditMutiple({super.key, this.knowledge, this.contents, this.icons});

//   @override
//   State<EditMutiple> createState() => _EditMutipleState();
// }

// class _EditMutipleState extends State<EditMutiple> {
//   List<List<String>> allKnowledgeContents = [];
//   TextEditingController contentNameController = TextEditingController();
//   String? message;
//   IconData? selectedIconData;
//   String? _selectedValue;
//   List<bool> _showPreview = [];
//   int _currentExpandedIndex = -1;
//   bool addedContent = false;
//   TextEditingController contentcontroller = new TextEditingController();
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController contentdetailcontroller = TextEditingController();
//   TextEditingController contentnamecontroller = TextEditingController();
//   List<TextEditingController> contentNameControllers = [];
//   List<TextEditingController> contentDetailControllers = [];
//   List<TextEditingController> contentNameupdate = [];
//   List<TextEditingController> contentDetailupdate = [];
//   List<Knowledge> knowledgelist = [];
//   List<int> _deletedPanels = [];
//   List<Widget> itemPhotosWidgetList = <Widget>[]; //แสดงตัวอย่างรูปภาพ
//   final ImagePicker _picker = ImagePicker();
//   File? file;
//   List<XFile>? photo =
//       <XFile>[]; //เป็นรายการของ XFile ที่ใช้ในการเก็บรูปภาพที่เลือกจากแกล
//   List<XFile> itemImagesList =
//       <XFile>[]; //ใช้ในการเก็บรูปภาพที่ผู้ใช้เลือกเพื่ออัปโหลด
//   List<String> downloadUrl = <String>[]; //เก็บ url ภาพ
//   bool uploading = false;
//   bool _isLoading = true;
//   List<Contents> contentList = [];
//   List<String> imageURLlist = [];
//   List<String> ContentDetaillist = [];
//   List<String> ContentNamelist = [];
//   List? itemContent;
//   List<String> ListimageUrl = [];

//   Future<List<Knowledge>> getKnowledges() async {
//     try {
//       final FirebaseFirestore firestore = FirebaseFirestore.instance;
//       final querySnapshot = await firestore
//           .collection('Knowledge')
//           .where('deleted_at', isNull: true)
//           .get();
//       return querySnapshot.docs
//           .map((doc) => Knowledge.fromFirestore(doc))
//           .toList();
//     } catch (error) {
//       print("Error getting knowledge: $error");
//       return []; // Or handle the error in another way
//     }
//   }

//   Future<Contents> getContentsById(String documentId) async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final docRef = firestore.collection('Content').doc(documentId);
//     final doc = await docRef.get();

//     if (doc.exists) {
//       final data = doc.data();
//       return Contents(
//         id: doc.id,
//         ContentName: data!['ContentName'].toString(),
//         ContentDetail: data['ContentDetail'].toString(),
//         ImageURL: data['image_url'].toString(),
//         deleted_at: doc['deleted_at'],
//         create_at: data['create_at'] as Timestamp? ??
//             Timestamp.fromDate(DateTime.now()),
//       );
//     } else {
//       throw Exception('Document not found with ID: $documentId');
//     }
//   }

//   void showToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.grey[800],
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   void deleteContentById(String documentId) async {
//     try {
//       await Databasemethods().deleteContent(documentId);
//       showToast("ลบข้อมูลเสร็จสิ้น");
//     } catch (e) {
//       print('Error deleting content: $e');
//     }
//   }

//   Future<void> updateContent(
//       List<String> newImageUrls, List<String> updatedImageUrls) async {
//     String? selectedValue;
//     selectedValue = widget.knowledge!.knowledgeIcons != null
//         ? widget.knowledge!.knowledgeIcons.toString()
//         : widget.icons != null
//             ? icons.keys.firstWhere(
//                 (key) => icons[key] == widget.icons,
//                 orElse: () => '',
//               )
//             : null;

//     try {
//       final knowledgeDocRef = FirebaseFirestore.instance
//           .collection('Knowledge')
//           .doc(widget.knowledge!.id);

//       // Update general data except Content and image_url
//       await knowledgeDocRef.update({
//         'KnowledgeName': namecontroller.text,
//         'KnowledgeIcons': _selectedValue ??
//             icons.keys.firstWhere(
//                 (key) => icons[key].toString() == selectedValue,
//                 orElse: () => ''),
//         "Content": contentIds,
//         'update_at': Timestamp.now()
//       });

//       List<String> existingContentIds =
//           contentList.map((content) => content.id).toList();
//       // Update existing contents with new image URLs
//       List<String> updatedContentIds = [];
//       for (int index = 0; index < contentList.length; index++) {
//         String contentName = contentNameControllers[index].text;
//         String contentDetail = contentDetailControllers[index].text;
//         String contentId = contentList[index].id;
//         String imageUrl = index < updatedImageUrls.length
//             ? updatedImageUrls[index]
//             : contentList[index].ImageURL;
//         updatedContentIds.add(
//             await upContent(contentId, contentName, contentDetail, imageUrl));
//       }

//       // Add new contents for new images
//       for (int index = 0; index < newImageUrls.length; index++) {
//         String contentNamenew = index < contentNameupdate.length
//             ? contentNameupdate[index].text
//             : '';
//         String contentdetailnew = index < contentDetailupdate.length
//             ? contentDetailupdate[index].text
//             : '';
//         String imageUrl = newImageUrls[index];
//         String newContentId =
//             await addContent(contentNamenew, contentdetailnew, imageUrl);
//         updatedContentIds.add(newContentId);
//       }
//       // // Update existing contents without changing image_url
//       // List<String> updatedContentIds = [];
//       // for (int index = 0; index < contentList.length; index++) {
//       //   String contentName = contentNameControllers[index].text;
//       //   String contentDetail = contentDetailControllers[index].text;
//       //   String contentId = contentList[index].id;
//       //   String imageUrl = index < newImageUrls.length
//       //       ? newImageUrls[index]
//       //       : contentList[index].ImageURL;
//       //   updatedContentIds.add(
//       //       await upContent(contentId, contentName, contentDetail, imageUrl));
//       //   print("Error getting knowledge updateContent: $updatedContentIds");
//       // }
//       // print(ListimageUrl);

//       // // Add new contents for new images
//       // for (int index = 0; index < newImageUrls.length; index++) {
//       //   String contentNamenew = index < contentNameupdate.length
//       //       ? contentNameupdate[index].text
//       //       : '';
//       //   String contentdetailnew = index < contentDetailupdate.length
//       //       ? contentDetailupdate[index].text
//       //       : '';
//       //   String imageUrl = newImageUrls[index];
//       //   String newContentId =
//       //       await addContent(contentNamenew, contentdetailnew, imageUrl);
//       //   updatedContentIds.add(newContentId);
//       // }

//       await knowledgeDocRef
//           .update({'Content': updatedContentIds, 'update_at': Timestamp.now()});
//           showDialog(
//           context: context,
//           builder: (context) => const DialogEdit(),
//         );
//         Future.delayed(const Duration(seconds: 1), () {
//           Navigator.pop(context);
//           context.goNamed("/mainKnowledge");
//         });
//     } catch (error) {
//       print("Error getting knowledge updateContent: $error");
//     }
//   }

//   Future<String> upContent(
//     String contentId,
//     String contentName,
//     String contentDetail,
//     String imageUrl,
//   ) async {
//     try {
//       Map<String, dynamic> updateContent = {
//         'ContentName': contentName,
//         'ContentDetail': contentDetail,
//         'image_url': imageUrl, // Update image_url with the new URL
//         'update_at': Timestamp.now(),
//       };

//       await FirebaseFirestore.instance
//           .collection('Content')
//           .doc(contentId)
//           .update(updateContent);

//       print('Updating content with ID: $contentId');
//       print('Content updated successfully');

//       return contentId;
//     } catch (e) {
//       print('Error updating content: $e');
//       rethrow;
//     }
//   }

//   List<String> contentIds = [];

//   Future<String> addContent(
//       String contentNamenew, String contentdetailnew, String imageUrl) async {
//     Map<String, dynamic> contentMap = {
//       "ContentName": contentNamenew,
//       "ContentDetail": contentdetailnew,
//       "image_url": imageUrl,
//       "create_at": Timestamp.now(),
//       "deleted_at": null,
//       "update_at": null,
//     };
//     print(" contentNamenew ${contentNamenew}");
//     print('addContent successfully');
//     // Generate a unique ID (replace with your preferred method)
//     String contentId = const Uuid().v4().substring(0, 10);

//     // Add data using addKnowlege, passing both contentMap and generated ID
//     await Databasemethods().addContent(contentMap, contentId);

//     return contentId;
//   }

//   List<List<XFile>> expansionPanelImagesList = [];

//   // Future<void> pickPhotoFromGallers(int index) async {
//   //   print("เริ่มการเลือกรูปภาพ pickPhotoFromGallers");
//   //   List<XFile>? newPhotos = await _picker.pickMultiImage();
//   //   if (newPhotos != null) {
//   //     setState(() {
//   //       print("Loop");
//   //       if (expansionPanelImagesList.length <= index) {
//   //         expansionPanelImagesList.add(newPhotos);
//   //         print("รายการรูปภาพใหม่ if: $expansionPanelImagesList");
//   //       }
//   //     });
//   //   }
//   // }
//   // List<List<XFile>> expansionPanelImagesList = [];

// // สำหรับรูปภาพที่ต้องการเพิ่ม
// List<XFile> newImageFiles = [];

// // สำหรับรูปภาพที่ต้องการอัปเดต
//   List<List<XFile>> updatedImageFiles = [];
// Future<void> pickPhotoFromGallers(int index) async {
//   print("เริ่มการเลือกรูปภาพ pickPhotoFromGallers");
//   List<XFile>? newPhotos = await _picker.pickMultiImage();
  
//   if (newPhotos != null) {
//     setState(() {
//       print("Loop");
//       print("รายการรูปภาพที่ต้องการอัปเดต 1: $updatedImageFiles");

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
//   // Future<void> pickPhotoFromGallers(int index) async {
//   //   print("เริ่มการเลือกรูปภาพ pickPhotoFromGallers");
//   //   List<XFile>? newPhotos = await _picker.pickMultiImage();
//   //   if (newPhotos != null) {
//   //     setState(() {
//   //       print("Loop");
//   //        print("รายการรูปภาพที่ต้องการอัปเดต 1: $updatedImageFiles");
//   //       if (updatedImageFiles.length <= index) {
//   //         updatedImageFiles.add(
//   //             newPhotos);
//   //              print("รายการรูปภาพที่ต้องการอัปเดต 2: $updatedImageFiles"); // เพิ่ม List ของ XFile เข้าไปในรายการ updatedImageFiles
//   //       } else {
//   //         updatedImageFiles[index] =
//   //             newPhotos; // กำหนด List ของ XFile ให้กับตำแหน่งที่ระบุในรายการ updatedImageFiles
//   //       }
//   //       print("รายการรูปภาพที่ต้องการอัปเดต 3: $updatedImageFiles");
//   //     });
//   //   }
//   // }
  
// Future<void> pickPhotoFromGallery(
//     int index,
//     ExpansionPanelData expansionPanelData,
//   ) async {
//     print("เริ่มการเลือกรูปภาพ");
//     List<XFile>? newPhotos = await _picker.pickMultiImage();
//     if (newPhotos != null) {
//       setState(() {
//         newImageFiles.addAll(newPhotos); // เพิ่มรูปภาพใหม่ลงในรายการ newImageFiles
//         addImage(expansionPanelData);
//       });
//       print("รายการรูปภาพใหม่: $newImageFiles");
//     }
//   }
  
//   // Future<void> pickPhotoFromGallers(int index) async {
//   //   print("เริ่มการเลือกรูปภาพ pickPhotoFromGallers");
//   //   List<XFile>? newPhotos = await _picker.pickMultiImage();
//   //   if (newPhotos != null) {
//   //     setState(() {
//   //       print("Loop");
//   //       if (expansionPanelImagesList.length <= index) {
//   //         expansionPanelImagesList.add(newPhotos);
//   //       } else {
//   //         expansionPanelImagesList[index] = newPhotos;
//   //       }
//   //       print("รายการรูปภาพใหม่: $expansionPanelImagesList");
//   //     });
//   //   }
//   // }


//   // Future<void> pickPhotoFromGallery(
//   //   int index,
//   //   ExpansionPanelData expansionPanelData,
//   // ) async {
//   //   print("เริ่มการเลือกรูปภาพ");
//   //   photo = await _picker.pickMultiImage();
//   //   if (photo != null) {
//   //     setState(() {
//   //       itemImagesList = itemImagesList + photo!;
//   //       addImage(expansionPanelData);
//   //       photo!.clear();
//   //     });
//   //     print("รายการรูปภาพใหม่: $itemImagesList");
//   //   }
//   // }

// //   Future<void> uploadImageAndSaveItemInfo() async {
// //   print('star uploadImageAndSaveItemInfo ');
// //   setState(() {
// //     uploading = true;
// //   });

// //   PickedFile? pickedFile;
// //   String? contentIdnew = const Uuid().v4().substring(0, 10);

// //   // Create a new list to store URLs of new images
// //   List<String> newImageUrls = [];

// //   // Upload and save new images
// //   for (XFile newImageFile in newImageFiles) {
// //     file = File(newImageFile.path);
// //     pickedFile = PickedFile(file.path);
// //     print('star uploadImageToStorage ');
// //     String imageUrl = await uploadImageToStorage(pickedFile, contentIdnew);
// //     newImageUrls.add(imageUrl); // Add the new image URL to the list
// //   }

// //   // Upload and update existing images
// //   List<String> updatedImageUrls = [];
// //   for (int i = 0; i < updatedImageFiles.length; i++) {
// //     XFile updatedImageFile = updatedImageFiles[i];
// //     file = File(updatedImageFile.path);
// //     pickedFile = PickedFile(file.path);
// //     print('star uploadImageToStorage ');
// //     String imageUrl = await uploadImageToStorage(pickedFile, contentList[i].id);
// //     updatedImageUrls.add(imageUrl); // Add the updated image URL to the list
// //   }

// //   await updateContent(newImageUrls, updatedImageUrls); // Pass the new and updated image URLs to updateContent

// //   setState(() {
// //     uploading = false;
// //   });
// // }

//   Future<void> uploadImageAndSaveItemInfo() async {
//     print('star uploadImageAndSaveItemInfo ');
//     setState(() {
//       uploading = true;
//     });

//     PickedFile? pickedFile;
//     String? contentIdnew = const Uuid().v4().substring(0, 10);

// // Create a new list to store URLs of new images
//     List<String> newImageUrls = [];

//     // Upload and save new images
//     for (XFile newImageFile in newImageFiles) {
//       file = File(newImageFile.path);
//       pickedFile = PickedFile(file!.path);
//       print('star uploadImageToStorage ');
//       String imageUrl = await uploadImageToStorage(pickedFile, contentIdnew,newImageFile);
//       newImageUrls.add(imageUrl); // Add the new image URL to the list
//     }

//     // Upload and update existing images
//     List<String> updatedImageUrls = [];
//     for (int i = 0; i < updatedImageFiles.length; i++) {
//       List<XFile> updatedImageFileList = updatedImageFiles[i];
//       for (int j = 0; j < updatedImageFileList.length; j++) {
//         XFile updatedImageFile = updatedImageFileList[j];
//         file = File(updatedImageFile.path);
//         pickedFile = PickedFile(file!.path);
//         print('star uploadImageToStorage ');
//         String imageUrl =
//             await uploadImageToStorage(pickedFile, contentList[i].id, j);
//         updatedImageUrls.add(imageUrl); // Add the updated image URL to the list
//       }
//     }

// //   await updateContent(newImageUrls, updatedImageUrls); // Pass the new and updated image URLs to updateContent

//     await updateContent(newImageUrls,
//         updatedImageUrls); // Pass the new image URLs to updateContent

//     setState(() {
//       uploading = false;
//     });
//   }

//  void addImage(ExpansionPanelData expansionPanelData) {
//   // ลบรูปภาพเดิมก่อนที่จะเพิ่มรูปภาพใหม่
//   expansionPanelData.itemPhotosWidgetList.clear();

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

//   Future<String> uploadImageToStorage(
//       PickedFile? pickedFile, String contentId, index) async {
//     String? kId = const Uuid().v4().substring(0, 10);
//     Reference reference = FirebaseStorage.instance
//         .ref()
//         .child('Content/$contentId/contentImg_$kId');
//     await reference.putData(
//       await pickedFile!.readAsBytes(),
//       SettableMetadata(contentType: 'image/jpeg'),
//     );
//     String imageUrl = await reference.getDownloadURL();
//     print("uploadImageToStorage imageUrl ${imageUrl}");
//     return imageUrl; // Return the image URL instead of adding it to ListimageUrl
//   }

//   void clearAllFields() {
//     namecontroller.clear();
//     contentcontroller.clear();

//     setState(() {
//       selectedIconData = null;
//     });

//     setState(() {
//       itemImagesList.clear();
//       itemPhotosWidgetList.clear();
//     });
//   }

 

//   Future<void> loadData() async {
//     if (widget.knowledge != null) {
//       namecontroller.text = widget.knowledge!.knowledgeName;
//       contentcontroller.text = widget.knowledge!.knowledgeDetail;
//     }

//     setState(() {
//       _isLoading = true; // Set loading state to true
//     });

//     // Clear the existing controllers
//     contentNameControllers.clear();
//     contentDetailControllers.clear();

//     // ใช้ลูป for ในการวนลูปผ่านทุกๆ document ID ใน widget.knowledge!.contents
//     for (var documentId in widget.knowledge!.contents) {
//       // ดึงข้อมูล Contents จาก Firestore โดยใช้ document ID แต่ละตัว
//       var contents = await getContentsById(documentId);

//       if (contents.deleted_at == null) {
//         setState(() {
//           contentList.add(contents);
//           contentNameControllers
//               .add(TextEditingController(text: contents.ContentName));
//           contentDetailControllers
//               .add(TextEditingController(text: contents.ContentDetail));
//               // updatedImageFiles.add(contents.ImageURL);
//         });
//       }
//       print(contents.deleted_at);
//       print(contentList);
//       print(contents.ContentName);
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//     setState(() {
//       _isLoading = true; // Set loading state to true
//     });

//     getKnowledges().then((value) async {
//       setState(() {
//         knowledgelist = value;
//       });
//       if (knowledgelist.length == 0) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//       for (var knowledge in knowledgelist) {
//         if (knowledge.knowledgeImg.isEmpty) {
//           // แสดง Loading indicator
//           final firstContent = knowledge.contents[0].toString();
//           final contents = await getContentsById(firstContent);
//           imageURLlist.add(contents.ImageURL);
//           setState(() {
//             _isLoading = false;
//           });
//           // ซ่อน Loading indicator
//         } else {
//           imageURLlist.add(knowledge.knowledgeImg);
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 color: GPrimaryColor,
//                 child: SideNav(
//                   status: 1,
//                   dropdown: true,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: Scaffold(
//                 appBar: Appbarmain(),
//                 backgroundColor: GrayColor,
//                 body: SingleChildScrollView(
//                   child: _isLoading
//                       ? Center(
//                           child: LoadingAnimationWidget.discreteCircle(
//                             color: WhiteColor,
//                             secondRingColor: Colors.green,
//                             thirdRingColor: Colors.yellow,
//                             size: 200,
//                           ),
//                         )
//                       : Container(
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 70),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 50,
//                                 ),
//                                 Column(
//                                   children: [
//                                     Center(
//                                       child: Container(
//                                         child: Stack(
//                                           children: [
//                                             FractionallySizedBox(
//                                               widthFactor: 0.9,
//                                               child: Container(
//                                                 width: MediaQuery.of(context)
//                                                     .size
//                                                     .width,
//                                                 height: 120,
//                                                 decoration: ShapeDecoration(
//                                                   color: Colors.white,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(20.0),
//                                               child: Row(
//                                                 children: [
//                                                   SizedBox(
//                                                     width: 140,
//                                                   ),
//                                                   Container(
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width *
//                                                             0.16,
//                                                     height:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .height *
//                                                             0.08,
//                                                     child: Container(
//                                                         decoration:
//                                                             ShapeDecoration(
//                                                           color: Color.fromARGB(
//                                                               255,
//                                                               255,
//                                                               255,
//                                                               255),
//                                                           shape:
//                                                               RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10),
//                                                           ),
//                                                         ),
//                                                         child: Padding(
//                                                           padding:
//                                                               EdgeInsets.only(
//                                                                   top: 20,
//                                                                   left: 70),
//                                                           child: Text(
//                                                             'เนื้อหาเดี่ยว',
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.grey,
//                                                               fontSize: 20,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500,
//                                                             ),
//                                                           ),
//                                                         )),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 150,
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 15),
//                                                     child: Container(
//                                                       width:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width *
//                                                               0.16,
//                                                       height:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .height *
//                                                               0.08,
//                                                       child: Container(
//                                                           decoration:
//                                                               ShapeDecoration(
//                                                             color:
//                                                                 GPrimaryColor,
//                                                             shape:
//                                                                 RoundedRectangleBorder(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                             ),
//                                                           ),
//                                                           child: Padding(
//                                                             padding:
//                                                                 EdgeInsets.only(
//                                                                     top: 16,
//                                                                     left: 70),
//                                                             child: Text(
//                                                               'หลายเนื้อหา',
//                                                               style: TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontSize: 20,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                               ),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 50,
//                                 ),
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.create_outlined,
//                                         size: 30,
//                                         color: GPrimaryColor,
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                         "แก้ไขคลังความรู้ ",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 32,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 50,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 490,
//                                       height: 400,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(25.0),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Image.asset(
//                                                     "assets/images/knowlege.png"),
//                                                 SizedBox(width: 10),
//                                                 Text(
//                                                   "แก้ไขคลังความรู้",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: 30),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0.0, right: 0),
//                                               child: Align(
//                                                 alignment: Alignment.topLeft,
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       "ไอคอน ",
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "*",
//                                                       style: TextStyle(
//                                                         color: Colors.red,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Container(
//                                                 child: DropdownButton(
//                                                   items: <String>[
//                                                     'สถิติ',
//                                                     'ดอกไม้',
//                                                     'หนังสือ',
//                                                     'น้ำ',
//                                                     'ระวัง',
//                                                     'คำถาม'
//                                                   ].map<
//                                                           DropdownMenuItem<
//                                                               String>>(
//                                                       (String value) {
//                                                     return DropdownMenuItem<
//                                                         String>(
//                                                       value: value,
//                                                       child: Row(
//                                                         children: [
//                                                           icons[value] != null
//                                                               ? Icon(
//                                                                   icons[value]!,
//                                                                   color:
//                                                                       GPrimaryColor,
//                                                                 )
//                                                               : SizedBox(),
//                                                           SizedBox(width: 25),
//                                                           Text(
//                                                             value,
//                                                             style: TextStyle(
//                                                                 color:
//                                                                     GPrimaryColor),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   }).toList(),
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       _selectedValue = value;
//                                                     });
//                                                   },
//                                                   hint: Row(
//                                                     children: [
//                                                       // ไอคอนที่ต้องการเพิ่ม
//                                                       SizedBox(
//                                                           width:
//                                                               10), // ระยะห่างระหว่างไอคอนและข้อความ
//                                                       Row(
//                                                         children: [
//                                                           Icon(
//                                                               widget.icons ??
//                                                                   Icons
//                                                                       .question_mark_rounded,
//                                                               color:
//                                                                   GPrimaryColor,
//                                                               size: 24),
//                                                           SizedBox(
//                                                             width: 20,
//                                                           ),
//                                                           Text(
//                                                             "${widget.icons != null ? icons.keys.firstWhere((key) => icons[key] == widget.icons, orElse: () => '') : ''}",
//                                                             style: TextStyle(
//                                                                 color:
//                                                                     GPrimaryColor),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   value: _selectedValue,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(height: 30),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0.0, right: 0),
//                                               child: Align(
//                                                 alignment: Alignment.topLeft,
//                                                 child: Row(
//                                                   children: [
//                                                     Text(
//                                                       "ชื่อ",
//                                                       style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       "*",
//                                                       style: TextStyle(
//                                                         color: Colors.red,
//                                                         fontSize: 18,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 0.0, right: 0),
//                                               child: Container(
//                                                 padding:
//                                                     EdgeInsets.only(left: 10.0),
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: Color(0xffCFD3D4)),
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                 ),
//                                                 child: TextField(
//                                                   controller: namecontroller,
//                                                   decoration: InputDecoration(
//                                                       border: InputBorder.none),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             ElevatedButton(
//                                               onPressed: display,
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     Color(0xffE69800),
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                               ),
//                                               child: Text(
//                                                 "แสดงผล",
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 20), // SizedBox
//                                     Container(
//                                       width: 490,
//                                       height: 400,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: Colors.white,
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(25.0),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons.light_mode_rounded,
//                                                   color: Color(0xffFFEE58),
//                                                 ),
//                                                 SizedBox(width: 10),
//                                                 Text(
//                                                   "แสดงผล",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 40,
//                                             ),
//                                             Container(
//                                               width: 390,
//                                               height: 100,
//                                               decoration: ShapeDecoration(
//                                                 color: Color(0xFFE7E7E7),
//                                                 shape: RoundedRectangleBorder(
//                                                   side: BorderSide(
//                                                       width: 5,
//                                                       color: Color(0xFF42BD41)),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                               ),
//                                               child: Column(
//                                                 children: [
//                                                   Expanded(
//                                                     child: _displayedWidget ??
//                                                         Container(),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     // Container
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 70),
//                                   child: buildList(),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 70),
//                                   child: ExpansionPanelList.radio(
//                                     expansionCallback:
//                                         (int index, bool isExpanded) {
//                                       if (_deletedPanels.contains(index)) {
//                                         return;
//                                       }
//                                       setState(() {
//                                         if (isExpanded) {
//                                           _currentExpandedIndex = index;
//                                         }
//                                       });
//                                     },
//                                     children: _panelData
//                                         .map<ExpansionPanelRadio>(
//                                             (ExpansionPanelData
//                                                 expansionPanelData) {
//                                       final int index = _panelData
//                                           .indexOf(expansionPanelData);
//                                       _showPreview.add(false);
//                                       contentNameupdate
//                                           .add(TextEditingController());
//                                       contentDetailupdate
//                                           .add(TextEditingController());

//                                       return ExpansionPanelRadio(
//                                         backgroundColor: Colors.white,
//                                         value: index,
//                                         canTapOnHeader: true,
//                                         headerBuilder: (BuildContext context,
//                                             bool isExpanded) {
//                                           final int index = _panelData
//                                               .indexOf(expansionPanelData);
//                                           print(index);

//                                           return ListTile(
//                                             tileColor: Colors.white,
//                                             leading: IconButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   setState(() {
//                                                     _deletedPanels.add(index);
//                                                     _panelData.removeAt(index);
//                                                   });
//                                                 });
//                                                 // final deleteDialogContent =
//                                                 //     (String id) => DeletedialogContent(
//                                                 //           id: id,
//                                                 //         );

//                                                 // for (var knowledge in knowledgelist) {
//                                                 // showDialog(
//                                                 //   context: context,
//                                                 //   builder: (context) =>
//                                                 //       deleteDialogContent(
//                                                 //           knowledge.contents),
//                                                 // );
//                                                 // }
//                                               },
//                                               icon: Icon(
//                                                 Icons.cancel,
//                                                 color: Color(0xFFFF543E),
//                                               ),
//                                             ),
//                                             title: Text(
//                                               'เนื้อหาย่อยที่ ${contentList.length + index + 1}',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 18,
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         body: Container(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     bottom: 0),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Container(
//                                                     width: 490,
//                                                     height: 750,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       color: Colors.white,
//                                                     ),
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               25.0),
//                                                       child: Column(
//                                                         children: [
//                                                           SizedBox(height: 20),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topLeft,
//                                                               child: Row(
//                                                                 children: [
//                                                                   Text(
//                                                                     "ชื่อ",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                   Text(
//                                                                     "*",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Container(
//                                                               padding: EdgeInsets
//                                                                   .only(
//                                                                       left:
//                                                                           10.0),
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 border: Border.all(
//                                                                     color: Color(
//                                                                         0xffCFD3D4)),
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5),
//                                                               ),
//                                                               child: TextField(
//                                                                 controller:
//                                                                     contentNameupdate[
//                                                                         index],
//                                                                 decoration:
//                                                                     InputDecoration(
//                                                                         border:
//                                                                             InputBorder.none),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 30),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topLeft,
//                                                               child: Row(
//                                                                 children: [
//                                                                   Text(
//                                                                     "เนื้อหา",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                   Text(
//                                                                     "*",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0.0,
//                                                                     right: 0),
//                                                             child: Container(
//                                                               decoration: BoxDecoration(
//                                                                   border: Border.all(
//                                                                       color: Color(
//                                                                           0xffCFD3D4)),
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               5)),
//                                                               child: TextField(
//                                                                 controller:
//                                                                     contentDetailupdate[
//                                                                         index],
//                                                                 keyboardType:
//                                                                     TextInputType
//                                                                         .multiline,
//                                                                 maxLines: 5,
//                                                                 decoration: InputDecoration(
//                                                                     focusedBorder: OutlineInputBorder(
//                                                                         borderSide: BorderSide(
//                                                                             width:
//                                                                                 1,
//                                                                             color:
//                                                                                 Colors.white))),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 30),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .only(
//                                                                     left: 0,
//                                                                     right: 0),
//                                                             child: Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topLeft,
//                                                               child: Row(
//                                                                 children: [
//                                                                   Text(
//                                                                     "รูปภาพ",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                   Text(
//                                                                     "*",
//                                                                     style:
//                                                                         TextStyle(
//                                                                       color: Colors
//                                                                           .red,
//                                                                       fontSize:
//                                                                           18,
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           // Container(
//                                                           //   decoration: BoxDecoration(
//                                                           //       borderRadius:
//                                                           //           BorderRadius
//                                                           //               .circular(
//                                                           //                   12.0),
//                                                           //       color: Colors
//                                                           //           .white70,
//                                                           //       boxShadow: [
//                                                           //         BoxShadow(
//                                                           //           color: Colors
//                                                           //               .grey
//                                                           //               .shade200,
//                                                           //           offset:
//                                                           //               const Offset(
//                                                           //                   0.0,
//                                                           //                   0.5),
//                                                           //           blurRadius:
//                                                           //               30.0,
//                                                           //         )
//                                                           //       ]),
//                                                           //   width:
//                                                           //       MediaQuery.of(
//                                                           //               context)
//                                                           //           .size
//                                                           //           .width,
//                                                           //   height: 200.0,
//                                                           //   child: Center(
//                                                           //     child: expansionPanelData
//                                                           //             .itemPhotosWidgetList
//                                                           //             .isEmpty
//                                                           //         ? Center(
//                                                           //             child:
//                                                           //                 MaterialButton(
//                                                           //               onPressed:
//                                                           //                   () =>
//                                                           //                       pickPhotoFromGallers(index),
//                                                           //               child:
//                                                           //                   Container(
//                                                           //                 width: MediaQuery.of(context)
//                                                           //                     .size
//                                                           //                     .width,
//                                                           //                 height:
//                                                           //                     200.0,
//                                                           //                 child:
//                                                           //                     AspectRatio(
//                                                           //                   aspectRatio:
//                                                           //                       1.0, // กำหนดสัดส่วนเป็น 1:1 เพื่อให้รูปภาพเต็มพื้นที่ของ Container
//                                                           //                   child: expansionPanelImagesList.length > index && expansionPanelImagesList[index].isNotEmpty
//                                                           //                       ? kIsWeb
//                                                           //                           ? Image.network(
//                                                           //                               expansionPanelImagesList[index].first.path,
//                                                           //                               fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
//                                                           //                             )
//                                                           //                           : Image.file(
//                                                           //                               File(expansionPanelImagesList[index].first.path),
//                                                           //                               fit: BoxFit.cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
//                                                           //                             )
//                                                           //                       : Image.network(
//                                                           //                           "https://static.thenounproject.com/png/3322766-200.png",
//                                                           //                           width: MediaQuery.of(context).size.width * 0.01,
//                                                           //                           height: 200.0,
//                                                           //                         ),
//                                                           //                 ),
//                                                           //               ),
//                                                           //             ),
//                                                           //           )
//                                                           //         : SingleChildScrollView(
//                                                           //             scrollDirection:
//                                                           //                 Axis.vertical,
//                                                           //             child:
//                                                           //                 Wrap(
//                                                           //               spacing:
//                                                           //                   5.0,
//                                                           //               direction:
//                                                           //                   Axis.horizontal,
//                                                           //               alignment:
//                                                           //                   WrapAlignment.spaceEvenly,
//                                                           //               runSpacing:
//                                                           //                   10.0,
//                                                           //               children: (expansionPanelImagesList.length > index &&
//                                                           //                       expansionPanelImagesList[index].isNotEmpty)
//                                                           //                   ? expansionPanelImagesList[index]
//                                                           //                       .map<Widget>(
//                                                           //                         (XFile xFile) => Padding(
//                                                           //                           padding: const EdgeInsets.all(0),
//                                                           //                           child: Container(
//                                                           //                             height: 200.0,
//                                                           //                             child: AspectRatio(
//                                                           //                               aspectRatio: 16 / 9,
//                                                           //                               child: kIsWeb ? Image.network(xFile.path) : Image.file(File(xFile.path)),
//                                                           //                             ),
//                                                           //                           ),
//                                                           //                         ),
//                                                           //                       )
//                                                           //                       .toList()
//                                                           //                   : itemPhotosWidgetList,
//                                                           //             ),
//                                                           //           ),
//                                                           //   ),
//                                                           // ),

//                                                           Container(
//                                                             decoration: BoxDecoration(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             12.0),
//                                                                 color: Colors
//                                                                     .white70,
//                                                                 boxShadow: [
//                                                                   BoxShadow(
//                                                                     color: Colors
//                                                                         .grey
//                                                                         .shade200,
//                                                                     offset:
//                                                                         const Offset(
//                                                                             0.0,
//                                                                             0.5),
//                                                                     blurRadius:
//                                                                         30.0,
//                                                                   )
//                                                                 ]),
//                                                             width:
//                                                                 MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width,
//                                                             height: 200.0,
//                                                             child: Center(
//                                                               child: newImageFiles
//                                                                       .isEmpty
//                                                                   ? Center(
//                                                                       child:
//                                                                           MaterialButton(
//                                                                         onPressed:
//                                                                             () {
//                                                                           if (index >= 0 &&
//                                                                               index < _panelData.length) {
//                                                                             pickPhotoFromGallery(
//                                                                               index,
//                                                                               _panelData[index],
//                                                                             );
//                                                                           }
//                                                                         },
//                                                                         child:
//                                                                             Container(
//                                                                           alignment:
//                                                                               Alignment.bottomCenter,
//                                                                           child:
//                                                                               Center(
//                                                                             child:
//                                                                                 Image.network(
//                                                                               "https://static.thenounproject.com/png/3322766-200.png",
//                                                                               height: 100.0,
//                                                                               width: 100.0,
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     )
//                                                                   : SingleChildScrollView(
//                                                                       scrollDirection:
//                                                                           Axis.vertical,
//                                                                       child:
//                                                                           Wrap(
//                                                                         spacing:
//                                                                             5.0,
//                                                                         direction:
//                                                                             Axis.horizontal,
//                                                                         children:
//                                                                             expansionPanelData.itemPhotosWidgetList,
//                                                                         alignment:
//                                                                             WrapAlignment.spaceEvenly,
//                                                                         runSpacing:
//                                                                             10.0,
//                                                                       ),
//                                                                     ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                           ElevatedButton(
//                                                             // onPressed: () =>
//                                                             //     pickPhotoFromGallers(
//                                                             //         index),
//                                                             onPressed: () {
//                                                               if (index >= 0 &&
//                                                                   index <
//                                                                       _panelData
//                                                                           .length) {
//                                                                 pickPhotoFromGallery(
//                                                                   index,
//                                                                   _panelData[
//                                                                       index],
//                                                                 );
//                                                                 print(
//                                                                     "_panelData ${_panelData.length}");
//                                                                 print(index);
//                                                               } else {
//                                                                 print(
//                                                                     "_panelData ${_panelData.length}");
//                                                                 print(index);
//                                                                 print(
//                                                                     "ไม่สามารถเรียกใช้งานฟังก์ชันได้: index ไม่ถูกต้อง");
//                                                               }
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               backgroundColor:
//                                                                   G2PrimaryColor,
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                               ),
//                                                             ),
//                                                             child: Text(
//                                                               "เพิ่มรูปภาพ",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 30),
//                                                           ElevatedButton(
//                                                             onPressed: () {
//                                                               displaycontent(
//                                                                   expansionPanelData,
//                                                                   index);
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               backgroundColor:
//                                                                   Color(
//                                                                       0xffE69800),
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                               ),
//                                                             ),
//                                                             child: Text(
//                                                               "แสดงผล",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Container(
//                                                     width: 490,
//                                                     height: 700,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       color: Colors.white,
//                                                     ),
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               25.0),
//                                                       child: Column(
//                                                         children: [
//                                                           SizedBox(
//                                                             height: 20,
//                                                           ),
//                                                           Container(
//                                                             width: 390,
//                                                             height: 600,
//                                                             decoration:
//                                                                 ShapeDecoration(
//                                                               color: Color(
//                                                                   0xFFE7E7E7),
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 side: BorderSide(
//                                                                     width: 5,
//                                                                     color: Color(
//                                                                         0xFF42BD41)),
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             10),
//                                                               ),
//                                                             ),
//                                                             child: Column(
//                                                               children: [
//                                                                 Expanded(
//                                                                   child: _previewWidget(
//                                                                       expansionPanelData,
//                                                                       index),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 20,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 75),
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         final nameController =
//                                             TextEditingController();
//                                         final detailController =
//                                             TextEditingController();
//                                         List<Widget> itemPhotosWidgetList =
//                                             []; // สร้างรายการว่างสำหรับรูปภาพ

//                                         _panelData.add(ExpansionPanelData(
//                                           nameController: nameController,
//                                           detailController: detailController,
//                                           itemPhotosWidgetList:
//                                               itemPhotosWidgetList, // ให้รายการรูปภาพใน ExpansionPanelData เป็นรายการว่าง
//                                         ));
//                                       });
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: WhiteColor,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(0),
//                                       ),
//                                       elevation: 3,
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 10),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Icon(Icons.add_box_rounded,
//                                               color: Color(0xFF42BD41)),
//                                           SizedBox(width: 8),
//                                           Text(
//                                             "เพิ่มเนื้อหาย่อย",
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 18,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   // padding: const EdgeInsets.all(25.0),
//                                   padding: const EdgeInsets.only(
//                                       right: 70.0, top: 50.0, bottom: 50),
//                                   child: Container(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             clearAllFields();
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Color(0xC5C5C5),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "ยกเลิก",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20.0,
//                                         ),
//                                         ElevatedButton(
//                                           onPressed: () async {
//                                             uploadImageAndSaveItemInfo();
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20.0,
//                                                 vertical: 15.0),
//                                             backgroundColor: YellowColor,
//                                           ),
//                                           child: uploading
//                                               ? SizedBox(
//                                                   child:
//                                                       CircularProgressIndicator(),
//                                                   height: 15.0,
//                                                 )
//                                               : const Text(
//                                                   "แก้ไข",
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _displayedWidget = Container();

//   Widget _displaycoverWidget() {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Container(
//         width: 350,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: WhiteColor,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Icon(
//                   icons[_selectedValue] ??
//                       Icons.error, // ระบุไอคอนตามค่าที่เลือก
//                   size: 24, // ขนาดของไอคอน
//                   color: GPrimaryColor, // สีของไอคอน
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: Text(
//                     namecontroller.text,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 9),
//                   child: Icon(
//                     Icons
//                         .keyboard_arrow_right_rounded, // ระบุไอคอนตามค่าที่เลือก
//                     size: 24, // ขนาดของไอคอน
//                     color: GPrimaryColor, // สีของไอคอน
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _displayedcontentWidget = Container();

//   Widget _displaycontentWidget(
//       ExpansionPanelData expansionPanelData, int index) {
//     return Scaffold(
//       appBar: Appbarmain_no_botton(
//         name: contentNameupdate.isNotEmpty ? contentNameupdate[0].text : '',
//       ),
//       body: Stack(
//         children: [
//           ListView.builder(
//             itemCount: itemPhotosWidgetList.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                 width: 390, // กำหนดความกว้างของรูปภาพ
//                 height: 253, // กำหนดความสูงของรูปภาพ
//                 child: itemPhotosWidgetList[index], // ใส่รูปภาพลงใน Container
//               );
//             },
//           ),
//           Positioned(
//             bottom: 0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
//             left: 0.0,
//             right: 0.0,
//             child: Container(
//               height: 400,
//               padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//               decoration: BoxDecoration(
//                   color: WhiteColor,
//                   borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(40))),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         icons[_selectedValue] ??
//                             Icons.error, // ระบุไอคอนตามค่าที่เลือก
//                         size: 24, // ขนาดของไอคอน
//                         color: GPrimaryColor, // สีของไอคอน
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       for (int index = 0;
//                           index < contentNameupdate.length;
//                           index++)
//                         Text(
//                           contentNameupdate[index].text,
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18),
//                         )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       for (int index = 0;
//                           index < contentDetailupdate.length;
//                           index++)
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             contentDetailupdate[index].text,
//                             style: TextStyle(color: Colors.black, fontSize: 15),
//                             textAlign: TextAlign.left,
//                             maxLines: null,
//                           ),
//                         ),
//                     ],
//                   )
//                 ],
//               ),
//               width: MediaQuery.of(context).size.width,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void display() {
//     // อัปเดตการแสดงผลโดยการ rebuild ด้วย setState()
//     setState(() {
//       // เรียกใช้งาน Widget ที่จะแสดงผล
//       _displayedWidget = _displaycoverWidget();
//     });
//   }

//   Widget _previewWidget(ExpansionPanelData expansionPanelData, int index) {
//     return _showPreview[index]
//         ? Container(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: _displayedcontentWidget,
//                 )
//               ],
//             ),
//           )
//         : Container(); // แสดงเป็น Container เปล่าถ้า _showPreview[index] เป็น false
//   }

//   void displaycontent(ExpansionPanelData expansionPanelData, int index) {
//     setState(() {
//       _displayedcontentWidget =
//           _displaycontentWidget(expansionPanelData, index);
//       _showPreview[index] =
//           true; // อัปเดตค่า _showPreview ของ index นั้นเป็น true
//     });
//   }

//   int _selectedIndex = 0;

//   Widget buildList() {
//     return ExpansionPanelList.radio(
//       expansionCallback: (
//         int index,
//         bool isExpanded,
//       ) {
//         setState(() {
//           _selectedIndex = isExpanded ? -1 : index;
//         });
//       },
//       children: List.generate(
//         contentList.length,
//         (index) => ExpansionPanelRadio(
//           backgroundColor: Colors.white,
//           value: index,
//           headerBuilder: (
//             BuildContext context,
//             bool isExpanded,
//           ) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 40),
//               child: ListTile(
//                 title: Text(
//                   'เนื้อหาย่อยที่ ${index + 1}',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                   ),
//                 ),
//                 leading: IconButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return Dialog(
//                           child: Container(
//                             width: 500,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 32, horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.info_outline,
//                                   size: 100,
//                                   color: Colors.red,
//                                 ),
//                                 const SizedBox(height: 20),
//                                 Text(
//                                   'ต้องการลบข้อมูลเนื้อหาย่อยที่ ${index + 1}',
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 24,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     OutlinedButton(
//                                       style: OutlinedButton.styleFrom(
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 20,
//                                           horizontal: 32,
//                                         ),
//                                         foregroundColor: Colors.red,
//                                         side: BorderSide(color: Colors.red),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text("ยกเลิก"),
//                                     ),
//                                     SizedBox(width: 20),
//                                     ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: G2PrimaryColor,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 20,
//                                           horizontal: 32,
//                                         ),
//                                         foregroundColor: Colors.white,
//                                       ),
//                                       onPressed: () {
//                                         deleteContentById(
//                                             widget.knowledge!.contents[index]);

//                                         Navigator.pop(context);
//                                       },
//                                       child: const Text("ยืนยัน"),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   icon: Icon(
//                     Icons.cancel,
//                     color: Color(0xFFFF543E),
//                   ),
//                 ),
//               ),
//             );
//           },
//           body: buildListItemBody(index),
//           canTapOnHeader: true,
//         ),
//       ),
//     );
//   }

  // Widget buildListItemBody(int index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 0),
//                             ),
//                             Row(
//                               children: [
//                                 Container(
//                                   width: 490,
//                                   height: 750,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(25.0),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(height: 20),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "ชื่อ",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Container(
//                                             padding:
//                                                 EdgeInsets.only(left: 10.0),
//                                             decoration: BoxDecoration(
//                                               border: Border.all(
//                                                   color: Color(0xffCFD3D4)),
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             child: TextField(
//                                               controller:
//                                                   contentNameControllers[index],
//                                               // controller: TextEditingController(
//                                               //     text: contentList[index]
//                                               //         .ContentName),

//                                               decoration: InputDecoration(
//                                                   border: InputBorder.none),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "เนื้อหา",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0.0, right: 0),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                     color: Color(0xffCFD3D4)),
//                                                 borderRadius:
//                                                     BorderRadius.circular(5)),
//                                             child: TextField(
//                                               controller:
//                                                   contentDetailControllers[
//                                                       index],

//                                               // controller: TextEditingController(
//                                               //     text: contentList[index]
//                                               //         .ContentDetail),
//                                               keyboardType:
//                                                   TextInputType.multiline,
//                                               maxLines: 5,
//                                               decoration: InputDecoration(
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                           borderSide:
//                                                               BorderSide(
//                                                                   width: 1,
//                                                                   color: Colors
//                                                                       .white))),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 0, right: 0),
//                                           child: Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Row(
//                                               children: [
//                                                 Text(
//                                                   "รูปภาพ",
//                                                   style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "*",
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 18,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         // Container(
//                                         //   decoration: BoxDecoration(
//                                         //       borderRadius:
//                                         //           BorderRadius.circular(12.0),
//                                         //       color: Colors.white70,
//                                         //       boxShadow: [
//                                         //         BoxShadow(
//                                         //           color: Colors.grey.shade200,
//                                         //           offset:
//                                         //               const Offset(0.0, 0.5),
//                                         //           blurRadius: 30.0,
//                                         //         )
//                                         //       ]),
//                                         //   width:
//                                         //       MediaQuery.of(context).size.width,
//                                         //   height: 200.0,
//                                         //   child: Center(
//                                         //     child:
//                                         //         expansionPanelImagesList.isEmpty
//                                         //             ? Center(
//                                         //                 child: MaterialButton(
//                                         //                   onPressed: () =>
//                                         //                       pickPhotoFromGallers(
//                                         //                           index),
//                                         //                   child: Container(
//                                         //                     width:
//                                         //                         MediaQuery.of(
//                                         //                                 context)
//                                         //                             .size
//                                         //                             .width,
//                                         //                     height: 200.0,
//                                         //                     child: AspectRatio(
//                                         //                       aspectRatio:
//                                         //                           1.0, // กำหนดสัดส่วนเป็น 1:1 เพื่อให้รูปภาพเต็มพื้นที่ของ Container
//                                         //                       child: expansionPanelImagesList
//                                         //                                       .length >
//                                         //                                   index &&
//                                         //                               expansionPanelImagesList[
//                                         //                                       index]
//                                         //                                   .isNotEmpty
//                                         //                           ? kIsWeb
//                                         //                               ? Image
//                                         //                                   .network(
//                                         //                                   expansionPanelImagesList[index]
//                                         //                                       .first
//                                         //                                       .path,
//                                         //                                   fit: BoxFit
//                                         //                                       .cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
//                                         //                                 )
//                                         //                               : Image
//                                         //                                   .file(
//                                         //                                   File(expansionPanelImagesList[index]
//                                         //                                       .first
//                                         //                                       .path),
//                                         //                                   fit: BoxFit
//                                         //                                       .cover, // ปรับขนาดรูปภาพให้เต็มพื้นที่ของ AspectRatio
//                                         //                                 )
//                                         //                           : Image
//                                         //                               .network(
//                                         //                               contentList[
//                                         //                                       index]
//                                         //                                   .ImageURL,
//                                         //                               width: MediaQuery.of(context)
//                                         //                                       .size
//                                         //                                       .width *
//                                         //                                   0.01,
//                                         //                               height:
//                                         //                                   200.0,
//                                         //                             ),
//                                         //                     ),
//                                         //                   ),
//                                         //                 ),
//                                         //               )
//                                         //             : SingleChildScrollView(
//                                         //                 scrollDirection:
//                                         //                     Axis.vertical,
//                                         //                 child: Wrap(
//                                         //                   spacing: 5.0,
//                                         //                   direction:
//                                         //                       Axis.horizontal,
//                                         //                   alignment:
//                                         //                       WrapAlignment
//                                         //                           .spaceEvenly,
//                                         //                   runSpacing: 10.0,
//                                         //                   children: (expansionPanelImagesList
//                                         //                                   .length >
//                                         //                               index &&
//                                         //                           expansionPanelImagesList[
//                                         //                                   index]
//                                         //                               .isNotEmpty)
//                                         //                       ? expansionPanelImagesList[
//                                         //                               index]
//                                         //                           .map<Widget>(
//                                         //                             (XFile xFile) =>
//                                         //                                 Padding(
//                                         //                               padding:
//                                         //                                   const EdgeInsets
//                                         //                                       .all(
//                                         //                                       0),
//                                         //                               child:
//                                         //                                   Container(
//                                         //                                 height:
//                                         //                                     200.0,
//                                         //                                 child:
//                                         //                                     AspectRatio(
//                                         //                                   aspectRatio:
//                                         //                                       16 / 9,
//                                         //                                   child: kIsWeb
//                                         //                                       ? Image.network(xFile.path)
//                                         //                                       : Image.file(File(xFile.path)),
//                                         //                                 ),
//                                         //                               ),
//                                         //                             ),
//                                         //                           )
//                                         //                           .toList()
//                                         //                       : itemPhotosWidgetList,
//                                         //                 ),
//                                         //               ),
//                                         //   ),
//                                         // ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(12.0),
//                                               color: Colors.white70,
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.grey.shade200,
//                                                   offset:
//                                                       const Offset(0.0, 0.5),
//                                                   blurRadius: 30.0,
//                                                 )
//                                               ]),
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           height: 200.0,
//                                           child: Center(
//                                             child: updatedImageFiles
//                                                         .isNotEmpty &&
//                                                     updatedImageFiles.length >
//                                                         index &&
//                                                     updatedImageFiles[index]
//                                                         .isNotEmpty
//                                                 ? SingleChildScrollView(
//                                                     scrollDirection:
//                                                         Axis.horizontal,
//                                                     child: Row(
//                                                       children:
//                                                           updatedImageFiles[
//                                                                   index]
//                                                               .map(
//                                                                 (xFile) =>
//                                                                     Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                           .all(
//                                                                           8.0),
//                                                                   child: Image
//                                                                       .network(
//                                                                     (xFile
//                                                                         .path),
//                                                                     fit: BoxFit
//                                                                         .cover,
//                                                                     height: 200,
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                               .toList(),
//                                                     ),
//                                                   )
//                                                 : Center(
//                                                     child: MaterialButton(
//                                                       onPressed: () =>
//                                                           pickPhotoFromGallers(
//                                                               index),
//                                                       child: Container(
//                                                         alignment: Alignment
//                                                             .bottomCenter,
//                                                         child: Center(
//                                                           child: contentList
//                                                                       .isNotEmpty &&
//                                                                   contentList
//                                                                           .length >
//                                                                       index
//                                                               ? Image.network(
//                                                                   contentList[
//                                                                           index]
//                                                                       .ImageURL,
//                                                                   fit: BoxFit
//                                                                       .cover,
//                                                                   height: 200,
//                                                                 )
//                                                               : SizedBox(),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         ElevatedButton(
//                                           onPressed: () =>
//                                               pickPhotoFromGallers(index),
//                                           // onPressed: () {
//                                           //   if (index >= 0 &&
//                                           //       index < _panelData.length) {
//                                           //     pickPhotoFromGallery(
//                                           //       index,
//                                           //       _panelData[index],
//                                           //     );
//                                           //     print("index: $index");
//                                           //     print(
//                                           //         "_panelData: ${_panelData[index]}");
//                                           //   } else {
//                                           //     print("index: $index");
//                                           //     print(
//                                           //         "_panelData: ${_panelData.length}");
//                                           //     print(
//                                           //         "ไม่สามารถเรียกใช้งานฟังก์ชันได้: index ไม่ถูกต้อง");
//                                           //   }
//                                           // },

//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.yellow,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "แก้ไขรูปภาพ",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                         SizedBox(height: 30),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             // displaycontent(
//                                             //     expansionPanelData, index);
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Color(0xffE69800),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           child: Text(
//                                             "แสดงผล",
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: 490,
//                                   height: 700,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white,
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(25.0),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(
//                                           height: 20,
//                                         ),
//                                         Container(
//                                           width: 390,
//                                           height: 600,
//                                           decoration: ShapeDecoration(
//                                             color: Color(0xFFE7E7E7),
//                                             shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                   width: 5,
//                                                   color: Color(0xFF42BD41)),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           // child: Column(
//                                           //   children: [
//                                           //     Expanded(
//                                           //       child: _displayedContentWidgets[
//                                           //               index] ??
//                                           //           Container(),
//                                           //     )
//                                           //   ],
//                                           // ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
