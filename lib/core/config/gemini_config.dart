class GeminiConfig {

  static const String apiKey = 'AIzaSyCRVrx7hTn9lJfssj9iuAgpj9FqeLKSBrI';
  static bool get isConfigured => apiKey != 'YOUR_ACTUAL_GEMINI_API_KEY_HERE' && apiKey.isNotEmpty;

  // API endpoints
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String model = 'gemini-2.0-flash';
  static const String endpoint = '$baseUrl/$model:generateContent';
}