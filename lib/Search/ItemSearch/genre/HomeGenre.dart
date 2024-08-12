import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/api_service.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';
import 'package:latihan_5/Search/ItemSearch/genre/search_genre.dart';

class HomeGenre extends StatelessWidget {
  final Genre genre;
  final List<Genre> allGenres;

  HomeGenre({required this.genre, required this.allGenres});

  @override
  Widget build(BuildContext context) {
    // Urutkan genre yang dipilih agar tetap di depan
    List<Genre> orderedGenres = [
      genre,
      ...allGenres.where((g) => g.id != genre.id)];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          genre.name, // Menampilkan nama genre di AppBar
          style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF292929),
      body: FutureBuilder<List<Movie>>(
        future: ApiService.searchMoviesByGenre(genre.id), // Menampilkan film berdasarkan genre yang dipilih
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada film yang ditemukan', style: (TextStyle(color: Colors.white))));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context,index) {
                final movie = snapshot.data![index];
                // Kirimkan orderedGenres ke SearchGenre
                return SearchGenre(
                  movie: movie,
                  orderGenres: orderedGenres, // Berikan orderedGenres
                );
              },
            );
          }
        },
      ),
    );
  }
}