import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  static final String baseUrl = 'https://api.themoviedb.org/3';
  static final String apiKey = '09bcce0c01e9a96d930f10be3c1b5d4e';
  static final String accessToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJjY2UwYzAxZTlhOTZkOTMwZjEwYmUzYzFiNWQ0ZSIsInN1YiI6IjY1ZDMwMGJkNzYxNDIxMDE3Y2ZmYzI1YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S0GqrO_e5XXS8LkhndDz7VsPwStuCuMbL_hKigB7l_A';

  static Future<MovieDetail> fetchMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=en-US'),
      headers: {
        'Authorization' : accessToken,
      },
    );

    if (response.statusCode == 200) {
      final movieDetail = MovieDetail.fromJson(jsonDecode(response.body));

      // Ambil detail kru
      final crewResponse = await http.get(
        Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey'),
        headers: {
          'Authorization': accessToken,
        },
      );

      if (crewResponse.statusCode == 200) {
        final crewJson = jsonDecode(crewResponse.body);
        final producers = (crewJson['crew'] as List)
            .where((person) => person['job'] == 'Producer')
            .map((person) => Cast.fromJson(person))
            .toList();

        final directors = (crewJson['crew'] as List)
            .where((person) => person['job'] == 'Director')
            .map((person) => Cast.fromJson(person))
            .toList();

        final writers = (crewJson['crew'] as List)
            .where((person) => person['job'] == 'Writer')
            .map((person) => Cast.fromJson(person))
            .toList();

        return movieDetail.copyWith(
          producers: producers,
          directors: directors,
          writers: writers,
        );
      } else {
        throw Exception('Gagal memuat detail kru');
      }
    } else {
      throw Exception('Gagal memuat detail film');
    }
  }
}