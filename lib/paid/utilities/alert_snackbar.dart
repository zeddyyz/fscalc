import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class AlertSnackbar {
  alertSnackbar(BuildContext context, String message) {
    Flushbar(
      margin: EdgeInsets.only(bottom: screenHeight * 0.09, left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: kThemeRed,
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
          fontWeight: FontWeight.w500,
          color: kWhite,
        ),
      ),
      icon: const Icon(
        Icons.info_outline,
        size: 28.0,
        color: kWhite,
      ),
      duration: const Duration(seconds: 5),
    ).show(context);
  }

  alertLightSnackbar(BuildContext context, String message) {
    Flushbar(
      margin: EdgeInsets.only(bottom: screenHeight * 0.09, left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: kWhite.withOpacity(0.9),
      titleText: Text(
        "Notice",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.orange.shade700,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: kBlack,
        ),
      ),
      icon: const Icon(
        Icons.info_outline,
        size: 28.0,
        color: kBlack,
      ),
      duration: const Duration(seconds: 5),
    ).show(context);
  }
}
