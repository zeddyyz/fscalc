import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const kThemeRed = Color.fromRGBO(182, 17, 49, 1);
const kHexThemeRed = Color(0xffB61131);

var kBackgroundColor = Colors.grey.shade100;
const kBlack = Colors.black;
const kWhite = Colors.white;
const kBlue = CupertinoColors.systemBlue;

final Shader termsTitle = const LinearGradient(
  colors: <Color>[Color(0xff8E2DE2), Color(0xff4A00E0)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

const kLightIndigo = Color(0xFF5856D6);
var kDarkGrey = Colors.grey.shade700;

var isAndroid = GetPlatform.isAndroid;
var isIos = GetPlatform.isIOS;
var isMobile = GetPlatform.isMobile;
var isTablet =
    !GetPlatform.isMobile || !GetPlatform.isDesktop || !GetPlatform.isWeb;
// var hasNotch = GetPlatform.;
var screenWidth = Get.width;
var screenHeight = Get.height;

const availableSize = double.maxFinite;

var kInputBoxDecoration =
    BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(12));

const kInputHintStyle =
    TextStyle(color: kBlack, fontSize: 16, fontWeight: FontWeight.w400);

var kInputContentPadding = const EdgeInsets.only(top: 20, left: 24);

var kPrefixIconPadding = const EdgeInsets.only(top: 10, left: 10, right: 10);

// get_storage
final storageBox = GetStorage();
var defaultCurrencyPreference = "Dollar";
var defaultCurrencySymbol = "\$";
var defaultChartPreference = "https://finance.yahoo.com/";
