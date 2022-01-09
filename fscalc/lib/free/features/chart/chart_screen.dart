import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fscalc/free/components/loading.dart';
import 'package:fscalc/free/utilities/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with TickerProviderStateMixin {
  late AnimationController _largeController;
  late Animation<Offset> _largeAnimation;

  late WebViewController _webViewController;
  bool _showOverlay = true;
  bool _visible = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _largeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _largeAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.85, 0.0),
    ).animate(CurvedAnimation(
      parent: _largeController,
      // curve: Curves.easeInCubic,
      curve: Curves.easeInToLinear,
    ));
  }

  @override
  Widget build(BuildContext context) {
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
              initialUrl:
                  storageBox.read("chartPreference") ?? defaultChartPreference,
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onProgress: (progress) {
                if (progress != 100) {
                  setState(() {
                    _loading = true;
                  });
                } else {
                  setState(() {
                    _loading = false;
                  });
                }
              },
            ),
          ),
        ),
        _showOverlay
            ? Positioned(
                bottom: 24,
                left: screenWidth * 0.1,
                width: screenWidth * 0.8,
                height: 50,
                child: SlideTransition(
                  position: _largeAnimation,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _visible ? 1.0 : 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withOpacity(0.18),
                            blurRadius: 24,
                            spreadRadius: 12,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              color: kBlue,
                              size: 32,
                            ),
                            onPressed: () async {
                              if (await _webViewController.canGoBack()) {
                                _webViewController.goBack();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              // Icons.refresh_rounded,
                              Icons.restart_alt_rounded,
                              color: kBlue,
                              size: 28,
                            ),
                            onPressed: () async {
                              await _webViewController.reload();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: kBlue,
                              size: 28,
                            ),
                            onPressed: () async {
                              await _webViewController.loadUrl(
                                  storageBox.read("chartPreference") ??
                                      defaultChartPreference);
                            },
                          ),
                          _loading ? Text("Loading...") : const SizedBox(),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: kBlue,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                _showOverlay = false;
                                _visible = !_visible;
                              });
                              _largeController.forward();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Positioned(
                bottom: 24,
                right: screenWidth * 0.1,
                width: 36,
                height: 40,
                child: SlideTransition(
                  position: _largeAnimation,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: !_visible ? 1.0 : 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kBlack.withOpacity(0.18),
                            blurRadius: 20,
                            spreadRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: kBlack,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _showOverlay = true;
                            _visible = !_visible;
                          });
                          _largeController.reverse();
                        },
                      ),
                    ),
                  ),
                ),
              ),
      ],
    )
        // : const Loading(),
        );
  }
}
