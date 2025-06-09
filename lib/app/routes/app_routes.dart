import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';



class AppRoutes {
  // Define route names as constants
  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = AppConstants.routeOnboarding;
  static const String login = AppConstants.routeLogin;
  static const String signup = AppConstants.routeSignup;
  static const String forgotPassword = AppConstants.routeForgotPassword;
  static const String resetPassword = AppConstants.routeResetPassword;
  static const String emailVerification = AppConstants.routeEmailVerification;
  static const String home = AppConstants.routeHome;
  static const String profile = AppConstants.routeProfile;
  static const String settings = AppConstants.routeSettings;
  static const String trips = AppConstants.routeTrips;
  static const String tripDetails = AppConstants.routeTripDetails;
  static const String marketplace = AppConstants.routeMarketplace;
  static const String bookings = AppConstants.routeBookings;
  static const String notifications = AppConstants.routeNotifications;
  static const String chat = AppConstants.routeChat;

  // Navigation helper methods
  static Future<void> pushLogin(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      login,
      (route) => false,
    );
  }

  static Future<void> pushHome(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      home,
      (route) => false,
    );
  }

  static Future<void> pushSignup(BuildContext context) {
    return Navigator.pushNamed(context, signup);
  }

  static Future<void> pushForgotPassword(BuildContext context) {
    return Navigator.pushNamed(context, forgotPassword);
  }

  static Future<void> pushResetPassword(BuildContext context, String token) {
    return Navigator.pushNamed(
      context,
      resetPassword,
      arguments: {'token': token},
    );
  }

  static Future<void> pushEmailVerification(BuildContext context, String email) {
    return Navigator.pushNamed(
      context,
      emailVerification,
      arguments: {'email': email},
    );
  }

  static Future<void> pushTripDetails(BuildContext context, String tripId) {
    return Navigator.pushNamed(
      context,
      tripDetails,
      arguments: {'tripId': tripId},
    );
  }

  static Future<void> pushChat(BuildContext context, String chatId, {String? chatName}) {
    return Navigator.pushNamed(
      context,
      chat,
      arguments: {
        'chatId': chatId,
        if (chatName != null) 'chatName': chatName,
      },
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
  
}



