import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final Map<String, IconData> iconMap = {
  'ดอกไม้': Icons.yard,
  // เพิ่มไอคอนอื่น ๆ
};

class Knowledge {
  final String id;
  final String knowledgeName;
  final List<dynamic> contents;
  final String knowledgeDetail;
  final IconData knowledgeIcons;
  final String knowledgeImg;
  final Timestamp? create_at;
  final Timestamp? deleted_at;
  final Timestamp? update_at;

  Knowledge({
    required this.id,
    required this.knowledgeName,
    required this.contents,
    required this.knowledgeDetail,
    required this.knowledgeIcons,
    required this.knowledgeImg,
    required this.create_at,
    this.deleted_at,
    this.update_at,
  });

  factory Knowledge.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Knowledge(
      id: doc.id,
      knowledgeName: data['KnowledgeName'] ?? '',
      contents: data['Content']?.map((e) => e).cast<dynamic>().toList() ?? [],
      knowledgeDetail: data['KnowledgeDetail'] ?? '',
      knowledgeIcons: iconMap[data['KnowledgeIcons']] ?? Icons.question_mark,
      knowledgeImg: data['KnowledgeImg'] ?? '',
      create_at:
          data['Create_at'] as Timestamp? ?? Timestamp.fromDate(DateTime.now()),
    );
  }
}