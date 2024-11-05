import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService1 {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static const String accessToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S0GqrO_e5XXS8LkhndDz7VsPwStuCuMbL_hKigB7l_A';
  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String fcmServerKey = 'BBF4MaKOYiMRQkuoWgFHTWZW54s8bprpDmIYxBfl7SpednYNgcmPdhrx_BWJYgYDJd97UUXtGTt3by7xb1jxt6E';

  // Fungsi untuk menampilkan notifikasi menggunakan Awesome Notifications
  static Future<void> showNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
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

  // Fungsi untuk mengirim notifikasi ke FCM
  static Future<void> sendNotificationToFCM(String title, String body, {String? token}) async {
    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Authorization': 'key=$fcmServerKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "to": token ?? "/topics/movie_updates", // Kirim ke token atau topik
          "notification": {
            "title": title,
            "body": body,
            "sound": "default",
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "screen": "home",
          }
        }),
      );

      if (response.statusCode == 200) {
        print('Notifikasi berhasil dikirim: ${response.body}');
      } else {
        print('Gagal mengirim notifikasi: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error saat mengirim notifikasi: $e');
    }
  }

  // Get Upcoming Movies
  static Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey'),
      headers: {
        'Authorization': accessToken,
      },
    );
    if (response.statusCode == 200) {
      return MovieResponse.fromJson(jsonDecode(response.body)).results;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

// Get Now Playing Movies
  static Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'),
      headers: {
        'Authorization': accessToken,
      },
    );
    if (response.statusCode == 200) {
      return MovieResponse.fromJson(jsonDecode(response.body)).results;
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }
}