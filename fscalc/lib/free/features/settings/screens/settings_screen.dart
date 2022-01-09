import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_outline_button.dart';
import 'package:fscalc/free/controller/custom_provider.dart';
import 'package:fscalc/free/models/ads_model.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/free/utilities/responsive_layout.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

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
      case "https://www.tradingview.com/":
        setState(() {
          _currentChartIndex = 0;
        });
        break;
      case "https://ca.finance.yahoo.com/":
        setState(() {
          _currentChartIndex = 1;
        });
        break;
      case "https://www.google.com/finance/":
        setState(() {
          _currentChartIndex = 2;
        });
        break;
      case "https://www.investing.com/":
        setState(() {
          _currentChartIndex = 3;
        });
        break;
      default:
        break;
    }
  }

  final Map<String, String> _availableOptionChart = {
    "Tradingview": "https://www.tradingview.com/",
    "Yahoo Finance": "https://ca.finance.yahoo.com/",
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
              child: Text(
                // "Please restart the app for changes to take effect.",
                "Please click on refresh icon on the previous page to change resource.",
                style: TextStyle(
                  color: kBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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
        child: ResponsiveLayout(
          isMobile: Column(
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
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
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
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
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
                        onPressed: () => _showAlertDialog(),
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
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       top: 4, left: 4, right: 4, bottom: 0),
                      //   child: Row(
                      //     children: [
                      //       const Text(
                      //         "Show navigation buttons",
                      //         style: TextStyle(fontSize: 18),
                      //       ),
                      //       const Spacer(),
                      //       CupertinoSwitch(
                      //         value: _showNavBtn,
                      //         thumbColor: kThemeRed,
                      //         trackColor: kBackgroundColor,
                      //         activeColor: kThemeRed.withOpacity(0.4),
                      //         onChanged: (value) {
                      //           if (!mounted) return;
                      //           if (value) {
                      //             storageBox.write("displayNavBtn", true);
                      //             setState(() {
                      //               _showNavBtn = true;
                      //             });
                      //           } else {
                      //             storageBox.write("displayNavBtn", false);
                      //             setState(() {
                      //               _showNavBtn = false;
                      //             });
                      //           }
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Consumer<CustomProvider>(
                          builder: (context, value, _) {
                            return ListView.builder(
                              itemCount: _availableOptionChart.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                var _list =
                                    _availableOptionChart.entries.toList();
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: CustomOutlineButton(
                                    backgroundColor: _currentChartIndex == index
                                        ? kWhite
                                        : kBackgroundColor,
                                    outlineBorderColor:
                                        _currentChartIndex == index
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

                                      storageBox.write("chartPreference",
                                          _list[index].value);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
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
          isTablet: Column(
            children: [
              Container(
                height: 140,
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Text(
                      "Preferences",
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // * Currency Preference
              Container(
                width: screenWidth * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpandablePanel(
                  header: const Padding(
                    padding: EdgeInsets.only(left: 4, top: 16, bottom: 16),
                    child: Text(
                      "Currency Preference",
                      style: TextStyle(
                        color: kBlack,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  collapsed: const SizedBox(),
                  expanded: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListView.builder(
                      itemCount: _availableOptionCurrency.length,
                      shrinkWrap: true,
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
                            titleFontSize: 22,
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
              const SizedBox(height: 24),
              // * Detailed Information
              Container(
                width: screenWidth * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpandablePanel(
                  header: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4, top: 16, bottom: 16),
                        child: Text(
                          "Detailed Information",
                          style: TextStyle(
                            color: kBlack,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showAlertDialog(),
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
                  expanded: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListView.builder(
                      itemCount: _availableOptionChart.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                            titleFontSize: 22,
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
      ),
    );
  }
}
