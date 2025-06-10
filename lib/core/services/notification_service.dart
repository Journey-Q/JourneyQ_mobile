import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // UNCOMMENT this line after you add google-services.json
      await Firebase.initializeApp();
      if (kDebugMode) print("✅ Firebase initialized successfully");

      // Initialize local notifications
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/launcher_icon'); // Using your app icon
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
      );

      // Create notification channel for Android
      await _createNotificationChannel();

      // Setup Firebase messaging
      await _setupFirebaseMessaging();

      _isInitialized = true;
      if (kDebugMode) print("✅ Notification service initialized completely");
    } catch (e) {
      if (kDebugMode) print("❌ Failed to initialize notifications: $e");
      // Don't rethrow in development - let app continue without notifications
    }
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission status: ${settings.authorizationStatus}');
    }

    // Get FCM token
    String? token = await messaging.getToken();
    print('FCM Token: $token');
   

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received message: ${message.notification?.title}');
      }
      
      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? 'New Message',
          body: message.notification!.body ?? 'You have a new message',
        );
      }
    });

    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message clicked: ${message.notification?.title}');
      }
      // Handle navigation here
    });
  }

  static void _onNotificationResponse(NotificationResponse response) {
    if (kDebugMode) {
      print("Notification tapped: ${response.payload}");
    }
    // Handle notification tap
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'High importance notifications for the app',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'), // Your app icon
        color: Color(0xFFF5F5F5),
        colorized: false, // Don't colorize the large icon
        timeoutAfter: 3000,
        autoCancel: true,
        showWhen: true,
        styleInformation: BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000), // Unique ID
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      if (kDebugMode) {
        print("✅ Notification shown: $title");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Failed to show notification: $e");
      }
    }
  }
}