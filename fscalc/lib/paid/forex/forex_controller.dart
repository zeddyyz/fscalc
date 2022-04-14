import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fscalc/paid/forex/forex_model.dart';
import 'package:get/get.dart';

class ForexController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference ref =
      FirebaseFirestore.instance.collection("forexHistory");
  // late AuthController _authController;
  ForexModel? forexModel;
  User? _user;

  var username = "".obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      user != null ? _user = user : null;
    });
  }

  @override
  void onReady() {
    super.onReady();
    getUsername();
    // _authController.user.obs.listen((value) {
    //   _user = value;
    // });
  }

  Future getUsername() async {
    var userDetails =
        users.doc(firebaseAuth.currentUser!.uid).collection('userDetails');
    userDetails.snapshots().forEach((element) {
      var resp = element.docs;
      for (var i in resp) {
        username.value = i.data().values.last;
      }
    });
  }

  Future addTrade({
    required String id,
    required String currencyPair,
    required DateTime entryDate,
    required DateTime exitDate,
    required String bookValue,
    required String marketValue,
  }) async {
    firestore
        .collection("users")
        .doc(_user!.uid)
        .collection("forexHistory")
        .add({
      // forexModel!.id: id,
      "id": id,
      // forexModel!.currencyPair: currencyPair,
      "currencyPair": currencyPair,
      // forexModel!.entryDate.toString(): Timestamp.fromDate(entryDate),
      "entryDate": entryDate,
      // forexModel!.exitDate.toString(): Timestamp.fromDate(exitDate),
      "exitDate": exitDate,
      // forexModel!.bookValue: bookValue,
      "bookValue": bookValue,
      // forexModel!.marketValue: marketValue,
      "marketValue": marketValue,
      // forexModel!.result:
      //     (double.parse(marketValue) - double.parse(bookValue)).toString(),
      "result":
          (double.parse(marketValue) - double.parse(bookValue)).toString(),
    });
  }

  Future getForexData() async {
    QuerySnapshot snapshot =
        await ref.where(_user!.uid, isEqualTo: _user!.uid).get();
    return snapshot.docs;
    // return users
    //     .doc(firebaseAuth.currentUser!.uid)
    //     .collection('forexHistory')
    //     .orderBy('id', descending: true)
    //     .get();
    // return userDetails;
  }

  Stream<QuerySnapshot> forexStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_user!.uid)
        .collection('forexHistory')
        .orderBy('id', descending: true)
        .snapshots();
  }
}
