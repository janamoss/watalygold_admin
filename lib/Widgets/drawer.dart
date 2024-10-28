import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // รายการเมนู
        ListTile(
          leading: Icon(Icons.group),
          title: Text('Partner'),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Pengguna'),
        ),
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text('Presensi'),
        ),
        Divider(), // คั่นกลุ่มเมนู
        ListTile(
          leading: Icon(Icons.work),
          title: Text('Proyek'),
        ),
      ],
    );
  }
}
