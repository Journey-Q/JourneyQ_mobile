import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Enum for animation types
enum PageTransitionType { slide, upDown, none }

// Optimized smooth page transition
class CustomPageTransition extends CustomTransitionPage<void> {
  CustomPageTransition({
    required super.key,
    required super.child,
    required PageTransitionType transitionType,
    Duration duration = const Duration(milliseconds: 350), // Optimized timing
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           switch (transitionType) {
             case PageTransitionType.slide:
               return _buildSlideTransition(animation, child);
             case PageTransitionType.upDown:
               return _buildUpDownTransition(animation, child);
             case PageTransitionType.none:
               return child;
           }
         },
       );

  // Smooth horizontal slide transition
  static Widget _buildSlideTransition(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // Smooth vertical slide transition
  static Widget _buildUpDownTransition(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

// Optimized GoRoute for smooth transitions
class TransitionGoRoute extends GoRoute {
  TransitionGoRoute({
    required super.path,
    required super.builder,
    required PageTransitionType transitionType,
    Duration transitionDuration = const Duration(milliseconds: 350),
    super.routes,
  }) : super(
         pageBuilder: (context, state) {
           return CustomPageTransition(
             key: ValueKey(state.fullPath), // Use fullPath for unique keys
             child: builder!(context, state),
             transitionType: transitionType,
             duration: transitionDuration,
           );
         },
       );
}