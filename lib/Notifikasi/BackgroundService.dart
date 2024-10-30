import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/api_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:latihan_5/Notifikasi/notification_service.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notificationService = NotificationService(
      apiService: ApiService1(),
      firestore: FirebaseFirestore.instance,
    );
    notificationService.initializeNotifications();
    await notificationService.checkForMovieUpdates();
    return Future.value(true);
  });
}

class BackgroundService {
  static void start() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    Workmanager().registerPeriodicTask(
      "1",
      "movieUpdatesTask",
      frequency: Duration(seconds: 15),  // Set interval to 15 minutes for production use
    );
  }

  static void stop() {
    Workmanager().cancelAll();
  }
}