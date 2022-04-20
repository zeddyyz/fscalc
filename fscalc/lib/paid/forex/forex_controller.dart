import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/forex/forex_model.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class ForexController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference ref =
      FirebaseFirestore.instance.collection("forexHistory");
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
  }

  @override
  void onClose() {
    bookValueController.dispose();
    marketValueController.dispose();
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

  // * Firebase CRUD operations
  Stream<QuerySnapshot> forexStreamOpenHistory() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_user!.uid)
        .collection('forexHistory')
        // .orderBy('id', descending: true)
        .where('isOpen', isEqualTo: true)
        .orderBy('entryDate', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> forexStreamClosedHistory() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(_user!.uid)
        .collection('forexHistory')
        // .orderBy('id', descending: true)
        .where('isOpen', isEqualTo: false)
        .orderBy('entryDate', descending: true)
        .snapshots();
  }

  Future addTrade({
    required String id,
    required String currencyPair,
    required DateTime entryDate,
    required DateTime exitDate,
    required String bookValue,
    required String marketValue,
    required bool isOpen,
  }) async {
    final details = ForexModel(
      id: id,
      entryDate: entryDate,
      exitDate: exitDate,
      currencyPair: currencyPair,
      bookValue: bookValue,
      marketValue: marketValue,
      result: (double.parse(marketValue) - double.parse(bookValue)).toString(),
      // result: "",
      isOpen: isOpen,
    );
    firestore
        .collection("users")
        .doc(_user!.uid)
        .collection("forexHistory")
        .add(details.toMap());
    //     .add({
    //   // forexModel!.id: id,
    //   "id": id,
    //   // forexModel!.currencyPair: currencyPair,
    //   "currencyPair": currencyPair,
    //   // forexModel!.entryDate.toString(): Timestamp.fromDate(entryDate),
    //   "entryDate": entryDate,
    //   // forexModel!.exitDate.toString(): Timestamp.fromDate(exitDate),
    //   "exitDate": exitDate,
    //   // forexModel!.bookValue: bookValue,
    //   "bookValue": bookValue,
    //   // forexModel!.marketValue: marketValue,
    //   "marketValue": marketValue,
    //   // forexModel!.result:
    //   //     (double.parse(marketValue) - double.parse(bookValue)).toString(),
    //   "result":
    //       (double.parse(marketValue) - double.parse(bookValue)).toString(),
    // });

    bookValueController.clear();
    marketValueController.clear();
  }

  Future confirmDelete({required int index}) async {
    return Flushbar(
      margin: EdgeInsets.only(bottom: screenHeight * 0.09, left: 20, right: 20),
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(18),
      titleText: Text(
        "Notice",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.yellow[600],
        ),
      ),
      messageText: const Text(
        "Are you sure you want to delete this entry?",
        style: TextStyle(
          fontSize: 16,
          color: kWhite,
        ),
      ),
      icon: const Icon(
        Icons.info_outline,
        size: 28.0,
        color: kWhite,
      ),
      mainButton: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Column(
          children: [
            MaterialButton(
              color: kLightIndigo.withOpacity(0.8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(color: kWhite),
              ),
              onPressed: () async {
                log("Delete command sent for $index");
                deleteTrade(id: index);
                Get.back();
              },
            ),
            MaterialButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: kWhite),
              ),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ).show(Get.context!);
  }

  Future<void> deleteTrade({required int id}) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(_user!.uid)
        .collection('forexHistory')
        .where("id", isEqualTo: id.toString())
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> editTrade({
    required String id,
    required String currencyPair,
    required DateTime entryDate,
    required DateTime exitDate,
    required String bookValue,
    required String marketValue,
    required bool isOpen,
  }) async {
    final details = ForexModel(
      id: id,
      entryDate: entryDate,
      exitDate: exitDate,
      currencyPair: currencyPair,
      bookValue: bookValue,
      marketValue: marketValue,
      result: (double.parse(marketValue) - double.parse(bookValue)).toString(),
      // result: "",
      isOpen: isOpen,
    );

    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(_user!.uid)
        .collection('forexHistory')
        .where("id", isEqualTo: id.toString())
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.set(details.toMap());
    }
  }

  // * Utilities
  String readableDatefromMilliseconds(int time) {
    String value = "";
    value = Jiffy(DateTime.fromMillisecondsSinceEpoch(time)
            .toString()
            .substring(0, 10))
        .yMMMMd;
    return value;
  }

  String convertStringToDateTime(String datetime) {
    datetime.isNotEmpty
        ? datetime = Jiffy().format(datetime)
        : Jiffy(DateTime.now()).yMMMMd;
    return readableDateFromDateTime(datetime);
  }

  String readableDateFromDateTime(String datetime) {
    datetime.isNotEmpty
        ? datetime = Jiffy(DateTime.parse(datetime)).yMMMd
        : Jiffy(DateTime.now()).yMMMMd;
    return datetime;
  }

  int indexValue({required String val}) {
    return int.parse(val);
  }

  // * Add Trade inputs
  var instrument = "".obs;
  var entryDate = "".obs;
  var bookValueController = TextEditingController();
  var isOpen = true.obs;
  var exitDate = "".obs;
  var marketValueController = TextEditingController();
  var result = "".obs;

  final List<String> currencyPairs = [
    "XAU/USD",
    "OIL",
    "EUR/USD",
    "USD/CAD",
  ];

  void toggleIsOpen() => isOpen.value = isOpen.value ? false : true;
  void toggleIsOpenEdit() => isOpenEdit.value = isOpenEdit.value ? false : true;

  final Map<int, Color> dateSelectionMaterialColor = {
    50: const Color.fromRGBO(182, 17, 49, .1),
    100: const Color.fromRGBO(182, 17, 49, .2),
    200: const Color.fromRGBO(182, 17, 49, .3),
    300: const Color.fromRGBO(182, 17, 49, .4),
    400: const Color.fromRGBO(182, 17, 49, .5),
    500: const Color.fromRGBO(182, 17, 49, .6),
    600: const Color.fromRGBO(182, 17, 49, .7),
    700: const Color.fromRGBO(182, 17, 49, .8),
    800: const Color.fromRGBO(182, 17, 49, .9),
    900: const Color.fromRGBO(182, 17, 49, 1),
  };

  void resetFormValues() {
    instrument = "".obs;
    entryDate = "".obs;
    bookValueController.clear();
    isOpen = true.obs;
    exitDate = "".obs;
    marketValueController.clear();
    result = "".obs;
  }

  // * Edit Trade Inputs
  var instrumentEdit = "".obs;
  var entryDateEdit = "".obs;
  var bookValueControllerEdit = TextEditingController();
  var isOpenEdit = true.obs;
  var exitDateEdit = "".obs;
  var marketValueControllerEdit = TextEditingController();
  var resultEdit = "".obs;

  void resetFormEditValues() {
    instrumentEdit = "".obs;
    entryDateEdit = "".obs;
    bookValueControllerEdit.clear();
    isOpenEdit = true.obs;
    exitDateEdit = "".obs;
    marketValueControllerEdit.clear();
    resultEdit = "".obs;
  }
  //
}
