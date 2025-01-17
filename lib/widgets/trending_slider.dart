import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluflix/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluflix/models/movie.dart';

class TrendingSlider extends StatelessWidget {
  final AsyncSnapshot<List<Movie>> snapshot;

  const TrendingSlider({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: snapshot.data!.length,
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          viewportFraction: 0.55,
          enlargeCenterPage: true,
          pageSnapping: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 1),
        ),
        itemBuilder: (context, itemIndex, pageViewIndex) {
          final movie = snapshot.data![itemIndex];
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 300,
              width: 200,
              child: Image.network(
                '${Constants.imagePath}${movie.posterPath}',
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("No Image"));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
