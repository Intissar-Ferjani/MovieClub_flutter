import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies/src/features/account/view/widgets/favorite_button.dart';
import 'package:movies/src/features/account/view/widgets/watchlist_button.dart';
import 'package:movies/src/features/movies/view/widgets/chip.dart';
import 'package:movies/src/features/movies/view/widgets/movie_slider.dart';
import 'package:movies/src/features/movies/view/widgets/rating.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../viewmodel/movies_viewmodel.dart';

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen(this.movieId, {super.key});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetails = ref.watch(detailsProvider(movieId));

    return movieDetails.when(
      data: (movie) {
        final posterUrl = ref.watch(imageProvider(movie.posterPath));

        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
            actions: [
              FavoriteButton(movieId),
              WatchlistButton(movieId),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 152,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: movie.posterPath.isEmpty
                            ? Image.asset('assets/images/empty_poster.png')
                            : Image.network(posterUrl),
                      ),
                    ),
                    gapW8,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingChip(movie.rating),
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${DateTime.tryParse(movie.releaseDate)?.year ?? ''}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                          // Display trailer button if available
                          if (movie.trailerKey != null) ...[
                            gapH8,
                            ElevatedButton.icon(
                              onPressed: () async {
                                final url =
                                    'https://www.youtube.com/watch?v=${movie.trailerKey}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Could not launch trailer.'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.play_circle_fill),
                              label: const Text('Watch Trailer'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                gapH12,
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final genre in movie.genres) MyChip(genre),
                  ],
                ),
                gapH12,
                Text(
                  movie.overview,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                gapH24,
                MovieSlider(
                  title: 'Similar movies',
                  movies: movie.similar,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}
