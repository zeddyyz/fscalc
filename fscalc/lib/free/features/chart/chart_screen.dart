import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controllerTradingView =
        Completer<WebViewController>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: kThemeRed,
            height: 50,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: WebView(
                initialUrl: storageBox.read("chartPreference") ??
                    defaultChartPreference,
                javascriptMode: JavascriptMode.unrestricted,
                gestureNavigationEnabled: true,
                onWebViewCreated: (WebViewController webViewController) {
                  if (!_controllerTradingView.isCompleted) {
                    _controllerTradingView.complete(webViewController);
                  } else {
                    const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
