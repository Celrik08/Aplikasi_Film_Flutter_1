import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';

class FilterMenu extends StatelessWidget {
  final List<Movie> suggestions;
  final Function(String, String) onSuggestionSelected;

  FilterMenu({required this.suggestions, required this.onSuggestionSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final movie = suggestions[index];
        return ListTile(
          tileColor: Color(0xFF444444),
          title: Row(
            children: [
              Icon(Icons.search, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  movie.title,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.clip, // Tidak memotong judul
                ),
              ),
            ],
          ),
          onTap: () {
            onSuggestionSelected(movie.title, movie.title);
          },
        );
      },
    );
  }
}
