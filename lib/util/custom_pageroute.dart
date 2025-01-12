import 'package:flutter/material.dart';

import 'enums.dart'; // Ensure you have the `TransitionType` enum defined.

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  final TransitionType transitionType;

  CustomPageRoute({
    required this.page,
    this.transitionType = TransitionType.slideRight,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.slideRight:
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        case TransitionType.slideLeft:
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        case TransitionType.flip:
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              double value = animation.value;
              double angle = value * 3.14159; // Rotate value in radians
              bool isFront = value < 0.5;

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective depth
                  ..rotateY(angle),
                child: isFront
                    ? child // Front side
                    : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(3.14159),
                  child: page, // Back side (new page)
                ),
              );
            },
            child: child,
          );
        case TransitionType.fade:
          return FadeTransition(
            opacity: animation.drive(
              Tween(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        default:
          return child;
      }
    },
  );
}
