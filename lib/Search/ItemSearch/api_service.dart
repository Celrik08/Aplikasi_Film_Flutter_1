import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models_search.dart';

class ApiService {
  static const String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static const String accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsIm5iZiI6MTcyMTA5ODI4MC4yMDI0MjMsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.g-zJiUOUjVaj2MnTMJadMV0aMdIEXgamxTv30SOGZUg';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic>? results = jsonResponse['results'] as List<dynamic>?;
      if (results != null) {
        // Panggil detail film untuk mendapatkan genre
        List<Movie> movies = [];
        for (var movieData in results) {
          Movie movie = Movie.fromJson(movieData);
          movie = await getMovieDetails(movie.id);
          movies.add(movie);
        }
        return movies;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=en-Us'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Movie.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  static Future<List<Genre>> getGenres() async {
    final response = await http.get(
      Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> genresJson = jsonResponse['genres'];
      return genresJson.map((genreJson) => Genre.fromJson(genreJson)).toList();
    } else {
      throw Exception('Gagal memuat genre');
    }
  }

  static Future<List<Movie>> searchMovies1(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?query=$query&api_key=$apiKey'),
      headers: {
        'Authorization' : accessToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Movie> movies = List<Movie>.from(data['results'].map((x) => Movie.fromJson(x)));
      return movies;
    } else {
      throw Exception('Gagal mencari film');
    }
  }
}