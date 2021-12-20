import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

var kIsMobile = Device.get().isPhone;
var kIsTablet = Device.get().isTablet;

const kThemeRed = Color.fromRGBO(182, 17, 49, 1);

var kBackgroundColor = Colors.grey.shade100;
const kBlack = Colors.black;
const kWhite = Colors.white;
const kBlue = CupertinoColors.systemBlue;

final Shader termsTitle = const LinearGradient(
  colors: <Color>[Color(0xff8E2DE2), Color(0xff4A00E0)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

const kLightIndigo = Color(0xFF5856D6);
var kDarkGrey = Colors.grey.shade700;

var isAndroid = Device.get().isAndroid;
var isIos = Device.get().isIos;
var isMobile = Device.get().isPhone;
var isTablet = Device.get().isTablet;
var hasNotch = Device.get().hasNotch;
var screenWidth = Device.screenWidth;
var screenHeight = Device.screenHeight;

var kInputBoxDecoration =
    BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(12));

const kInputHintStyle =
    TextStyle(color: kBlack, fontSize: 16, fontWeight: FontWeight.w400);

var kInputContentPadding = const EdgeInsets.only(top: 20, left: 24);

var kPrefixIconPadding = const EdgeInsets.only(top: 10, left: 10, right: 10);
