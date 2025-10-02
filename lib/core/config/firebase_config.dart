import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static FirebaseConfig? _instance;
  static FirebaseConfig get instance => _instance ??= FirebaseConfig._internal();
  FirebaseConfig._internal();

  // 🔥 FIREBASE CREDENTIALS - Replace with your actual values
  static const String _projectId = 'journeyq-bfbbd';
  static const String _databaseUrl = 'https://journeyq-bfbbd-default-rtdb.firebaseio.com/';
  static const String _apiKey = 'AIzaSyBy82-kU32CkHKIPtRJTw_QFUYxBdYW84g'; // Your actual API key
  static const String _appId = '1:764245104845:android:c7a35ab270f5c6404df184'; // Your actual App ID
  static const String _messagingSenderId = '764245104845'; // Your actual Sender ID
  static const String _storageBucket = 'journeyq-bfbbd.firebasestorage.app';

  bool _initialized = false;
  FirebaseApp? _app;
  FirebaseDatabase? _database;

  /// Initialize Firebase with programmatic credentials
  Future<void> initialize() async {
    if (_initialized) {
      print('🔥 Firebase Chat already initialized');
      return;
    }

    try {
      print('🔄 Initializing Firebase Chat with programmatic credentials...');

      // Check if default app already exists (from authentication)
      FirebaseApp? existingApp;
      try {
        existingApp = Firebase.app();
        print('🔥 Found existing Firebase app for authentication');
      } catch (e) {
        print('🔄 No existing Firebase app found, will create new one');
      }

      if (existingApp != null) {
        // Use existing app but create separate database instance
        print('🔄 Using existing Firebase app for chat database...');
        _app = existingApp;

        // Get database instance with your specific database URL
        _database = FirebaseDatabase.instanceFor(
          app: _app!,
          databaseURL: _databaseUrl,
        );

      } else {
        // Create new Firebase app if none exists
        final firebaseOptions = FirebaseOptions(
          projectId: _projectId,
          databaseURL: _databaseUrl,
          apiKey: _apiKey,
          appId: _appId,
          messagingSenderId: _messagingSenderId,
          storageBucket: _storageBucket,
          // Platform-specific additional options
          authDomain: kIsWeb ? '$_projectId.firebaseapp.com' : null,
          iosBundleId: defaultTargetPlatform == TargetPlatform.iOS ? 'com.example.journeyq' : null,
        );

        // Initialize Firebase with specific credentials
        _app = await Firebase.initializeApp(
          options: firebaseOptions,
        );
        
        // Get database instance with your specific database URL
        _database = FirebaseDatabase.instanceFor(
          app: _app!,
          databaseURL: _databaseUrl,
        );

      }

      // Configure database settings
      await _configureDatabaseSettings();

      _initialized = true;
      print('✅ Firebase initialized successfully');
      print('📍 Project ID: $_projectId');
      print('📍 Database URL: $_databaseUrl');

      // Verify connection
      await _verifyConnection();
      
    } catch (e) {
      print('❌ Failed to initialize Firebase: $e');
      _initialized = false;
      throw Exception('Firebase initialization failed: $e');
    }
  }


  /// Configure database settings for better performance
  Future<void> _configureDatabaseSettings() async {
    if (_database == null) return;

    try {
      // Enable offline persistence (optional, skip if it causes issues)
      try {
        _database!.setPersistenceEnabled(true);
        print('🔧 Offline persistence enabled');
      } catch (e) {
        print('⚠️ Could not enable offline persistence: $e');
      }
      
      // Set cache size (10MB) (optional, skip if it causes issues)
      try {
        _database!.setPersistenceCacheSizeBytes(10 * 1024 * 1024);
        print('🔧 Cache size configured');
      } catch (e) {
        print('⚠️ Could not configure cache size: $e');
      }

      print('🔧 Database settings configuration completed');
    } catch (e) {
      print('⚠️ Warning: General database configuration error: $e');
    }
  }

  /// Verify database connection with open access
  Future<void> _verifyConnection() async {
    try {
      print('🔍 Verifying database connection with open access...');

      // Test with a simple write/read to verify open access
      final testRef = _database!.ref('connection_test');
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Try to write test data (this will work if database rules allow open access)
      await testRef.set({
        'timestamp': timestamp,
        'status': 'connected',
        'message': 'Firebase chat database connection test - no auth required'
      });

      // Try to read it back
      final snapshot = await testRef.get();
      if (snapshot.exists && snapshot.value != null) {
        print('✅ Database connection verified - open access working');

        // Clean up test data
        await testRef.remove();
        print('✅ Test data cleaned up');
      } else {
        print('⚠️ Could not verify database read access');
      }

      print('✅ Firebase chat database setup complete');

    } catch (e) {
      print('❌ Database connection verification failed: $e');
      print('⚠️ Please set your Firebase Database Rules to allow open access:');
      print('1. Go to https://console.firebase.google.com/');
      print('2. Select your project: journeyq-bfbbd');
      print('3. Go to Realtime Database > Rules');
      print('4. Replace the rules with:');
      print('''
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
      ''');
      print('5. Click "Publish" to save the rules');
      print('⚠️ Continuing with Firebase setup');
    }
  }

  /// Get the configured Firebase Database instance
  FirebaseDatabase get database {
    if (!_initialized || _database == null) {
      throw StateError('Firebase not initialized. Call initialize() first.');
    }
    return _database!;
  }

  /// Get the Firebase App instance
  FirebaseApp get app {
    if (!_initialized || _app == null) {
      throw StateError('Firebase not initialized. Call initialize() first.');
    }
    return _app!;
  }


  /// Get database reference with specific path
  DatabaseReference getDatabaseReference([String? path]) {
    final db = database;
    return path != null ? db.ref(path) : db.ref();
  }

  /// Check if Firebase is initialized
  bool get isInitialized => _initialized;

  /// Get database URL being used
  String get databaseUrl => _databaseUrl;

  /// Get project ID being used  
  String get projectId => _projectId;

  /// Dispose Firebase resources
  Future<void> dispose() async {
    try {
      if (_app != null) {
        await _app!.delete();
        _app = null;
        _database = null;
        _initialized = false;
        print('🗑️ Firebase disposed successfully');
      }
    } catch (e) {
      print('⚠️ Error disposing Firebase: $e');
    }
  }
}

