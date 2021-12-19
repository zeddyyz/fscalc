import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fscalc/free/components/bottom_nav.dart';
import 'package:fscalc/free/controller/custom_provider.dart';
import 'package:fscalc/free/controller/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  NotificationService().init();

  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    try {
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (exception) {
      debugPrint("$exception");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences _sharedPreferences;
  final NotificationService _notificationService = NotificationService();
  String url = "";

  @override
  void initState() {
    super.initState();
    _sharedPreferencesInitialization().then((value) => {
          _sharedPreferencesChart(),
        });

    _notificationSetup();
  }

  Future<void> _sharedPreferencesInitialization() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> _sharedPreferencesChart() async {
    if (_sharedPreferences.getString("chart_preference") == null) {
      setState(() {
        url = "https://www.tradingview.com/";
      });
    } else {
      setState(() {
        url = _sharedPreferences.getString("chart_preference")!;
      });
    }
  }

  Future<void> _notificationSetup() async {
    await _notificationService.scheduleNotifications(
      "Just checking in",
      "Money management is essential in being successful in the financial markets",
      const Duration(days: 7),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CustomProvider(
              url: url,
            ),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'fscalc',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            home: GestureDetector(
              child: const BottomNav(),
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus!.unfocus();
                }
              },
            ),
          );
        });
  }
}
