import 'package:flutter/material.dart';
import 'package:fluflix/api/api.dart';
import 'package:fluflix/models/movie.dart';
import 'widgets/movies_slider.dart';

class TrendingMoviesScreen extends StatelessWidget {
  const TrendingMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Movies'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Movie>>(
        future: Api().getTrendingMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return MoviesSlider(movies: snapshot.data!);
          } else {
            return const Center(child: Text('No trending movies available.'));
          }
        },
      ),
    );
  }
}
