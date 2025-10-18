class GeminiConfig {

  static const String apiKey = 'AIzaSyAyvHPpN6Tumaqy9yO1u4zPJK69EzEUPOQ';
  static bool get isConfigured => apiKey != 'YOUR_ACTUAL_GEMINI_API_KEY_HERE' && apiKey.isNotEmpty;

  // API endpoints
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String model = 'gemini-2.5-flash'; // Changed to Gemini 2.5 Flash
  static const String endpoint = '$baseUrl/$model:generateContent';
}