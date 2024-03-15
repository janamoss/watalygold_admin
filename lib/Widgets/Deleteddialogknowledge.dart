import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class Deleteddialogknowledge extends StatelessWidget {
  const Deleteddialogknowledge({Key? key, required this.knowledgeName});

  Future<void> deleteKnowledge() async {
    try {
      // อัปเดตเอกสารแทนการลบ
      await FirebaseFirestore.instance
          .collection("Knowledge")
          .doc(this.knowledgeName)
          .update({"deleted_at": Timestamp.now()});
    } catch (e) {
      // จัดการข้อผิดพลาดที่เกิดขึ้น
      print("เกิดข้อผิดพลาดในการ Soft Delete เอกสาร: $e");
      throw e; // ส่งข้อผิดพลาดต่อไปเพื่อให้การจัดการข้อผิดพลาดเฉพาะรายละเอียด
    }
  }

  final String knowledgeName;

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
            Text(
              '$knowledgeName',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'IBM Plex Sans Thai',
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
                    deleteKnowledge();
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
