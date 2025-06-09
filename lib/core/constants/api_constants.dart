// core/constants/api_constants.dart
class ApiConstants {
  // Base configuration
  static const String apiVersion = 'v1';
  static const String contentType = 'application/json';
  static const String acceptType = 'application/json';
  
  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusAccepted = 202;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusConflict = 409;
  static const int statusUnprocessableEntity = 422;
  static const int statusInternalServerError = 500;
  static const int statusBadGateway = 502;
  static const int statusServiceUnavailable = 503;
  
  // Timeout configurations
  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int sendTimeoutSeconds = 30;
  
  // Request headers
  static const String headerContentType = 'Content-Type';
  static const String headerAccept = 'Accept';
  static const String headerAuthorization = 'Authorization';
  static const String headerRefreshToken = 'Refresh-Token';
  static const String headerDeviceId = 'Device-Id';
  static const String headerAppVersion = 'App-Version';
  static const String headerPlatform = 'Platform';
  static const String headerLanguage = 'Accept-Language';
  
  // Response keys
  static const String keySuccess = 'success';
  static const String keyMessage = 'message';
  static const String keyData = 'data';
  static const String keyError = 'error';
  static const String keyErrors = 'errors';
  static const String keyCode = 'code';
  static const String keyAccessToken = 'accessToken';
  static const String keyRefreshToken = 'refreshToken';
  static const String keyExpiresAt = 'expiresAt';
  static const String keyUser = 'user';
  
  // Pagination keys
  static const String keyPage = 'page';
  static const String keyLimit = 'limit';
  static const String keyTotal = 'total';
  static const String keyTotalPages = 'totalPages';
  static const String keyHasNext = 'hasNext';
  static const String keyHasPrev = 'hasPrev';
  
  // Default values
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const String defaultLanguage = 'en';
  static const String defaultCurrency = 'USD';
}

// network/endpoints.dart
class Endpoints {
  // Base endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String trips = '/trips';
  static const String marketplace = '/marketplace';
  static const String notifications = '/notifications';
  static const String chat = '/chat';
  static const String reviews = '/reviews';
  static const String bookings = '/bookings';
  static const String payments = '/payments';
  static const String locations = '/locations';
  static const String media = '/media';
  
  // Authentication endpoints
  static const String login = '$auth/login';
  static const String signup = '$auth/signup';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String verifyEmail = '$auth/verify-email';
  static const String resendVerification = '$auth/resend-verification';
  static const String changePassword = '$auth/change-password';
  static const String verifyOtp = '$auth/verify-otp';
  static const String socialLogin = '$auth/social';
  
  // User endpoints
  static const String profile = '$users/profile';
  static const String updateProfile = '$users/profile';
  static const String uploadAvatar = '$users/avatar';
  static const String userPreferences = '$users/preferences';
  static const String userSettings = '$users/settings';
  static const String deleteAccount = '$users/delete';
  static const String userStats = '$users/stats';
  static const String userTrips = '$users/trips';
  static const String userBookings = '$users/bookings';
  static const String userReviews = '$users/reviews';
  
  // Trip endpoints
  static const String createTrip = '$trips';
  static const String joinTrip = '$trips/join';
  static const String leaveTrip = '$trips/leave';
  static const String tripDetails = '$trips/{id}';
  static const String tripMembers = '$trips/{id}/members';
  static const String tripItinerary = '$trips/{id}/itinerary';
  static const String tripExpenses = '$trips/{id}/expenses';
  static const String tripPhotos = '$trips/{id}/photos';
  static const String tripReviews = '$trips/{id}/reviews';
  static const String searchTrips = '$trips/search';
  static const String popularTrips = '$trips/popular';
  static const String nearbyTrips = '$trips/nearby';
  static const String myTrips = '$trips/my';
  
  // Marketplace endpoints
  static const String marketplaceItems = '$marketplace/items';
  static const String marketplaceCategories = '$marketplace/categories';
  static const String marketplaceSearch = '$marketplace/search';
  static const String marketplaceFeatured = '$marketplace/featured';
  static const String marketplaceItem = '$marketplace/items/{id}';
  static const String marketplaceItemReviews = '$marketplace/items/{id}/reviews';
  static const String marketplaceVendors = '$marketplace/vendors';
  static const String marketplaceVendor = '$marketplace/vendors/{id}';
  
  // Booking endpoints
  static const String createBooking = '$bookings';
  static const String bookingDetails = '$bookings/{id}';
  static const String cancelBooking = '$bookings/{id}/cancel';
  static const String confirmBooking = '$bookings/{id}/confirm';
  static const String bookingPayment = '$bookings/{id}/payment';
  static const String myBookings = '$bookings/my';
  static const String bookingHistory = '$bookings/history';
  
  // Payment endpoints
  static const String paymentMethods = '$payments/methods';
  static const String addPaymentMethod = '$payments/methods';
  static const String deletePaymentMethod = '$payments/methods/{id}';
  static const String processPayment = '$payments/process';
  static const String paymentHistory = '$payments/history';
  static const String refund = '$payments/refund';
  
  
  // Utility methods
  static String replacePathParameter(String endpoint, String parameter, String value) {
    return endpoint.replaceAll('{$parameter}', value);
  }
  
  static String buildQueryString(Map<String, dynamic> params) {
    if (params.isEmpty) return '';
    
    final query = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    
    return query.isEmpty ? '' : '?$query';
  }
  
  static String buildPaginationQuery({
    int page = 1,
    int limit = ApiConstants.defaultPageSize,
    String? sortBy,
    String? sortOrder,
    Map<String, dynamic>? filters,
  }) {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (sortBy != null) params['sortBy'] = sortBy;
    if (sortOrder != null) params['sortOrder'] = sortOrder;
    if (filters != null) params.addAll(filters);
    
    return buildQueryString(params);
  }
}