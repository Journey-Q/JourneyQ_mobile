class EnvConfig {
  // Base URLs for different environments
  static const String devBaseUrl = 'https://dev-api.travel.com';
  static const String stagingBaseUrl = 'https://staging-api.travel.com';
  static const String prodBaseUrl = 'https://api.travel.com';
  
  // API Version
  static const String apiVersion = 'v1';
  
  // Database configurations
  static const String devDatabaseUrl = 'mongodb://localhost:27017/travel_dev';
  static const String stagingDatabaseUrl = 'mongodb://staging-db.travel.com:27017/travel_staging';
  static const String prodDatabaseUrl = 'mongodb://prod-db.travel.com:27017/travel_prod';
  
  // External API Keys (these should be loaded from environment variables in real app)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
  static const String oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';
  static const String stripePublishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';
  static const String facebookAppId = 'YOUR_FACEBOOK_APP_ID';
  static const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID';
  
  // Firebase configuration
  static const Map<String, String> firebaseConfig = {
    'apiKey': firebaseApiKey,
    'authDomain': 'travel-app.firebaseapp.com',
    'projectId': 'travel-app',
    'storageBucket': 'travel-app.appspot.com',
    'messagingSenderId': '123456789',
    'appId': '1:123456789:android:abcdef123456',
  };
  
  // Payment configuration
  static const Map<String, String> paymentConfig = {
    'stripe_publishable_key': stripePublishableKey,
    'currency': 'USD',
    'country': 'US',
  };
  
  // Social login configuration
  static const Map<String, String> socialLoginConfig = {
    'facebook_app_id': facebookAppId,
    'google_client_id': googleClientId,
  };
  
  // Analytics configuration
  static const Map<String, String> analyticsConfig = {
    'google_analytics_id': 'GA_TRACKING_ID',
    'mixpanel_token': 'MIXPANEL_TOKEN',
    'amplitude_api_key': 'AMPLITUDE_API_KEY',
  };
  
  // Security configuration
  static const Map<String, dynamic> securityConfig = {
    'encryption_key': 'YOUR_ENCRYPTION_KEY',
    'jwt_secret': 'YOUR_JWT_SECRET',
    'password_salt_rounds': 12,
    'token_expiry_hours': 24,
    'refresh_token_expiry_days': 30,
  };
  
  // Feature flags configuration
  static const Map<String, bool> featureFlags = {
    'enable_biometric_auth': true,
    'enable_social_login': true,
    'enable_push_notifications': true,
    'enable_location_services': true,
    'enable_offline_mode': true,
    'enable_dark_theme': true,
    'enable_multi_language': true,
    'enable_analytics': true,
    'enable_crash_reporting': true,
    'enable_performance_monitoring': true,
  };
  
  // Get configuration based on environment
  static String getDatabaseUrl(String environment) {
    switch (environment.toLowerCase()) {
      case 'development':
      case 'dev':
        return devDatabaseUrl;
      case 'staging':
      case 'test':
        return stagingDatabaseUrl;
      case 'production':
      case 'prod':
        return prodDatabaseUrl;
      default:
        return devDatabaseUrl;
    }
  }
  
  static Map<String, String> getHeaders(String environment) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Environment': environment,
      'X-Platform': 'mobile',
      'X-App-Version': '1.0.0',
    };
  }
}