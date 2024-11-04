import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/api_service.dart';
import 'package:latihan_5/Notifikasi/BackgroundService.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:latihan_5/Notifikasi/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'movie_channel',
        channelName: 'Movie Notifications',
        channelDescription: 'Notification channel for movie updates',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ApiService1 apiService = ApiService1();

  BackgroundService.start();

  runApp(MyApp(
    notificationService: NotificationService(
      apiService: apiService,
      firestore: firestore,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  MyApp({required this.notificationService});

  @override
  Widget build(BuildContext context) {
    notificationService.initializeNotifications();
    return MaterialApp(
      title: 'Flutter Movie App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}