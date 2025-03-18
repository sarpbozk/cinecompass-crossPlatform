import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadTrendingMovies extends MoviesEvent {}

class SearchMovies extends MoviesEvent {
  final String query;
  
  const SearchMovies(this.query);
  
  @override
  List<Object?> get props => [query];
} 