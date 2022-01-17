import 'package:flutter/material.dart';
import 'package:fscalc/paid/controllers/auth_controller.dart';
import 'package:get/get.dart';

class WrapperComponent extends StatefulWidget {
  const WrapperComponent({Key? key}) : super(key: key);

  @override
  State<WrapperComponent> createState() => _WrapperComponentState();
}

class _WrapperComponentState extends State<WrapperComponent> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // return Obx(() => authController.);
    return Container();
  }
}
