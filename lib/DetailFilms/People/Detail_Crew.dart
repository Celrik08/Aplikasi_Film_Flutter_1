import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/api_service.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';
import 'package:latihan_5/DetailFilms/People/card_crew.dart';

class DetailCrew extends StatelessWidget {
  final int movieId;

  DetailCrew({required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292929),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: FutureBuilder<MovieDetail>(
          future: ApiService.fetchMovieDetail(movieId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...', style: TextStyle(color: Colors.white));
            } else if (snapshot.hasError || !snapshot.hasData) {
              return Text('Error');
            } else {
              final movieDetail = snapshot.data!;
              return Text(movieDetail.title,
                  style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis, // Menambahkan ellips jika teks terlalu panjang
              );
            }
          },
        ),
      ),
      body: FutureBuilder<MovieDetail>(
        future: ApiService.fetchMovieDetail(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final movieDetail = snapshot.data!;
            final crew = movieDetail.allPeople;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Crew (${crew.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: crew.length,
                    itemBuilder: (context, index) {
                      return CardCrew(person: crew[index]);
                    },
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