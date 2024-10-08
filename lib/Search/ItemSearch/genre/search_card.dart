import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';

class CardGenre extends StatelessWidget {
  final Genre genre;

  CardGenre({required this.genre});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth( // Sesuaikan lebar dengan konten
      child: IntrinsicWidth( // Sesuaikan tinggi dengan konten
       child: Card(
          color: Color(0xFF545454),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0), // Padding di dalam card
            child: Center(
              child: Text(
                genre.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center, // Memastikan teks di-center
              ),
            ),
          ),
        ),
      )
    );
  }
}