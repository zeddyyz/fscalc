import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

const kThemeRed = Color.fromRGBO(182, 17, 49, 1);

var kBackgroundColor = Colors.grey.shade100;
const kBlack = Colors.black;
const kWhite = Colors.white;

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
