import 'package:go_router/go_router.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/features/authentication/pages/signup_page.dart';
import 'package:journeyq/features/authentication/pages/login_page.dart';
import 'package:journeyq/features/market_place/pages/index.dart';
import 'package:journeyq/features/market_place/pages/BookingHistoryPage.dart';
import 'package:journeyq/features/market_place/pages/viewall_hotels.dart';
import 'package:journeyq/features/market_place/pages/hotel_details.dart';
import 'package:journeyq/features/market_place/pages/room_details.dart';
import 'package:journeyq/features/market_place/pages/booking_room.dart';
import 'package:journeyq/features/market_place/pages/viewall_tour_packages.dart';
import 'package:journeyq/features/market_place/pages/tour_package_details.dart';
import 'package:journeyq/features/market_place/pages/book_package_page.dart';
import 'package:journeyq/features/market_place/pages/viewall_travelling_agency.dart';
import 'package:journeyq/features/market_place/pages/travel_agency_details.dart';
import 'package:journeyq/features/market_place/pages/travel_agency_reviews.dart';
import 'package:journeyq/features/market_place/pages/contact_travel_agency.dart';
import 'package:journeyq/features/join_trip/pages/index.dart';
import 'package:journeyq/features/create_trip/pages/index.dart';
import 'package:journeyq/features/home/pages/home_page.dart';
import 'route_transistion.dart';
import 'package:journeyq/features/profile/pages/index.dart';
import 'package:journeyq/features/profile/pages/SettingsPage.dart';
import 'package:journeyq/features/profile/pages/EditProfilePage.dart';
import 'package:journeyq/features/profile/pages/PostDetailPage.dart';
import 'package:journeyq/features/profile/pages/BucketListPage.dart';
import 'package:journeyq/features/home/user_profile_page.dart';
// ADD THESE NEW IMPOR
import 'package:journeyq/features/profile/pages/FollowersFollowingPage.dart';
import 'package:journeyq/features/profile/pages/PaymentPage.dart';
import 'package:journeyq/app/app.dart';
import 'package:journeyq/features/search/pages/search_page.dart';
import 'package:journeyq/features/notification/pages/notification.dart';
import 'package:journeyq/features/chat/pages/indexpage.dart';
import 'package:journeyq/features/chat/pages/chatpage.dart';
import 'package:journeyq/features/journey_view/pages/journey_detail.dart';
import 'package:journeyq/features/Trip_planner/pages/index.dart';
import 'package:journeyq/features/market_place/search_page.dart';
import 'package:journeyq/features/market_place/pages/market_chat.dart';
import 'package:journeyq/features/market_place/pages/BookingHistoryPage.dart';
import 'package:journeyq/features/market_place/pages/chat_details.dart';

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
          path: '/booking-history',
          builder: (context, state) => const BookingHistoryPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/hotels',
          builder: (context, state) => AppWrapper(
            currentRoute: '/marketplace',
            child: const ViewAllHotelsPage(),
          ),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/hotels/details/:hotelId',
          builder: (context, state) {
            final hotelId = state.pathParameters['hotelId']!;
            return AppWrapper(
              currentRoute: '/marketplace',
              child: HotelDetailsPage(hotelId: hotelId),
            );
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/hotels/room_details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              // If no room data provided, redirect to hotels
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllHotelsPage(),
              );
            }

            final hotel = extra['hotel'] as Map<String, dynamic>?;
            final room = extra['room'] as Map<String, dynamic>?;

            if (hotel == null || room == null) {
              // If incomplete data, redirect to hotels
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllHotelsPage(),
              );
            }

            return AppWrapper(
              currentRoute: '/marketplace',
              child: RoomDetailsPage(hotel: hotel, room: room),
            );
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/hotels/booking',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              // If no booking data provided, redirect to hotels
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllHotelsPage(),
              );
            }

            final hotel = extra['hotel'] as Map<String, dynamic>?;
            final room = extra['room'] as Map<String, dynamic>?;

            return BookingRoomPage(hotel: hotel, room: room);
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/tour_packages',
          builder: (context, state) => AppWrapper(
            currentRoute: '/marketplace',
            child: const ViewAllTourPackagesPage(),
          ),
          transitionType: PageTransitionType.slide,
        ),
        TransitionGoRoute(
          path: '/marketplace/tour_packages/details/:packageId',
          builder: (context, state) {
            final packageId = state.pathParameters['packageId']!;
            return AppWrapper(
              currentRoute: '/marketplace',
              child: TourPackageDetailsPage(packageId: packageId),
            );
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/travel_agencies',
          builder: (context, state) => AppWrapper(
            currentRoute: '/marketplace',
            child: const ViewAllTravelAgenciesPage(),
          ),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/travel_agencies/details/:agencyId',
          builder: (context, state) {
            final agencyId = state.pathParameters['agencyId']!;
            return AppWrapper(
              currentRoute: '/marketplace',
              child: TravelAgencyDetailsPage(agencyId: agencyId),
            );
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/travel_agencies/reviews/:agencyId',
          builder: (context, state) {
            final agencyId = state.pathParameters['agencyId']!;
            return AppWrapper(
              currentRoute: '/marketplace',
              child: TravelAgencyReviewsPage(agencyId: agencyId),
            );
          },
          transitionType: PageTransitionType.slide,
        ),
        // Contact Travel Agency Route (without AppWrapper as it's a full-screen contact flow)
        TransitionGoRoute(
          path: '/marketplace/travel_agencies/contact/:agencyId',
          builder: (context, state) {
            final agencyId = state.pathParameters['agencyId'];
            if (agencyId == null) {
              // If no agency ID provided, redirect to travel agencies
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllTravelAgenciesPage(),
              );
            }
            return ContactTravelAgencyPage(agencyId: agencyId);
          },
          transitionType: PageTransitionType.none,
        ),

        // Book Package Route (without AppWrapper as it's a full-screen booking flow)
        TransitionGoRoute(
          path: '/marketplace/book_package/:packageId',
          builder: (context, state) {
            final packageId = state.pathParameters['packageId'];
            if (packageId == null) {
              // If no package ID provided, redirect to tour packages
              return AppWrapper(
                currentRoute: '/marketplace',
                child: const ViewAllTourPackagesPage(),
              );
            }
            return BookPackagePage(packageId: packageId);
          },
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

        // Profile-related routes (without AppWrapper for full-screen experience)
        TransitionGoRoute(
          path: '/profile/settings',
          builder: (context, state) => const SettingsPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/market_chat',
          builder: (context, state) => const MarketplaceChatPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/market_chat/details/:chatId',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId']!;
            final name = state.uri.queryParameters['name'] ?? 'Unknown';
            final serviceType =
                state.uri.queryParameters['serviceType'] ?? 'Service';

            return ChatDetailsPage(
              chatId: chatId,
              name: name,
              serviceType: serviceType,
            );
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/booking_history',
          builder: (context, state) => const BookingHistoryPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/profile/edit',
          builder: (context, state) {
            final userData = state.extra as Map<String, dynamic>?;
            return EditProfilePage(userData: userData ?? {});
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/profile/followers-following',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            if (extra == null) {
              // Fallback to profile if no data provided
              return AppWrapper(currentRoute: '/profile', child: ProfilePage());
            }

            final initialTab = extra['initialTab'] as String? ?? 'followers';
            final userData = extra['userData'] as Map<String, dynamic>? ?? {};

            return FollowersFollowingPage(
              initialTab: initialTab,
              userData: userData,
            );
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/profile/payment',
          builder: (context, state) {
            final userData = state.extra as Map<String, dynamic>?;

            if (userData == null) {
              // Fallback to profile if no data provided
              return AppWrapper(currentRoute: '/profile', child: ProfilePage());
            }

            return PaymentPage(userData: userData);
          },
          transitionType: PageTransitionType.slide,
        ),
        TransitionGoRoute(
          path: '/profile/post/:postIndex',
          builder: (context, state) {
            final postIndex =
                int.tryParse(state.pathParameters['postIndex'] ?? '0') ?? 0;
            final extra = state.extra as Map<String, dynamic>?;

            if (extra == null) {
              // Fallback to profile if no data provided
              return AppWrapper(currentRoute: '/profile', child: ProfilePage());
            }

            final postData = extra['postData'] as Map<String, dynamic>? ?? {};
            final userData = extra['userData'] as Map<String, dynamic>? ?? {};

            return PostDetailPage(
              postData: postData,
              userData: userData,
              postIndex: postIndex,
            );
          },
          transitionType: PageTransitionType.slide,
        ),

        // NEW: Bucket List Route
        TransitionGoRoute(
          path: '/profile/bucketlist',
          builder: (context, state) => const BucketListPage(),
          transitionType: PageTransitionType.slide,
        ),

        // NEW: User Profile Route (for viewing other users' profiles)
        TransitionGoRoute(
          path: '/user-profile/:userId/:userName',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            final userName = Uri.decodeComponent(state.pathParameters['userName']!);
            return UserProfilePage(
              userId: userId,
              userName: userName,
            );
          },
          transitionType: PageTransitionType.slide,
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
          path: '/planner',
          builder: (context, state) => const TripPlannerPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/journey/:journeyId',
          builder: (context, state) {
            final journeyId = state.pathParameters['journeyId']!;
            return JourneyDetailsPage(journeyId: journeyId);
          },
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/marketplace/search',
          builder: (context, state) => const Market_SearchPage(),
          transitionType: PageTransitionType.slide,
        ),

        TransitionGoRoute(
          path: '/chat/:chatId',
          builder: (context, state) {
            final chatId = state.pathParameters['chatId']!;
            final chatData = state.extra as Map<String, dynamic>;
            return IndividualChatPage(chatId: chatId, chatData: chatData);
          },
          transitionType: PageTransitionType.slide,
          // Custom animation duration
        ),
      ],
    );
  }
}
