import 'dart:convert';
import 'package:fluflix/constants.dart';
import 'package:fluflix/models/movie.dart';
import 'package:http/http.dart' as http;

class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}&language=en-US';

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await http.get(Uri.parse(_trendingUrl));
      if (response.statusCode == 200) {
        final List decodedData = json.decode(response.body)['results'];
        return decodedData.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load trending movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trending movies: $e');
    }
  }
}
