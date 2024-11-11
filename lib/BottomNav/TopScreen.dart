import 'package:flutter/material.dart';
import 'package:latihan_5/APIMovies/ApiTop/api_service.dart';
import 'package:latihan_5/APIMovies/ApiTop/models.dart';
import 'package:latihan_5/APIMovies/ApiTop/movie_card.dart';

class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  late Future<TopResponse> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService.getTopMovies(); // Update to use Top Rated movies
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 12),
        child: AppBar(
          backgroundColor: Color(0xFF292929),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Rated Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Discover top rated movies',
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
        color: Color(0xFF292929),
        child: FutureBuilder<TopResponse>(
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