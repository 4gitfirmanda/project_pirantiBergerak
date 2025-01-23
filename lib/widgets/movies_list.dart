import 'package:flutter/material.dart';
import 'package:fluflix/models/movie.dart';

class MoviesList extends StatelessWidget {
  final List<Movie> movies;

  const MoviesList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Image.network(
              'https://image.tmdb.org/t/p/w92${movie.posterPath}',
              fit: BoxFit.cover,
            ),
            title: Text(movie.title),
            subtitle: Text('Rating: ${movie.voteAverage}'),
            onTap: () {
              // Handle movie detail navigation
            },
          ),
        );
      },
    );
  }
}
