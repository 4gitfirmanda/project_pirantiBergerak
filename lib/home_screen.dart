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

  // Search State
  Future<List<Movie>>? searchResults;
  final TextEditingController _searchController = TextEditingController();

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
        leading: searchResults != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    searchResults = null; // Hapus hasil pencarian
                    _searchController.clear(); // Kosongkan input teks
                  });
                },
              )
            : null,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white54), // Border transparan
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white), // Text putih
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    hintText: 'Search movies...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: InputBorder.none, // Hilangkan border
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onSubmitted: (query) => _onSearch(query),
                ),
              ),
              const SizedBox(height: 16),

              // Display Search Results (if available)
              if (searchResults != null)
                FutureBuilder<List<Movie>>(
                  future: searchResults,
                  builder: (context, snapshot) {
                    return _buildSearchResults(snapshot);
                  },
                ),

              // Trending Movies Section (Always visible)
              SectionTitle(title: 'Trending Movies'),
              const SizedBox(height: 16),
              FutureBuilder<List<Movie>>(
                future: trendingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return TrendingSlider(snapshot: snapshot);
                  } else {
                    return const Center(child: Text('No movies available'));
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

  // Search Method
  void _onSearch(String query) {
    setState(() {
      searchResults = Api().searchMovies(query);
    });
  }

  // Build Search Results
  Widget _buildSearchResults(AsyncSnapshot<List<Movie>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      return MoviesSlider(movies: snapshot.data!);
    } else {
      return const Center(child: Text('No results found'));
    }
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
