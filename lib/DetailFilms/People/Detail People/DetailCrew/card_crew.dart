import 'package:flutter/material.dart';
import 'package:latihan_5/DetailFilms/ApiDetailFilms/models.dart';

class CardCrew extends StatelessWidget {
  final People person;

  CardCrew({required this.person});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add functionality if needed when the card is tapped.
      },
      child: Card(
        margin: EdgeInsets.all(3.0),
        color: Color(0xFF545454),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 259,
              child: Image.network(
                'http://image.tmdb.org/t/p/w500/${person.profilePath}',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      person.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      person.role,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}