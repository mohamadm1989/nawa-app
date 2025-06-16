import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// نظام مؤشرات التحميل
/// يوفر مؤشرات تحميل متنوعة وجذابة
class LoadingIndicators {
  LoadingIndicators._();

  // ========== أنواع مؤشرات التحميل ==========

  /// مؤشر التحميل الدائري البسيط
  static Widget circular({
    Color? color,
    double size = 24.0,
    double strokeWidth = 2.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryGreen,
        strokeWidth: strokeWidth,
      ),
    );
  }

  /// مؤشر التحميل الخطي
  static Widget linear({
    Color? color,
    Color? backgroundColor,
    double? value,
    double height = 4.0,
  }) {
    return Container(
      height: height,
      child: LinearProgressIndicator(
        value: value,
        color: color ?? AppColors.primaryGreen,
        backgroundColor: backgroundColor ?? AppColors.helperGray.withValues(alpha: 0.2),
      ),
    );
  }

  /// مؤشر التحميل مع نص
  static Widget withText({
    required String text,
    Color? color,
    double size = 24.0,
    TextStyle? textStyle,
    MainAxisAlignment alignment = MainAxisAlignment.center,
  }) {
    return Column(
      mainAxisAlignment: alignment,
      children: [
        circular(color: color, size: size),
        const SizedBox(height: 16),
        Text(
          text,
          style: textStyle ?? AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// مؤشر التحميل مع نسبة مئوية
  static Widget withPercentage({
    required double percentage,
    Color? color,
    double size = 60.0,
    TextStyle? textStyle,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: percentage / 100,
            color: color ?? AppColors.primaryGreen,
            strokeWidth: 4.0,
            backgroundColor: AppColors.helperGray.withValues(alpha: 0.2),
          ),
        ),
        Text(
          '${percentage.toInt()}%',
          style: textStyle ?? AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  /// مؤشر التحميل النقطي
  static Widget dots({
    Color? color,
    double size = 8.0,
    int count = 3,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: duration,
          margin: EdgeInsets.symmetric(horizontal: size / 4),
          child: _DotIndicator(
            color: color ?? AppColors.primaryGreen,
            size: size,
            delay: Duration(milliseconds: index * 200),
          ),
        );
      }),
    );
  }

  /// مؤشر التحميل الموجي
  static Widget wave({
    Color? color,
    double size = 40.0,
    int count = 5,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        return _WaveIndicator(
          color: color ?? AppColors.primaryGreen,
          size: size,
          delay: Duration(milliseconds: index * 100),
        );
      }),
    );
  }

  /// مؤشر التحميل الدوار المخصص
  static Widget spinner({
    Color? color,
    double size = 32.0,
    double strokeWidth = 3.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: _SpinnerIndicator(
        color: color ?? AppColors.primaryGreen,
        strokeWidth: strokeWidth,
      ),
    );
  }

  // ========== مؤشرات التحميل للصفحات ==========

  /// مؤشر تحميل الصفحة الكاملة
  static Widget fullPage({
    String? message,
    Color? backgroundColor,
    Color? indicatorColor,
  }) {
    return Container(
      color: backgroundColor ?? AppColors.backgroundPrimary.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circular(
              color: indicatorColor ?? AppColors.primaryGreen,
              size: 48.0,
              strokeWidth: 4.0,
            ),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// مؤشر تحميل البطاقة
  static Widget card({
    String? message,
    double height = 200.0,
    Color? backgroundColor,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circular(size: 32.0),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// مؤشر تحميل القائمة
  static Widget list({
    int itemCount = 5,
    double itemHeight = 80.0,
  }) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Container(
          height: itemHeight,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: _ShimmerEffect(
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.helperGray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        margin: const EdgeInsets.only(right: 16, bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.helperGray.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 12,
                        width: 200,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: AppColors.helperGray.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ========== مؤشرات التحميل التفاعلية ==========

  /// مؤشر تحميل الزر
  static Widget button({
    Color? color,
    double size = 20.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? Colors.white,
        strokeWidth: 2.0,
      ),
    );
  }

  /// مؤشر تحميل الأيقونة
  static Widget icon({
    Color? color,
    double size = 16.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primaryGreen,
        strokeWidth: 1.5,
      ),
    );
  }

  // ========== دوال مساعدة ==========

  /// عرض مؤشر تحميل في حوار
  static void showLoadingDialog(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              circular(size: 48.0),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// إخفاء مؤشر التحميل
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

// ========== مؤشرات مخصصة ==========

/// مؤشر النقطة المتحركة
class _DotIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final Duration delay;

  const _DotIndicator({
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  State<_DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<_DotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

/// مؤشر الموجة
class _WaveIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final Duration delay;

  const _WaveIndicator({
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  State<_WaveIndicator> createState() => _WaveIndicatorState();
}

class _WaveIndicatorState extends State<_WaveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 4,
          height: widget.size * _animation.value,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}

/// مؤشر الدوران المخصص
class _SpinnerIndicator extends StatefulWidget {
  final Color color;
  final double strokeWidth;

  const _SpinnerIndicator({
    required this.color,
    required this.strokeWidth,
  });

  @override
  State<_SpinnerIndicator> createState() => _SpinnerIndicatorState();
}

class _SpinnerIndicatorState extends State<_SpinnerIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: CustomPaint(
            painter: _SpinnerPainter(
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}

/// رسام المؤشر الدوار
class _SpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _SpinnerPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      3.14159 * 1.5,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// تأثير الشيمر
class _ShimmerEffect extends StatefulWidget {
  final Widget child;

  const _ShimmerEffect({required this.child});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.5),
                Colors.transparent,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
