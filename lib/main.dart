import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/api_service.dart';
import 'package:latihan_5/Notifikasi/BackgroundService.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:latihan_5/Notifikasi/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Define navigatorKey globally so it can be accessed from NotificationService
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Inisialisasi ApiService dari file yang benar
  final ApiService1 apiService = ApiService1(); // Pastikan ini sesuai dengan NotificationService

  // Inisialisasi notifikasi
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

  // Membuat instance dari NotificationService dengan argumen yang diperlukan
  final NotificationService notificationService = NotificationService(
    apiService: apiService,
    firestore: firestore,
  );

  // Memulai layanan latar belakang dengan instance NotificationService
  BackgroundService.start();

  // Run the app with NotificationService passed to MyApp
  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  MyApp({required this.notificationService});

  @override
  Widget build(BuildContext context) {
    notificationService.initializeNotifications();

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