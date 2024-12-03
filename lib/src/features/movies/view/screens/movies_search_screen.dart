import 'package:flutter/material.dart';

import '../../../../core/api/api.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({super.key});

  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TMDBApi _api = TMDBApi();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  String? _selectedYear; // Selected release year
  final List<String> _years =
      List.generate(50, (index) => '${2024 - index}'); // Generate years

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Pass the selected year to the API method
      final response = await _api.fetchSearchResultsWithYear(query,
          releaseDate: _selectedYear);
      setState(() {
        _searchResults = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching movies: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Expanded TextField for search
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for movies...',
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(
                    width: 8), // Spacing between TextField and Dropdown
                // Dropdown for release year
                DropdownButton<String>(
                  value: _selectedYear,
                  hint: const Text('Year'),
                  items: _years.map((year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                ),
                const SizedBox(
                    width: 8), // Spacing between Dropdown and IconButton
                // Search icon button
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? const Center(child: Text('No results found.'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final movie = _searchResults[index];
                            return ListTile(
                              title: Text(movie['title'] ?? 'Unknown Title'),
                              subtitle: Text(
                                'Release Date: ${movie['release_date'] ?? 'Unknown Date'}',
                              ),
                              leading: movie['poster_path'] != null
                                  ? Image.network(
                                      _api
                                          .image(movie['poster_path'])
                                          .toString(),
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.movie),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
