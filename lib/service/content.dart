import 'package:cloud_firestore/cloud_firestore.dart';

class Contents {
  final String id;
  final String ContentName;
  final String ContentDetail;
  final String ImageURL;
  final Timestamp? create_at;
  final Timestamp? deleted_at;
  final Timestamp? update_at;

  Contents({
    required this.id,
    required this.ContentName,
    required this.ContentDetail,
    required this.ImageURL,
    required this.create_at,
    this.deleted_at,
    this.update_at,
  });

  factory Contents.fromFirestore(DocumentSnapshot doc) {
    return Contents(
      id: doc.id,
      ImageURL: doc['image_url'],
      ContentName: doc['ContentName'],
      ContentDetail: doc['ContentDetail'],
      deleted_at: doc['deleted_at'],
       create_at:
          doc['create_at'] as Timestamp? ?? Timestamp.fromDate(DateTime.now()),
    );
  }

}