import 'package:flutter/material.dart';

class PersonNull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 110,
      color: Color(0xFF545454), // Warna latar belakang untuk menyesuaikan dengan Card
      child: Center(
        child: Icon(
          Icons.person, // Ganti dengan gambar yang diinginkan
          size: 50,
          color: Colors.grey, // Warna icon
        ),
      ),
    );
  }
}