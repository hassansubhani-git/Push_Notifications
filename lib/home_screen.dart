import 'package:flutter/material.dart';
import 'package:push_notifications/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  NotificationServices notificationServices = NotificationServices();
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.isTokenRefresh();
    notificationServices.RequestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.getDeviceToken().then((value) {
      print('Token is : ');
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
