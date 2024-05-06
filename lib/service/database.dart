import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Databasemethods {
  final logger = Logger();
  
  Future addKnowlege(Map<String, dynamic> knowledgeMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Knowledge")
        .doc(id)
        .set(knowledgeMap);
  }

  Future<String> addContent(Map<String, dynamic> contentMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection("Content")
          .doc(id)
          .set(contentMap);
      return id;
    } catch (e) {
      throw e;
    }
  }

  Future updateKnowledge(
      Map<String, dynamic> updateknowledge, String id) async {
    return await FirebaseFirestore.instance
        .collection("Knowledge")
        .doc(id)
        .update(updateknowledge);
  }

  Future updateContent(
      Map<String, dynamic> updatecontent, String contentId , String contentName,
      String contentDetail, String imageUrl) async {
        logger.d(" id ${contentId}");
        logger.d(" content ${updatecontent}");
        logger.d(" name ${contentName}");
        logger.d(" detail ${contentDetail}");
        logger.d(" url ${imageUrl}");
    return await FirebaseFirestore.instance
    
        .collection("Content")
        .doc(contentId)
        .update(updatecontent);
  }


  Future<void> deleteContent(String contentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final contentRef = firestore.collection('Content').doc(contentId);

    try {
      // อัปเดตฟิลด์ deleted_at เป็นเวลาปัจจุบันแทนการลบข้อมูลจริง
      await contentRef.update({'deleted_at': Timestamp.now()});
      logger.d('Content deleted successfully');
    } catch (e) {
      logger.d('Error deleting content: $e');
    }
  }
}
