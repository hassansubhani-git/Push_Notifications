import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'home_screen.dart';
import 'dart:math';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initlocalNotifications(BuildContext context) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  // SHOW NOTIFICATIONS

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      Random.secure().nextInt(1000).toString(),
      'Important Notification',
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      importance: Importance.high,
      priority: Priority.high,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void RequestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permissuion');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted permissuion for provisional');
    } else {
      AppSettings.openAppSettings();
      print('user denied permissuion');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
      }
    });
  }

  // Show notifications
}
