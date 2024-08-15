class Cast {
  final String name;

  Cast({required this.name});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'],
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ProductionCompany {
  final String name;
  final String? logoPath;
  final String originCountry;

  ProductionCompany({
    required this.name,
    this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      name: json['name'],
      logoPath: json['logo_path'],
      originCountry: json['origin_country'],
    );
  }
}

class MovieDetail {
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final List<Genre> genres;
  final List<Cast> producers;
  final List<Cast> directors;
  final List<Cast> writers;
  final List<ProductionCompany> productionCompanies; // Tambahkan ini

  MovieDetail({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.genres,
    required this.producers,
    required this.directors,
    required this.writers,
    required this.productionCompanies, // Tambahkan ini
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      genres: (json['genres'] as List)
          .map((genreJson) => Genre.fromJson(genreJson))
          .toList(),
      producers: [],
      directors: [],
      writers: [],
      productionCompanies: (json['production_companies'] as List)
          .map((companyJson) => ProductionCompany.fromJson(companyJson))
          .toList(),
    );
  }

  MovieDetail copyWith({
    List<Cast>? producers,
    List<Cast>? directors,
    List<Cast>? writers,
    List<ProductionCompany>? productionCompanies,
  }) {
    return MovieDetail(
      title: this.title,
      overview: this.overview,
      posterPath: this.posterPath,
      releaseDate: this.releaseDate,
      genres: this.genres,
      producers: producers ?? this.producers,
      directors: directors ?? this.directors,
      writers: writers ?? this.writers,
      productionCompanies: productionCompanies ?? this.productionCompanies,
    );
  }
}