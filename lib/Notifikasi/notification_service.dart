import 'package:latihan_5/Notifikasi/ApiNotifikasi/api_service.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  final ApiService1 apiService;
  final FirebaseFirestore firestore;

  NotificationService({required this.apiService, required this.firestore});

  // Inisialisasi Firebase Messaging
  Future<void> initializeNotifications() async {
    // Mendapatkan FCM token
    await getToken();

    // Subscribe to topic
    FirebaseMessaging.instance.subscribeToTopic("movie_updates");

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
        );
      }
    });

    // Handle messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> getToken() async {
    // Mendapatkan token FCM
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");

    // Menangani pembaruan token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("FCM Token yang diperbarui: $newToken");
    }).onError((err) {
      print("Error saat mendapatkan token: $err");
    });
  }

  // Show local notification using Awesome Notifications
  void showNotification(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10, // Ensure this is unique
        channelKey: 'movie_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN_HOME',
          label: 'Buka Aplikasi',
          actionType: ActionType.Default,
        ),
      ],
    );
  }

  // Handle message navigation
  void _handleMessage(RemoteMessage message) {
    // Implement navigation logic based on message data
    // Example:
    if (message.data['type'] == 'chat') {
      // Navigate to chat screen with data
    }
  }

  // Check for movie updates and send notifications
  Future<void> checkForMovieUpdates() async {
    await _checkAndNotifyMovies('upcoming');
    await _checkAndNotifyMovies('now_playing');
  }

  // Function to check for and notify movie updates
  Future<void> _checkAndNotifyMovies(String type) async {
    List<Movie> movies = (type == 'upcoming')
        ? await ApiService1.getUpcomingMovies()
        : await ApiService1.getNowPlayingMovies();

    for (var movie in movies) {
      bool notified = await _isMovieNotified(movie.id, type);
      if (!notified && type == 'now_playing') {
        await ApiService1.sendNotificationToFCM(
          'Film ${movie.title} telah tayang di bioskop terdekat!',
          'Ayo saksikan segera film yang Anda tunggu-tunggu!',
        );
        await _markMovieAsNotified(movie.id, type);
      }
    }
  }

  Future<bool> _isMovieNotified(int movieId, String type) async {
    DocumentSnapshot doc = await firestore.collection(type).doc(movieId.toString()).get();
    return doc.exists;
  }

  Future<void> _markMovieAsNotified(int movieId, String type) async {
    await firestore.collection(type).doc(movieId.toString()).set({'notified': true});
  }

  // Function to send a test notification
  Future<void> sendTestNotification() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await ApiService1.sendNotificationToFCM(
        'Notifikasi Uji Coba',
        'Ini adalah pesan uji coba notifikasi FCM.',
        token: fcmToken,
      );
      showNotification(
        'Notifikasi Uji Coba',
        'Ini adalah pesan uji coba dari awesome_notifications.',
      );
    } else {
      print('Gagal mendapatkan token FCM');
    }
  }
}