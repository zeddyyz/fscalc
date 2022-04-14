import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/bottom_nav.dart';
import 'package:fscalc/free/utilities/alert_snackbar.dart';
import 'package:fscalc/paid/authentication/auth_model.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Rx<List<AuthModel>> authModelList = Rx<List<AuthModel>>([]);
  List<AuthModel> get todos => authModelList.value;

  late User user;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();

  var isLoggedIn = false.obs;
  var username = "".obs;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  @override
  void onReady() {
    isLoggedIn.isTrue ? authModelList.bindStream(todoStream()) : false;
  }

  Stream<void> checkLogin() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      user == null ? isLoggedIn(false) : isLoggedIn(true);
      user = user;
    });
    return isLoggedIn.stream;
  }

  Future signUpUser() async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = result.user;

      if (user != null) {
        log(user.toString());
        await addUserDetails(
          user: user,
          userEmail: emailController.text,
          userName: nameController.text,
        );

        isLoggedIn(true);
        log("Logged In");
      } else {
        isLoggedIn(false);
        log("Not logged in");
        AlertSnackbar().alertSnackbar(Get.context!, "Error!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future addUserDetails({
    required User user,
    required String userEmail,
    required String userName,
  }) async {
    firestore.collection("users").doc(user.uid).collection("userDetails").add({
      "email": userEmail,
      "name": userName,
    });
  }

  Future signInUser() async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = result.user;

      if (user != null) {
        isLoggedIn(true);
        Get.offAll(() => const BottomNav());
        log("Logged In");
      } else {
        isLoggedIn(false);
        log("Not logged in");
        AlertSnackbar().alertSnackbar(Get.context!, "Error Loggin in!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future signOut() async {
    await firebaseAuth.signOut();
    log("User has been signed out");
    Get.offAll(() => const BottomNav());
  }

  Stream<List<AuthModel>> todoStream() {
    return firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('userDetails')
        .snapshots()
        .map((QuerySnapshot query) {
      List<AuthModel> todos = [];

      for (var todo in query.docs) {
        final todoModel =
            AuthModel.fromDocumentSnapshot(documentSnapshot: todo);

        todos.add(todoModel);
        username = RxString(todos.first.name.toString());
        // update();
      }

      return todos;
    });
  }
}
