import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fscalc/paid/features/authentication/auth_sign_up.dart';
import 'package:fscalc/paid/features/history/history_home.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  RxBool isLoggedIn = false.obs;

  @override
  void onReady() {
    super.onReady();

    firebaseUser = Rx<User?>(firebaseAuth.currentUser);
    firebaseUser.bindStream(firebaseAuth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const SignUpScreen());
      isLoggedIn = RxBool(false);
    } else {
      Get.to(() => const HistoryHomeScreen());
      isLoggedIn = RxBool(true);
    }
  }

  Future firebaseSignIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future firebaseRegister(String email, String password, String name) async {
    UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user!;
    await createProfile(email, name, user.uid);
  }

  final CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createProfile(String uid, String email, String name) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'name': name,
    });
  }

  Future firebaseResetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future firebaseSignOut() async {
    await firebaseAuth.signOut();
  }
}
