import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/Singlecontent.dart';
import 'package:watalygold_admin/Page/Knowlege/Knowledgecolumn.dart';
import 'package:watalygold_admin/Page/Knowlege/PageKnowledge.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_top.dart';
import 'package:watalygold_admin/service/database.dart';
import 'package:watalygold_admin/service/knowledge.dart';

class HomeKnowlege extends StatefulWidget {
  const HomeKnowlege({super.key});

  @override
  State<HomeKnowlege> createState() => _Home_KnowlegeState();
}

Map<String, IconData> icons = {
  'บ้าน': Icons.home,
  'ดอกไม้': Icons.yard,
  'บุคคล': Icons.person,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded
};

class _Home_KnowlegeState extends State<HomeKnowlege> {
  List<Knowledge> knowledgelist = [];

  Future<List<Knowledge>> getKnowledge() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection("Knowledge").get();
    return querySnapshot.docs.map((doc) => Knowledge.fromFirestore(doc)).toList();
  }

  @override
  void initState() {
    super.initState();
    getKnowledge().then((value) {
      setState(() {
        knowledgelist = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F6F5),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Column(
              children: [
                for (var knowledge in knowledgelist)
                  KnowlegdeCol(
                    onTap: () {
                      if (knowledge.contents.isEmpty) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KnowledgePage(
                            knowledge: knowledge,
                            icons: knowledge.knowledgeIcons,
                          ),
                        ),
                      );
                    },
                    title: knowledge.knowledgeName,
                    icons: knowledge.knowledgeIcons,
                    ismutible: knowledge.contents.isEmpty ? false : true,
                    contents: knowledge.contents,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
