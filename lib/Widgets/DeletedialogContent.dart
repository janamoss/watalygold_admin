import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class DeletedialogContent extends StatelessWidget {
  const DeletedialogContent({
    Key? key,
    required this.knowledgeName,
    required this.id,
  });
  
void deleteContentById(String documentId) async {
    try {
      await Databasemethods().deleteContent(documentId);
     
    } catch (e) {
      print('Error deleting content: $e');
    }
  }
  
  // Future<void> deleteContent() async {
  //   try {
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
     
  //       DocumentSnapshot contentSnapshot = await transaction.get(
  //         FirebaseFirestore.instance.collection("Content").doc(this.id),
  //       );

  //       // ตรวจสอบว่ามีข้อมูลของ Knowledge หรือไม่
  //       if (contentSnapshot.exists) {
  //         // ลบข้อมูลของ Knowledge
  //         transaction.update(
  //           FirebaseFirestore.instance.collection("Knowledge").doc(this.id),
  //           {"deleted_at": Timestamp.now()},
  //         );

  //         // ตรวจสอบและลบข้อมูล content ที่อ้างถึงใน Knowledge
  //         List<String> contentIds =
  //             List<String>.from(contentSnapshot["Content"]);
  //         for (String contentId in contentIds) {
  //           // ลบข้อมูล content
  //           transaction.update(
  //             FirebaseFirestore.instance.collection("Content").doc(contentId),
  //             {"deleted_at": Timestamp.now()},
  //           );
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     // จัดการข้อผิดพลาดที่เกิดขึ้น
  //     print("เกิดข้อผิดพลาดในการ Soft Delete เอกสารและเนื้อหา: $e");
  //     throw e; // ส่งข้อผิดพลาดต่อไปเพื่อให้การจัดการข้อผิดพลาดเฉพาะรายละเอียด
  //   }
  // }

  final String knowledgeName;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
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
              'ต้องการลบข้อมูลคลังความรู้',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'IBM Plex Sans Thai',
              ),
            ),
            // Text(
            //   '$knowledgeName',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 24,
            //     fontFamily: 'IBM Plex Sans Thai',
            //   ),
            // ),
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
                    deleteContentById;
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
  }
}
