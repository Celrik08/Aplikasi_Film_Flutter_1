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
          title: Row(
            children: [
              Expanded(
                child: Text(
                  movie.title,
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.search, color: Colors.black)
            ],
          ),
          onTap: () => onSuggestionSelected(movie.title),
        );
      },
    );
  }
}