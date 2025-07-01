import 'package:go_router/go_router.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/features/authentication/pages/signup_page.dart';
import 'package:journeyq/features/authentication/pages/login_page.dart';
import 'package:journeyq/features/market_place/pages/index.dart';
import 'package:journeyq/features/market_place/pages/viewall_hotels.dart';
import 'package:journeyq/features/market_place/pages/hotel_details.dart';
import 'package:journeyq/features/market_place/pages/viewall_tour_packages.dart';
import 'package:journeyq/features/market_place/pages/tour_package_details.dart';
import 'package:journeyq/features/market_place/pages/book_package_page.dart';
import 'package:journeyq/features/market_place/pages/viewall_travelling_agency.dart';
import 'package:journeyq/features/market_place/pages/travel_agency_details.dart';
import 'package:journeyq/features/market_place/pages/contact_travel_agency.dart';
import 'package:journeyq/features/join_trip/pages/index.dart';
import 'package:journeyq/features/create_trip/pages/index.dart';
import 'package:journeyq/features/home/home_page.dart';
import 'route_transistion.dart';
import 'package:journeyq/features/profile/pages/index.dart';
import 'package:journeyq/app/app.dart'; // Add this import

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
          builder: (context, state) => AppWrapper(
            currentRoute: '/home',
            child: HomePage(),
          ),
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
          path: '/marketplace/hotels',
          builder: (context, state) => AppWrapper(
            currentRoute: '/marketplace',
            child: const ViewAllHotelsPage(),
          ),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/marketplace/hotels/details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return AppWrapper(
              currentRoute: '/marketplace',
              child: HotelDetailsPage(hotel: extra),
            );
          },
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/marketplace/tour_packages',
          builder: (context, state) => AppWrapper(
            currentRoute: '/marketplace',
            child: const ViewAllTourPackagesPage(),
          ),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/marketplace/tour_packages/details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              // If no package data provided, redirect to tour packages
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllTourPackagesPage(),
              );
            }
            return AppWrapper(
              currentRoute: '/marketplace',
              child: TourPackageDetailsPage(package: extra),
            );
          },
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/marketplace/travel_agencies',
          builder: (context, state) => AppWrapper(
            currentRoute: '/marketplace',
            child: const ViewAllTravelAgenciesPage(),
          ),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/marketplace/travel_agencies/details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              // If no agency data provided, redirect to travel agencies
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllTravelAgenciesPage(),
              );
            }
            return TravelAgencyDetailsPage(agency: extra);
          },
          transitionType: PageTransitionType.none,
        ),

        // Contact Travel Agency Route (without AppWrapper as it's a full-screen contact flow)
        TransitionGoRoute(
          path: '/marketplace/travel_agencies/contact',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              // If no agency data provided, redirect to travel agencies
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllTravelAgenciesPage(),
              );
            }
            return ContactTravelAgencyPage(agency: extra);
          },
          transitionType: PageTransitionType.none,
        ),


        // Book Package Route (without AppWrapper as it's a full-screen booking flow)
        TransitionGoRoute(
          path: '/marketplace/book_package',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              // If no package data provided, redirect to marketplace
              return AppWrapper(
                currentRoute: '/marketplace',
                child: MarketplacePage(),
              );
            }
            return BookPackagePage(package: extra);
          },
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/create',
          builder: (context, state) => AppWrapper(
            currentRoute: '/create',
            child: CreateTripPage(),
          ),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/join_trip',
          builder: (context, state) => AppWrapper(
            currentRoute: '/join_trip',
            child: JoinTripPage(),
          ),
          transitionType: PageTransitionType.none,
        ),

        TransitionGoRoute(
          path: '/profile',
          builder: (context, state) => AppWrapper(
            currentRoute: '/profile',
            child: ProfilePage(),
          ),
          transitionType: PageTransitionType.none,
        ),


      ],
    );
  }
}

