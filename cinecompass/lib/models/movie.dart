class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
    );
  }

  String get posterUrl => posterPath != null 
    ? 'https://image.tmdb.org/t/p/w220_and_h330_face/$posterPath'
    : 'https://via.placeholder.com/220x330?text=No+Image';

  String get backdropUrl => backdropPath != null 
    ? 'https://image.tmdb.org/t/p/w500/$backdropPath'
    : 'https://via.placeholder.com/500x281?text=No+Image';
} 