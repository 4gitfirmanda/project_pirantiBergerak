import 'package:flutter/material.dart';
import 'package:fluflix/api/api.dart';
import 'package:fluflix/models/movie.dart';
import 'widgets/movies_slider.dart';

class UpcomingMoviesScreen extends StatelessWidget {
  const UpcomingMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Movies'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Movie>>(
        future: Api().getUpcomingMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return MoviesSlider(movies: snapshot.data!);
          } else {
            return const Center(child: Text('No upcoming movies available.'));
          }
        },
      ),
    );
  }
}
