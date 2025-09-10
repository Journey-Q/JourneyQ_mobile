// storage/local_storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journeyq/data/models/user_model/user_model.dart';

/// LocalStorage class for managing app data persistence
///
/// WARNING: This implementation stores sensitive data (tokens) in SharedPreferences
/// which is less secure than FlutterSecureStorage. Consider the security implications
/// for your specific use case.
class LocalStorage {
  // Keys for storing data
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _themeKey = 'theme';
  static const String _languageKey = 'language';
  static const String _rememberMeKey = 'remember_me';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _firstTimeUserKey = 'first_time_user';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _lastSyncTimeKey = 'last_sync_time';
  static const String _searchHistoryKey = 'search_history';
  static const String _recentlyViewedKey = 'recently_viewed';

  final SharedPreferences _prefs;

  LocalStorage({required SharedPreferences prefs}) : _prefs = prefs;

  // Token storage methods (WARNING: Less secure than FlutterSecureStorage)
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  Future<void> clearAccessToken() async {
    await _prefs.remove(_accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> clearRefreshToken() async {
    await _prefs.remove(_refreshTokenKey);
  }

  // Convenience method to save both tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  // Convenience method to get both tokens
  Future<Map<String, String?>> getTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();

    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  // User data storage methods
  Future<void> saveUser(User user) async {
    try {
      final userJson = json.encode(user.toJson());
      await _prefs.setString(_userKey, userJson);
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      } catch (e) {
        await clearUser();
        return null;
      }
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  // Token expiry methods
  Future<void> saveTokenExpiryDate(DateTime expiryDate) async {
    await _prefs.setString(_tokenExpiryKey, expiryDate.toIso8601String());
  }

  Future<DateTime?> getTokenExpiryDate() async {
    final expiryString = _prefs.getString(_tokenExpiryKey);
    if (expiryString != null) {
      try {
        return DateTime.parse(expiryString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearTokenExpiryDate() async {
    await _prefs.remove(_tokenExpiryKey);
  }

  // Check if token is expired
  Future<bool> isTokenExpired() async {
    final expiryDate = await getTokenExpiryDate();
    if (expiryDate == null) return true;
    return DateTime.now().isAfter(expiryDate);
  }

  // Authentication state methods
  Future<void> setRememberMe(bool remember) async {
    await _prefs.setBool(_rememberMeKey, remember);
  }

  Future<bool> getRememberMe() async {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBool(_biometricEnabledKey, enabled);
  }

  Future<bool> getBiometricEnabled() async {
    return _prefs.getBool(_biometricEnabledKey) ?? false;
  }

  // App preferences methods
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  Future<String?> getLanguage() async {
    return _prefs.getString(_languageKey);
  }

  Future<void> setTheme(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  Future<String?> getTheme() async {
    return _prefs.getString(_themeKey);
  }

  // Onboarding and first-time user methods
  Future<void> setFirstTimeUser(bool isFirstTime) async {
    await _prefs.setBool(_firstTimeUserKey, isFirstTime);
  }

  Future<bool> isFirstTimeUser() async {
  // Get setup status - if null or false, it's a first-time user
  bool? isSetup = _prefs.getBool('is_setup');
  print('User setup status: $isSetup');
  
  // First time user if setup is null (no data) or false (not set up)
  return isSetup != true;
}

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingCompletedKey, completed);
  }

  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  // Cache management methods
  Future<void> saveLastSyncTime(DateTime syncTime) async {
    await _prefs.setString(_lastSyncTimeKey, syncTime.toIso8601String());
  }

  Future<DateTime?> getLastSyncTime() async {
    final syncString = _prefs.getString(_lastSyncTimeKey);
    if (syncString != null) {
      try {
        return DateTime.parse(syncString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Search history methods
  Future<void> saveSearchHistory(List<String> searches) async {
    await _prefs.setStringList(_searchHistoryKey, searches);
  }

  Future<List<String>> getSearchHistory() async {
    return _prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> addToSearchHistory(String query) async {
    if (query.trim().isEmpty) return;

    final history = await getSearchHistory();
    history.remove(query); // Remove if already exists
    history.insert(0, query); // Add to beginning

    // Keep only last 20 searches
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }

    await saveSearchHistory(history);
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove(_searchHistoryKey);
  }

  // Recently viewed items
  Future<void> saveRecentlyViewed(List<String> items) async {
    await _prefs.setStringList(_recentlyViewedKey, items);
  }

  Future<List<String>> getRecentlyViewed() async {
    return _prefs.getStringList(_recentlyViewedKey) ?? [];
  }

  Future<void> addToRecentlyViewed(String itemId) async {
    if (itemId.trim().isEmpty) return;

    final recentItems = await getRecentlyViewed();
    recentItems.remove(itemId); // Remove if already exists
    recentItems.insert(0, itemId); // Add to beginning

    // Keep only last 50 items
    if (recentItems.length > 50) {
      recentItems.removeRange(50, recentItems.length);
    }

    await saveRecentlyViewed(recentItems);
  }

  Future<void> clearRecentlyViewed() async {
    await _prefs.remove(_recentlyViewedKey);
  }

  // Favorites management
  Future<void> saveFavorites(List<String> favorites) async {
    await _prefs.setStringList('favorites', favorites);
  }

  Future<List<String>> getFavorites() async {
    return _prefs.getStringList('favorites') ?? [];
  }

  Future<void> addToFavorites(String itemId) async {
    final favorites = await getFavorites();
    if (!favorites.contains(itemId)) {
      favorites.add(itemId);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFromFavorites(String itemId) async {
    final favorites = await getFavorites();
    favorites.remove(itemId);
    await saveFavorites(favorites);
  }

  Future<bool> isFavorite(String itemId) async {
    final favorites = await getFavorites();
    return favorites.contains(itemId);
  }

  // Cache data with expiry
  Future<void> setCacheData(String key, String data, Duration duration) async {
    final expiryTime = DateTime.now().add(duration);
    await _prefs.setString('cache_$key', data);
    await _prefs.setString('cache_${key}_expiry', expiryTime.toIso8601String());
  }

  Future<String?> getCacheData(String key) async {
    final expiryString = _prefs.getString('cache_${key}_expiry');
    if (expiryString != null) {
      try {
        final expiryTime = DateTime.parse(expiryString);
        if (DateTime.now().isAfter(expiryTime)) {
          // Cache expired, remove it
          await _prefs.remove('cache_$key');
          await _prefs.remove('cache_${key}_expiry');
          return null;
        }
      } catch (e) {
        // Invalid expiry time, remove cache
        await _prefs.remove('cache_$key');
        await _prefs.remove('cache_${key}_expiry');
        return null;
      }
    }

    return _prefs.getString('cache_$key');
  }

  // Clear all data methods
  Future<void> clearAllData() async {
    await _prefs.clear();
  }

  Future<void> clearAuthData() async {
    await Future.wait([
      clearAccessToken(),
      clearRefreshToken(),
      clearUser(),
      clearTokenExpiryDate(),
    ]);
  }

  Future<void> clearCacheData() async {
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where((key) => key.startsWith('cache_')).toList();

    for (final key in cacheKeys) {
      await _prefs.remove(key);
    }
  }

  // Utility methods
  Future<bool> hasKey(String key) async {
    return _prefs.containsKey(key);
  }

  Future<Set<String>> getAllKeys() async {
    return _prefs.getKeys();
  }

  Future<Map<String, dynamic>> getAllPrefs() async {
    final keys = _prefs.getKeys();
    final Map<String, dynamic> prefsMap = {};

    for (String key in keys) {
      final value = _prefs.get(key);
      prefsMap[key] = value;
    }

    return prefsMap;
  }

  // App settings
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool('notifications_enabled') ?? true;
  }

  Future<void> setLocationEnabled(bool enabled) async {
    await _prefs.setBool('location_enabled', enabled);
  }

  Future<bool> getLocationEnabled() async {
    return _prefs.getBool('location_enabled') ?? false;
  }

  // Statistics and analytics
  Future<void> incrementLaunchCount() async {
    final currentCount = _prefs.getInt('launch_count') ?? 0;
    await _prefs.setInt('launch_count', currentCount + 1);
  }

  Future<int> getLaunchCount() async {
    return _prefs.getInt('launch_count') ?? 0;
  }

  Future<void> setLastLaunchDate(DateTime date) async {
    await _prefs.setString('last_launch_date', date.toIso8601String());
  }

  Future<DateTime?> getLastLaunchDate() async {
    final dateString = _prefs.getString('last_launch_date');
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Debug methods (only for development)
  Future<void> printAllStoredData() async {
    final allPrefs = await getAllPrefs();
    allPrefs.forEach((key, value) {
      // Mask sensitive data for security
      if (key.contains('token')) {
        if (value is String && value.isNotEmpty) {
          print('$key: ${value.substring(0, 10)}...[MASKED]');
        } else {
          print('$key: [EMPTY]');
        }
      } else {
        print('$key: $value');
      }
    });
  }
}