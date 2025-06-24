import 'package:go_router/go_router.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/features/authentication/pages/signup_page.dart';
import 'package:journeyq/features/authentication/pages/login_page.dart';
import 'package:journeyq/features/home/home_page.dart';
import 'route_transistion.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final authStatus = authProvider.status;
        final isOnLogin =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';

        if (authStatus == AuthStatus.unauthenticated && !isOnLogin) {
          return '/login';
        }

        if (authStatus == AuthStatus.authenticated &&
            (isOnLogin )) {
          return '/home';
        }

        return null;
      },
      routes: [
        
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

        TransitionGoRoute(
          path: '/home',
          builder: (context, state) =>  HomePage(),
          transitionType: PageTransitionType.slide,
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
