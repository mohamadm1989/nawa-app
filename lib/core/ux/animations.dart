import 'package:flutter/material.dart';

/// نظام الرسوم المتحركة المحسّن
/// يوفر رسوم متحركة سلسة وجذابة
class UXAnimations {
  UXAnimations._();

  // ========== مدد الرسوم المتحركة ==========
  
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // ========== منحنيات الرسوم المتحركة ==========
  
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticIn = Curves.elasticIn;
  static const Curve elasticOut = Curves.elasticOut;

  // ========== رسوم متحركة للظهور ==========

  /// رسوم متحركة للتلاشي
  static Widget fadeIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeInOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// رسوم متحركة للانزلاق من الأسفل
  static Widget slideUp({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    double begin = 50.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: child,
    );
  }

  /// رسوم متحركة للانزلاق من اليمين
  static Widget slideFromRight({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    double begin = 100.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  /// رسوم متحركة للانزلاق من اليسار
  static Widget slideFromLeft({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    double begin = -100.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: 0.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  /// رسوم متحركة للتكبير
  static Widget scaleIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = elasticOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // ========== رسوم متحركة مركبة ==========

  /// رسوم متحركة للظهور مع الانزلاق
  static Widget fadeSlideIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    double slideBegin = 30.0,
    double fadeBegin = 0.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, slideBegin * (1 - value)),
          child: Opacity(
            opacity: fadeBegin + (1 - fadeBegin) * value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// رسوم متحركة للظهور مع التكبير
  static Widget fadeScaleIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = easeOut,
    double scaleBegin = 0.8,
    double fadeBegin = 0.0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: scaleBegin + (1 - scaleBegin) * value,
          child: Opacity(
            opacity: fadeBegin + (1 - fadeBegin) * value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // ========== رسوم متحركة للقوائم ==========

  /// رسوم متحركة لعناصر القائمة
  static Widget listItemAnimation({
    required Widget child,
    required int index,
    Duration duration = normal,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + (delay * index),
      curve: easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// رسوم متحركة للشبكة
  static Widget gridItemAnimation({
    required Widget child,
    required int index,
    Duration duration = normal,
    Duration delay = const Duration(milliseconds: 30),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + (delay * index),
      curve: easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + 0.2 * value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // ========== رسوم متحركة للتفاعل ==========

  /// رسوم متحركة للضغط
  static Widget tapAnimation({
    required Widget child,
    required VoidCallback? onTap,
    Duration duration = fast,
    double scaleDown = 0.95,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        
        return GestureDetector(
          onTapDown: (_) {
            setState(() => isPressed = true);
          },
          onTapUp: (_) {
            setState(() => isPressed = false);
            onTap?.call();
          },
          onTapCancel: () {
            setState(() => isPressed = false);
          },
          child: AnimatedScale(
            scale: isPressed ? scaleDown : 1.0,
            duration: duration,
            curve: easeInOut,
            child: child,
          ),
        );
      },
    );
  }

  /// رسوم متحركة للتمرير
  static Widget hoverAnimation({
    required Widget child,
    Duration duration = fast,
    double scaleUp = 1.05,
    double elevation = 4.0,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: duration,
            transform: Matrix4.identity()..scale(isHovered ? scaleUp : 1.0),
            child: AnimatedContainer(
              duration: duration,
              decoration: BoxDecoration(
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: elevation,
                          offset: Offset(0, elevation / 2),
                        ),
                      ]
                    : null,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  // ========== رسوم متحركة للحالات ==========

  /// رسوم متحركة للتحميل
  static Widget loadingAnimation({
    required Widget child,
    bool isLoading = false,
    Duration duration = normal,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      child: isLoading
          ? const Center(
              key: ValueKey('loading'),
              child: CircularProgressIndicator(),
            )
          : child,
    );
  }

  /// رسوم متحركة للخطأ
  static Widget errorAnimation({
    required Widget child,
    bool hasError = false,
    Duration duration = normal,
  }) {
    return AnimatedContainer(
      duration: duration,
      transform: hasError
          ? (Matrix4.identity()
            ..translate(5.0, 0.0)
            ..rotateZ(0.1))
          : Matrix4.identity(),
      child: child,
    );
  }

  // ========== رسوم متحركة للانتقالات ==========

  /// انتقال الصفحة من اليمين
  static PageRouteBuilder<T> slidePageRoute<T>({
    required Widget page,
    Duration duration = normal,
    Curve curve = easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween.chain(
          CurveTween(curve: curve),
        ));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  /// انتقال الصفحة بالتلاشي
  static PageRouteBuilder<T> fadePageRoute<T>({
    required Widget page,
    Duration duration = normal,
    Curve curve = easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: curve)),
          child: child,
        );
      },
    );
  }

  /// انتقال الصفحة بالتكبير
  static PageRouteBuilder<T> scalePageRoute<T>({
    required Widget page,
    Duration duration = normal,
    Curve curve = easeInOut,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation.drive(CurveTween(curve: curve)),
          child: child,
        );
      },
    );
  }

  // ========== دوال مساعدة ==========

  /// تأخير الرسوم المتحركة
  static Widget delayed({
    required Widget child,
    required Duration delay,
    Duration duration = normal,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: delay + duration,
      builder: (context, value, child) {
        final progress = (value * (delay + duration).inMilliseconds - delay.inMilliseconds) / duration.inMilliseconds;
        final clampedProgress = progress.clamp(0.0, 1.0);
        
        return Opacity(
          opacity: clampedProgress,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - clampedProgress)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// رسوم متحركة مشروطة
  static Widget conditional({
    required Widget child,
    required bool condition,
    Duration duration = normal,
    Curve curve = easeInOut,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      child: condition ? child : const SizedBox.shrink(),
    );
  }

  /// رسوم متحركة للدوران
  static Widget rotate({
    required Widget child,
    Duration duration = const Duration(seconds: 2),
    bool repeat = true,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: duration,
          builder: (context, value, child) {
            return Transform.rotate(
              angle: value * 2 * 3.14159,
              child: child,
            );
          },
          onEnd: () {
            if (repeat) {
              setState(() {});
            }
          },
          child: child,
        );
      },
    );
  }

  /// رسوم متحركة للنبض
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(seconds: 1),
    double minScale = 0.95,
    double maxScale = 1.05,
    bool repeat = true,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: minScale, end: maxScale),
          duration: duration,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          onEnd: () {
            if (repeat) {
              setState(() {});
            }
          },
          child: child,
        );
      },
    );
  }
}
