import 'package:go_router/go_router.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/features/authentication/pages/signup_page.dart';
import 'package:journeyq/features/splash_page.dart';
import 'package:journeyq/features/authentication/pages/login_page.dart';
import 'route_transistion.dart';



class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final authStatus = authProvider.status;
        final isOnSplash = state.matchedLocation == '/splash';
        final isOnLogin =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';

        if (authStatus == AuthStatus.initial && !isOnSplash) {
          return '/splash';
        }

        if (authStatus == AuthStatus.unauthenticated && !isOnLogin) {
          return '/login';
        }

        if (authStatus == AuthStatus.authenticated &&
            (isOnLogin || isOnSplash)) {
          return '/home';
        }

        return null;
      },
      routes: [
        // Splash route with no animation
        TransitionGoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
          transitionType: PageTransitionType.none,
        ),

        // Login route with up-down animation
        
        TransitionGoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpPage(),
          transitionType: PageTransitionType.upDown,
        ),
        
        TransitionGoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
          transitionType: PageTransitionType.upDown,
        ),
        // Example of protected routes with different animations
        /*
        TransitionGoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          transitionType: PageTransitionType.slide,
          routes: [
            TransitionGoRoute(
              path: 'profile/:userId',
              builder: (context, state) => ProfileScreen(
                userId: state.pathParameters['userId']!,
              ),
              transitionType: PageTransitionType.upDown,
            ),
          ],
        ),

        TransitionGoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/create',
          builder: (context, state) => const CreatePostScreen(),
          transitionType: PageTransitionType.upDown,
        ),

        TransitionGoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/profile',
          builder: (context, state) => const MyProfileScreen(),
          transitionType: PageTransitionType.slide,
          routes: [
            TransitionGoRoute(
              path: 'edit',
              builder: (context, state) => const EditProfileScreen(),
              transitionType: PageTransitionType.upDown,
            ),
            TransitionGoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
              transitionType: PageTransitionType.slide,
              routes: [
                TransitionGoRoute(
                  path: 'privacy',
                  builder: (context, state) => const PrivacySettingsScreen(),
                  transitionType: PageTransitionType.upDown,
                ),
                TransitionGoRoute(
                  path: 'security',
                  builder: (context, state) => const SecuritySettingsScreen(),
                  transitionType: PageTransitionType.upDown,
                ),
              ],
            ),
          ],
        ),

        TransitionGoRoute(
          path: '/messages',
          builder: (context, state) => const MessagesScreen(),
          transitionType: PageTransitionType.slide,
          routes: [
            TransitionGoRoute(
              path: 'chat/:chatId',
              builder: (context, state) => ChatScreen(
                chatId: state.pathParameters['chatId']!,
              ),
              transitionType: PageTransitionType.upDown,
            ),
          ],
        ),
        */
      ],
    );
  }
}