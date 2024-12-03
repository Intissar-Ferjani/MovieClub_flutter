import 'dart:convert';

import 'package:http/http.dart' as http;

class TMDBApi {
  final String _apiKey = 'c1f46d17355ae2cb31a99e2888a39a48';
  final String _baseUrl = 'api.themoviedb.org';

  // Trending Movies
  Uri trendingMovies(int page) =>
      _buildUri(endpoint: 'trending/movie/week', page: page);

  // Popular Movies
  Uri popularMovies(int page) =>
      _buildUri(endpoint: 'movie/popular', page: page);

  // Upcoming Movies
  Uri upcomingMovies(int page) =>
      _buildUri(endpoint: 'movie/upcoming', page: page);

  // Now Playing Movies
  Uri nowPlayingMovies(int page) =>
      _buildUri(endpoint: 'movie/now_playing', page: page);

  // Top Rated Movies
  Uri topRatedMovies(int page) =>
      _buildUri(endpoint: 'movie/top_rated', page: page);

  // Single Movie by ID
  Uri movie(int movieId) => _buildUri(endpoint: 'movie/$movieId');

  // Movie Details with Append to Response (Credits, Similar, and Videos)
  Uri movieDetails(int movieId) =>
      _buildUri(endpoint: 'movie/$movieId', query: {
        'append_to_response': 'credits,similar,videos',
      });

  // Image URL
  Uri image(String imagePath) =>
      Uri.parse('https://image.tmdb.org/t/p/w500$imagePath');

  // Helper Method to Build URIs
  Uri _buildUri({
    required String endpoint,
    int? page,
    Map<String, dynamic>? query,
  }) {
    final queryParameters = {
      'api_key': _apiKey,
      if (page != null) 'page': page.toString(),
      if (query != null) ...query,
    };

    return Uri(
      scheme: 'https',
      host: _baseUrl,
      path: '/3/$endpoint',
      queryParameters: queryParameters,
    );
  }

  // Assume this function is already defined elsewhere
  /*Uri searchMovies(String query) {
    // Replace with your actual movie search API URL construction
    return Uri.parse('https://api.example.com/search?query=$query');
  }*/
  // Corrected searchMovies method
  Uri searchMovies(String query) {
    return _buildUri(
      endpoint: 'search/movie',
      query: {'query': query},
    );
  }

  // Fetch Search Results
  Future<List<dynamic>> fetchSearchResults(String query) async {
    try {
      final url = searchMovies(query); // Use the updated searchMovies method
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['results'] ?? [];
      } else {
        throw Exception(
            'Failed to fetch movies: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  Future<List<dynamic>> fetchSearchResultsWithYear(String query,
      {String? releaseDate}) async {
    try {
      final url = _buildUri(
        endpoint: 'search/movie',
        query: {
          'query': query,
          if (releaseDate != null) 'primary_release_year': releaseDate,
        },
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['results'] ?? [];
      } else {
        throw Exception(
            'Failed to fetch movies: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }
}
