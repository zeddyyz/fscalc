import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_outline_button.dart';
import 'package:fscalc/free/controller/custom_provider.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/free/utilities/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _sharedPreferences;
  int _currentChartIndex = 0;
  int _currentCurrencyIndex = 0;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesInitialization().then((value) => {
          _assignCurrencyIndex(),
          _assignChartIndex(),
        });
  }

  Future<void> _sharedPreferencesInitialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // #region Currency options
  Future<void> _assignCurrencyIndex() async {
    String _value = _sharedPreferences.getString("currency_name")!;

    switch (_value) {
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
    String _value = _sharedPreferences.getString("chart_preference")!;

    switch (_value) {
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
      default:
        break;
    }
  }

  final Map<String, String> _availableOptionChart = {
    "Tradingview": "https://www.tradingview.com/",
    "Yahoo Finance": "https://ca.finance.yahoo.com/",
    "Google Finance": "https://www.google.com/finance/",
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
                "Please restart the app for changes to take effect.",
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
                // height: 140,
                height: 160,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: kThemeRed,
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(20),
                  //   bottomRight: Radius.circular(20),
                  // ),
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
                  expanded: ListView.builder(
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
                          onTap: () async {
                            setState(() {
                              _currentCurrencyIndex = index;
                            });

                            await _sharedPreferences.setString(
                                "currency_name", _list[index].key);
                            await _sharedPreferences.setString(
                                "currency_symbol", _list[index].value);
                          },
                        ),
                      );
                    },
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
                  expanded: Consumer<CustomProvider>(
                    builder: (context, value, _) {
                      return ListView.builder(
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
                              onTap: () async {
                                setState(() {
                                  _currentChartIndex = index;
                                });

                                await _sharedPreferences.setString(
                                    "chart_preference", _list[index].value);

                                value.changeURL(_list[index].value);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          isTablet: Wrap(
            spacing: 50,
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
                width: screenWidth,
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
                        fontSize: 18,
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
                            onTap: () async {
                              setState(() {
                                _currentCurrencyIndex = index;
                              });

                              await _sharedPreferences.setString(
                                  "currency_name", _list[index].key);
                              await _sharedPreferences.setString(
                                  "currency_symbol", _list[index].value);
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
                        padding: EdgeInsets.only(left: 4, top: 16, bottom: 16),
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
                  expanded: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Consumer<CustomProvider>(
                      builder: (context, value, _) {
                        return ListView.builder(
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
                                onTap: () async {
                                  setState(() {
                                    _currentChartIndex = index;
                                  });

                                  await _sharedPreferences.setString(
                                      "chart_preference", _list[index].value);

                                  value.changeURL(_list[index].value);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
