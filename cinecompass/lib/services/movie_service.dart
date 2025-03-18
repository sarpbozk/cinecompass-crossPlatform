import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'secure_storage_service.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  final SecureStorageService _secureStorage = SecureStorageService();
  
  Future<String> _getApiKey() async {
    final apiKey = await _secureStorage.getApiKey();
    if (apiKey == null) {
      await _secureStorage.initialize();
      return await _secureStorage.getApiKey() ?? '';
    }
    return apiKey;
  }
  
  Future<List<Movie>> getTrendingMovies() async {
    final apiKey = await _getApiKey();
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/top_rated?api_key=$apiKey'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }
  
  Future<List<Movie>> searchMovies(String query) async {
    if (query.length < 2) {
      return [];
    }
    
    final apiKey = await _getApiKey();
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$apiKey&query=$query'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
  
  Future<Movie> getMovieDetails(int movieId) async {
    final apiKey = await _getApiKey();
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId?api_key=$apiKey'),
    );
    
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }
} 