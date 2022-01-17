import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    Key? key,
    required this.textTop,
    required this.textBottom,
  }) : super(key: key);

  final String textTop;
  final String textBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/paid_info/red_design.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: kWhite,
                size: 40,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 60),
              child: Text(
                textTop,
                style: const TextStyle(
                  color: kWhite,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                textBottom,
                style: const TextStyle(
                  color: kWhite,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
