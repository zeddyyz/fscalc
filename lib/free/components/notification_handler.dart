import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHandler extends StatefulWidget {
  const NotificationHandler({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _notificationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {},
    );

    //initialize timezone package
    tz.initializeTimeZones();
  }

  Future<void> _notificationSettings() async {
    // Removes app badge
    FlutterAppBadger.removeBadge();

    AndroidNotificationDetails _androidNotificationDetails =
        const AndroidNotificationDetails(
      'channel ID',
      'channel name',
      channelDescription: 'channel description',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    IOSNotificationDetails _iosNotificationDetails =
        const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    Future<void> showNotifications(String title, String body) async {
      await _notificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(
          android: _androidNotificationDetails,
          iOS: _iosNotificationDetails,
        ),
      );
    }

    Future<void> scheduleNotifications(
        String title, String body, Duration duration) async {
      await _notificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(duration),
        NotificationDetails(
          android: _androidNotificationDetails,
          iOS: _iosNotificationDetails,
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
