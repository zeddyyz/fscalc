import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class AlertSnackbar {
  alertSnackbar(BuildContext context, String message) {
    return Flushbar(
      margin: EdgeInsets.only(bottom: screenHeight * 0.09, left: 30, right: 30),
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(13),
      titleText: Text(
        "Notice",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.yellow[600],
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: kWhite,
        ),
      ),
      icon: const Icon(
        Icons.info_outline,
        size: 28.0,
        color: kWhite,
      ),
      duration: const Duration(seconds: 5),
    )..show(context);
  }
}