/// Extension to create database references easily
extension DatabaseReferenceExtension on FirebaseConfig {
  /// Get individual chats reference
  DatabaseReference get individualChatsRef => getDatabaseReference('individual_chats');
  
  /// Get user chats reference
  DatabaseReference get userChatsRef => getDatabaseReference('user_chats');
  
  /// Get typing reference
  DatabaseReference get typingRef => getDatabaseReference('typing');
  
  /// Get user status reference
  DatabaseReference get userStatusRef => getDatabaseReference('user_status');
  
  /// Get specific chat reference
  DatabaseReference getChatRef(String chatId) => 
      getDatabaseReference('individual_chats/$chatId');
  
  /// Get specific user chat list reference
  DatabaseReference getUserChatListRef(String userId) => 
      getDatabaseReference('user_chats/$userId');
}

/// Firebase credential configuration helper
class FirebaseCredentials {
  // 🔧 HOW TO GET THESE VALUES:
  // 1. Go to Firebase Console: https://console.firebase.google.com/
  // 2. Select your project
  // 3. Go to Project Settings > General
  // 4. Under "Your apps", select your app or add new app
  // 5. Copy the configuration values
  
  /// Validate that credentials are properly configured
  static bool validateCredentials() {
    const defaultValues = [
      'your-project-id',
      'AIzaSy...',
      '1:123456:android:abc123',
      '123456789'
    ];
    
    const actualValues = [
      FirebaseConfig._projectId,
      FirebaseConfig._apiKey,
      FirebaseConfig._appId,
      FirebaseConfig._messagingSenderId,
    ];
    
    // Check if any default placeholder values are still being used
    for (int i = 0; i < defaultValues.length; i++) {
      if (actualValues[i] == defaultValues[i]) {
        print('❌ Please update ${_getFieldName(i)} in firebase_config.dart');
        return false;
      }
    }
    
    return true;
  }
  
  static String _getFieldName(int index) {
    switch (index) {
      case 0: return 'PROJECT_ID';
      case 1: return 'API_KEY';
      case 2: return 'APP_ID';
      case 3: return 'MESSAGING_SENDER_ID';
      default: return 'UNKNOWN_FIELD';
    }
  }
  
  /// Print setup instructions
  static void printSetupInstructions() {
    print('🔧 FIREBASE SETUP INSTRUCTIONS:');
    print('1. Go to https://console.firebase.google.com/');
    print('2. Select your project');
    print('3. Go to Project Settings > General');
    print('4. Under "Your apps", find your app configuration');
    print('5. Update the values in firebase_config.dart:');
    print('   - _projectId: Your Firebase project ID');
    print('   - _databaseUrl: Your Realtime Database URL');
    print('   - _apiKey: Your API key');
    print('   - _appId: Your app ID');
    print('   - _messagingSenderId: Your messaging sender ID');
  }
  
  /// Print database rules for open access (no authentication required)
  static void printOpenAccessRules() {
    print('🔧 FIREBASE DATABASE RULES (OPEN ACCESS):');
    print('1. Go to https://console.firebase.google.com/');
    print('2. Select your project: journeyq-bfbbd');
    print('3. Go to Realtime Database > Rules');
    print('4. Replace the rules with:');
    print('''
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
    ''');
    print('5. Click "Publish" to save the rules');
    print('ℹ️  This allows the chat functionality to work without authentication');
    print('ℹ️  Perfect for development and testing');
  }
}