import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';

class FilterMenu extends StatelessWidget {
  final List<Movie> suggestions;
  final Function(String) onSuggestionSelected;

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
              Icon(Icons.search,color: Colors.white), // Tempatkan ikon di sini
              SizedBox(width: 8), // Tambahkan spasi antara ikon dan teks
              Expanded(
                child: Text(
                  movie.title,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          onTap: () => onSuggestionSelected(movie.title),
        );
      },
    );
  }
}