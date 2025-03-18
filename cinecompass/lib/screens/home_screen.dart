import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movies/movies_bloc.dart';
import '../blocs/movies/movies_event.dart';
import '../blocs/movies/movies_state.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Load trending movies when screen initializes
    context.read<MoviesBloc>().add(LoadTrendingMovies());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isEmpty) {
        context.read<MoviesBloc>().add(LoadTrendingMovies());
      } else if (_searchController.text.length >= 2) {
        context.read<MoviesBloc>().add(SearchMovies(_searchController.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineCompass'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return Center(
                      child: Text(
                        state.isSearchResult
                            ? 'No results found for "${state.searchQuery}"'
                            : 'No trending movies available',
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(movie: state.movies[index]);
                    },
                  );
                } else if (state is MoviesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Start searching for movies'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
} 