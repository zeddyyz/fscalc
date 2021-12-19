import 'package:flutter/material.dart';

class CustomProvider extends ChangeNotifier {
  String? url = "";

  void changeURL(String incomingURL) {
    url = incomingURL;
    notifyListeners();
  }

  CustomProvider({this.url});
}
