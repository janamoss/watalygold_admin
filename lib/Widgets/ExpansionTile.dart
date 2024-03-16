// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }


//  List? itemcontent;




// class _MyWidgetState extends State<MyWidget> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//                   padding: const EdgeInsets.only(right: 70),
//                   child: ExpansionPanelList.radio(
//                     expansionCallback: (int index, bool isExpanded) {
//                       if (_deletedPanels.contains(index)) {
//                         return;
//                       }
//                       setState(() {
//                         if (isExpanded) {
//                           _currentExpandedIndex = index;
//                         }
//                       });
//                     },
//                     children: _panelData.map<ExpansionPanelRadio>(
//                         (ExpansionPanelData expansionPanelData) {
//                       final int index = _panelData.indexOf(expansionPanelData);
//                       // สร้าง TextEditingController สำหรับชื่อเนื้อหาและรายละเอียดเนื้อหา
//                       contentNameControllers.add(TextEditingController());
//                       contentDetailControllers.add(TextEditingController());

//                       return ExpansionPanelRadio(
//                         backgroundColor: Colors.white,
//                         value: index,
//                         canTapOnHeader: true,
//                         headerBuilder: (BuildContext context, bool isExpanded) {
//                           return ListTile(
//                             tileColor: Colors.white,
//                             leading: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _deletedPanels.add(index);
//                                 });
//                                 // showDialog(
//                                 //   context: context,
//                                 //   builder: (context) => const Deletedialog(),
//                                 // );
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
//                                     height: 750,
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
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     "ชื่อ",
//                                                     style: TextStyle(
//                                                       color: Colors.black,
//                                                       fontSize: 18,
//                                                       fontFamily:
//                                                           'IBM Plex Sans Thai',
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     "*",
//                                                     style: TextStyle(
//                                                       color: Colors.red,
//                                                       fontSize: 18,
//                                                       fontFamily:
//                                                           'IBM Plex Sans Thai',
//                                                     ),
//                                                   ),
//                                                 ],
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
//                                                 controller:
//                                                     contentNameControllers[
//                                                         index],
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
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     "เนื้อหา",
//                                                     style: TextStyle(
//                                                       color: Colors.black,
//                                                       fontSize: 18,
//                                                       fontFamily:
//                                                           'IBM Plex Sans Thai',
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     "*",
//                                                     style: TextStyle(
//                                                       color: Colors.red,
//                                                       fontSize: 18,
//                                                       fontFamily:
//                                                           'IBM Plex Sans Thai',
//                                                     ),
//                                                   ),
//                                                 ],
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
//                                                 controller:
//                                                     contentDetailControllers[
//                                                         index],
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
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     "รูปภาพ",
//                                                     style: TextStyle(
//                                                       color: Colors.black,
//                                                       fontSize: 18,
//                                                       fontFamily:
//                                                           'IBM Plex Sans Thai',
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     "*",
//                                                     style: TextStyle(
//                                                       color: Colors.red,
//                                                       fontSize: 18,
//                                                       fontFamily:
//                                                           'IBM Plex Sans Thai',
//                                                     ),
//                                                   ),
//                                                 ],
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
//                                               child: expansionPanelData
//                                                       .itemPhotosWidgetList
//                                                       .isEmpty
//                                                   ? Center(
//                                                       child: MaterialButton(
//                                                         onPressed: () {
//                                                           pickPhotoFromGallery(
//                                                               _panelData[
//                                                                   index]); // ส่งข้อมูลของแผงที่ต้องการไปยังฟังก์ชัน pickPhotoFromGallery
//                                                         },
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
//                                                         children: expansionPanelData
//                                                             .itemPhotosWidgetList,
//                                                         alignment: WrapAlignment
//                                                             .spaceEvenly,
//                                                         runSpacing: 10.0,
//                                                       ),
//                                                     ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           ElevatedButton(
//                                             onPressed: () {
//                                               // pickPhotoFromGallery()
//                                               //     .then((newImageUrl) {
//                                               //   if (newImageUrl != null) {
//                                               //     setState(() {
//                                               //       addImage(); // เพิ่มภาพใหม่
//                                               //     });
//                                               //   }
//                                               // });
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: G2PrimaryColor,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                             child: Text(
//                                               "เพิ่มรูปภาพ",
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                           ),
//                                           SizedBox(height: 30),
//                                           ElevatedButton(
//                                             onPressed: () {
//                                               displaycontent(); // เรียกใช้งานเมื่อคลิกปุ่ม "แสดงผล"
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
//                                             child: Column(
//                                               children: [
//                                                 Expanded(
//                                                   child:
//                                                       _displayedcontentWidget ??
//                                                           Container(),
//                                                 )
//                                               ],
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
// }