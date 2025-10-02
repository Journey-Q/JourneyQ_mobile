class GoogleMapsConfig {
  // Using the same API key as journey view for consistency
  // This matches the API key used in journey_detail.dart
  static const String apiKey = 'AIzaSyCFbprhDc_fKXUHl-oYEVGXKD1HciiAsz0';

  // Check if API key is configured
  static bool get isConfigured => apiKey != 'YOUR_GOOGLE_MAPS_API_KEY_HERE' && apiKey.isNotEmpty;

  // Available travel modes
  static const String drivingMode = 'driving';
  static const String walkingMode = 'walking';
  static const String transitMode = 'transit';
  static const String bicyclingMode = 'bicycling';

  // Default settings
  static const String defaultTravelMode = drivingMode;
  static const bool optimizeWaypoints = true;
}