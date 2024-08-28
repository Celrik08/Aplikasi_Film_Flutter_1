import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'package:latihan_5/DetailFilms/VideoTrailer/models.dart';

class ApiService {
  static final String baseUrl = 'https://api.themoviedb.org/3';
  static final String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static final String accessToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S0GqrO_e5XXS8LkhndDz7VsPwStuCuMbL_hKigB7l_A';

  static Future<MovieDetail> fetchMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US'),
      headers: {'Authorization': accessToken},
    );

    if (response.statusCode == 200) {
      final movieDetail = MovieDetail.fromJson(jsonDecode(response.body));

      // Fetch cast and crew details
      final creditsResponse = await http.get(
        Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'),
        headers: {'Authorization': accessToken},
      );

      if (creditsResponse.statusCode == 200) {
        final creditsJson = jsonDecode(creditsResponse.body);

        final List<People> cast = (creditsJson['cast'] as List?)?.take(9).map((json) => People.fromJson(json)).toList() ?? [];
        final List<People> crew = (creditsJson['crew'] as List?)?.map((json) => People.fromJson(json)).toList() ?? [];

        return movieDetail.copyWith(castCrew: [...cast, ...crew]);
      } else {
        throw Exception('Failed to load cast and crew details');
      }
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  static Future<List<MovieVideo>> fetchMovieVideos(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=en-US'),
      headers: {'Authorization': accessToken},
    );

    if (response.statusCode == 200) {
      final videosJson = jsonDecode(response.body);
      final videoList = (videosJson['results'] as List?)?.map((videoJson) => MovieVideo.fromJson(videoJson)).toList() ?? [];

      return videoList;
    } else {
      throw Exception('Gagal memuat video trailer');
    }
  }
}