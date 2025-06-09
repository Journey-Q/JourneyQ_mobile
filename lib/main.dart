// main.dart
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.instance.initialize(environment: 'development');
  runApp(TravelApp());
}
