import 'dart:async';
import 'package:workmanager/workmanager.dart';
import 'package:latihan_5/Notifikasi/notification_service.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notificationService = NotificationService();
    notificationService.initializeNotifications();
    await notificationService.checkForMovieUpdates();
    return Future.value(true);
  });
}

class BackgroundService {
  static void start() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false, // Disable debug mode for production
    );

    // Set periodic task to run every 15 minutes
    Workmanager().registerPeriodicTask(
      "1",
      "movieUpdatesTask",
      frequency: Duration(seconds: 30),
    );
  }

  static void stop() {
    Workmanager().cancelAll();
  }
}