import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';


class DetailPerson extends StatelessWidget {
  final Future<PersonDetail> futurePerson; // Change to use Future

  DetailPerson({required this.futurePerson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292929),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: FutureBuilder<PersonDetail>(
          future: futurePerson,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...', style: TextStyle(color: Colors.white));
            } else if (snapshot.hasError) {
              return Text('Error', style: TextStyle(color: Colors.white));
            } else if (snapshot.hasData) {
              return Text(snapshot.data!.name, style: TextStyle(color: Colors.white));
            }
            return Text('No Data', style: TextStyle(color: Colors.white));
          },
        ),
        backgroundColor: Color(0xFF292929),
      ),
      body: FutureBuilder<PersonDetail>(
        future: futurePerson,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load data', style: TextStyle(color: Colors.white)));
          } else if (snapshot.hasData) {
            final person = snapshot.data!;
            // Jika birthday null, tampilkan '-' dan jangan hitung umur
            final birthdayDisplay = person.birthday != null
                ? '${DateFormat.yMMMMd().format(person.birthday!)} (${_calculateAge(person.birthday!, DateTime.now())} years old)'
                : '-';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Profile Picture
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${person.profilePath}',
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Name
                        Expanded(
                          child: Text(
                            person.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Biography
                    Text(
                      'Biography:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      person.biography.isNotEmpty ? person.biography : '-',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    // Known For
                    Text(
                      'Known For:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      person.knownFor.isNotEmpty ? person.knownFor : '-',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    // Gender
                    Text(
                      'Gender:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      person.gender.isNotEmpty ? person.gender : '-',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    // Birthday
                    Text(
                      'Birthday:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      birthdayDisplay, // Menampilkan tanggal lahir atau '-'
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    // Place of Birth
                    Text(
                      'Place of Birth:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      person.placeOfBirth.isNotEmpty ? person.placeOfBirth : '-',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No Data Available', style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }

  // Fungsi untuk menghitung usia
  int _calculateAge(DateTime birthDate, DateTime currentDate) {
    int age = currentDate.year - birthDate.year;

    // Cek apakah ulang tahun sudah dilewati tahun ini atau belum
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--; // Jika belum ulang tahun, kurangi 1 dari usia
    }

    return age;
  }
}