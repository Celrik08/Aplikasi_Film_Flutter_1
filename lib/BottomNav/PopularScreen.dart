import 'package:flutter/material.dart';
import 'package:latihan_5/APIMovies/ApiPopular/api_service.dart';
import 'package:latihan_5/APIMovies/ApiPopular/models.dart';
import 'package:latihan_5/APIMovies/ApiPopular/movie_card.dart';

class PopularScreen extends StatefulWidget {
  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  late Future<PopularResponse> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService.getPopularMovies(); // Update to use Popular movies
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 12), // Tinggi yang diinginkan untuk AppBar
        child: AppBar(
          backgroundColor: Color(0xFF292929), // Mengatur warna AppBar menjadi abu-abu
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Discover popular movies currently trending',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Color(0xFF292929), // Mengatur warna latar belakang
        child: FutureBuilder<PopularResponse>(
          future: futureMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
              return Center(child: Text('No movies found', style: TextStyle(color: Colors.white)));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data!.results.length,
                itemBuilder: (context, index) {
                  return MovieCard(movie: snapshot.data!.results[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}