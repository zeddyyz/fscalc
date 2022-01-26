import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fscalc/paid/features/history/forex/models/forex_model.dart';
import 'package:get/get.dart';

class ForexController extends GetxController {
  static ForexController forexController = Get.find();
  CollectionReference ref =
      FirebaseFirestore.instance.collection("forexHistory");

  String email = "";

  String getUserEmail() {
    FirebaseAuth.instance.authStateChanges().listen((value) {
      if (value!.email!.isNotEmpty) {
        email = value.email!;
      }
    });
    return email;
  }

  Future getForexData(String collection, String email) async {
    QuerySnapshot snapshot = await ref.where("email", isEqualTo: email).get();
    return snapshot.docs;
  }

  // * CRUD functions
  CollectionReference forexHistory =
      FirebaseFirestore.instance.collection("forexHistory");
  late ForexModel _forexModel;

  Future<void> addTrade(
    int id,
    String email,
    String currencyPair,
    DateTime entryDate,
    DateTime exitDate,
    String bookValue,
    String marketValue,
  ) {
    return forexHistory.add({
      "id": id,
      "email": email,
      _forexModel.currencyPair: currencyPair,
      _forexModel.entryDate: Timestamp.fromDate(entryDate),
      _forexModel.exitDate: Timestamp.fromDate(exitDate),
      _forexModel.bookValue: bookValue,
      _forexModel.marketValue: marketValue,
      _forexModel.result:
          (double.parse(marketValue) - double.parse(bookValue)).toString(),
    });
  }

  Future<void> deleteTrade(int id, String email) async {
    var snapshot = await forexHistory
        .where('email', isEqualTo: email)
        .where("id", isEqualTo: id)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
