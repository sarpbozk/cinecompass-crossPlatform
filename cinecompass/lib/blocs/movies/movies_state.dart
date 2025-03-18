import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();
  
  @override
  List<Object> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final bool isSearchResult;
  final String searchQuery;

  const MoviesLoaded({
    required this.movies, 
    this.isSearchResult = false,
    this.searchQuery = '',
  });
  
  @override
  List<Object> get props => [movies, isSearchResult, searchQuery];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);
  
  @override
  List<Object> get props => [message];
} 