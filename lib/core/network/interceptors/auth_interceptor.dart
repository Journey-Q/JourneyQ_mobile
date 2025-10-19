
import 'package:dio/dio.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';


class AuthInterceptor extends Interceptor {
  final AuthProvider authProvider;

  AuthInterceptor(this.authProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if this is a public endpoint that doesn't need authentication
    bool isPublicEndpoint = _isPublicEndpoint(options.path);

    print('🔐 AuthInterceptor - Request to: ${options.path}');
    print('   Is Public Endpoint: $isPublicEndpoint');
    print('   Is Authenticated: ${authProvider.isAuthenticated}');
    print('   Has Access Token: ${authProvider.accessToken != null}');

    // CRITICAL: For public endpoints, explicitly remove Authorization header if it exists
    if (isPublicEndpoint) {
      options.headers.remove('Authorization');
      print('   ✅ Removed any Authorization header (public endpoint)');
    } else if (authProvider.isAuthenticated && authProvider.accessToken != null) {
      // Add token only for protected endpoints when user is authenticated
      options.headers['Authorization'] = 'Bearer ${authProvider.accessToken}';
      print('   ✅ Added Authorization header for protected endpoint');
    } else {
      print('   ℹ️ No Authorization header (not authenticated)');
    }

    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    print('   Final Headers: ${options.headers}');
    handler.next(options);
  }

  bool _isPublicEndpoint(String path) {
    final publicPaths = [
      '/service/hotel-profiles',   // Hotel profile endpoints are public
      '/service/rooms',             // Room endpoints are public
      '/service/reviews',           // Review endpoints are public
      '/service/agency-profiles',   // Agency profile endpoints are public
      '/service/providers',         // Provider endpoints are public
      '/service/tours',             // Tour package endpoints are public
      '/service/vehicles',          // Vehicle endpoints are public
      '/service/drivers',           // Driver endpoints are public
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/login',
      '/register',
    ];
    return publicPaths.any((publicPath) => path.contains(publicPath));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('🚨 AuthInterceptor - Error for: ${err.requestOptions.path}');
    print('   Status Code: ${err.response?.statusCode}');
    print('   Error Type: ${err.type}');

    // Handle 401 Unauthorized (token expired)
    if (err.response?.statusCode == 401) {
      print('   401 Unauthorized - Token may be expired');
      // Don't try to refresh token for auth endpoints to avoid infinite loops
      if (_isAuthEndpoint(err.requestOptions.path)) {
        handler.next(err);
        return;
      }
    }

    // Handle 403 Forbidden - might be due to invalid token on public endpoint
    if (err.response?.statusCode == 403) {
      print('   403 Forbidden - Checking if this is a public endpoint');
      if (_isPublicEndpoint(err.requestOptions.path)) {
        print('   ⚠️ Public endpoint returning 403! This should not happen.');
        print('   Request Headers: ${err.requestOptions.headers}');
        print('   Response: ${err.response?.data}');
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
