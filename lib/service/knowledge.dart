import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Map<String, IconData> iconMap = {
  'ใบไม้': FontAwesomeIcons.leaf,
  'ต้นกล้า': FontAwesomeIcons.seedling,
  'ไวรัส': FontAwesomeIcons.virus,
  'สถิติ': Icons.analytics_outlined,
  'ดอกไม้': Icons.yard,
  'หนังสือ': FontAwesomeIcons.book,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded,
  'คำถาม': Icons.quiz_outlined,
  'รูปภาพ': FontAwesomeIcons.image,
  'ระฆัง': FontAwesomeIcons.bell,
  'ความคิดเห็น': FontAwesomeIcons.comments,
  'ตำแหน่ง': FontAwesomeIcons.locationDot,
  'กล้อง': FontAwesomeIcons.camera,
  'ปฏิทิน': FontAwesomeIcons.calendarDays,
};

Future<Knowledge?> getKnowledgeById(String id) async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final docSnapshot = await firestore.collection('Knowledge').doc(id).get();

    if (docSnapshot.exists) {
      return Knowledge.fromFirestore(docSnapshot);
    } else {
      return null; // ถ้าไม่มีข้อมูลตาม id นั้น
    }
  } catch (error) {
    debugPrint("Error getting knowledge by ID: $error");
    return null; // หรือจัดการ error อย่างอื่นได้ตามต้องการ
  }
}

class Knowledge {
  final String id;
  final String knowledgeName;
  final List<dynamic> contents;
  final String knowledgeDetail;
  final IconData knowledgeIcons;
  final List<String> knowledgeImg;
  final String knowledgeIconString;
  final Timestamp? create_at;

  Knowledge({
    required this.id,
    required this.knowledgeName,
    required this.contents,
    required this.knowledgeDetail,
    required this.knowledgeIcons,
    required this.knowledgeImg,
    required this.knowledgeIconString,
    required this.create_at,
  });

  factory Knowledge.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    var rawKnowledgeImg = data['KnowledgeImg'];
    List<String> knowledgeImgList = [];

    if (rawKnowledgeImg is List) {
      knowledgeImgList = List<String>.from(rawKnowledgeImg);
    } else if (rawKnowledgeImg is String) {
      knowledgeImgList = [rawKnowledgeImg];
    }

    return Knowledge(
      id: doc.id,
      knowledgeName: data['KnowledgeName'] ?? '',
      contents: (data['Content'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      knowledgeDetail: data['KnowledgeDetail'] ?? '',
      knowledgeIcons: iconMap[data['KnowledgeIcons']] ?? Icons.question_mark,
      knowledgeIconString: data['KnowledgeIcons'] ?? '',
      knowledgeImg: knowledgeImgList,
      create_at:
          data['create_at'] as Timestamp? ?? Timestamp.fromDate(DateTime.now()),
    );
  }
}
