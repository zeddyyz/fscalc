import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_textfield.dart';
import 'package:fscalc/free/utilities/constants.dart';

class StocksPercentScreen extends StatefulWidget {
  const StocksPercentScreen({Key? key}) : super(key: key);

  @override
  _StocksPercentScreenState createState() => _StocksPercentScreenState();
}

class _StocksPercentScreenState extends State<StocksPercentScreen> {
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  // Calculator values
  double? accountSize, percentRisk, entryPrice, targetPrice, stopLoss;
  String? riskAmountText, sharesAmountText, returnText;
  String? errorMessageText;
  bool nullValues = true;

  void calculatePercentValues() {
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
        riskAmountText = "Investment: \$" + dollarRisk.toStringAsFixed(2);

        double sharesAmount = dollarRisk / entryPrice!;

        if (sharesAmount < 1.00) {
          sharesAmountText = "Don't trade. It's not worth it.";
        } else {
          // Long trade
          // Shares calculation
          sharesAmountText =
              "Max Shares: " + sharesAmount.floor().toStringAsFixed(0);

          double potentialReturn = (targetPrice! - entryPrice!) * sharesAmount;
          returnText =
              "Potential Return: \$" + potentialReturn.toStringAsFixed(2);
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
          padding: MediaQuery.of(context).viewInsets,
          height: screenHeight * 0.40,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            gradient: LinearGradient(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.85),
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
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: screenWidth * 0.80,
                height: screenHeight * 0.175,
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.overlay,
                  borderRadius: BorderRadius.circular(20),
                  color: kWhite.withOpacity(0.5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        '$sharesAmountText',
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
