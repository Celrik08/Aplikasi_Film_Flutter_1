import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/api_service.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';
import 'package:latihan_5/DetailFilms/VideoTrailer/TrailerYotube.dart';
import 'package:latihan_5/DetailFilms/VideoTrailer/models.dart';
import 'package:latihan_5/DetailFilms/People/card_people.dart';
import 'package:latihan_5/DetailFilms/People/Detail_Crew.dart';

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
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FutureBuilder<List<MovieVideo>>(
                    future: futureMovieVideos,
                    builder: (context, videoSnapshot) {
                      if (videoSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (videoSnapshot.hasError || !videoSnapshot.hasData || videoSnapshot.data!.isEmpty) {
                        return Container();
                      } else {
                        final videoKey = videoSnapshot.data!.first.key;
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
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
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
                            // Daftar Cast
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Cast:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 250, // Sesuaikan tinggi sesuai kebutuhan
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieDetail.crew2.length > 9 ? 10 : movieDetail.crew2.length,
                      itemBuilder: (context, index) {
                        if (index == 9) {
                          // Tampilkan tombol "View More"
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0), // Jarak horizontal dari tombol lain
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 120, // Sesuaikan lebar tombol
                                height: 30, // Sesuaikan tinggi tombol
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailCrew(movieId: widget.movieId),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, // Warna latar belakang tombol
                                    foregroundColor: Colors.white, // Warna teks tombol
                                    elevation: 0, // Menghilangkan bayangan
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'View More',
                                        style: TextStyle(fontSize: 12), // Sesuaikan ukuran teks jika diperlukan
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Tampilkan kru
                          return CardPeople(person: movieDetail.crew2[index]);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}