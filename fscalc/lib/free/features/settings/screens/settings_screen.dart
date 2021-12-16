import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              height: 50,
              width: screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Detailed Info"),
            ),
          ],
        ),
      ),
    );
  }
}
