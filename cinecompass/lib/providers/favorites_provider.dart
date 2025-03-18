import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoritesProvider with ChangeNotifier {
  List<Movie> _favorites = [];
  final String _prefsKey = 'favorites';
  
  List<Movie> get favorites => _favorites;
  
  FavoritesProvider() {
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_prefsKey) ?? [];
    
    _favorites = favoritesJson
        .map((json) => Movie.fromJson(jsonDecode(json)))
        .toList();
    
    notifyListeners();
  }
  
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favorites
        .map((movie) => jsonEncode({
              'id': movie.id,
              'title': movie.title,
              'overview': movie.overview,
              'poster_path': movie.posterPath,
              'backdrop_path': movie.backdropPath,
              'vote_average': movie.voteAverage,
              'release_date': movie.releaseDate,
            }))
        .toList();
    
    await prefs.setStringList(_prefsKey, favoritesJson);
  }
  
  bool isFavorite(Movie movie) {
    return _favorites.any((m) => m.id == movie.id);
  }
  
  void toggleFavorite(Movie movie) {
    if (isFavorite(movie)) {
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      _favorites.add(movie);
    }
    
    _saveFavorites();
    notifyListeners();
  }
} 