// main.dart
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';
import 'package:journeyq/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  AppConfig.instance.initialize(environment: 'development');
  runApp(TravelApp());
}
