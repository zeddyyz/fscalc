import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/features/authentication/auth_sign_up.dart';
import 'package:fscalc/paid/features/authentication/components/main_layout.dart';
import 'package:fscalc/paid/features/authentication/controllers/auth_controller.dart';
import 'package:fscalc/paid/features/history/history_home.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _passwordVisible = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const MainLayout(textTop: "Welcome", textBottom: "Back"),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 30),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.47),
                  TextField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.mail_outline_rounded, color: kThemeRed),
                      fillColor: kThemeRed,
                      focusColor: kThemeRed,
                      hoverColor: kThemeRed,
                      hintText: "Email",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kThemeRed,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kThemeRed,
                          width: 1.5,
                        ),
                      ),
                    ),
                    cursorColor: kThemeRed,
                    onChanged: (value) {
                      emailController.text = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.lock_outline_rounded,
                        color: kThemeRed,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: kThemeRed.withOpacity(0.8),
                        ),
                      ),
                      fillColor: kThemeRed,
                      focusColor: kThemeRed,
                      hoverColor: kThemeRed,
                      hintText: "Password",
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: kThemeRed),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kThemeRed,
                          width: 1.5,
                        ),
                      ),
                    ),
                    cursorColor: kThemeRed,
                    obscureText: _passwordVisible,
                    onChanged: (value) {
                      passwordController.text = value;
                    },
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    title: "Login",
                    width: availableSize,
                    fontWeight: FontWeight.w700,
                    onTap: () {
                      try {
                        _authController
                            .firebaseSignIn(
                                emailController.text, passwordController.text)
                            .then((value) =>
                                {Get.to(() => const HistoryHomeScreen())});
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 20,
                    child: Row(
                      children: const [
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Divider(
                              indent: 8,
                              color: kThemeRed,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text("or"),
                        SizedBox(width: 12),
                        Flexible(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Divider(
                              endIndent: 8,
                              color: kThemeRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kThemeRed),
                    ),
                    child: CustomButton(
                      title: "Sign Up",
                      width: availableSize,
                      height: 40,
                      fontWeight: FontWeight.w600,
                      buttonColor: Colors.transparent,
                      textColor: kBlack,
                      onTap: () => Get.to(() => const SignUpScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
