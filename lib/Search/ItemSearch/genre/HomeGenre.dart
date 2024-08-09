import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/api_service.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';
import 'package:latihan_5/Search/ItemSearch/genre/search_genre.dart';

class HomeGenre extends StatelessWidget {
  final Genre genre;
  
  HomeGenre({required this.genre});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Text(
          genre.name, // Menampilkan nama genre di AppBar
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF292929),
      body: FutureBuilder<List<Movie>>(
        future: ApiService.searchMoviesByGenre(genre.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada film yang ditemukan'))
          }
        },
      ),
    );
  }
}