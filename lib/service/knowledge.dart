import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


Map<String, IconData> iconMap = {
  'บ้าน': Icons.home,
  'ดอกไม้': Icons.yard,
  'บุคคล': Icons.person,
  'น้ำ': Icons.water_drop_outlined,
  'ระวัง': Icons.warning_rounded
};

class Knowledge {
  final String id;
  final String knowledgeName;
  final List<dynamic> contents; // เพิ่มฟิลด์นี้เพื่อเก็บ ID ของเนื้อหา
  final String knowledgeDetail;
  final IconData knowledgeIcons;
  final String knowledgeImg;

  Knowledge({
    required this.id,
    required this.knowledgeName,
    required this.contents,
    required this.knowledgeDetail,
    required this.knowledgeIcons,
    required this.knowledgeImg,
  });

  factory Knowledge.fromFirestore(DocumentSnapshot doc) {
    return Knowledge(
      id: doc.id,
      knowledgeName: doc['KnowledgeName'],
      contents: doc['Content'].map((e) => e).cast<dynamic>().toList(),
      knowledgeDetail: doc['KnowledgeDetail'],
      knowledgeIcons: iconMap[doc['KnowledgeIcons']] ?? Icons.question_mark,
      knowledgeImg: doc['KnowledgeImg'],
    );
  }
}