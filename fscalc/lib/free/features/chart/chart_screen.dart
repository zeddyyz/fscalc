import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fscalc/free/controller/custom_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String _url = "";
  late SharedPreferences _sharedPreferences;

  final Completer<WebViewController> _controllerTradingView =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    _sharedPreferencesInitialization().then((value) => {
          _sharedPreferencesChart(),
        });
    // _url = "https://www.tradingview.com/";
  }

  Future<void> _sharedPreferencesInitialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.reload();
  }

  Future<void> _sharedPreferencesChart() async {
    setState(() {
      _url = _sharedPreferences.getString("chart_preference")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Consumer<CustomProvider>(
            builder: (BuildContext context, value, Widget? child) {
              print("Consumer URL: ${value.url}");
              return WebView(
                initialUrl: value.url,
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                onWebViewCreated: (WebViewController webViewController) {
                  if (!_controllerTradingView.isCompleted) {
                    _controllerTradingView.complete(webViewController);
                  } else {
                    const CircularProgressIndicator();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
