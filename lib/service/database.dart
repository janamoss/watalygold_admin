import 'package:cloud_firestore/cloud_firestore.dart';

class Databasemethods{
  Future addKnowlege(Map<String, dynamic> knowledgeMap, String id)async{
   return await  FirebaseFirestore.instance.collection("Knowledge").doc(id).set(knowledgeMap);
  }
}