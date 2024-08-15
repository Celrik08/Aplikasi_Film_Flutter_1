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
      appBar: AppBar(
        title: Text('Detail Film'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<MovieDetail>(
          future: futureMovieDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Tidak ada detail yang ditemukan'));
            } else {
              final movieDetail = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris pertama: Gambar poster, judul, release, genre
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar poster
                        Image.network(
                          'https://image.tmdb.org/t/p/w500${movieDetail.posterPath}',
                          width: 100,
                        ),
                        SizedBox(width: 16),
                        // Detail film (judul, release date, genre)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieDetail.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                movieDetail.releaseDate,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 8),
                              Text(
                                movieDetail.genres.map((genre) => genre.name).join(', '),
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Overview section
                    Text(
                      'Overview:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(movieDetail.overview),
                    SizedBox(height: 16),
                    // Produser, Director, Writer sections
                    Text('Produser:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...movieDetail.producers.map((producer) => Text(producer.name)).toList(),
                    SizedBox(height: 16),
                    Text('Director:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...movieDetail.directors.map((director) => Text(director.name)).toList(),
                    SizedBox(height: 16),
                    Text('Writer:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...movieDetail.writers.map((writer) => Text(writer.name)).toList(),
                    SizedBox(height: 16),
                    // Production Companies section
                    Text('Production Companies:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...movieDetail.productionCompanies
                        .map((company) => Text(company.name))
                        .toList(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}