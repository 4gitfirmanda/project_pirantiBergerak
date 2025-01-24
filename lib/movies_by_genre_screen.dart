import 'package:flutter/material.dart';
import 'package:fluflix/api/api.dart';
import 'package:fluflix/models/movie.dart';
import 'package:fluflix/models/genre.dart';
import 'package:fluflix/movie_detail_screen.dart';
import 'widgets/movies_list.dart';

class MoviesByGenreScreen extends StatelessWidget {
  final Genre genre;

  const MoviesByGenreScreen({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${genre.name} Movies'),
        backgroundColor: const Color.fromARGB(255, 162, 3, 3),
      ),
      body: FutureBuilder<List<Movie>>(
        future: Api().getMoviesByGenre(genre.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return MoviesList(
              movies: snapshot.data!,
              onMovieTap: (movie) {
                // Navigasi ke MovieDetailScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movieId: movie.id),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No movies available for ${genre.name}.'),
            );
          }
        },
      ),
    );
  }
}
