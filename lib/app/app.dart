import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/app/routes/app_router.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/app/themes/theme.dart';
import 'package:journeyq/shared/components/bottom_naviagtion.dart';

class TravelApp extends StatefulWidget {
  const TravelApp({super.key});

  @override
  State<TravelApp> createState() => _TravelAppState();
}

class _TravelAppState extends State<TravelApp> {
  @override
  void initState() {
    super.initState();

    // Lock orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI styles
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider()..initialize(),
      child: const RouterWrapper(),
    );
  }
}

class RouterWrapper extends StatelessWidget {
  const RouterWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final router = AppRouter.createRouter(authProvider);

    return MaterialApp.router(
      title: 'JourneyQ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (context, child) {
        return AppWrapper(child: child);
      },
    );
  }
}

class AppWrapper extends StatelessWidget {
  final Widget? child;
  final String? currentRoute; // Pass route as parameter
  
  const AppWrapper({
    this.child,
    this.currentRoute,
  });

  int _getCurrentPageIndex(String? route) {
    if (route == null) return -1;
    
    switch (route) {
      case '/home':
        return 0;
      case '/marketplace':
        return 1;
      case '/create':
        return 2;
      case '/join_trip':
        return 3;
      case '/profile':
        return 4;
      default:
        return -1;
    }
  }

  bool _shouldShowNavigation(String? route) {
    if (route == null) return false;
    
    const navigationRoutes = [
      '/home',
      '/marketplace',
      '/create', 
      '/join_trip',
      '/profile',
    ];
    return navigationRoutes.contains(route);
  }

  @override
  Widget build(BuildContext context) {
    final currentPageIndex = _getCurrentPageIndex(currentRoute);
    final showNavigation = _shouldShowNavigation(currentRoute);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: child,
        bottomNavigationBar: showNavigation
            ? CustomBottomNavigation(currentPageIndex: currentPageIndex)
            : null,
      ),
    );
  }
}




