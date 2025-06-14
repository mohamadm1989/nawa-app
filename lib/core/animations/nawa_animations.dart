import 'package:flutter/material.dart';

/// نظام الرسوم المتحركة لتطبيق نِواة
/// يوفر انتقالات وتأثيرات بصرية جميلة
class NawaAnimations {
  // مدد الرسوم المتحركة
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // منحنيات الرسوم المتحركة
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;

  /// انتقال الصفحات - انزلاق من اليمين
  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// انتقال الصفحات - انزلاق من الأسفل
  static Route<T> slideFromBottom<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = easeOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// انتقال الصفحات - تكبير مع تلاشي
  static Route<T> scaleAndFade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: normal,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: easeOut,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// انتقال Hero مخصص
  static Widget heroTransition({
    required String tag,
    required Widget child,
    Duration? duration,
  }) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  /// أنيميشن الظهور التدريجي
  static Widget fadeInAnimation({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? normal,
      curve: curve ?? easeInOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// أنيميشن الانزلاق من الأعلى
  static Widget slideDownAnimation({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? offset,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? normal,
      curve: curve ?? easeOut,
      tween: Tween(begin: -(offset ?? 50.0), end: 0.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Opacity(
            opacity: 1 - (value.abs() / (offset ?? 50.0)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// أنيميشن الدوران
  static Widget rotationAnimation({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? turns,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? slow,
      curve: curve ?? easeInOut,
      tween: Tween(begin: 0.0, end: turns ?? 1.0),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: child,
        );
      },
      child: child,
    );
  }

  /// أنيميشن النبض
  static Widget pulseAnimation({
    required Widget child,
    Duration? duration,
    double? minScale,
    double? maxScale,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final scale = (minScale ?? 0.95) +
                     ((maxScale ?? 1.05) - (minScale ?? 0.95)) *
                     (0.5 + 0.5 * (value * 2 - 1).abs());
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  /// أنيميشن الاهتزاز للأخطاء
  static Widget errorShakeAnimation({
    required Widget child,
    Duration? duration,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final shake = 10 * (1 - value) * (value < 0.5 ? 1 : -1);
        return Transform.translate(
          offset: Offset(shake, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// ويدجت للرسوم المتحركة المتدرجة
class StaggeredAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Axis direction;

  const StaggeredAnimation({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.direction = Axis.vertical,
  });

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.duration,
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: widget.curve),
      );
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.delay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(StaggeredAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // إعادة تهيئة الأنيميشن إذا تغير عدد العناصر
    if (oldWidget.children.length != widget.children.length) {
      // إيقاف الأنيميشن القديمة
      for (var controller in _controllers) {
        controller.dispose();
      }

      // إعادة تهيئة
      _initializeAnimations();
      _startAnimations();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.direction == Axis.vertical
        ? Column(
            children: _buildAnimatedChildren(),
          )
        : Row(
            children: _buildAnimatedChildren(),
          );
  }

  List<Widget> _buildAnimatedChildren() {
    return List.generate(widget.children.length, (index) {
      // حماية من تجاوز الحد
      if (index >= _animations.length) {
        return widget.children[index];
      }

      return AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return Transform.translate(
            offset: widget.direction == Axis.vertical
                ? Offset(0, 20 * (1 - _animations[index].value))
                : Offset(20 * (1 - _animations[index].value), 0),
            child: Opacity(
              opacity: _animations[index].value,
              child: widget.children[index],
            ),
          );
        },
      );
    });
  }
}

/// ويدجت للتأثيرات التفاعلية
class InteractiveAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final Duration duration;

  const InteractiveAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.95,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<InteractiveAnimation> createState() => _InteractiveAnimationState();
}

class _InteractiveAnimationState extends State<InteractiveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// ويدجت لرسوم التحميل المتحركة
class LoadingAnimation extends StatefulWidget {
  final Color? color;
  final double size;
  final LoadingType type;

  const LoadingAnimation({
    super.key,
    this.color,
    this.size = 40.0,
    this.type = LoadingType.dots,
  });

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    switch (widget.type) {
      case LoadingType.dots:
        return _buildDotsAnimation(color);
      case LoadingType.pulse:
        return _buildPulseAnimation(color);
      case LoadingType.wave:
        return _buildWaveAnimation(color);
    }
  }

  Widget _buildDotsAnimation(Color color) {
    return SizedBox(
      width: widget.size,
      height: widget.size / 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final value = (_controller.value - (index * 0.2)).clamp(0.0, 1.0);
              return Transform.translate(
                offset: Offset(0, -10 * (1 - (value * 2 - 1).abs())),
                child: Container(
                  width: widget.size / 8,
                  height: widget.size / 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildPulseAnimation(Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + 0.2 * (1 - (_controller.value * 2 - 1).abs()),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveAnimation(Color color) {
    return SizedBox(
      width: widget.size,
      height: widget.size / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final value = (_controller.value - (index * 0.1)).clamp(0.0, 1.0);
              final height = widget.size / 2 * (0.3 + 0.7 * (1 - (value * 2 - 1).abs()));
              return Container(
                width: widget.size / 8,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(widget.size / 16),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

enum LoadingType {
  dots,
  pulse,
  wave,
}
