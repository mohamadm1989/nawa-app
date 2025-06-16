import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/constants.dart';

/// نوع التفاعل
enum InteractionType {
  tap,           // ضغطة عادية
  longPress,     // ضغطة طويلة
  doubleTap,     // ضغطة مزدوجة
  swipe,         // سحب
  success,       // نجاح
  error,         // خطأ
  warning,       // تحذير
  info,          // معلومات
}

/// شدة التفاعل
enum FeedbackIntensity {
  light,    // خفيف
  medium,   // متوسط
  strong,   // قوي
}

/// نظام التفاعل البصري
/// يوفر تغذية راجعة بصرية ولمسية للتفاعلات
class InteractionFeedback {
  InteractionFeedback._();

  // ========== التفاعل اللمسي ==========

  /// تشغيل تفاعل لمسي
  static void haptic(InteractionType type, {FeedbackIntensity intensity = FeedbackIntensity.medium}) {
    switch (type) {
      case InteractionType.tap:
        switch (intensity) {
          case FeedbackIntensity.light:
            HapticFeedback.selectionClick();
            break;
          case FeedbackIntensity.medium:
            HapticFeedback.lightImpact();
            break;
          case FeedbackIntensity.strong:
            HapticFeedback.mediumImpact();
            break;
        }
        break;
        
      case InteractionType.longPress:
        HapticFeedback.heavyImpact();
        break;
        
      case InteractionType.doubleTap:
        HapticFeedback.lightImpact();
        Future.delayed(const Duration(milliseconds: 100), () {
          HapticFeedback.lightImpact();
        });
        break;
        
      case InteractionType.success:
        HapticFeedback.lightImpact();
        break;
        
      case InteractionType.error:
        HapticFeedback.heavyImpact();
        break;
        
      case InteractionType.warning:
        HapticFeedback.mediumImpact();
        break;
        
      default:
        HapticFeedback.selectionClick();
    }
  }

  // ========== التفاعل البصري ==========

  /// إنشاء تأثير الضغط
  static Widget createTapEffect({
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    InteractionType type = InteractionType.tap,
    FeedbackIntensity intensity = FeedbackIntensity.medium,
    Color? splashColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
    bool enableFeedback = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () {
          if (enableFeedback) {
            haptic(type, intensity: intensity);
          }
          onTap();
        } : null,
        onLongPress: onLongPress != null ? () {
          if (enableFeedback) {
            haptic(InteractionType.longPress);
          }
          onLongPress();
        } : null,
        splashColor: splashColor ?? AppColors.primaryGreen.withValues(alpha: 0.2),
        highlightColor: highlightColor ?? AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: child,
      ),
    );
  }

  /// إنشاء تأثير الضغط للأزرار
  static Widget createButtonEffect({
    required Widget child,
    required VoidCallback? onPressed,
    InteractionType type = InteractionType.tap,
    FeedbackIntensity intensity = FeedbackIntensity.medium,
    bool enableFeedback = true,
    Duration animationDuration = const Duration(milliseconds: 150),
  }) {
    return AnimatedScale(
      scale: 1.0,
      duration: animationDuration,
      child: GestureDetector(
        onTapDown: (_) {
          if (enableFeedback && onPressed != null) {
            haptic(type, intensity: intensity);
          }
        },
        onTap: onPressed,
        child: AnimatedContainer(
          duration: animationDuration,
          child: child,
        ),
      ),
    );
  }

  /// إنشاء تأثير التمرير
  static Widget createHoverEffect({
    required Widget child,
    Color? hoverColor,
    double hoverElevation = 2.0,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: animationDuration,
        child: child,
      ),
    );
  }

  // ========== تأثيرات الحالة ==========

  /// تأثير النجاح
  static void showSuccessFeedback(BuildContext context, {
    String? message,
    Duration duration = const Duration(seconds: 2),
  }) {
    haptic(InteractionType.success);
    
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  /// تأثير الخطأ
  static void showErrorFeedback(BuildContext context, {
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    haptic(InteractionType.error);
    
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.error,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  /// تأثير التحذير
  static void showWarningFeedback(BuildContext context, {
    String? message,
    Duration duration = const Duration(seconds: 2),
  }) {
    haptic(InteractionType.warning);
    
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.warning,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  /// تأثير المعلومات
  static void showInfoFeedback(BuildContext context, {
    String? message,
    Duration duration = const Duration(seconds: 2),
  }) {
    haptic(InteractionType.info);
    
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  // ========== تأثيرات متقدمة ==========

  /// تأثير الموجة
  static Widget createRippleEffect({
    required Widget child,
    required VoidCallback? onTap,
    Color? rippleColor,
    double? radius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () {
          haptic(InteractionType.tap);
          onTap();
        } : null,
        splashColor: rippleColor ?? AppColors.primaryGreen.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(radius ?? 8),
        child: child,
      ),
    );
  }

  /// تأثير النبض
  static Widget createPulseEffect({
    required Widget child,
    bool animate = true,
    Duration duration = const Duration(seconds: 1),
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    if (!animate) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: minScale, end: maxScale),
      duration: duration,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  /// تأثير الاهتزاز
  static Widget createShakeEffect({
    required Widget child,
    bool animate = false,
    Duration duration = const Duration(milliseconds: 500),
    double offset = 5.0,
  }) {
    if (!animate) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      builder: (context, value, child) {
        final shakeValue = math.sin(value * 4 * 3.14159) * offset * (1 - value);
        return Transform.translate(
          offset: Offset(shakeValue, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  // ========== دوال مساعدة ==========

  /// تشغيل تفاعل مخصص
  static void customFeedback({
    required BuildContext context,
    InteractionType type = InteractionType.tap,
    FeedbackIntensity intensity = FeedbackIntensity.medium,
    String? message,
    Color? backgroundColor,
    IconData? icon,
  }) {
    haptic(type, intensity: intensity);
    
    if (message != null) {
      final color = backgroundColor ?? _getColorForType(type);
      final iconData = icon ?? _getIconForType(type);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(iconData, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  /// الحصول على لون حسب نوع التفاعل
  static Color _getColorForType(InteractionType type) {
    switch (type) {
      case InteractionType.success:
        return AppColors.success;
      case InteractionType.error:
        return AppColors.error;
      case InteractionType.warning:
        return AppColors.warning;
      case InteractionType.info:
        return AppColors.primaryGreen;
      default:
        return AppColors.primaryGreen;
    }
  }

  /// الحصول على أيقونة حسب نوع التفاعل
  static IconData _getIconForType(InteractionType type) {
    switch (type) {
      case InteractionType.success:
        return Icons.check_circle;
      case InteractionType.error:
        return Icons.error;
      case InteractionType.warning:
        return Icons.warning;
      case InteractionType.info:
        return Icons.info;
      default:
        return Icons.touch_app;
    }
  }
}
