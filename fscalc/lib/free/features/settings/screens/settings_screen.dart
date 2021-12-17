import 'package:flutter/material.dart';
import 'package:fscalc/free/controller/custom_provider.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesInitialization();
  }

  Future<void> _sharedPreferencesInitialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
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
              height: 140,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: kThemeRed,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    "Settings",
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
            Container(
              height: 50,
              width: screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Dark Mode?"),
            ),
            // Slide down container that displays "Light mode, Dark mode, and System theme" on clicking on container
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Currency"),
            ),
            const SizedBox(height: 20),
            Container(
              width: screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Consumer<CustomProvider>(
                builder: (context, value, _) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text("Detailed Info"),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: Container(
                          color: kBackgroundColor,
                          child: const Text("Tradingview"),
                        ),
                        onTap: () async {
                          await _sharedPreferences.setString("chart_preference",
                              "https://www.tradingview.com/");
                          value.changeURL("https://www.tradingview.com/");
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: Container(
                          color: kBackgroundColor,
                          child: const Text("Yahoo Finance"),
                        ),
                        onTap: () async {
                          await _sharedPreferences.setString("chart_preference",
                              "https://ca.finance.yahoo.com/");
                          value.changeURL("https://ca.finance.yahoo.com/");
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: Container(
                          color: kBackgroundColor,
                          child: const Text("Google Finance"),
                        ),
                        onTap: () async {
                          await _sharedPreferences.setString("chart_preference",
                              "https://www.google.com/finance/");
                          value.changeURL("https://www.google.com/finance/");
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),

            // ListTile(
            //   title: const Text('Tradingview'),
            //   leading: Radio(
            //     value: ChartOptions.tradingview,
            //     groupValue: _chartOptions,
            //     onChanged: (ChartOptions? value) async {
            //       setState(() {
            //         _chartOptions = value!;
            //       });
            //       _sharedPreferences.setString(
            //           "chart_preference", "https://www.tradingview.com/");
            //     },
            //   ),
            // ),
            // ListTile(
            //   title: const Text('Yahoo Finance'),
            //   leading: Radio(
            //     value: ChartOptions.yahooFinance,
            //     groupValue: _chartOptions,
            //     onChanged: (ChartOptions? value) async {
            //       setState(() {
            //         _chartOptions = value!;
            //       });
            //       _sharedPreferences.setString(
            //           "chart_preference", "https://ca.finance.yahoo.com/");
            //     },
            //   ),
            // ),
            // ListTile(
            //   title: const Text('Google Finance'),
            //   leading: Radio(
            //     value: ChartOptions.googleFinance,
            //     groupValue: _chartOptions,
            //     onChanged: (ChartOptions? value) async {
            //       setState(() {
            //         _chartOptions = value!;
            //       });
            //       await _sharedPreferences.setString(
            //           "chart_preference", "https://www.google.com/finance/");
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
