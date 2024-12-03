import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies/src/core/constants/app_sizes.dart';
import 'package:movies/src/features/movies/view/screens/movies_search_screen.dart'; // Import the search screen
import 'package:movies/src/features/movies/view/widgets/movie_slider.dart';
import 'package:movies/src/features/movies/viewmodel/movies_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/images/logo24px.svg'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to the MovieSearchPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MovieSearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ref.watch(homeProvider).when(
            data: (data) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  MovieSlider(
                    title: 'Trending',
                    movies: data.trendingMovies,
                    movieProvider: trendingMoviesProvider,
                  ),
                  gapH12,
                  MovieSlider(
                    title: 'Popular',
                    movies: data.popularMovies,
                    movieProvider: popularMoviesProvider,
                  ),
                  gapH12,
                  MovieSlider(
                    title: 'Now Playing',
                    movies: data.nowPlayingMovies,
                    movieProvider: nowMoviesProvider,
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              return Center(
                child: Text(error.toString()),
              );
            },
          ),
    );
  }
}
