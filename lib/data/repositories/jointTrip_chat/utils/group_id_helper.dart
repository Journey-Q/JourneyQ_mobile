/// Helper utility for managing group IDs
///
/// This utility handles the conversion between Firebase group IDs (String format: "trip_{tripId}")
/// and backend group IDs (Long/int format)
class GroupIdHelper {
  /// Generate a numeric group ID from trip ID
  /// This is the groupId that will be sent to backend API
  ///
  /// For simplicity, we use the tripId itself as the groupId
  /// Backend stores this as a Long in the database
  static int generateGroupId(int tripId) {
    return tripId;
  }

  /// Generate Firebase group ID string from trip ID
  /// Format: "trip_{tripId}"
  /// This is used as the key in Firebase Realtime Database
  static String generateFirebaseGroupId(int tripId) {
    return 'trip_$tripId';
  }

  /// Extract trip ID from Firebase group ID
  /// Converts "trip_123" to 123
  static int? extractTripIdFromFirebaseGroupId(String firebaseGroupId) {
    if (!firebaseGroupId.startsWith('trip_')) {
      return null;
    }

    final tripIdStr = firebaseGroupId.substring(5); // Remove "trip_" prefix
    return int.tryParse(tripIdStr);
  }

  /// Validate Firebase group ID format
  static bool isValidFirebaseGroupId(String groupId) {
    if (!groupId.startsWith('trip_')) {
      return false;
    }

    final tripIdStr = groupId.substring(5);
    return int.tryParse(tripIdStr) != null;
  }

  /// Get numeric group ID from Firebase group ID
  /// Converts "trip_123" to 123
  static int? getNumericGroupId(String firebaseGroupId) {
    return extractTripIdFromFirebaseGroupId(firebaseGroupId);
  }
}

/// Extension on int for easy group ID operations
extension TripIdGroupIdExtension on int {
  /// Get the numeric group ID for this trip ID
  /// For API requests to backend
  int get groupId => GroupIdHelper.generateGroupId(this);

  /// Get the Firebase group ID for this trip ID
  /// For Firebase Realtime Database operations
  String get firebaseGroupId => GroupIdHelper.generateFirebaseGroupId(this);
}

/// Extension on String for Firebase group ID operations
extension FirebaseGroupIdExtension on String {
  /// Check if this string is a valid Firebase group ID
  bool get isValidFirebaseGroupId => GroupIdHelper.isValidFirebaseGroupId(this);

  /// Extract trip ID from Firebase group ID
  int? get tripId => GroupIdHelper.extractTripIdFromFirebaseGroupId(this);

  /// Get numeric group ID from Firebase group ID
  int? get numericGroupId => GroupIdHelper.getNumericGroupId(this);
}
