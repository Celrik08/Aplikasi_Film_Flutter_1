import 'package:flutter/material.dart';

class Imagenull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Icon di tengah atas
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0), // Sesuaikan padding jika perlu
              child: Icon(
                Icons.image, // Ganti dengan gambar yang diinginkan
                size: 50,
                color: Colors.grey, // Warna icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}