import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';

class SearchGenre extends StatelessWidget {
  final Movie movie;

  SearchGenre({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF545454),
      margin: EdgeInsets.all(3.0),
      child: Row(
        children: [
          Container(
            width: 100, // Atur lebar gambar
            height: 150, // Atur tinggi gambar
            child: Image.network(
              'http://image.tmdb.org/t/p/w500/${movie.posterPath}',
              fit: BoxFit.cover,
            ),
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
    );
  }
}