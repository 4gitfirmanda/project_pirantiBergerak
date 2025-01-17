import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluflix/api/api.dart';
import 'package:fluflix/models/movie.dart';
import 'widgets/movies_slider.dart';
import 'widgets/trending_slider.dart';
import 'package:fluflix/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upcomingMovies;

  @override
  void initState() {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    upcomingMovies = Api().getUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/flutflix.png',
          height: 180,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trending Movies Section
              SectionTitle(title: 'Trending Movies'),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  '',
                  style: GoogleFonts.aBeeZee(fontSize: 25),
                ),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Movie>>(
                future: trendingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return TrendingSlider(snapshot: snapshot);
                  } else {
                    return const Center(
                      child: Text('No movies available'),
                    );
                  }
                },
              ),

              // Top Rated Movies Section
              SectionTitle(title: 'Top Rated Movies'),
              FutureBuilder<List<Movie>>(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  return _buildMovieSection(snapshot);
                },
              ),

              // Upcoming Movies Section
              SectionTitle(title: 'Upcoming Movies'),
              FutureBuilder<List<Movie>>(
                future: upcomingMovies,
                builder: (context, snapshot) {
                  return _buildMovieSection(snapshot);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build each movie section
  Widget _buildMovieSection(AsyncSnapshot<List<Movie>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      return MoviesSlider(movies: snapshot.data!);
    } else {
      return const Center(child: Text('No movies available'));
    }
  }
}

// Widget for Section Titles
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.aBeeZee(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Widget for auto-slide Trending Movies
class TrendingMoviesSlider extends StatelessWidget {
  final List<Movie> movies;

  const TrendingMoviesSlider({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: movies.length,
        controller: PageController(viewportFraction: 0.8, keepPage: true),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${Constants.imagePath}${movie.posterPath}',
                width: 150,
                height: 225,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
