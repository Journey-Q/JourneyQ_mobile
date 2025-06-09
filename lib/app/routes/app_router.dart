import 'package:go_router/go_router.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/features/splash_page.dart';
import 'package:journeyq/features/authentication/pages/login_page.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider, // Rebuilds routes when auth changes
      redirect: (context, state) {
        final authStatus = authProvider.status;
        final isOnSplash = state.matchedLocation == '/splash';
        final isOnLogin =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // Show splash while determining auth status
        if (authStatus == AuthStatus.initial && !isOnSplash) {
          return '/splash';
        }

        // Redirect to login if not authenticated and not already on auth pages
        if (authStatus == AuthStatus.unauthenticated &&
            !isOnLogin) {
          return '/login';
        }

        // Redirect to home if authenticated and on auth pages
        if (authStatus == AuthStatus.authenticated &&
            (isOnLogin || isOnSplash)) {
          return '/home';
        }

        return null; // No redirect needed
      },
      routes: [
        // Splash route
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
        ),

        // Auth routes (public)
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        )

        // Protected routes
        // ShellRoute(
        //   builder: (context, state, child) {
        //     return ProtectedRouteShell(child: child);
        //   },
        //   routes: [
        //     GoRoute(
        //       path: '/home',
        //       builder: (context, state) => const HomeScreen(),
        //       routes: [
        //         GoRoute(
        //           path: 'profile/:userId',
        //           builder: (context, state) => ProfileScreen(
        //             userId: state.pathParameters['userId']!,
        //           ),
        //         ),
        //       ],
        //     ),
        //     GoRoute(
        //       path: '/search',
        //       builder: (context, state) => const SearchScreen(),
        //     ),
        //     GoRoute(
        //       path: '/create',
        //       builder: (context, state) => const CreatePostScreen(),
        //     ),
        //     GoRoute(
        //       path: '/notifications',
        //       builder: (context, state) => const NotificationsScreen(),
        //     ),
        //     GoRoute(
        //       path: '/profile',
        //       builder: (context, state) => const MyProfileScreen(),
        //       routes: [
        //         GoRoute(
        //           path: 'edit',
        //           builder: (context, state) => const EditProfileScreen(),
        //         ),
        //         GoRoute(
        //           path: 'settings',
        //           builder: (context, state) => const SettingsScreen(),
        //           routes: [
        //             GoRoute(
        //               path: 'privacy',
        //               builder: (context, state) => const PrivacySettingsScreen(),
        //             ),
        //             GoRoute(
        //               path: 'security',
        //               builder: (context, state) => const SecuritySettingsScreen(),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //     GoRoute(
        //       path: '/messages',
        //       builder: (context, state) => const MessagesScreen(),
        //       routes: [
        //         GoRoute(
        //           path: 'chat/:chatId',
        //           builder: (context, state) => ChatScreen(
        //             chatId: state.pathParameters['chatId']!,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
