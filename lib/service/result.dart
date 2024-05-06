import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final String id;
  final String another_note;
  final String quality;

  final double length;
  final double width;
  final double weight;

  final Timestamp? created_at;
  final String? updated_at;
  final String? deleted_at;

  const Result({
    required this.id,
    required this.another_note,
    required this.quality,
    required this.length,
    required this.width,
    required this.weight,
    this.created_at,
    this.updated_at,
    this.deleted_at,
  });

  factory Result.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  // ดึง image_result เป็น List<Map<String, dynamic>>
  List<Map<String, dynamic>> imageResultList = 
    (data['Image_result'] as List).cast<Map<String, dynamic>>();

  // ดึง user_id เป็น Map<String, dynamic>
  Map<String, dynamic> userIdMap = data['user'] as Map<String, dynamic>;

  return Result(
    id: doc.id,
    // image_result: imageResultList,
    // user_id: userIdMap,
    another_note: data['Another_note'] ?? '',
    quality: data['Quality'] ?? '',
    length: data['Length'] ?? 0.0,  // แก้ไข key ให้ตรงกับข้อมูล
    width: data['Width'] ?? 0.0,   // แก้ไข key ให้ตรงกับข้อมูล
    weight: data['Weight'] ?? 0.0,  // แก้ไข key ให้ตรงกับข้อมูล
    created_at: data['Create_at'] as Timestamp? ?? Timestamp.fromDate(DateTime.now()),
  );
}
}
