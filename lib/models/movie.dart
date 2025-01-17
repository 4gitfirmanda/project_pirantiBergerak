class Movie {
  String title;
  String backdropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  int id;

  Movie({
    required this.title,
    required this.backdropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"] ?? "Untitled",
      backdropPath: json["backdrop_path"] ?? "",
      originalTitle: json["original_title"] ?? "Untitled",
      overview: json["overview"] ?? "No overview available",
      posterPath: json["poster_path"] ?? "",
      releaseDate: json["release_date"] ?? "Unknown",
      voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
      id: json["id"] ?? 0,
    );
  }
}
