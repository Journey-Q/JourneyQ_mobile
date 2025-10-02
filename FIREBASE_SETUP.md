# Firebase Realtime Database Configuration Guide

## Overview
This guide explains how to configure the Flutter app to connect to the same Firebase Realtime Database that your Spring Boot backend is using.

## 🔧 Configuration Steps

### 1. Get Firebase Configuration from Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (the same one your Spring Boot backend uses)
3. Go to **Project Settings** > **General** > **Your apps**
4. Find your app or create a new Flutter app
5. Copy the configuration values

### 2. Update Firebase Options

Edit `lib/core/config/firebase_options.dart` and replace the placeholder values:

```dart
// Replace these with your actual Firebase project configuration
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyC...', // Your actual API key
  appId: '1:123456789:android:abc123', // Your actual App ID  
  messagingSenderId: '123456789', // Your actual sender ID
  projectId: 'your-actual-project-id', // Same as Spring Boot
  databaseURL: 'https://your-project-id-default-rtdb.firebaseio.com', // Same database URL as Spring Boot
  storageBucket: 'your-project-id.appspot.com',
);
```

### 3. Update Firebase Config Service

Edit `lib/core/config/firebase_config.dart` and update the constants:

```dart
class FirebaseConfig {
  // Replace with your actual project details
  static const String _projectId = 'your-actual-project-id'; // Same as Spring Boot
  static const String _databaseUrl = 'https://your-project-id-default-rtdb.firebaseio.com/'; // Same as Spring Boot
  static const String _apiKey = 'AIzaSyC...'; // Your actual API key
  static const String _appId = '1:123456789:android:abc123'; // Your actual app ID
  static const String _messagingSenderId = '123456789'; // Your actual sender ID
}
```

### 4. Match Spring Boot Configuration

Make sure the database URL in Flutter matches exactly with your Spring Boot `application.properties`:

**Spring Boot (application.properties):**
```properties
firebase.database.url=https://your-project-id-default-rtdb.firebaseio.com/
firebase.service.account.key.path=path/to/service-account-key.json
```

**Flutter (firebase_config.dart):**
```dart
static const String _databaseUrl = 'https://your-project-id-default-rtdb.firebaseio.com/';
```

### 5. Initialize Firebase in Your App

In your `main.dart`, initialize Firebase before running the app:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:journeyq/core/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with your configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}
```

## 🌍 Environment-Specific Configuration

For different environments (dev/staging/prod), update the build command:

```bash
# Development
flutter run --dart-define=ENVIRONMENT=development

# Staging  
flutter run --dart-define=ENVIRONMENT=staging

# Production
flutter run --dart-define=ENVIRONMENT=production
```

## 🔐 Security Rules

Make sure your Firebase Database has appropriate security rules. Example rules for chat functionality:

```json
{
  "rules": {
    "individual_chats": {
      "$chatId": {
        ".read": "auth != null && (data.child('participants').child(auth.uid).exists() || !data.exists())",
        ".write": "auth != null && (data.child('participants').child(auth.uid).exists() || !data.exists())",
        "messages": {
          "$messageId": {
            ".write": "auth != null && auth.uid == newData.child('senderId').val()"
          }
        }
      }
    },
    "user_chats": {
      "$userId": {
        ".read": "auth != null && auth.uid == $userId",
        ".write": "auth != null && auth.uid == $userId"
      }
    },
    "typing": {
      "$chatId": {
        "$userId": {
          ".write": "auth != null && auth.uid == $userId"
        }
      }
    },
    "user_status": {
      "$userId": {
        ".read": true,
        ".write": "auth != null && auth.uid == $userId"
      }
    }
  }
}
```

## 🧪 Testing the Connection

The chat service will automatically verify the database connection when initialized. Check the console logs for:

```
✅ Firebase Chat Service initialized successfully
📍 Database URL: https://your-project-id-default-rtdb.firebaseio.com
📍 Project ID: your-project-id
✅ Database connection verified successfully
```

## 🚀 Usage in Chat Service

The chat service will now connect to your specific database:

```dart
// This will use your configured database
final chatService = FirebaseChatService();
await chatService.initialize();

// All operations now use your specific Firebase database
final messages = chatService.streamChatMessages('chat_user1_user2');
```

## 📝 Important Notes

1. **Same Database**: The Flutter app and Spring Boot backend must use the EXACT same database URL
2. **Authentication**: Make sure Firebase Auth is properly configured if using security rules
3. **Network**: Ensure your app has internet connectivity for real-time updates
4. **Offline**: The service enables offline persistence for better performance

## 🔍 Troubleshooting

If you see connection errors:

1. Verify the database URL is exactly the same as your Spring Boot configuration
2. Check that your Firebase project has Realtime Database enabled
3. Ensure your API keys are correct and have proper permissions
4. Check network connectivity and Firebase security rules

## 📱 Platform-Specific Setup

### Android
Add `google-services.json` to `android/app/`

### iOS  
Add `GoogleService-Info.plist` to `ios/Runner/`

### Web
Update `web/index.html` with Firebase configuration

The configuration files can be downloaded from Firebase Console > Project Settings > Your apps.