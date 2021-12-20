import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fscalc/free/components/custom_button.dart';
import 'package:fscalc/free/components/custom_textfield.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StocksFixedScreen extends StatefulWidget {
  const StocksFixedScreen({Key? key}) : super(key: key);

  @override
  _StocksFixedScreenState createState() => _StocksFixedScreenState();
}

class _StocksFixedScreenState extends State<StocksFixedScreen> {
  late SharedPreferences _sharedPreferences;

  final TextEditingController _tradeSizeController = TextEditingController();
  final TextEditingController _entryPriceController = TextEditingController();
  final TextEditingController _targetPriceController = TextEditingController();

  Future<void> _disposeControllers() async {
    _tradeSizeController.dispose();
    _entryPriceController.dispose();
    _targetPriceController.dispose();
  }

  Future<void> _clearControllers() async {
    _tradeSizeController.clear();
    _entryPriceController.clear();
    _targetPriceController.clear();
  }

  Future<void> _sharedPreferencesInitialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _sharedPreferencesInitialization();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  // Calculator values
  double? tradeSize, entryPrice, targetPrice;
  String? sharesAmountText, returnText;
  String? errorMessageText;
  bool nullValues = true;

  void calculatePercentValues() {
    String? _currencySymbol = _sharedPreferences.getString("currency_symbol");
    if (_currencySymbol == "") {
      setState(() {
        _currencySymbol = "\$";
      });
    }

    if (!mounted) return;
    setState(() {
      if (tradeSize == null) {
        errorMessageText = "Account size is required";
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
      } else {
        nullValues = false;

        double sharesAmount = tradeSize! / entryPrice!;
        double profitPotential = targetPrice! - entryPrice!;
        double potentialReturn = sharesAmount * profitPotential;

        if (sharesAmount < 1.00) {
          sharesAmountText = "Don't trade. It's not worth it.";
        } else {
          // Long trade
          // Shares calculation
          sharesAmountText =
              "Max Shares: " + sharesAmount.floor().toStringAsFixed(0);

          returnText = "Potential Return: " +
              _currencySymbol! +
              potentialReturn.toStringAsFixed(2);
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
          controller: _tradeSizeController,
          hintText: "Trade Size",
          prefixIcon: Icons.account_balance_rounded,
          onChanged: (value) {
            if (value != "") tradeSize = double.parse(value);
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
