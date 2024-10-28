import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class Addknowledgedialog extends StatelessWidget {
  const Addknowledgedialog({super.key});

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
              color: G2PrimaryColor,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'เพิ่มคลังความรู้สำเร็จ',
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