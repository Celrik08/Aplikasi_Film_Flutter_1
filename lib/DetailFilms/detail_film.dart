import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/api_service.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';

class DetailFilm extends StatefulWidget {
  final int movieId;

  DetailFilm({required this.movieId});

  @override
  _DetailFilmState createState() => _DetailFilmState();
}

class _DetailFilmState extends State<DetailFilm> {
  late Future<MovieDetail> futureMovieDetail;

  @override
  void initState() {
    super.initState();
    futureMovieDetail = ApiService.fetchMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Membuat AppBar transparan
        elevation: 0, // Menghilangkan bayangan AppBar
        iconTheme: IconThemeData(color: Colors.white), // Warna putih untuk tombol kembali
      ),
      backgroundColor: Color(0xFF545454), // Warna latar belakang
      body: FutureBuilder<MovieDetail>(
        future: futureMovieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada detail yang ditemukan', style: TextStyle(color: Colors.white)));
          } else {
            final movieDetail = snapshot.data!;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menampilkan gambar backdrop
                      if (movieDetail.backdropPath.isNotEmpty)
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${movieDetail.backdropPath}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 60), // Memberikan jarak agar konten tidak terhalang AppBar
                            // Poster, judul, tanggal rilis, dan genre
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar poster
                                Image.network(
                                  'https://image.tmdb.org/t/p/w500${movieDetail.posterPath}',
                                  width: 100,
                                ),
                                SizedBox(width: 16),
                                // Detail film
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movieDetail.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // Warna teks putih
                                        ),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        movieDetail.releaseDate,
                                        style: TextStyle(fontSize: 15, color: Colors.white),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        movieDetail.genres
                                            .map((genre) => genre.name)
                                            .join(', '),
                                        style: TextStyle(fontSize: 15, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Bagian Overview
                            Text(
                              'Overview:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Warna teks putih
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              movieDetail.overview,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 16),
                            // Bagian Produser
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
                            // Bagian Sutradara
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
                            // Bagian Penulis
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
                            // Bagian Production Companies
                            Text('Production Companies:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            movieDetail.productionCompanies.isNotEmpty
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: movieDetail.productionCompanies
                                  .map((company) => Text(company.name, style: TextStyle(color: Colors.white)))
                                  .toList(),
                            )
                                : Text('-', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
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