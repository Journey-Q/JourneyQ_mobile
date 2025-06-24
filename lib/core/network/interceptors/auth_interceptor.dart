// auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/data/repositories/auth_repositories/auth_repository.dart'; // Import your AuthProvider

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

      try {
        // Attempt to refresh token
       final refreshtoken  = await AuthRepository.getRefreshToken();
        if (refreshtoken == null) {
          handler.next(err);
          return;
        }

  
       final authProvider = AuthProvider(); // or get it via Provider/Dependency Injection
       final bool refreshed = await authProvider.refreshTokenSilently();


        if (refreshed) {
          // Update the failed request with new token
          err.requestOptions.headers['Authorization'] =
              'Bearer ${authProvider.accessToken}';

          // Retry the original request
          final dio = Dio();

          // Copy base options
          dio.options = BaseOptions(
            baseUrl: err.requestOptions.baseUrl,
            headers: err.requestOptions.headers,
          );

          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } 
      } catch (refreshError) {
         return ;
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
