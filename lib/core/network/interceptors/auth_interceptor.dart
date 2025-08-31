
import 'package:dio/dio.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';


class AuthInterceptor extends Interceptor {
  final AuthProvider authProvider;

  AuthInterceptor(this.authProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add token if available and user is authenticated
    if (authProvider.isAuthenticated && authProvider.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${authProvider.accessToken}';
    }

    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized (token expired)
    if (err.response?.statusCode == 401) {
      // Don't try to refresh token for auth endpoints to avoid infinite loops
      if (_isAuthEndpoint(err.requestOptions.path)) {
        handler.next(err);
        return;
      }
    }

   
    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    final authPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/logout',
      '/login',
      '/register',
      '/refresh',
      '/logout',
    ];
    return authPaths.any((authPath) => path.contains(authPath));
  }
}
