import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Databasemethods {
  Future addKnowlege(Map<String, dynamic> knowledgeMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Knowledge")
        .doc(id)
        .set(knowledgeMap);
  }

  Future addContent(Map<String, dynamic> contentMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Content")
        .doc(id)
        .set(contentMap);
  }

  Future updateKnowledge(
      Map<String, dynamic> updateknowledge, String id) async {
    return await FirebaseFirestore.instance
        .collection("Knowledge")
        .doc(id)
        .update(updateknowledge);
  }
}
