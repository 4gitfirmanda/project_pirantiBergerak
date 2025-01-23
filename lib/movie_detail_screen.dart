import 'package:flutter/material.dart';
import 'package:fluflix/api/api.dart';
import 'package:fluflix/models/movie.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({required this.movieId, Key? key}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> movieDetail;
  late Future<String?> movieTrailerKey; // Untuk trailer
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    movieDetail = Api().getMovieDetail(widget.movieId);
    movieTrailerKey = Api().getMovieTrailer(widget.movieId);

    // Inisialisasi controller dengan video default sementara
    _youtubeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Detail'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Movie>(
        future: movieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final movie = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Bagian Trailer
                FutureBuilder<String?>(
                  future: movieTrailerKey,
                  builder: (context, trailerSnapshot) {
                    if (trailerSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (trailerSnapshot.hasError) {
                      return const Text('Failed to load trailer');
                    } else if (trailerSnapshot.hasData &&
                        trailerSnapshot.data != null) {
                      final youtubeKey = trailerSnapshot.data!;
                      _youtubeController.loadVideoById(videoId: youtubeKey);
                      return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          controller: _youtubeController,
                        ),
                      );
                    } else {
                      return const Center(child: Text('No trailer available'));
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Bagian Detail Film
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // child: Image.network(
                  //   'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                  //   height: 250,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                const SizedBox(height: 16),
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Release Date: ${movie.releaseDate}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rating: ${movie.voteAverage}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Overview:',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
