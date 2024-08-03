import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/api_service.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';
import 'package:latihan_5/Search/ItemSearch/search_card.dart';

class HomeSearch extends StatelessWidget {
  final String query;

  HomeSearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF292929),
      child: FutureBuilder<List<Movie>>(
        future: ApiService.searchMovies(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada film yang ditemukan', style: TextStyle(color: Colors.white)));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SearchCard(movie: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}