import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';

class ForexPercentScreen extends StatefulWidget {
  const ForexPercentScreen({Key? key}) : super(key: key);

  @override
  _ForexPercentScreenState createState() => _ForexPercentScreenState();
}

class _ForexPercentScreenState extends State<ForexPercentScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text('FOREX PERCENT', style: TextStyle(color: kThemeRed)),
        ),
      ],
    );
  }
}
