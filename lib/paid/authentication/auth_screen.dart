import 'package:flutter/material.dart';
import 'package:fscalc/paid/authentication/auth_controller.dart';
import 'package:fscalc/paid/forex/forex_history_screen.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthController authController = Get.put(AuthController());
    return GetX<AuthController>(builder: (AuthController authController) {
      return Scaffold(
        appBar: AppBar(
          title: Text(authController.username.string),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Sign Up'),
                TextField(
                  controller: authController.emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                TextField(
                  controller: authController.passwordController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                ),
                TextField(
                  controller: authController.nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await authController.signUpUser().then((value) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForexHistoryScreen(),
                            ),
                          ),
                        });
                  },
                  child: const Text("Sign Up"),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: authController.emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                TextField(
                  controller: authController.passwordController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await authController.signInUser().then((value) => {
                          // authController.isLoggedIn.isTrue
                          //     ? Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (_) => const ForexHistoryScreen(),
                          //         ),
                          //       )
                          //     : false,
                        });
                  },
                  child: const Text("Sign In"),
                ),
                GetX<AuthController>(builder: (AuthController controller) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(controller.todos[index].email);
                      print(controller.todos[index].name);

                      final _todoModel = controller.todos[index];

                      return Container(
                        height: 100,
                        color: Colors.blue,
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
