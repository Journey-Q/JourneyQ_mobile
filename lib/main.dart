// main.dart
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';
import 'package:journeyq/core/services/notification_service.dart';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/data/repositories/chat_repository/chat_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await NotificationService.initialize();

  // Initialize app config
  AppConfig.instance.initialize(environment: 'development');

  // Initialize AuthProvider and load stored tokens
  final authProvider = AuthProvider();
  await authProvider.initialize(); // This loads tokens and sets authentication state

  // Initialize ApiService with the auth provider
  ApiService.initialize(authProvider);

  // Initialize ChatRepository with the auth provider
  await ChatRepository().initialize(authProvider);

  runApp(TravelApp());
}