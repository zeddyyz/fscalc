import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {
  late String email;
  late String name;

  AuthModel({
    required this.email,
    required this.name,
  });

  AuthModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    // documentId = documentSnapshot.id;
    email = documentSnapshot["email"];
    name = documentSnapshot["name"];
  }
}
