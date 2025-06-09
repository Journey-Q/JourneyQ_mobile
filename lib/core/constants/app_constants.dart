// core/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Travel App';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String packageName = 'com.travel.app';
  
  // Colors
  static const Color primaryColor = Color(0xFF0088cc);
  static const Color primaryLightColor = Color(0xFF33a3dd);
  static const Color primaryDarkColor = Color(0xFF005588);
  static const Color backgroundColor = Color(0xFFF8FBFF);
  static const Color surfaceColor = Color(0xFFEEF7FF);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFD69E2E);
  static const Color infoColor = Color(0xFF3182CE);
  
  // Text Colors
  static const Color textPrimaryColor = Color(0xFF2D3748);
  static const Color textSecondaryColor = Color(0xFF4A5568);
  static const Color textTertiaryColor = Color(0xFF718096);
  static const Color textLightColor = Color(0xFFA0AEC0);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLightColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundColor, surfaceColor],
  );
  
  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  
  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;
  
  // Padding
  static const EdgeInsets paddingSmall = EdgeInsets.all(spacingSmall);
  static const EdgeInsets paddingMedium = EdgeInsets.all(spacingMedium);
  static const EdgeInsets paddingLarge = EdgeInsets.all(spacingLarge);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: spacingLarge);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: spacingMedium);
  
  // Font Sizes
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeHeading = 24.0;
  static const double fontSizeTitleSmall = 28.0;
  static const double fontSizeTitleMedium = 32.0;
  static const double fontSizeTitleLarge = 36.0;
  
  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;
  
  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  // Button Heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;
  
  // Input Field Heights
  static const double inputHeightSmall = 40.0;
  static const double inputHeightMedium = 48.0;
  static const double inputHeightLarge = 56.0;
  
  // Animation Durations
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  static const Duration animationDurationLong = Duration(milliseconds: 1000);
  
  // Network Timeouts
  static const Duration networkTimeoutShort = Duration(seconds: 10);
  static const Duration networkTimeoutMedium = Duration(seconds: 30);
  static const Duration networkTimeoutLong = Duration(seconds: 60);
  
  // Asset Paths
  static const String assetPathImages = 'assets/images/';
  static const String assetPathIcons = 'assets/icons/';
  static const String assetPathLottie = 'assets/lottie/';
  static const String assetPathFonts = 'assets/fonts/';
  
  // Image Assets
  static const String logoImage = '${assetPathImages}logo.png';
  static const String placeholderImage = '${assetPathImages}placeholder.png';
  static const String noInternetImage = '${assetPathImages}no_internet.png';
  static const String errorImage = '${assetPathImages}error.png';
  static const String emptyStateImage = '${assetPathImages}empty_state.png';
  
  // Lottie Assets
  static const String loadingAnimation = '${assetPathLottie}loading.json';
  static const String successAnimation = '${assetPathLottie}success.json';
  static const String errorAnimation = '${assetPathLottie}error.json';
  static const String emptyAnimation = '${assetPathLottie}empty.json';
  
  // Routes
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeResetPassword = '/reset-password';
  static const String routeEmailVerification = '/email-verification';
  static const String routeOnboarding = '/onboarding';
  static const String routeHome = '/home';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeTrips = '/trips';
  static const String routeTripDetails = '/trip-details';
  static const String routeMarketplace = '/marketplace';
  static const String routeBookings = '/bookings';
  static const String routeNotifications = '/notifications';
  static const String routeChat = '/chat';
  
  // Validation
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 128;
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;
  static const int phoneMinLength = 10;
  static const int phoneMaxLength = 15;
  static const int otpLength = 6;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache
  static const Duration cacheExpiryDuration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // Location
  static const double defaultLatitude = 37.7749; // San Francisco
  static const double defaultLongitude = -122.4194;
  static const double locationUpdateIntervalSeconds = 10.0;
  static const double geofenceRadiusMeters = 100.0;
  
  // Push Notifications
  static const String notificationChannelId = 'travel_app_notifications';
  static const String notificationChannelName = 'Travel App Notifications';
  static const String notificationChannelDescription = 'Notifications for travel updates and messages';
  
  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keySelectedLanguage = 'selected_language';
  static const String keySelectedTheme = 'selected_theme';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyLocationPermissionGranted = 'location_permission_granted';
  
  // Error Messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'No internet connection. Please check your network.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorTimeout = 'Request timeout. Please try again.';
  static const String errorUnauthorized = 'Session expired. Please login again.';
  static const String errorValidation = 'Please check your input and try again.';
  static const String errorLocationPermission = 'Location permission is required.';
  static const String errorCameraPermission = 'Camera permission is required.';
  static const String errorStoragePermission = 'Storage permission is required.';
  
  // Success Messages
  static const String successLogin = 'Login successful!';
  static const String successSignup = 'Account created successfully!';
  static const String successPasswordReset = 'Password reset email sent!';
  static const String successProfileUpdate = 'Profile updated successfully!';
  static const String successPasswordChange = 'Password changed successfully!';
  
  // Loading Messages
  static const String loadingLogin = 'Signing you in...';
  static const String loadingSignup = 'Creating your account...';
  static const String loadingPasswordReset = 'Sending reset email...';
  static const String loadingProfileUpdate = 'Updating profile...';
  
  // Empty State Messages
  static const String emptyTrips = 'No trips found. Start planning your adventure!';
  static const String emptyBookings = 'No bookings yet. Book your first trip!';
  static const String emptyNotifications = 'No new notifications.';
  static const String emptyMessages = 'No messages yet. Start a conversation!';
  
  // Date Formats
  static const String dateFormatShort = 'MMM dd, yyyy';
  static const String dateFormatLong = 'MMMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  static const String timeFormat = 'HH:mm';
  
  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';
  
  // Platform Specific
  static const double iosNavigationBarHeight = 44.0;
  static const double androidAppBarHeight = 56.0;
  static const double bottomNavigationBarHeight = 60.0;
  
  // Feature Flags
  static const bool enableBiometric = true;
  static const bool enableSocialLogin = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableDarkMode = true;
  static const bool enableOfflineMode = true;
  
  // Social Media URLs
  static const String facebookUrl = 'https://facebook.com/travelapp';
  static const String twitterUrl = 'https://twitter.com/travelapp';
  static const String instagramUrl = 'https://instagram.com/travelapp';
  static const String linkedinUrl = 'https://linkedin.com/company/travelapp';
  
  // Support
  static const String supportEmail = 'support@travelapp.com';
  static const String supportPhone = '+1-800-TRAVEL';
  static const String termsUrl = 'https://travelapp.com/terms';
  static const String privacyUrl = 'https://travelapp.com/privacy';
  static const String faqUrl = 'https://travelapp.com/faq';
}