import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class DeleteknowledgeSuccess extends StatelessWidget {
  //   final String knowledgeName;
  // final String id;

  // DeleteknowledgeSuccess({
  //   required this.knowledgeName,
  //   required this.id,
  // });

  @override
  Widget build(BuildContext context) {
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
         mainAxisSize: MainAxisSize.min, // กำหนดให้ความยาวของ Column ปรับตามขนาดของเนื้อหาภายใน
  // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons. add_task,
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