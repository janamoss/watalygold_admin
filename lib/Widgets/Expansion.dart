// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:watalygold_admin/Widgets/Deletedialog.dart';
// import 'package:watalygold_admin/Widgets/knowlege.dart';

// class Expansion extends StatefulWidget {
//   const Expansion({super.key});

//   @override
//   State<Expansion> createState() => _ExpansionState();
// }

// class _ExpansionState extends State<Expansion> {

//   Map<String, IconData> iconDataMap = {
//   'บ้าน': Icons.home,
//   'ติดตั้ง': Icons.settings,
//   'บุคคล': Icons.person,
// };

// final List<Product> _products = Product.generateItems(1);
//   int _currentExpandedIndex = -1;
//    List<Widget> itemPhotosWidgetList = <Widget>[];
//   final ImagePicker _picker = ImagePicker();
//   File? file;
//   List<XFile>? photo = <XFile>[];
//   List<XFile> itemImagesList = <XFile>[];
//   List<String> downloadUrl = <String>[];
//   bool uploading = false;
//   TextEditingController contentcontroller = new TextEditingController();
//   TextEditingController namecontroller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//                   padding: const EdgeInsets.only(
//                     right: 70,
//                   ),
//                   child: ExpansionPanelList.radio(
//                     expansionCallback: (int index, bool isExpanded) {
//                       setState(() {
//                         if (isExpanded) {
//                           _currentExpandedIndex = index;
//                         }
//                       });
//                     },
//                     children:
//                         _products.map<ExpansionPanelRadio>((Product product) {
//                       final int index = _products.indexOf(product);
//                       return ExpansionPanelRadio(
//                         backgroundColor: Colors.white,
//                         value: product.id,
//                         canTapOnHeader: true,
//                         headerBuilder: (BuildContext context, bool isExpanded) {
//                           return ListTile(
//                             tileColor: Colors.white,
//                             leading: IconButton(
//                               onPressed: () {
//                                 showDialog(context: context, 
//                                 builder: (context) => const Deletedialog()
//                                 );
//                               },
//                               icon: Icon(
//                                 Icons.cancel,
//                                 color: Color(0xFFFF543E),
//                               ),
//                             ),
//                             title: Text(
//                               'เนื้อหาย่อยที่${index + 1}',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontFamily: 'IBM Plex Sans Thai',
//                               ),
//                             ),
//                           );
//                         },
//                         body: Container(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 0),
//                               ),
//                               Row(
//                                 children: [
//                                   Container(
//                                     width: 490,
//                                     height: 700,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.white,
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(25.0),
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: 20),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 0.0, right: 0),
//                                             child: Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Text(
//                                                 "ชื่อ",
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 18,
//                                                   fontFamily:
//                                                       'IBM Plex Sans Thai',
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 0.0, right: 0),
//                                             child: Container(
//                                               padding:
//                                                   EdgeInsets.only(left: 10.0),
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                     color: Color(0xffCFD3D4)),
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                               ),
//                                               child: TextField(
//                                                 controller: namecontroller,
//                                                 decoration: InputDecoration(
//                                                     border: InputBorder.none),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 30),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 0.0, right: 0),
//                                             child: Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Text(
//                                                 "เนื้อหา",
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 18,
//                                                   fontFamily:
//                                                       'IBM Plex Sans Thai',
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 0.0, right: 0),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       color: Color(0xffCFD3D4)),
//                                                   borderRadius:
//                                                       BorderRadius.circular(5)),
//                                               child: TextField(
//                                                 controller: contentcontroller,
//                                                 keyboardType:
//                                                     TextInputType.multiline,
//                                                 maxLines: 5,
//                                                 decoration: InputDecoration(
//                                                     focusedBorder:
//                                                         OutlineInputBorder(
//                                                             borderSide: BorderSide(
//                                                                 width: 1,
//                                                                 color: Colors
//                                                                     .white))),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 30),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 0, right: 0),
//                                             child: Align(
//                                               alignment: Alignment.topLeft,
//                                               child: Text(
//                                                 "รูปภาพ",
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 18,
//                                                   fontFamily:
//                                                       'IBM Plex Sans Thai',
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12.0),
//                                                 color: Colors.white70,
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.grey.shade200,
//                                                     offset:
//                                                         const Offset(0.0, 0.5),
//                                                     blurRadius: 30.0,
//                                                   )
//                                                 ]),
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width,
//                                             height: 200.0,
//                                             child: Center(
//                                               child: itemPhotosWidgetList
//                                                       .isEmpty
//                                                   ? Center(
//                                                       child: MaterialButton(
//                                                         onPressed:
//                                                             pickPhotoFromGallery,
//                                                         child: Container(
//                                                           alignment: Alignment
//                                                               .bottomCenter,
//                                                           child: Center(
//                                                             child:
//                                                                 Image.network(
//                                                               "https://static.thenounproject.com/png/3322766-200.png",
//                                                               height: 100.0,
//                                                               width: 100.0,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : SingleChildScrollView(
//                                                       scrollDirection:
//                                                           Axis.vertical,
//                                                       child: Wrap(
//                                                         spacing: 5.0,
//                                                         direction:
//                                                             Axis.horizontal,
//                                                         children:
//                                                             itemPhotosWidgetList,
//                                                         alignment: WrapAlignment
//                                                             .spaceEvenly,
//                                                         runSpacing: 10.0,
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 30),
//                                           ElevatedButton(
//                                             onPressed: () async {
//                                               updateText();
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor:
//                                                   Color(0xffE69800),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                             child: Text(
//                                               "แสดงผล",
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 490,
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
//                                                     color: Color(0xFF42BD41)),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 yourText,
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 20,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 );
//   }
//   addImage() {
//     for (var bytes in photo!) {
//       itemPhotosWidgetList.add(Padding(
//         padding: const EdgeInsets.all(1.0),
//         child: Container(
//           height: 200.0,
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: Container(
//               child: kIsWeb
//                   ? Image.network(File(bytes.path).path)
//                   : Image.file(
//                       File(bytes.path),
//                     ),
//             ),
//           ),
//         ),
//       ));
//     }
//   }

//   pickPhotoFromGallery() async {
//     photo = await _picker.pickMultiImage();
//     if (photo != null) {
//       setState(() {
//         itemImagesList = itemImagesList + photo!;
//         addImage();
//         photo!.clear();
//       });
//     }
//   }

//   upload() async {
//     String knowledgetId = await uplaodImageAndSaveItemInfo();
//     setState(() {
//       uploading = false;
//     });
//     // showToast("Image Uploaded Successfully");
//   }



//   Future<String> uplaodImageAndSaveItemInfo() async {
//     setState(() {
//       uploading = true;
//     });
//     PickedFile? pickedFile;
//     String? knowledgetId = const Uuid().v4().substring(0, 10);
//     for (int i = 0; i < itemImagesList.length; i++) {
//       file = File(itemImagesList[i].path);
//       pickedFile = PickedFile(file!.path);

//       await uploadImageToStorage(pickedFile, knowledgetId);
//     }
//     return knowledgetId;
//   }


//   uploadImageToStorage(PickedFile? pickedFile, String knowledgetId) async {
//     String? kId = const Uuid().v4().substring(0, 10);
//     Reference reference = FirebaseStorage.instance
//         .ref()
//         .child('Knowledge/$knowledgetId/knowledImg_$kId');
//     await reference.putData(
//       await pickedFile!.readAsBytes(),
//       SettableMetadata(contentType: 'image/jpeg'),
//     );
//     String imageUrl = await reference.getDownloadURL();
//     addKnowlege(imageUrl);
//   }

//   void addKnowlege(String imageUrl) async {
//     if (selectedIconData != null &&
//         namecontroller.text.isNotEmpty &&
//         contentcontroller.text.isNotEmpty) {
//       String Id = namecontroller.text;
//       IconData selectedIconData = iconDataMap[iconName]!;
//       String iconDataString = getIconDataString(selectedIconData);

//       Map<String, dynamic> knowledgeMap = {
//         "KnowledgeName": namecontroller.text,
//         "KnowledgeDetail": contentcontroller.text,
//         "KnowledgeImg": imageUrl,
//         "KnowledgeIcons": iconDataString,
//       };
//       await Databasemethods().addKnowlege(knowledgeMap, Id).then((value) {
//         Fluttertoast.showToast(
//           msg: "เพิ่มความรู้เรียบร้อยแล้ว",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       });
//     } else {
//       Fluttertoast.showToast(
//         msg: "กรุณากรอกข้อมูลให้ครบ",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0,
//       );
//     }
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

//   String yourText = "";

//   void updateText() {
//     setState(() {
//       // เปลี่ยนค่าของ Text Widget เมื่อกดปุ่ม "แสดงผล"
//       yourText = "Your Updated Text";
//     });
//   }
// }

