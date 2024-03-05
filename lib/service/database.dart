import 'package:cloud_firestore/cloud_firestore.dart';

class Databasemethods{
  Future addKnowlege(Map<String, dynamic> knowledgeMap, String id)async{
   return await  FirebaseFirestore.instance.collection("Knowledge").doc(id).set(knowledgeMap);
  }
}



// class Databasemethods {
//   // Define the method to add knowledge to Firestore
//   Future<void> addKnowledge(Map<String, dynamic> knowledgeMap, String id) async {
//     await FirebaseFirestore.instance.collection("knowledge").doc(id).set(knowledgeMap);
//   }
// }
