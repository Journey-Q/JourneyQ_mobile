import 'package:go_router/go_router.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/features/authentication/pages/signup_page.dart';
import 'package:journeyq/features/authentication/pages/login_page.dart';
import 'package:journeyq/features/market_place/pages/index.dart';
import 'package:journeyq/features/join_trip/pages/index.dart';
import 'package:journeyq/features/create_trip/pages/index.dart';
import 'package:journeyq/features/home/pages/home_page.dart';
import 'route_transistion.dart';
import 'package:journeyq/features/profile/pages/index.dart';
import 'package:journeyq/app/app.dart';
import 'package:journeyq/features/search/pages/search_page.dart';
import 'package:journeyq/features/notification/pages/notification.dart';
import 'package:journeyq/features/chat/pages/indexpage.dart';
import 'package:journeyq/features/chat/pages/chatpage.dart';

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

        if (authStatus == AuthStatus.authenticated && (isOnLogin)) {
          return '/home';
        }

        return null;
      },
      routes: [
        // Authentication routes (NO _AppWrapper - no bottom navigation needed)
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

        // Main app routes (WITH _AppWrapper - bottom navigation included)
        TransitionGoRoute(
          path: '/home',
          builder: (context, state) =>
              AppWrapper(currentRoute: '/home', child: HomePage()),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/marketplace',
          builder: (context, state) => AppWrapper(
            currentRoute: '/marketplace',
            child: MarketplacePage(),
          ),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/create',
          builder: (context, state) =>
              AppWrapper(currentRoute: '/create', child: CreateTripPage()),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/join_trip',
          builder: (context, state) =>
              AppWrapper(currentRoute: '/join_trip', child: JoinTripPage()),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/profile',
          builder: (context, state) =>
              AppWrapper(currentRoute: '/profile', child: ProfilePage()),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/search',
          builder: (context, state) => const SearchPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/notification',
          builder: (context, state) => const NotificationPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/chat',
          builder: (context, state) => const ChatPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
             path: '/chat/:chatId',
            builder: (context, state) {
             final chatId = state.pathParameters['chatId']!;
    final chatData = state.extra as Map<String, dynamic>;
    return IndividualChatPage(
      chatId: chatId,
      chatData: chatData,
    );
  },
   transitionType: PageTransitionType.slide,
  // Custom animation duration
)
      ],
    );
  }
}
