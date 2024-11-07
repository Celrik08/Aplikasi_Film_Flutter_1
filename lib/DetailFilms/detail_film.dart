import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/api_service.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';
import 'package:latihan_5/DetailFilms/VideoTrailer/TrailerYotube.dart';
import 'package:latihan_5/DetailFilms/VideoTrailer/models.dart';
import 'package:latihan_5/DetailFilms/People/card_people.dart';
import 'package:latihan_5/DetailFilms/People/DetailPeople/DetailCrew/Detail_Crew.dart';
import 'package:latihan_5/Image/TrailerNull/TrailerNull.dart';
import 'package:latihan_5/Image/MovieNull/MovieNull.dart';

class DetailFilm extends StatefulWidget {
  final int movieId;

  DetailFilm({required this.movieId});

  @override
  _DetailFilmState createState() => _DetailFilmState();
}

class _DetailFilmState extends State<DetailFilm> {
  late Future<MovieDetail> futureMovieDetail;
  late Future<List<MovieVideo>> futureMovieVideos;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    futureMovieDetail = ApiService.fetchMovieDetail(widget.movieId);
    futureMovieVideos = ApiService.fetchMovieVideos(widget.movieId);
  }

  void _showTrailerDialog(String videoKey) {
    setState(() {
      _isVideoPlaying = true;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              _isVideoPlaying = false;
            });
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {},
              child: Center(
                child: TrailerYouTube(videoKey: videoKey),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF292929),
      body: FutureBuilder<MovieDetail>(
        future: futureMovieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
            );
          } else if (snapshot.hasData) {
            final movie = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<List<MovieVideo>>(
                    future: futureMovieVideos,
                    builder: (context, videoSnapshot) {
                      if (videoSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (videoSnapshot.hasError || !videoSnapshot.hasData || videoSnapshot.data!.isEmpty) {
                        return TrailerNull();
                      } else {
                        final videoKey = videoSnapshot.data!.first.key;
                        // Kondisi jika backdropPath dan posterPath tidak null atau kosong
                        final hasBackdrop = movie.backdropPath != null && movie.backdropPath!.isNotEmpty;

                        return GestureDetector(
                          onTap: hasBackdrop
                              ? () {
                                  _showTrailerDialog(videoKey);
                                }
                              : null, // Tidak dapat ditekan jika backdropPath atau posterPath null atau kosong
                          child: Stack(
                            children: [
                              hasBackdrop
                                  ? Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 250,
                                    )
                                  : TrailerNull(), // Jika backdropPath atau posterPath null, tampilkan TrailerNull
                              if (hasBackdrop) // Tampilkan icon hanya jika backdropPath dan posterPath ada
                                Positioned.fill(
                                  child: Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  width: 100,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : MovieNull(), // If posterPath is null, show MovieNull
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${movie.releaseDate}', // Display only date, month, and year
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              Text(
                                movie.genres.map((genre) => genre.name).join(', '),
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (movie.overview.isNotEmpty) ...[
                          Text(
                            'Overview:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(movie.overview, style: TextStyle(color: Colors.white)),
                          SizedBox(height: 16),
                        ],
                        // Producers
                        Text(
                          'Producers:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5), // Add spacing between the title and the names
                        if (movie.producers.isNotEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: movie.producers.map((producer) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 1.0), // Space between names
                                child: Text(
                                  producer.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ] else
                          Text('-', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16), // Add spacing after the producers section

                        // Directors
                        Text(
                          'Directors:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5), // Add spacing between the title and the names
                        if (movie.directors.isNotEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: movie.directors.map((director) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 1.0), // Space between names
                                child: Text(
                                  director.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ] else
                          Text('-', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16), // Add spacing after the directors section

                        // Writers
                        Text(
                          'Writers:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5), // Add spacing between the title and the names
                        if (movie.writers.isNotEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: movie.writers.map((writer) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 1.0), // Space between names
                                child: Text(
                                  writer.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ] else
                          Text('-', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16), // Add spacing after the writers section

                        // Production Companies
                        Text(
                          'Production Companies:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5), // Add spacing between the title and the names
                        if (movie.productionCompanies.isNotEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: movie.productionCompanies.map((company) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 1.0), // Space between names
                                child: Text(
                                  company.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                          ),
                        ] else
                          Text('-', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16), // Add spacing after the production companies section
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Cast:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 230, // Adjust the height to accommodate the CardPeople items.
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movie.castCrew.length > 9 ? 10 : movie.castCrew.length,
                      itemBuilder: (context, index) {
                        if (index == 9 && movie.castCrew.length > 9) {
                          // Display the "View More" button
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 120,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailCrew(
                                          allPeople: movie.allPeople,
                                          movieId: widget.movieId,
                                          movieTitle: movie.title,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('View More', style: TextStyle(fontSize: 12)),
                                      Icon(Icons.arrow_forward, size: 12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Display each CardPeople widget
                        final person = movie.castCrew[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to DetailPerson screen
                          },
                          child: CardPeople(person1: person),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No data available', style: TextStyle(color: Colors.white)),
            );
          }
        },
      ),
    );
  }
}