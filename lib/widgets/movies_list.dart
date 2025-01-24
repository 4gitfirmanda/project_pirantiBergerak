import 'package:flutter/material.dart';
import 'package:fluflix/models/movie.dart';

class MoviesList extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie) onMovieTap; // Callback untuk navigasi detail film

  const MoviesList({
    Key? key,
    required this.movies,
    required this.onMovieTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.movie,
                    size: 50,
                  );
                },
              ),
            ),
            title: Text(
              movie.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'Rating: ${movie.voteAverage.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            onTap: () => onMovieTap(movie), // Panggil callback saat diklik
          ),
        );
      },
    );
  }
}
