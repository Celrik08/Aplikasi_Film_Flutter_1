import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static const String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsIm5iZiI6MTcyMTA5ODI4MC4yMDI0MjMsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.g-zJiUOUjVaj2MnTMJadMV0aMdIEXgamxTv30SOGZUg';

  static Future<List<Movie>> searchAllMovies() async {
    List<Movie> allMovies = [];
    int page = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      final response1 = await http.get(
        Uri.parse('$baseUrl/discover/movie?page=$page&api_key=$apiKey'),
        headers: {
          'Authorization': accessToken,
        },
      );

      if (response1.statusCode == 200) {
        final data1 = jsonDecode(response1.body);
        List<Movie> movies1 = List<Movie>.from(data1['results'].map((x) => Movie.fromJson(x)));
        allMovies.addAll(movies1);

        hasMorePages = data1['page'] < data1['total_pages'];
        page++;
      } else {
        throw Exception('Failed to load movies');
      }
    }

    return allMovies;
  }
}