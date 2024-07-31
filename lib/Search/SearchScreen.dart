import 'package:flutter/material.dart';
import 'package:latihan_5/Search/HomeSearch.dart';
import 'package:latihan_5/Search/ItemSearch/api_service.dart';
import 'package:latihan_5/Search/ItemSearch/models_search.dart';
import 'package:latihan_5/Search/ItemSearch/filter_menu.dart';

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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();

    if (widget.autoFocus) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        setState(() {
          _isSearching = true;
          _query = query;
          _suggestionsFuture = ApiService.searchMovies(query);
        });
      } else {
        setState(() {
          _isSearching = false;
          _query = '';
          _suggestionsFuture = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeSearch(query: query),
      ),
    );
  }

  void _selectSuggestion(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeSearch(query: query),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Stack(
      children: [
        Container(
          width: 270,
          height: 40,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 10.0),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => _performSearch(value),
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Cari film...',
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
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
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _query = '';
                });
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (_isSearching && _suggestionsFuture != null)
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future: _suggestionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('Tidak ada film yang ditemukan',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    return FilterMenu(
                      suggestions: snapshot.data!,
                      onSuggestionSelected: _selectSuggestion,
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}