class Movie {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'] ?? false,  // Default to false if null
      backdropPath: json['backdrop_path'] ?? '',  // Default to empty string
      genreIds: (json['genre_ids'] as List?)?.map((id) => id as int).toList() ?? [],  // Default to an empty list if null
      id: json['id'] ?? 0,  // Default to 0 if null
      originalLanguage: json['original_language'] ?? 'Unknown',  // Default to 'Unknown' if null
      originalTitle: json['original_title'] ?? '',  // Default to empty string if null
      overview: json['overview'] ?? '',  // Default to empty string if null
      popularity: (json['popularity'] ?? 0.0).toDouble(),  // Default to 0.0 if null
      posterPath: json['poster_path'] ?? '',  // Default to empty string
      releaseDate: json['release_date'] ?? '',  // Default to empty string if null
      title: json['title'] ?? '',  // Default to empty string if null
      video: json['video'] ?? false,  // Default to false if null
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),  // Default to 0.0 if null
      voteCount: json['vote_count'] ?? 0,  // Default to 0 if null
    );
  }
}

class TopResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  TopResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TopResponse.fromJson(Map<String, dynamic> json) {
    return TopResponse(
      page: json['page'] ?? 0,  // Default to 0 if null
      results: (json['results'] as List?)?.map((x) => Movie.fromJson(x)).toList() ?? [],  // Default to empty list if null
      totalPages: json['total_pages'] ?? 0,  // Default to 0 if null
      totalResults: json['total_results'] ?? 0,  // Default to 0 if null
    );
  }
}