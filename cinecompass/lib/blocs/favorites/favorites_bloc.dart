import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movie.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final String _prefsKey = 'favorites';
  
  FavoritesBloc() : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }
  
  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());
    try {
      final favorites = await _loadFavoritesFromPrefs();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError('Failed to load favorites: ${e.toString()}'));
    }
  }
  
  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final updatedFavorites = List<Movie>.from(currentState.favorites)
          ..add(event.movie);
        await _saveFavoritesToPrefs(updatedFavorites);
        emit(FavoritesLoaded(updatedFavorites));
      }
    } catch (e) {
      emit(FavoritesError('Failed to add favorite: ${e.toString()}'));
    }
  }
  
  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final updatedFavorites = List<Movie>.from(currentState.favorites)
          ..removeWhere((movie) => movie.id == event.movie.id);
        await _saveFavoritesToPrefs(updatedFavorites);
        emit(FavoritesLoaded(updatedFavorites));
      }
    } catch (e) {
      emit(FavoritesError('Failed to remove favorite: ${e.toString()}'));
    }
  }
  
  Future<List<Movie>> _loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_prefsKey) ?? [];
    
    return favoritesJson
        .map((json) => Movie.fromJson(jsonDecode(json)))
        .toList();
  }
  
  Future<void> _saveFavoritesToPrefs(List<Movie> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favorites
        .map((movie) => jsonEncode(movie.toJson()))
        .toList();
    
    await prefs.setStringList(_prefsKey, favoritesJson);
  }
  
  bool isFavorite(Movie movie) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.favorites.any((m) => m.id == movie.id);
    }
    return false;
  }
} 