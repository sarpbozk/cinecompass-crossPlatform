import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _apiKeyKey = 'tmdb_api_key';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // Default API key to use initially
  static const String _defaultApiKey = 'a6c08cda11c5499ee1534afbd6143955';
  
  Future<void> initialize() async {
    // Check if API key exists, if not, set the default one
    final apiKey = await getApiKey();
    if (apiKey == null) {
      await saveApiKey(_defaultApiKey);
    }
  }
  
  Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKeyKey);
  }
  
  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyKey, value: apiKey);
  }
} 