import 'package:flutter/material.dart';
import 'package:fluflix/models/movie.dart';
import 'package:fluflix/constants.dart';
import 'package:fluflix/movie_detail_screen.dart'; // Import MovieDetailScreen

class MoviesSlider extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlider({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // Ketinggian cukup untuk gambar dan teks
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                // Navigasi ke halaman detail film
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movieId: movie.id),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Film
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '${Constants.imagePath}${movie.posterPath}',
                      width: 150,
                      height: 220, // Tetapkan tinggi gambar
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8), // Spasi antara gambar dan teks
                  // Judul Film
                  SizedBox(
                    width: 150, // Sesuaikan lebar teks
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Batasi teks menjadi maksimal 2 baris
                      overflow: TextOverflow
                          .ellipsis, // Tambahkan "..." jika teks terlalu panjang
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
