import 'package:flutter/material.dart';

class TrailerNull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Color(0xFF545454), // Warna latar belakang untuk menyesuaikan dengan Card
      child: Center(
        child: Icon(
          Icons.play_circle_outline, // Ganti dengan gambar yang diinginkan
          size: 50,
          color: Colors.grey, // Warna icon
        ),
      ),
    );
  }
}