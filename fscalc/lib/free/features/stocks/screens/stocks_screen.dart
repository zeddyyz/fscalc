import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Stocks",
                  style: TextStyle(
                    color: kBlack,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
