import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fscalc/free/components/onboarding_screen.dart';
import 'package:fscalc/free/controller/notification_service.dart';
import 'package:fscalc/paid/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  NotificationService().init();
  await Firebase.initializeApp();
  await GetStorage.init();

  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    try {
      if (await AppTrackingTransparency.trackingAuthorizationStatus ==
          TrackingStatus.notDetermined) {
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
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationSetup();
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
    return GetMaterialApp(
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
        child: const OnboardingScreen(),
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
      ),
    );
  }
}
