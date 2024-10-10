import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/detail_film.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';

class MovieCard2 extends StatelessWidget {
  final Movie movie;

  MovieCard2({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailFilm(movieId: movie.id),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(3.0),
        color: Color(0xFF545454),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              child: Image.network(
                'http://image.tmdb.org/t/p/w500/${movie.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}