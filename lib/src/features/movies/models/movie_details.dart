import 'movie.dart';

class MovieDetails {
  MovieDetails({
    required this.backdropPath,
    required this.posterPath,
    required this.title,
    required this.rating,
    required this.releaseDate,
    required this.genres,
    required this.overview,
    required this.similar,
    required this.trailerKey,
  });

  final String backdropPath;
  final String posterPath;
  final String title;
  final double rating;
  final String releaseDate;
  final List<String> genres;
  final String overview;
  final List<Movie> similar;
  final String? trailerKey; // Nullable field for the trailer key

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    // Extract the first YouTube trailer key from the videos data, if available
    String? extractTrailerKey(Map<String, dynamic> videos) {
      final results = videos['results'] as List<dynamic>;
      final trailer = results.firstWhere(
        (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
        orElse: () => null,
      );
      return trailer?['key'] as String?;
    }

    return MovieDetails(
      backdropPath: json['backdrop_path'] ?? '',
      posterPath: json['poster_path'] ?? '',
      title: json['title'] ?? '',
      rating: json['vote_average'] ?? 0.0,
      releaseDate: json['release_date'] ?? '',
      genres: (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList(),
      overview: json['overview'] ?? '',
      similar: (json['similar']['results'] as List)
          .map((item) => Movie.fromJson(item))
          .toList(),
      trailerKey: json['videos'] != null
          ? extractTrailerKey(json['videos'])
          : null, // Extract the trailer key if available
    );
  }
}
