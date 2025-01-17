import 'dart:convert';
import 'package:fluflix/constants.dart';
import 'package:fluflix/models/movie.dart';
import 'package:http/http.dart' as http;

class Api {
  static const _baseUrl = 'https://api.themoviedb.org/3';
  static const _trendingUrl =
      '$_baseUrl/trending/movie/day?api_key=${Constants.apiKey}&language=en-US';
  static const _topRatedUrl =
      '$_baseUrl/movie/top_rated?language=en-US&page=1&api_key=${Constants.apiKey}';
  static const _upcomingUrl =
      '$_baseUrl/movie/upcoming?language=en-US&page=1&api_key=${Constants.apiKey}';

  // Method for Trending Movies
  Future<List<Movie>> getTrendingMovies() async {
    return _fetchMovies(_trendingUrl);
  }

  // Method for Top Rated Movies
  Future<List<Movie>> getTopRatedMovies() async {
    return _fetchMovies(_topRatedUrl);
  }

  // Method for Upcoming Movies
  Future<List<Movie>> getUpcomingMovies() async {
    return _fetchMovies(_upcomingUrl);
  }

  // Generalized method for fetching movies
  Future<List<Movie>> _fetchMovies(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List decodedData = json.decode(response.body)['results'];
        return decodedData.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  // Fetch movie detail
  Future<Movie> getMovieDetail(int movieId) async {
    final url =
        '$_baseUrl/movie/$movieId?api_key=${Constants.apiKey}&language=en-US';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return Movie.fromJson(decodedData);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  // NEW: Method for Searching Movies
  Future<List<Movie>> searchMovies(String query) async {
    final url =
        '$_baseUrl/search/movie?query=$query&include_adult=false&language=en-US&api_key=${Constants.apiKey}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List decodedData = json.decode(response.body)['results'];
        return decodedData.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching search results: $e');
    }
  }
}
