import 'dart:convert';
import 'package:http/http.dart' as http; // tambahkan import http di sini
import 'models.dart';

class ApiService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static const String accessToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S0GqrO_e5XXS8LkhndDz7VsPwStuCuMbL_hKigB7l_A';

  // Updated method to fetch Popular movies
  static Future<PopularResponse> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
      headers: {
        'Authorization' : accessToken,
      },
    );

    if (response.statusCode == 200) {
      return PopularResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}