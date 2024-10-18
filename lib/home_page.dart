import 'package:flutter/material.dart';

// Import screens
import 'package:latihan_5/BottomNav/HomeScreen.dart';
import 'package:latihan_5/BottomNav/PopularScreen.dart';
import 'package:latihan_5/BottomNav/TopScreen.dart';
import 'package:latihan_5/BottomNav/UpcomingScreen.dart';
import 'package:latihan_5/Search/SearchScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Menyimpan index tab yang dipilih

  final List<Widget> _pages = [
    HomeScreen(),
    PopularScreen(),
    TopScreen(),
    UpcomingScreen(),
  ]; // Daftar halaman yang akan ditampilkan

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Ubah index tab yang dipilih
    });
  }

  void _navigateToSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen(autoFocus: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 18), // Tinggi yang diinginkan untuk AppBar
        child: AppBar(
          backgroundColor: Color(0xFF292929), // Mengatur warna AppBar menjadi hitam
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menyusun elemen ke kanan dan kiri
            children: [
              GestureDetector(
                onTap: () => _navigateToSearchScreen(context),
                child: Container(
                  width: 270,
                  height: 40,
                  padding: EdgeInsets.all(5), // Padding yang sama di semua sisi
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna solid
                    border: Border.all(
                      color: Colors.white, // Warna solid
                      width: 2, // Lebar border
                    ),
                    borderRadius: BorderRadius.circular(100), // Sudut membulat
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0), // Padding khusus di sebelah kiri teks 'search'
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0), // Atur padding atas untuk posisi vertikal
                          child: Text(
                            'Search', // Konten yang ingin Anda letakkan di dalamnya
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold, // Membuat teks tebal
                            ), // Ukuran teks
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0), //Padding khusus di sebelah kanan ikon user
                child: Icon(
                  Icons.person,
                  color: Colors.white, // Warna ikon
                  size: 24, // Ukuran ikon
                ),
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex], // Menampilkan halaman berdasarkan index tab yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex, // Index tab yang sedang dipilih
        onTap: _onItemTapped, // Method yang akan dipanggil saat tab di-tap
        backgroundColor: Color(0xFF292929), // Warna latar belakang BottomNavigationBar
        selectedItemColor: Colors.white, // Warna item yang dipilih
        unselectedItemColor: Color(0xFF545454), // Warna item yang tidak dipilih
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Popular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Top Rated',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Upcoming',
          ),
        ],
      ),
    );
  }
}