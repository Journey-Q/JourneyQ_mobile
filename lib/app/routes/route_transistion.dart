import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Enum for animation types
enum PageTransitionType { slide, upDown, none }

// Ultra-smooth page transition with scale, fade, and slide effects
class CustomPageTransition extends CustomTransitionPage<void> {
  CustomPageTransition({
    required LocalKey super.key,
    required super.child,
    required PageTransitionType transitionType,
    Duration duration = const Duration(milliseconds: 900), // Ultra smooth timing
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           switch (transitionType) {
             case PageTransitionType.slide:
               return _buildUltraSmoothSlideTransition(
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.upDown:
               return _buildUltraSmoothUpDownTransition(
                 animation,
                 secondaryAnimation,
                 child,
               );
             case PageTransitionType.none:
               return child;
           }
         },
       );

  static Widget _buildUltraSmoothSlideTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    
    // Ultra smooth slide animation with perfect timing
    var slideAnimation = Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    // Gentle fade-in effect
    var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Subtle scale effect for premium feel
    var scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart),
      ),
    );

    // Previous page fade-out and scale
    var exitFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    var exitScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    return Stack(
      children: [
        // Previous page with exit animation
        if (secondaryAnimation.value > 0.0)
          FadeTransition(
            opacity: exitFadeAnimation,
            child: ScaleTransition(
              scale: exitScaleAnimation,
              child: child,
            ),
          ),
        // New page with enter animation
        SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildUltraSmoothUpDownTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    
    // Ultra smooth slide animation with perfect timing
    var slideAnimation = Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    // Gentle fade-in effect
    var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Subtle scale effect for premium feel
    var scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart),
      ),
    );

    // Previous page fade-out and scale
    var exitFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    var exitScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    return Stack(
      children: [
        // Previous page with exit animation
        if (secondaryAnimation.value > 0.0)
          FadeTransition(
            opacity: exitFadeAnimation,
            child: ScaleTransition(
              scale: exitScaleAnimation,
              child: child,
            ),
          ),
        // New page with enter animation
        SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

// Ultra-smooth GoRoute for premium app experience
class TransitionGoRoute extends GoRoute {
  TransitionGoRoute({
    required super.path,
    required super.builder,
    required PageTransitionType transitionType,
    Duration transitionDuration = const Duration(milliseconds: 800), // Ultra smooth
    super.routes,
  }) : super(
         pageBuilder: (context, state) {
           return CustomPageTransition(
             key: state.pageKey,
             child: builder!(context, state),
             transitionType: transitionType,
             duration: transitionDuration,
           );
         },
       );
}