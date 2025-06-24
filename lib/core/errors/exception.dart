abstract class AppException implements Exception {
  final String message;
  final int? code;
  
  AppException(this.message, {this.code});
  
  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(super.message, {super.code});
}

class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;
  
  ValidationException(super.message, {super.code, this.errors});
}

class CacheException extends AppException {
  CacheException(super.message, {super.code});
}

class LocationException extends AppException {
  LocationException(super.message, {super.code});
}

class PermissionException extends AppException {
  PermissionException(super.message, {super.code});
}



