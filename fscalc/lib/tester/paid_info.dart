import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fscalc/free/components/cupertino_close_icon.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:fscalc/free/utilities/loading_screen.dart';

class PaidInfoTest extends StatefulWidget {
  const PaidInfoTest({Key? key}) : super(key: key);

  @override
  _PaidInfoTestState createState() => _PaidInfoTestState();
}

class _PaidInfoTestState extends State<PaidInfoTest> {
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: LoadingScreen(
        loading: isLoading,
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
                      onTap: () {},
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

class CustomDots extends StatelessWidget {
  const CustomDots({
    Key? key,
    required int itemIndex,
  })  : _itemIndex = itemIndex,
        super(key: key);

  final int _itemIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (indexDots) {
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              margin: const EdgeInsets.only(
                right: 4,
              ),
              width: _itemIndex == indexDots ? 22 : 12,
              height: 6,
              decoration: BoxDecoration(
                color: _itemIndex == indexDots
                    ? kThemeRed
                    : kThemeRed.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }
}
