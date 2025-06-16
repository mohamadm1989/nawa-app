import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accessibility_constants.dart';

/// مساعد إمكانية الوصول
/// يوفر دوال وأدوات لتحسين إمكانية الوصول في التطبيق
class AccessibilityHelper {
  AccessibilityHelper._();

  // ========== التحقق من إعدادات النظام ==========

  /// التحقق من تفعيل قارئ الشاشة
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// التحقق من تفعيل تقليل الحركة
  static bool isReduceMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// التحقق من تفعيل النص الكبير
  static bool isLargeTextEnabled(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor > 1.0;
  }

  /// التحقق من تفعيل التباين العالي
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// التحقق من تفعيل الألوان المقلوبة
  static bool isInvertColorsEnabled(BuildContext context) {
    return MediaQuery.of(context).invertColors;
  }

  // ========== حساب التباين ==========

  /// حساب نسبة التباين بين لونين
  static double calculateContrastRatio(Color foreground, Color background) {
    final foregroundLuminance = _calculateLuminance(foreground);
    final backgroundLuminance = _calculateLuminance(background);
    
    final lighter = foregroundLuminance > backgroundLuminance 
        ? foregroundLuminance 
        : backgroundLuminance;
    final darker = foregroundLuminance > backgroundLuminance 
        ? backgroundLuminance 
        : foregroundLuminance;
    
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// حساب الإضاءة النسبية للون
  static double _calculateLuminance(Color color) {
    final r = _calculateColorComponent(color.red / 255.0);
    final g = _calculateColorComponent(color.green / 255.0);
    final b = _calculateColorComponent(color.blue / 255.0);
    
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// حساب مكون اللون
  static double _calculateColorComponent(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    } else {
      return math.pow((component + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// التحقق من صحة التباين
  static bool isValidContrast(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = calculateContrastRatio(foreground, background);
    return AccessibilityConstants.isValidContrast(ratio, isLargeText: isLargeText);
  }

  /// الحصول على لون بتباين مناسب
  static Color getContrastingColor(Color background, {bool isLargeText = false}) {
    final whiteContrast = calculateContrastRatio(Colors.white, background);
    final blackContrast = calculateContrastRatio(Colors.black, background);
    
    final minRatio = isLargeText 
        ? AccessibilityConstants.minContrastRatioLarge 
        : AccessibilityConstants.minContrastRatioNormal;
    
    if (whiteContrast >= minRatio && whiteContrast >= blackContrast) {
      return Colors.white;
    } else if (blackContrast >= minRatio) {
      return Colors.black;
    } else {
      // إذا لم يكن أي منهما مناسباً، نختار الأفضل
      return whiteContrast > blackContrast ? Colors.white : Colors.black;
    }
  }

  // ========== أحجام أهداف اللمس ==========

  /// التحقق من صحة حجم هدف اللمس
  static bool isValidTouchTargetSize(double width, double height) {
    return width >= AccessibilityConstants.minTouchTargetSize && 
           height >= AccessibilityConstants.minTouchTargetSize;
  }

  /// الحصول على حجم هدف اللمس المناسب
  static Size getValidTouchTargetSize(double width, double height) {
    final validWidth = width < AccessibilityConstants.minTouchTargetSize 
        ? AccessibilityConstants.minTouchTargetSize 
        : width;
    final validHeight = height < AccessibilityConstants.minTouchTargetSize 
        ? AccessibilityConstants.minTouchTargetSize 
        : height;
    
    return Size(validWidth, validHeight);
  }

  /// إنشاء حاوية بحجم هدف لمس صحيح
  static Widget createAccessibleTouchTarget({
    required Widget child,
    required VoidCallback? onTap,
    double? width,
    double? height,
    String? semanticLabel,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    final targetSize = getValidTouchTargetSize(
      width ?? AccessibilityConstants.preferredTouchTargetSize,
      height ?? AccessibilityConstants.preferredTouchTargetSize,
    );

    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: Tooltip(
        message: tooltip ?? semanticLabel ?? '',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: targetSize.width,
            height: targetSize.height,
            padding: padding ?? const EdgeInsets.all(8),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  // ========== التغذية الراجعة الصوتية ==========

  /// تشغيل تغذية راجعة صوتية
  static void announceToScreenReader(BuildContext context, String message) {
    if (isScreenReaderEnabled(context)) {
      // استخدام Semantics للإعلان للقارئ الصوتي
      // يمكن تحسين هذا لاحقاً باستخدام SemanticsService
      debugPrint('Screen Reader Announcement: $message');
    }
  }

  /// تشغيل اهتزاز تغذية راجعة
  static void provideTactileFeedback([AccessibilityHapticFeedback? type]) {
    switch (type) {
      case AccessibilityHapticFeedback.lightImpact:
        HapticFeedback.lightImpact();
        break;
      case AccessibilityHapticFeedback.mediumImpact:
        HapticFeedback.mediumImpact();
        break;
      case AccessibilityHapticFeedback.heavyImpact:
        HapticFeedback.heavyImpact();
        break;
      case AccessibilityHapticFeedback.selectionClick:
        HapticFeedback.selectionClick();
        break;
      default:
        HapticFeedback.lightImpact();
    }
  }

  // ========== التنقل بالكيبورد ==========

  /// إنشاء عنصر قابل للتنقل بالكيبورد
  static Widget createKeyboardNavigable({
    required Widget child,
    required VoidCallback? onActivate,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    String? tooltip,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          
          return Semantics(
            label: semanticLabel,
            button: onActivate != null,
            focused: isFocused,
            child: Tooltip(
              message: tooltip ?? semanticLabel ?? '',
              child: InkWell(
                onTap: onActivate,
                focusColor: Theme.of(context).focusColor,
                hoverColor: Theme.of(context).hoverColor,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: isFocused
                      ? BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ========== الرسوم المتحركة المتكيفة ==========

  /// الحصول على مدة الرسوم المتحركة المناسبة
  static Duration getAnimationDuration(BuildContext context, Duration defaultDuration) {
    if (isReduceMotionEnabled(context)) {
      return Duration.zero;
    }
    return defaultDuration;
  }

  /// إنشاء رسوم متحركة متكيفة
  static Widget createAdaptiveAnimation({
    required BuildContext context,
    required Widget child,
    Duration? duration,
    Curve curve = Curves.easeInOut,
  }) {
    final animationDuration = getAnimationDuration(
      context, 
      duration ?? AccessibilityConstants.normalAnimationDuration,
    );

    if (animationDuration == Duration.zero) {
      return child;
    }

    return AnimatedContainer(
      duration: animationDuration,
      curve: curve,
      child: child,
    );
  }

  // ========== أحجام الخطوط المتكيفة ==========

  /// الحصول على حجم خط متكيف
  static double getAdaptiveFontSize(BuildContext context, double baseSize) {
    final textScaler = MediaQuery.of(context).textScaler;
    final scaledSize = textScaler.scale(baseSize);
    
    // ضمان الحد الأدنى لحجم الخط
    return scaledSize < AccessibilityConstants.minFontSize 
        ? AccessibilityConstants.minFontSize 
        : scaledSize;
  }

  /// إنشاء نمط نص متكيف
  static TextStyle createAdaptiveTextStyle(
    BuildContext context, 
    TextStyle baseStyle,
  ) {
    final adaptiveFontSize = getAdaptiveFontSize(
      context, 
      baseStyle.fontSize ?? AccessibilityConstants.preferredFontSize,
    );

    return baseStyle.copyWith(fontSize: adaptiveFontSize);
  }

  // ========== دوال مساعدة عامة ==========

  /// إنشاء تسمية دلالية مركبة
  static String createSemanticLabel({
    required String mainLabel,
    String? state,
    String? value,
    String? hint,
  }) {
    final parts = <String>[mainLabel];
    
    if (state != null) parts.add(state);
    if (value != null) parts.add(value);
    if (hint != null) parts.add(hint);
    
    return parts.join(', ');
  }

  /// التحقق من إمكانية الوصول الشاملة للعنصر
  static Map<String, bool> validateAccessibility({
    required double width,
    required double height,
    required Color foreground,
    required Color background,
    required double fontSize,
    String? semanticLabel,
    bool isLargeText = false,
  }) {
    return {
      'validTouchTarget': isValidTouchTargetSize(width, height),
      'validContrast': isValidContrast(foreground, background, isLargeText: isLargeText),
      'validFontSize': AccessibilityConstants.isValidFontSize(fontSize),
      'hasSemanticLabel': semanticLabel != null && semanticLabel.isNotEmpty,
    };
  }
}

/// أنواع التغذية الراجعة اللمسية
enum AccessibilityHapticFeedback {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
}

/// امتداد لتسهيل استخدام إمكانية الوصول
extension AccessibilityExtension on Widget {
  /// إضافة إمكانية الوصول للويدجت
  Widget accessible({
    String? label,
    String? hint,
    String? value,
    bool? button,
    bool? header,
    bool? focused,
    bool? selected,
    bool? enabled,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      header: header,
      focused: focused,
      selected: selected,
      enabled: enabled,
      onTap: onTap,
      onLongPress: onLongPress,
      child: this,
    );
  }

  /// إضافة هدف لمس صحيح
  Widget touchTarget({
    double? width,
    double? height,
    VoidCallback? onTap,
    String? semanticLabel,
    String? tooltip,
  }) {
    return AccessibilityHelper.createAccessibleTouchTarget(
      child: this,
      onTap: onTap,
      width: width,
      height: height,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
    );
  }

  /// إضافة تنقل بالكيبورد
  Widget keyboardNavigable({
    VoidCallback? onActivate,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    String? tooltip,
  }) {
    return AccessibilityHelper.createKeyboardNavigable(
      child: this,
      onActivate: onActivate,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
    );
  }
}
