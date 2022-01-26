import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_textfield.dart';
import 'package:fscalc/free/utilities/constants.dart';

class ForexPercentScreen extends StatefulWidget {
  const ForexPercentScreen({Key? key}) : super(key: key);

  @override
  _ForexPercentScreenState createState() => _ForexPercentScreenState();
}

class _ForexPercentScreenState extends State<ForexPercentScreen> {
  final TextEditingController _accountSizeController = TextEditingController();
  final TextEditingController _percentRiskController = TextEditingController();
  final TextEditingController _entryPriceController = TextEditingController();
  final TextEditingController _targetPriceController = TextEditingController();
  final TextEditingController _stopLossController = TextEditingController();

  Future<void> _disposeControllers() async {
    _accountSizeController.dispose();
    _percentRiskController.dispose();
    _entryPriceController.dispose();
    _targetPriceController.dispose();
    _stopLossController.dispose();
  }

  Future<void> _clearControllers() async {
    _accountSizeController.clear();
    _percentRiskController.clear();
    _entryPriceController.clear();
    _targetPriceController.clear();
    _stopLossController.clear();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  // Calculator values
  double? accountSize, percentRisk, entryPrice, targetPrice, stopLoss;
  String? riskAmountText, lotSizeText, returnText;
  String? errorMessageText;
  bool nullValues = true;

  void calculatePercentValues() {
    String _currencySymbol =
        storageBox.read("currencySymbol") ?? defaultCurrencySymbol;

    if (!mounted) return;
    setState(() {
      if (accountSize == null) {
        errorMessageText = "Account size is required";
        nullValues = true;
        alertDialog();
      } else if (percentRisk == null) {
        errorMessageText = "Percent risk is required";
        nullValues = true;
        alertDialog();
      } else if (entryPrice == null) {
        errorMessageText = "Entry price is required";
        nullValues = true;
        alertDialog();
      } else if (targetPrice == null) {
        errorMessageText = "Target price is required";
        nullValues = true;
        alertDialog();
      } else if (stopLoss == null) {
        errorMessageText = "Stop loss is required";
        nullValues = true;
        alertDialog();
      } else {
        nullValues = false;
        double dollarRisk = accountSize! * (percentRisk! / 100);
        riskAmountText =
            "Investment: " + _currencySymbol + dollarRisk.toStringAsFixed(2);

        if (entryPrice! > targetPrice!) {
          // Short trade
          // Lot size calculation
          double stopLossPips = (stopLoss! * 10000) - (entryPrice! * 10000);
          double lots = (dollarRisk / stopLossPips) / 10;
          lotSizeText = "Lot Size: " + lots.toStringAsFixed(2);
          // Return on investment calculation
          double returnCalculation =
              (entryPrice! * 10000) - (targetPrice! * 10000);
          String resultText =
              (returnCalculation * (lots * 10)).toStringAsFixed(2);
          returnText = "Potential Return: " + _currencySymbol + resultText;
        } else {
          // Long trade
          // Lot size calculation
          double stopLossPips = (entryPrice! * 10000) - (stopLoss! * 10000);
          double lots = (dollarRisk / stopLossPips) / 10;
          lotSizeText = "Lot Size: " + lots.toStringAsFixed(2);
          // Return on investment calculation
          double returnCalculation =
              (targetPrice! * 10000) - (entryPrice! * 10000);
          String resultText =
              (returnCalculation * (lots * 10)).toStringAsFixed(2);
          returnText = "Potential Return: " + _currencySymbol + resultText;
        }
      }
    });
  }

  // Alert Dialog
  void alertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 280,
              height: 135,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "$errorMessageText",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: CustomButton(
                      height: 40,
                      width: double.maxFinite,
                      textSize: 16,
                      title: "Close",
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kIsMobile ? const SizedBox() : const SizedBox(height: 20),
        CustomTextField(
          controller: _accountSizeController,
          hintText: "Account Size",
          prefixIcon: Icons.account_balance_rounded,
          onChanged: (value) {
            if (value != "") accountSize = double.parse(value);
          },
        ),
        CustomTextField(
          controller: _percentRiskController,
          hintText: "Percent Risk",
          prefixIcon: Icons.money_rounded,
          onChanged: (value) {
            if (value != "") percentRisk = double.parse(value);
          },
        ),
        CustomTextField(
          controller: _entryPriceController,
          hintText: "Entry Price",
          prefixIcon: Icons.attach_money_rounded,
          onChanged: (value) {
            if (value != "") entryPrice = double.parse(value);
          },
        ),
        CustomTextField(
          controller: _targetPriceController,
          hintText: "Target Price",
          prefixIcon: Icons.local_atm_rounded,
          onChanged: (value) {
            if (value != "") targetPrice = double.parse(value);
          },
        ),
        CustomTextField(
          controller: _stopLossController,
          hintText: "Stop Loss",
          prefixIcon: Icons.money_off_rounded,
          onChanged: (value) {
            if (value != "") stopLoss = double.parse(value);
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          title: "Calculate",
          onTap: () {
            calculatePercentValues();
            FocusScope.of(context).unfocus();
            !nullValues ? _calculationPopup() : null;
          },
        ),
        const SizedBox(height: 8),
        CustomButton(
          title: "Reset",
          buttonColor: Colors.grey.shade300.withOpacity(0.5),
          height: 44,
          textColor: kBlack,
          onTap: () {
            _clearControllers();
          },
        ),
      ],
    );
  }

  _calculationPopup() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: kBackgroundColor.withOpacity(0),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80, vertical: isMobile ? 30 : 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [kThemeRed, Colors.deepOrange],
              stops: [
                0.1,
                0.9,
              ],
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CupertinoButton(
                    child: const Icon(
                      Icons.cancel,
                      color: kWhite,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 150,
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.5),
                  backgroundBlendMode: BlendMode.overlay,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: isMobile ? 32 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "$riskAmountText",
                        style: const TextStyle(
                          fontSize: 15,
                          color: kBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '$lotSizeText',
                        style: const TextStyle(
                          fontSize: 21,
                          color: kBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '$returnText',
                        style: const TextStyle(
                          fontSize: 15,
                          color: kBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
