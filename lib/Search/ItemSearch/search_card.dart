import 'package:flutter/material.dart';
import 'models_search.dart';
import 'package:latihan_5/Image/MovieNull/MovieNull.dart';
import 'package:latihan_5/DetailFilms/detail_film.dart';

class SearchCard extends StatelessWidget {
  final Movie movie;

  SearchCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailFilm(movieId: movie.id), // Pass movieId to DetailFilm
          ),
        );
      },
      child: Card(
        color: Color(0xFF545454),
        margin: EdgeInsets.all(3.0),
        child: Row(
          children: [
            Container(
              width: 100, // Atur lebar gambar
              height: 150, // Atur tinggi gambar
              child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                  ? Image.network(
                'http://image.tmdb.org/t/p/w500/${movie.posterPath}',
                fit: BoxFit.cover,
              )
                  : MovieNull(), // If posterPath is null, show MovieNull
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      movie.genres.map((genre) => genre.name).join(', '),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}