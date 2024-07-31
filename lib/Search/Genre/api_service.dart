import 'dart:convert';
import 'package:http/http.dart';
import 'package:latihan_5/Search/Genre/models.dart';

class ApiService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static const String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsIm5iZiI6MTcyMTA5ODI4MC4yMDI0MjMsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.g-zJiUOUjVaj2MnTMJadMV0aMdIEXgamxTv30SOGZUg';

  static Future<List<Movie>> searchAllMovies() async {
    List<Movie> allMovies = [];
    int page = 1;
    bool haMorePages = true;

    while (haMorePages) {
      final response = await http.get(
        Ur
      );
    }
  }
}