import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watalygold_admin/Page/Knowlege/Add/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/Edit/EditMutiple.dart';
import 'package:watalygold_admin/Page/Knowlege/Knowledgecolumn.dart';
import 'package:watalygold_admin/Page/Knowlege/PageKnowledge.dart';
import 'package:watalygold_admin/Widgets/Deleteddialogknowledge.dart';
import 'package:watalygold_admin/Widgets/ExpansionTile.dart';
import 'package:watalygold_admin/service/content.dart';
import 'package:watalygold_admin/service/knowledge.dart';

class HomeKnowledgeMain extends StatefulWidget {
  const HomeKnowledgeMain({super.key});

  @override
  State<HomeKnowledgeMain> createState() => _KnowledgeMainState();
}

Future<Contents> getContentsById(String documentId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final docRef = firestore.collection('Content').doc(documentId);
  final doc = await docRef.get();

  if (doc.exists) {
    final data = doc.data();
    return Contents(
      id: doc.id,
      ContentName: data!['ContentName'].toString(),
      ContentDetail: data['ContentDetail'].toString(),
      deleted_at: doc['deleted_at'],
        create_at: data['create_at'] as Timestamp? ??
            Timestamp.fromDate(DateTime.now()),
      ImageURL: data['image_url'].toString(),
    );
  } else {
    throw Exception('Document not found with ID: $documentId');
  }
}

class _KnowledgeMainState extends State<HomeKnowledgeMain> {
  List<Knowledge> knowledgelist = [];
  bool _isLoading = true;

  List<String> imageURLlist = [];
  Future<List<Knowledge>> getKnowledges() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('Knowledge')
          .where("deleted_at", isNull: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Knowledge.fromFirestore(doc))
          .toList();
    } catch (error) {
      print("Error getting knowledge: $error");
      return []; // Or handle the error in another way
    }
  }

  @override
  void initState() {
    super.initState();
    getKnowledges().then((value) async {
      setState(() {
        knowledgelist = value;
      });
      if (knowledgelist.length == 0) {
        setState(() {
          _isLoading = false;
        });
      }
      for (var knowledge in knowledgelist) {
        if (knowledge.knowledgeImg.isEmpty) {
          // แสดง Loading indicator
          final firstContent = knowledge.contents[0].toString();
          final contents = await getContentsById(firstContent);
          imageURLlist.add(contents.ImageURL);
          setState(() {
            _isLoading = false;
          });
          // ซ่อน Loading indicator
        } else {
          imageURLlist.add(knowledge.knowledgeImg);
        }
      }
    });
  }
  

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
                  Container(
                    width: 400,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(knowledge.knowledgeIcons),
                        Text(knowledge.knowledgeName),
                        SizedBox(
                          width: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (knowledge.contents.isNotEmpty) {
                                  // หากมีข้อมูล content ให้เปิดหน้า ExpansionTileExample
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditMutiple(
                                        knowledge: knowledge,
                                        icons: knowledge.knowledgeIcons,
                                      ),
                                    ),
                                  );
                                } else {
                                  // ถ้าไม่มีข้อมูล content ให้เปิดหน้า EditKnowlege
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditKnowlege(
                                         knowledge: knowledge,
                                        icons: knowledge.knowledgeIcons,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffE69800),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "แก้ไข",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Deleteddialogknowledge(
                                    knowledgeName: knowledge.knowledgeName,
                                    id: knowledge.id,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "ลบ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
