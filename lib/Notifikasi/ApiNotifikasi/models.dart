class Dates {
  final String maximum;
  final String minimum;

  Dates({
    required this.maximum,
    required this.minimum,
  });

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      maximum: json['maximum'] ?? '', // Berikan nilai default jika null
      minimum: json['minimum'] ?? '', // Berikan nilai default jika null
    );
  }
}

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
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      adult: json['adult'] ?? false, // Nilai default false jika null
      backdropPath: json['backdrop_path'] ?? '', // Berikan nilai default jika null
      genreIds: List<int>.from(json['genre_ids'] ?? []), // Berikan default list kosong jika null
      id: json['id'] ?? 0, // Berikan nilai default jika null
      originalLanguage: json['original_language'] ?? 'Unknown', // Default "Unknown" jika null
      originalTitle: json['original_title'] ?? 'Untitled', // Default "Untitled" jika null
      overview: json['overview'] ?? '', // Default string kosong jika null
      popularity: (json['popularity'] != null) ? json['popularity'].toDouble() : 0.0, // Nilai default 0.0 jika null
      posterPath: json['poster_path'] ?? '', // Berikan nilai default jika null
      releaseDate: json['release_date'] ?? 'Unknown', // Default "Unknown" jika null
      title: json['title'] ?? 'Untitled', // Default "Untitled" jika null
      video: json['video'] ?? false, // Nilai default false jika null
      voteAverage: (json['vote_average'] != null) ? json['vote_average'].toDouble() : 0.0, // Default 0.0 jika null
      voteCount: json['vote_count'] ?? 0, // Default 0 jika null
    );
  }
}

class MovieResponse {
  final Dates dates;
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MovieResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      dates: json['dates'] != null ? Dates.fromJson(json['dates']) : Dates(maximum: '', minimum: ''), // Default Dates jika null
      page: json['page'] ?? 1, // Default page 1 jika null
      results: (json['results'] as List<dynamic>?)
          ?.map((x) => Movie.fromJson(x))
          .toList() ??
          [], // Default list kosong jika null
      totalPages: json['total_pages'] ?? 1, // Default totalPages 1 jika null
      totalResults: json['total_results'] ?? 0, // Default totalResults 0 jika null
    );
  }
}