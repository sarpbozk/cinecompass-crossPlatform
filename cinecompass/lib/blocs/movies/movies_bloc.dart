import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/movie_service.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MovieService _movieService;
  
  MoviesBloc({required MovieService movieService})
      : _movieService = movieService,
        super(MoviesInitial()) {
    on<LoadTrendingMovies>(_onLoadTrendingMovies);
    on<SearchMovies>(_onSearchMovies);
  }
  
  Future<void> _onLoadTrendingMovies(
    LoadTrendingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    try {
      final movies = await _movieService.getTrendingMovies();
      emit(MoviesLoaded(movies: movies, isSearchResult: false));
    } catch (e) {
      emit(MoviesError('Failed to load trending movies: ${e.toString()}'));
    }
  }
  
  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MoviesState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadTrendingMovies());
      return;
    }
    
    emit(MoviesLoading());
    try {
      final movies = await _movieService.searchMovies(event.query);
      emit(MoviesLoaded(
        movies: movies,
        isSearchResult: true,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(MoviesError('Failed to search movies: ${e.toString()}'));
    }
  }
} 