import 'package:flutter/material.dart';
import 'package:latihan_5/Notifikasi/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'home_page.dart';
import 'package:latihan_5/Notifikasi/BackgroundService.dart';

// Define navigatorKey globally so it can be accessed from NotificationService
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Awesome Notifications
  AwesomeNotifications().initialize('resource_key', [
    NotificationChannel(
      channelKey: 'movie_updates_channel',
      channelName: 'Movie Updates',
      channelDescription: 'Notification channel for movie updates',
      defaultColor: Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,
    ),
  ]);

  BackgroundService.start(); // Start background service
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationService().initializeNotifications();

    return MaterialApp(
      title: 'Flutter Movie App',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
