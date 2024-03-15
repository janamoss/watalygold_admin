import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class Deletedialog extends StatelessWidget {
  const Deletedialog({super.key});

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
              Icons.info_outline,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'คุณต้องการลบเนื้อหาย่อยใช่หรือไม่',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'IBM Plex Sans Thai',
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                        side: const BorderSide(color: Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ยกเลิก")),
                    SizedBox(width: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: G2PrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 32,
                        ),
                  ),
                  onPressed: () {
                    
                  }, child: const Text("ยืนยัน"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
