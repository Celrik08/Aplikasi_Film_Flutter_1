import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/api_service.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';
import 'package:latihan_5/DetailFilms/People/Detail%20People/DetailPerson/Detail_Person.dart';

class CardPeople extends StatelessWidget {
  final People person1;

  CardPeople({required this.person1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasikan ke layar DetailPerson dengan futurePerson
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPerson(
              futurePerson: ApiService.fetchPersonDetail(person1.id), // Lewati futurePerson di sini
            ),
          ),
        );
      },
      child: SizedBox(
        width: 150,
        height: 300,
        child: Card(
          margin: EdgeInsets.all(3.0),
          color: Color(0xFF545454),
          child: Column(
            children: [
              Container(
                width: 144, // Mengatur lebar gambar mengikuti lebar Card
                height: 150,
                child: Image.network(
                  'http://image.tmdb.org/t/p/w500/${person1.profilePath}',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  person1.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: Text(
                  person1.role, // Menampilkan karakter atau pekerjaan
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  maxLines: 2, // Batasi teks menjadi 2 baris
                  overflow: TextOverflow.ellipsis, // Teks akan terpotong jika terlalu panjang
                  textAlign: TextAlign.center, // Menyelaraskan teks di tengah
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}