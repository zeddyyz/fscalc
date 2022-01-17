import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_outline_button.dart';
import 'package:fscalc/free/models/ads_model.dart';
import 'package:fscalc/free/utilities/alert_snackbar.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/paid/controllers/auth_controller.dart';
import 'package:fscalc/paid/features/authentication/auth_sign_up.dart';
import 'package:fscalc/tester/paid_info.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentChartIndex = 0;
  int _currentCurrencyIndex = 0;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  final AlertSnackbar _alertSnackbar = AlertSnackbar();

  @override
  void initState() {
    super.initState();

    _assignCurrencyIndex();
    _assignChartIndex();

    _bannerAd = BannerAd(
      adUnitId: AdsModel.bannerUnitId,
      request: const AdRequest(),
      size: isMobile ? AdSize.banner : AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          // print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  // #region Currency options
  Future<void> _assignCurrencyIndex() async {
    var currencyPreference =
        storageBox.read("currencyPreference") ?? defaultCurrencyPreference;

    switch (currencyPreference) {
      case "Dollar":
        setState(() {
          _currentCurrencyIndex = 0;
        });
        break;
      case "Yen":
        setState(() {
          _currentCurrencyIndex = 1;
        });
        break;
      case "Euro":
        setState(() {
          _currentCurrencyIndex = 2;
        });
        break;
      default:
        break;
    }
  }

  final Map<String, String> _availableOptionCurrency = {
    "Dollar": "\$",
    "Yen": "¥",
    "Euro": "€",
  };

  // #endregion

  // #region Chart options
  Future<void> _assignChartIndex() async {
    var chartPreference =
        storageBox.read("chartPreference") ?? defaultChartPreference;

    switch (chartPreference) {
      case "https://finance.yahoo.com/":
        setState(() {
          _currentChartIndex = 0;
        });
        break;
      case "https://www.google.com/finance/":
        setState(() {
          _currentChartIndex = 1;
        });
        break;
      case "https://www.investing.com/":
        setState(() {
          _currentChartIndex = 2;
        });
        break;
      default:
        break;
    }
  }

  final Map<String, String> _availableOptionChart = {
    "Yahoo Finance": "https://finance.yahoo.com/",
    "Google Finance": "https://www.google.com/finance/",
    "Investing.com": "https://www.investing.com/",
  };
  // #endregion

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          elevation: 10,
          actions: [
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "Please click on refresh icon on the previous page to change resource.",
                  style: TextStyle(
                    color: kBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                title: "Okay",
                width: double.maxFinite,
                height: 40,
                buttonColor: kThemeRed,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              width: screenWidth,
              decoration: BoxDecoration(
                color: kThemeRed,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(screenWidth, 40),
                ),
              ),
              child: const SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    "Preferences",
                    style: TextStyle(
                      color: kWhite,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            // * Currency Preference
            Container(
              width: screenWidth,
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(13),
              ),
              child: ExpandablePanel(
                header: const Padding(
                  padding: EdgeInsets.only(left: 4, top: 12, bottom: 12),
                  child: Text(
                    "Currency Preference",
                    style: TextStyle(
                      color: kBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                collapsed: const SizedBox(),
                expanded: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ListView.builder(
                    itemCount: _availableOptionCurrency.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var _list = _availableOptionCurrency.entries.toList();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomOutlineButton(
                          backgroundColor: _currentCurrencyIndex == index
                              ? kWhite
                              : kBackgroundColor,
                          outlineBorderColor: _currentCurrencyIndex == index
                              ? kThemeRed
                              : kBackgroundColor,
                          title: _list[index].value,
                          titleColor: _currentCurrencyIndex == index
                              ? kThemeRed
                              : kBlack,
                          titleFontWeight: _currentCurrencyIndex == index
                              ? FontWeight.w600
                              : FontWeight.normal,
                          titleFontSize: 18,
                          onTap: () async {
                            setState(() {
                              _currentCurrencyIndex = index;
                            });

                            storageBox.write(
                                "currencyPreference", _list[index].key);
                            storageBox.write(
                                "currencySymbol", _list[index].value);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // * Detailed Information
            Container(
              width: screenWidth,
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(13),
              ),
              child: ExpandablePanel(
                header: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, top: 12, bottom: 12),
                      child: Text(
                        "Detailed Information",
                        style: TextStyle(
                          color: kBlack,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _alertSnackbar.alertSnackbar(context,
                          "Please click on refresh icon on the previous page to change resource."),
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: kThemeRed.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                collapsed: const Padding(
                  padding: EdgeInsets.only(bottom: 12, left: 4),
                  child: Text("View different resources."),
                ),
                expanded: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ListView.builder(
                        itemCount: _availableOptionChart.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          var _list = _availableOptionChart.entries.toList();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: CustomOutlineButton(
                              backgroundColor: _currentChartIndex == index
                                  ? kWhite
                                  : kBackgroundColor,
                              outlineBorderColor: _currentChartIndex == index
                                  ? kThemeRed
                                  : kBackgroundColor,
                              title: _list[index].key,
                              titleColor: _currentChartIndex == index
                                  ? kThemeRed
                                  : kBlack,
                              titleFontWeight: _currentChartIndex == index
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              onTap: () async {
                                setState(() {
                                  _currentChartIndex = index;
                                });

                                storageBox.write(
                                    "chartPreference", _list[index].value);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // * Investment History
            Container(
              width: screenWidth,
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(13),
              ),
              child: ListTile(
                leading: const Icon(Icons.payment_rounded),
                title: const Text(
                  "Investment History",
                  style: TextStyle(
                    color: kBlack,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.chevron_right_rounded,
                  ),
                  onPressed: () {
                    // _paidInfoPopup();
                    // Get.to(() => const PaidInfoTest());
                    // Get.to(() => SignUpScreen());
                    Get.put(AuthController());
                  },
                ),
              ),
            ),
            _isBannerAdReady
                ? SizedBox(height: screenHeight * 0.1)
                : const SizedBox(),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  void _paidInfoPopup() {
    /*
      - Firebase authentication with Getx Controller to manage user auth state
    */
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: kWhite.withOpacity(0),
      context: context,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(13),
            topRight: Radius.circular(13),
          ),
          color: kBackgroundColor,
        ),
        height: availableSize,
        margin: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              child: Image.asset(
                "assets/paid_info/dollar_notes_wrap.jpg",
                fit: BoxFit.cover,
                height: screenHeight,
                width: screenWidth,
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              top: screenHeight * 0.15,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get fscalc Premium",
                      style: TextStyle(
                        color: Colors.yellow.shade300,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: const Text(
                        "Unlock investment history, investment analytics, and remove ads",
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.05),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 4,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      title: "One-Time Payment",
                      onTap: () => Get.to(() => const SignUpScreen()),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.15,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  const CupertinoCloseIcon(
                    backgroundColor: kThemeRed,
                    iconColor: kWhite,
                  ),
                  const Spacer(),
                  CustomButton(
                    title: "Restore",
                    textSize: 14,
                    buttonColor: Colors.transparent,
                    textColor: kWhite,
                    fontWeight: FontWeight.w800,
                    height: 30,
                    width: 100,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
