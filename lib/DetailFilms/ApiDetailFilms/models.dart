class PersonDetail {
  final String profilePath;
  final String name;
  final String biography;
  final String knownFor;
  final String gender;
  final DateTime? birthday;
  final DateTime? deathday; // Tambahkan deathday
  final String placeOfBirth;

  PersonDetail({
    required this.profilePath,
    required this.name,
    required this.biography,
    required this.knownFor,
    required this.gender,
    this.birthday,
    this.deathday,
    required this.placeOfBirth,
  });

  factory PersonDetail.fromJson(Map<String, dynamic> json) {
    return PersonDetail(
      profilePath: json['profile_path'] ?? '', // Jika null, isi dengan string kosong
      name: json['name'] ?? '', // Jika null, isi dengan string kosong
      biography: json['biography'] ?? '', // Jika null, isi dengan string kosong
      knownFor: json['known_for_department'] ?? '', // Jika null, isi dengan string kosong
      gender: _genderFromId(json['gender']), // Gunakan method untuk menangani gender null
      birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday']) : null, // Cek null sebelum parse tanggal
      deathday: json['deathday'] != null ? DateTime.tryParse(json['deathday']) : null,
      placeOfBirth: json['place_of_birth'] ?? '', // Jika null, isi dengan string kosong
    );
  }

  // Fungsi untuk mengonversi ID gender ke teks yang sesuai
  static String _genderFromId(int? id) {
    switch (id) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      case 3:
        return 'Non-binary';
      default:
        return 'Not specified'; // Jika null atau tidak sesuai, berikan default
    }
  }
}

class People {
  final int id;
  final String name;
  final String profilePath;
  final String role;

  People({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.role,
  });

  factory People.fromJson(Map<String, dynamic> json) {
    return People(
      id: json ['id'],
      name: json['name'] ?? '',  // Berikan default value jika null
      profilePath: json['profile_path'] ?? '', // Berikan default value jika null
      role: json['job'] ?? json['character'] ?? '', // Berikan default value jika null
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
  final List<ProductionCompany> productionCompanies;
  final String backdropPath;
  final List<People> castCrew;

  MovieDetail({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.genres,
    required this.productionCompanies,
    required this.backdropPath,
    required this.castCrew,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      genres: (json['genres'] as List?)?.map((genreJson) => Genre.fromJson(genreJson)).toList() ?? [],
      productionCompanies: (json['production_companies'] as List?)?.map((companyJson) => ProductionCompany.fromJson(companyJson)).toList() ?? [],
      backdropPath: json['backdrop_path'] ?? '',
      castCrew: [], // Initial empty list, will be updated by `copyWith`
    );
  }

  MovieDetail copyWith({
    List<People>? castCrew,
  }) {
    return MovieDetail(
      title: this.title,
      overview: this.overview,
      posterPath: this.posterPath,
      releaseDate: this.releaseDate,
      genres: this.genres,
      productionCompanies: this.productionCompanies,
      backdropPath: this.backdropPath,
      castCrew: castCrew ?? this.castCrew,
    );
  }

  List<People> get producers =>
      castCrew.where((person) => person.role == 'Producer').toList();

  List<People> get directors =>
      castCrew.where((person) => person.role == 'Director').toList();

  List<People> get writers =>
      castCrew.where((person) => person.role == 'Writer').toList();

  List<People> get allPeople => castCrew.toList();

  List<People> get crew2 =>
      castCrew.where((person) => person.role == 'Producer' ||
          person.role == 'Director' ||
          person.role == 'Writer' ||
          person.role != 'Actor').toList();
}