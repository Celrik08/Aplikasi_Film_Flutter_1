import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService1 {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static const String accessToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S0GqrO_e5XXS8LkhndDz7VsPwStuCuMbL_hKigB7l_A';
  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send/ABCD1234';
  static const String fcmServerKey = 'BBF4MaKOYiMRQkuoWgFHTWZW54s8bprpDmIYxBfl7SpednYNgcmPdhrx_BWJYgYDJd97UUXtGTt3by7xb1jxt6E';

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