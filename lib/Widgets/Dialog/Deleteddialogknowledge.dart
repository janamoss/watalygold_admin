import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watalygold_admin/Widgets/Dialog/DeleteknowledgeSuccess.dart';
import 'package:watalygold_admin/service/knowledge.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class Deleteddialogknowledge extends StatefulWidget {
  final String knowledgeName;
  final String id;
  final Function(String) onDelete;

  Deleteddialogknowledge({
    Key? key,
    required this.knowledgeName,
    required this.id,
    required this.onDelete,
  }) : super(key: key);

  @override
  _DeleteddialogknowledgeState createState() => _DeleteddialogknowledgeState();
}

class _DeleteddialogknowledgeState extends State<Deleteddialogknowledge> {
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

  Future<void> deleteKnowledge() async {
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // อ่านข้อมูลของ Knowledge ที่ต้องการลบ
        DocumentSnapshot knowledgeSnapshot = await transaction.get(
          FirebaseFirestore.instance.collection("Knowledge").doc(widget.id),
        );

        // ตรวจสอบว่ามีข้อมูลของ Knowledge หรือไม่
        if (knowledgeSnapshot.exists) {
          // ลบข้อมูลของ Knowledge
          transaction.update(
            FirebaseFirestore.instance.collection("Knowledge").doc(widget.id),
            {"deleted_at": Timestamp.now()},
          );

          // ตรวจสอบและลบข้อมูล content ที่อ้างถึงใน Knowledge
          List<String> contentIds =
              List<String>.from(knowledgeSnapshot["Content"]);
          for (String contentId in contentIds) {
            // ลบข้อมูล content
            transaction.update(
              FirebaseFirestore.instance.collection("Content").doc(contentId),
              {"deleted_at": Timestamp.now()},
            );
          }
        }
      });
      // showToast("ลบคลังความรู้เสร็จสิ้น");
      // widget.onDelete(widget.id);
      // Close the current dialog and show success dialog
      // Navigator.of(context).pop(); // Close the confirmation dialog
      // await Future.delayed(Duration(milliseconds: 300)); // Add a small delay for smooth transition
      // showDialog(
      //   context: context,
      //   builder: (context) => DeleteKnowledgeSuccessDialog(
      //     knowledgeName: widget.knowledgeName,
      //   ),
      // ).then((_) => widget.onDelete(widget.id)); // Notify about deletion completion
    } catch (e) {
      // จัดการข้อผิดพลาดที่เกิดขึ้น
      debugPrint("เกิดข้อผิดพลาดในการ Soft Delete เอกสารและเนื้อหา: $e");
      throw e; // ส่งข้อผิดพลาดต่อไปเพื่อให้การจัดการข้อผิดพลาดเฉพาะรายละเอียด
    }
  }

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
              '${widget.knowledgeName}',
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
                    backgroundColor: GPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 32,
                    ),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    // Close the current dialog
                    Navigator.of(context).pop();
                    // Execute the deletion process
                    try {
                      await deleteKnowledge();
                      showDialog(
                        context: context,
                        builder: (context) => DeleteKnowledgeSuccessDialog(
                          knowledgeName: widget.knowledgeName,
                        ),
                      ).then((_) {
                        // Notify about deletion completion if needed
                        widget.onDelete(widget.id);
                      });
                    } catch (e) {
                      debugPrint("Error deleting knowledge: $e");
                    }
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

class DeleteKnowledgeSuccessDialog extends StatelessWidget {
  final String knowledgeName;

  const DeleteKnowledgeSuccessDialog({required this.knowledgeName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close the success dialog after 2 seconds
    });

    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          // horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // กำหนดให้ความยาวของ Column ปรับตามขนาดของเนื้อหาภายใน
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add_task,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'ลบคลังความรู้สำเร็จ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'IBM Plex Sans Thai',
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
