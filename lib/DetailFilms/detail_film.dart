import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/api_service.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';
import 'package:latihan_5/DetailFilms/VideoTrailer/TrailerYotube.dart';
import 'package:latihan_5/DetailFilms/VideoTrailer/models.dart';

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
      _isVideoPlaying = true; // Set state when video starts playing
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog
            setState(() {
              _isVideoPlaying = false; // Set state when dialog is closed
            });
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {}, // Prevent closing the dialog when tapping inside the container
              child: Center(
                child: TrailerYouTube(
                  videoKey: videoKey,
                ),
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
      backgroundColor: Color(0xFF545454),
      body: FutureBuilder<MovieDetail>(
        future: futureMovieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Tidak ada detail yang ditemukan', style: TextStyle(color: Colors.white)),
            );
          } else {
            final movieDetail = snapshot.data!;
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
                        return Container();
                      } else {
                        final videoKey = videoSnapshot.data!.first.key; // Get the first video key
                        return GestureDetector(
                          onTap: () {
                            _showTrailerDialog(videoKey);
                          },
                          child: Stack(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w500${movieDetail.backdropPath}',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://image.tmdb.org/t/p/w500${movieDetail.posterPath}',
                              width: 100,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movieDetail.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    movieDetail.releaseDate,
                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    movieDetail.genres.map((genre) => genre.name).join(', '),
                                    style: TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Overview:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movieDetail.overview,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text('Produser:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        movieDetail.producers.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: movieDetail.producers
                              .map((producer) => Text(producer.name, style: TextStyle(color: Colors.white)))
                              .toList(),
                        )
                            : Text('-', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16),
                        Text('Director:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        movieDetail.directors.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: movieDetail.directors
                              .map((director) => Text(director.name, style: TextStyle(color: Colors.white)))
                              .toList(),
                        )
                            : Text('-', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16),
                        Text('Writer:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        movieDetail.writers.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: movieDetail.writers
                              .map((writer) => Text(writer.name, style: TextStyle(color: Colors.white)))
                              .toList(),
                        )
                            : Text('-', style: TextStyle(color: Colors.white)),
                        SizedBox(height: 16),
                        Text('Production Companies:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        movieDetail.productionCompanies.isNotEmpty
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: movieDetail.productionCompanies
                              .map((company) => Text(company.name, style: TextStyle(color: Colors.white)))
                              .toList(),
                        )
                            : Text('-', style: TextStyle(color: Colors.white)),
                        // Add padding at the bottom to avoid content being cut off
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30), // Provide extra space at the bottom
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}