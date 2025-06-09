import 'env_config.dart';

class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._internal();
  
  AppConfig._internal();

  late final String _environment;
  late final String _baseUrl;
  late final String _apiVersion;
  late final int _connectTimeout;
  late final int _receiveTimeout;
  late final bool _enableLogging;

  // Initialize configuration
  void initialize({required String environment}) {
    _environment = environment;
    _loadEnvironmentConfig();
  }

  void _loadEnvironmentConfig() {
    switch (_environment.toLowerCase()) {
      case 'development':
      case 'dev':
        _baseUrl = EnvConfig.devBaseUrl;
        _apiVersion = EnvConfig.apiVersion;
        _connectTimeout = 30000; // 30 seconds
        _receiveTimeout = 30000; // 30 seconds
        _enableLogging = true;
        break;
      case 'staging':
      case 'test':
        _baseUrl = EnvConfig.stagingBaseUrl;
        _apiVersion = EnvConfig.apiVersion;
        _connectTimeout = 30000;
        _receiveTimeout = 30000;
        _enableLogging = true;
        break;
      case 'production':
      case 'prod':
        _baseUrl = EnvConfig.prodBaseUrl;
        _apiVersion = EnvConfig.apiVersion;
        _connectTimeout = 20000; // 20 seconds
        _receiveTimeout = 20000; // 20 seconds
        _enableLogging = false;
        break;
      default:
        throw Exception('Unknown environment: $_environment');
    }
  }

  // Getters
  String get environment => _environment;
  String get baseUrl => _baseUrl;
  String get apiVersion => _apiVersion;
  int get connectTimeout => _connectTimeout;
  int get receiveTimeout => _receiveTimeout;
  bool get enableLogging => _enableLogging;
  
  // API URLs
  String get apiBaseUrl => '$_baseUrl/api/$_apiVersion';
  
  
  
  // App constants
  String get appName => 'JoruneyQ';
  String get appVersion => '1.0.0';
  int get maxLoginAttempts => 5;
  int get sessionTimeoutMinutes => 30;
  int get passwordMinLength => 8;
  int get otpLength => 6;
  int get otpExpiryMinutes => 5;
  
  // Cache settings
  int get cacheMaxAge => 3600; // 1 hour in seconds
  int get imageCacheMaxAge => 86400; // 24 hours in seconds
  
  // Network settings
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'App-Version': appVersion,
    'Platform': 'mobile',
  };
  
  
  // Image and media settings
  int get maxImageSizeMB => 10;
  

  
  @override
  String toString() {
    return 'AppConfig(environment: $_environment, baseUrl: $_baseUrl, apiVersion: $_apiVersion)';
  }
}

