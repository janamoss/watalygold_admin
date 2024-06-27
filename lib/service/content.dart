import 'package:cloud_firestore/cloud_firestore.dart';

class Contents {
  final String id;
  final String ContentName;
  final String ContentDetail;
  // final String ImageURL;
   late final List<String> ImageURL;
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
    ImageURL: List<String>.from(doc.get('image_url') ?? []),
    ContentName: doc.get('ContentName'),
    ContentDetail: doc.get('ContentDetail'),
    deleted_at: doc.get('deleted_at'),
    create_at: doc.get('create_at'),
    update_at: doc.get('update_at'),
  );
}
}

