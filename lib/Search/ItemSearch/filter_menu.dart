import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';

class FilterMenu extends StatelessWidget {
  final List<Movie> suggestions;
  final Function(String, String) onSuggestionSelected;

  FilterMenu({required this.suggestions, required this.onSuggestionSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF545454), // Mengatur warna latar belakang
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final movie = suggestions[index];
          return ListTile(
            title: Text(
              movie.title,
              style: TextStyle(color: Colors.white), // Mengatur warna teks
            ),
            onTap: () => onSuggestionSelected(movie.title, 'movie'),
          );
        },
      ),
    );
  }
}