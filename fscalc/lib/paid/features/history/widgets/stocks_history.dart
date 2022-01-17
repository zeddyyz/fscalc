import 'package:flutter/material.dart';

class StocksHistoryWidget extends StatefulWidget {
  const StocksHistoryWidget({Key? key}) : super(key: key);

  @override
  _StocksHistoryWidgetState createState() => _StocksHistoryWidgetState();
}

class _StocksHistoryWidgetState extends State<StocksHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("STOCKS HISOTRY"));
  }
}
