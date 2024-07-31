import 'package:flutter/material.dart';
import 'package:latihan_5/Search/ItemSearch/api_service.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';
import 'package:latihan_5/Search/ItemSearch/search_card.dart';

class HomeSearch extends StatefulWidget {
  final String query;

  HomeSearch({required this.query});

  @override
  _HomeSearchState createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService.searchMovies(widget.query);
  }

  @override
  void didUpdateWidget(covariant HomeSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      futureMovies = ApiService.searchMovies(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: AppBar(
          backgroundColor: Color(0xFF292929),
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Hasil Search',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFF292929),
        child: FutureBuilder<List<Movie>>(
          future: futureMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('Tidak ada film yang ditemukan',
                      style: TextStyle(color: Colors.white)));
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
      ),
    );
  }
}