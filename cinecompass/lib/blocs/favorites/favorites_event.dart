import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class AddFavorite extends FavoritesEvent {
  final Movie movie;
  
  const AddFavorite(this.movie);
  
  @override
  List<Object?> get props => [movie];
}

class RemoveFavorite extends FavoritesEvent {
  final Movie movie;
  
  const RemoveFavorite(this.movie);
  
  @override
  List<Object?> get props => [movie];
} 