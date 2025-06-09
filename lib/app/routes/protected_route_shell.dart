import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/features/authentication/pages/login_page.dart';

class ProtectedRouteShell extends StatefulWidget {
  final Widget child;
  
  const ProtectedRouteShell({super.key, required this.child});
  @override
  State<ProtectedRouteShell> createState() => _ProtectedRouteShellState();
}

class _ProtectedRouteShellState extends State<ProtectedRouteShell> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading while checking auth
        if (authProvider.status == AuthStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Redirect happens in router, but double-check here
        if (authProvider.status == AuthStatus.unauthenticated) {
          return LoginPage();
        }

        // User is authenticated, show the protected content
        return widget.child;
      },
    );
  }
}
