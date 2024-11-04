import 'package:latihan_5/Notifikasi/ApiNotifikasi/api_service.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final ApiService1 apiService;
  final FirebaseFirestore firestore;

  NotificationService({required this.apiService, required this.firestore});

  // Inisialisasi Firebase Messaging untuk subskripsi topik dan penerimaan pesan
  void initializeNotifications() {
    FirebaseMessaging.instance.subscribeToTopic("movie_updates");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
        );
      }
    });
  }

  // Fungsi untuk menampilkan notifikasi lokal menggunakan Awesome Notifications
  void _showLocalNotification(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
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

  // Memeriksa pembaruan film dari TMDB secara real-time
  Future<void> checkForMovieUpdates() async {
    await _checkAndNotifyMovies('upcoming');
    await _checkAndNotifyMovies('now_playing');
  }

  // Fungsi umum untuk memeriksa dan notifikasi jika film berubah status
  Future<void> _checkAndNotifyMovies(String type) async {
    List<Movie> movies = (type == 'upcoming')
        ? await ApiService1.getUpcomingMovies()
        : await ApiService1.getNowPlayingMovies();

    for (var movie in movies) {
      bool notified = await _isMovieNotified(movie.id, type);
      if (!notified && type == 'now_playing') {
        await _sendNotificationToFirebase(
          'Film ${movie.title} telah tayang di bioskop terdekat!',
          'Ayo saksikan segera film yang Anda tunggu-tunggu!',
        );
        _showLocalNotification(
          'Film ${movie.title} telah tayang di bioskop terdekat!',
          'Ayo saksikan segera film yang Anda tunggu-tunggu!',
        );
        await _markMovieAsNotified(movie.id, type);
      }
    }
  }

  // Fungsi untuk mengirimkan notifikasi ke Firebase Messaging
  Future<void> _sendNotificationToFirebase(String title, String body) async {
    final response = await http.post(
      Uri.parse(ApiService1.fcmUrl),
      headers: {
        'Authorization': 'key=${ApiService1.fcmServerKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "to": "/topics/movie_updates",
        "notification": {
          "title": title,
          "body": body,
        },
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send notification to Firebase Messaging');
    }
  }

  // Cek apakah notifikasi sudah diberitahukan
  Future<bool> _isMovieNotified(int movieId, String type) async {
    DocumentSnapshot doc = await firestore.collection(type).doc(movieId.toString()).get();
    return doc.exists;
  }

  // Tandai film sebagai diberitahukan di Firebase Firestore
  Future<void> _markMovieAsNotified(int movieId, String type) async {
    await firestore.collection(type).doc(movieId.toString()).set({'notified': true});
  }
}