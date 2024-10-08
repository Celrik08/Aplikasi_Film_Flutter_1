import 'package:flutter/material.dart';
import 'package:latihan_5/Search/HomeSearch.dart';
import 'package:latihan_5/Search/ItemSearch/api_service.dart';
import 'package:latihan_5/Search/ItemSearch/genre/HomeGenre.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';
import 'package:latihan_5/Search/ItemSearch/filter_menu.dart';
import 'package:latihan_5/Search/ItemSearch/genre/search_card.dart';

class SearchScreen extends StatefulWidget {
  final bool autoFocus;

  SearchScreen({this.autoFocus = false});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  bool _isSearching = false;
  String _query = '';
  Future<List<Movie>>? _suggestionsFuture;
  Future<List<Genre>>? _genresFuture;
  bool _showHomeSearch = false;
  String? _fullTitle;
  bool _isTruncated = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      setState(() {
        if (query.isNotEmpty) {
          _isSearching = true;
          _query = query;
          _suggestionsFuture = ApiService.searchMovies(query);
          _showHomeSearch = false;
        } else {
          _isSearching = false;
          _query = '';
          _suggestionsFuture = null;
          _showHomeSearch = false;
        }
      });
    });

    _genresFuture = ApiService.getGenres(); // Mengambil genre saat layar diinisialisasi
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _fullTitle = query;
      _query = query;
      _showHomeSearch = true;
      _isTruncated = true;
    });
  }

  void _selectSuggestion(String fullTitle, String type) {
    setState(() {
      _searchController.text = _truncateTitle(fullTitle, 20);
      _fullTitle = fullTitle;
      _query = fullTitle;
      _showHomeSearch = true;
      _isTruncated = true;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _showHomeSearch = false;
      _isSearching = false;
      _query = '';
      _fullTitle = null;
      _isTruncated = true;
      _suggestionsFuture = null;
    });
  }

  void _toggleTruncate() {
    setState(() {
      _isTruncated = !_isTruncated;
      if (_isTruncated && _fullTitle != null) {
        _searchController.text = _truncateTitle(_fullTitle!, 20);
      } else {
        _searchController.text = _fullTitle ?? '';
      }
    });
  }

  String _truncateTitle(String title, int maxLength) {
    return title.length > maxLength ? '${title.substring(0, maxLength)}...' : title;
  }

  void _onGenreSelected(Genre genre) {
    _genresFuture?.then((allGenres) { // Mengguunakan _genresFuture yang benar
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeGenre(
            genre: genre, // Menggunakan parameter genre yang benar
            allGenres: allGenres, // Berikan semua genre ke HomeGenre
          ),
        ),
      );
    });
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: _toggleTruncate,
      child: Stack(
        children: [
          Container(
            width: 270,
            height: 40,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Icon(Icons.search, size: 20, color: Colors.black),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 10.0),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        _performSearch(_fullTitle ?? value);
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Cari film...',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                      readOnly: _showHomeSearch,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isSearching)
            Positioned(
              top: -4,
              right: 3,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black54),
                onPressed: _clearSearch,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenreChips(List<Genre> genres) {
    return _isSearching
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            height: 50.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: GestureDetector(
                    onTap: () => _onGenreSelected(genres[index]), // Navigasi ke HomeGenre
                    child: CardGenre(genre: genres[index]), // Menggunakan CardGenre
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Mengatur background warna
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: AppBar(
          backgroundColor: Color(0xFF292929),
          iconTheme: IconThemeData(color: Colors.white),
          title: _buildSearchBar(),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Genre>>(
            future: _genresFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Jangan tampilkan CircularProgressIndicator di sini
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
              } else if (snapshot.hasData) {
                return _buildGenreChips(snapshot.data!);
              } else {
                return Container();
              }
            },
          ),
          if (_showHomeSearch && _fullTitle != null)
            Expanded(
              child: HomeSearch(query: _query), // Pass the query to HomeSearch
            )
          else if (_isSearching && _suggestionsFuture != null)
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _suggestionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                  } else if (snapshot.hasData) {
                    final movies = snapshot.data!;
                    return FilterMenu( // Menggunakan FilterMenu
                      suggestions: movies,
                      onSuggestionSelected: (fullTitle, type) => _selectSuggestion(fullTitle, type),
                    );
                  } else {
                    return Center(child: Text('No results found', style: TextStyle(color: Colors.white)));
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}