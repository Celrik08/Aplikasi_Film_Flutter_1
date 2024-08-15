import 'package:flutter/material.dart';
import 'package:latihan_5/APIMovies/ApiNowPlaying/api_service.dart';
import 'package:latihan_5/APIMovies/ApiNowPlaying/models.dart';
import 'package:latihan_5/APIMovies/ApiNowPlaying/movie_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<NowPlayingResponse> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService.getNowPlayingMovies(); // Inisialisasi Future di sini
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
                'Now Playing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Exciting movies that will entertain you',
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
        child: FutureBuilder<NowPlayingResponse>(
          future: ApiService.getNowPlayingMovies(),
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