import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// أنماط إمكانية الوصول
/// تحتوي على أنماط محسّنة لإمكانية الوصول
class AccessibilityStyles {
  AccessibilityStyles._();

  // ========== أنماط الأزرار ==========

  /// نمط الزر الأساسي مع إمكانية الوصول
  static ButtonStyle accessiblePrimaryButtonStyle(BuildContext context) {
    final backgroundColor = AppColors.primaryGreen;
    final foregroundColor = AccessibilityHelper.getContrastingColor(backgroundColor);
    
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      minimumSize: const Size(
        AccessibilityConstants.minTouchTargetSize,
        AccessibilityConstants.minTouchTargetSize,
      ),
      padding: const EdgeInsets.all(AccessibilityConstants.preferredInteractivePadding),
      textStyle: AccessibilityHelper.createAdaptiveTextStyle(
        context,
        const TextStyle(
          fontSize: AccessibilityConstants.preferredFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      elevation: 2,
      shadowColor: AppColors.shadowLight,
    );
  }

  /// نمط الزر الثانوي مع إمكانية الوصول
  static ButtonStyle accessibleSecondaryButtonStyle(BuildContext context) {
    final borderColor = AppColors.primaryGreen;
    final foregroundColor = AppColors.primaryGreen;
    
    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor,
      minimumSize: const Size(
        AccessibilityConstants.minTouchTargetSize,
        AccessibilityConstants.minTouchTargetSize,
      ),
      padding: const EdgeInsets.all(AccessibilityConstants.preferredInteractivePadding),
      textStyle: AccessibilityHelper.createAdaptiveTextStyle(
        context,
        const TextStyle(
          fontSize: AccessibilityConstants.preferredFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      side: BorderSide(
        color: borderColor,
        width: 2,
      ),
    );
  }

  /// نمط الزر النصي مع إمكانية الوصول
  static ButtonStyle accessibleTextButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primaryGreen,
      minimumSize: const Size(
        AccessibilityConstants.minTouchTargetSize,
        AccessibilityConstants.minTouchTargetSize,
      ),
      padding: const EdgeInsets.all(AccessibilityConstants.preferredInteractivePadding),
      textStyle: AccessibilityHelper.createAdaptiveTextStyle(
        context,
        const TextStyle(
          fontSize: AccessibilityConstants.preferredFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
    );
  }

  // ========== أنماط حقول الإدخال ==========

  /// نمط حقل الإدخال مع إمكانية الوصول
  static InputDecoration accessibleInputDecoration(BuildContext context, {
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.backgroundCard,
      contentPadding: const EdgeInsets.all(AccessibilityConstants.preferredInteractivePadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: AppColors.border,
          width: AppConstants.borderWidthThin,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: AppColors.border,
          width: AppConstants.borderWidthThin,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: AppColors.primaryGreen,
          width: 3, // حد أكثر وضوحاً للتركيز
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: AppColors.error,
          width: 3,
        ),
      ),
      labelStyle: AccessibilityHelper.createAdaptiveTextStyle(
        context,
        AppTextStyles.labelMedium,
      ),
      hintStyle: AccessibilityHelper.createAdaptiveTextStyle(
        context,
        AppTextStyles.hint,
      ),
      helperStyle: AccessibilityHelper.createAdaptiveTextStyle(
        context,
        AppTextStyles.bodySmall,
      ),
      errorStyle: AccessibilityHelper.createAdaptiveTextStyle(
        context,
        AppTextStyles.error,
      ),
    );
  }

  // ========== أنماط الكروت ==========

  /// نمط الكرت مع إمكانية الوصول
  static BoxDecoration accessibleCardDecoration(BuildContext context, {
    bool selected = false,
    bool focused = false,
  }) {
    return BoxDecoration(
      color: AppColors.backgroundCard,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      border: selected || focused
          ? Border.all(
              color: AppColors.primaryGreen,
              width: focused ? 3 : 2,
            )
          : Border.all(
              color: AppColors.border,
              width: AppConstants.borderWidthThin,
            ),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: selected ? 8 : 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ========== أنماط النصوص ==========

  /// نمط النص مع إمكانية الوصول
  static TextStyle accessibleTextStyle(
    BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    bool isLargeText = false,
  }) {
    final baseSize = fontSize ?? AccessibilityConstants.preferredFontSize;
    final adaptiveSize = AccessibilityHelper.getAdaptiveFontSize(context, baseSize);
    
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = color ?? AppColors.textPrimary;
    
    // التحقق من التباين
    final hasValidContrast = AccessibilityHelper.isValidContrast(
      textColor, 
      backgroundColor, 
      isLargeText: isLargeText,
    );
    
    final finalColor = hasValidContrast 
        ? textColor 
        : AccessibilityHelper.getContrastingColor(backgroundColor, isLargeText: isLargeText);

    return TextStyle(
      fontSize: adaptiveSize,
      fontWeight: fontWeight,
      color: finalColor,
      fontFamily: 'Cairo',
      height: 1.4, // تحسين المسافة بين الأسطر للقراءة
    );
  }

  /// نمط العنوان مع إمكانية الوصول
  static TextStyle accessibleHeadlineStyle(BuildContext context) {
    return accessibleTextStyle(
      context,
      fontSize: AccessibilityConstants.largeFontSize,
      fontWeight: FontWeight.bold,
      isLargeText: true,
    );
  }

  /// نمط العنوان الفرعي مع إمكانية الوصول
  static TextStyle accessibleSubheadlineStyle(BuildContext context) {
    return accessibleTextStyle(
      context,
      fontSize: AccessibilityConstants.preferredFontSize + 2,
      fontWeight: FontWeight.w600,
    );
  }

  /// نمط النص الأساسي مع إمكانية الوصول
  static TextStyle accessibleBodyStyle(BuildContext context) {
    return accessibleTextStyle(
      context,
      fontSize: AccessibilityConstants.preferredFontSize,
      fontWeight: FontWeight.normal,
    );
  }

  /// نمط النص التفسيري مع إمكانية الوصول
  static TextStyle accessibleCaptionStyle(BuildContext context) {
    return accessibleTextStyle(
      context,
      fontSize: AccessibilityConstants.minFontSize,
      fontWeight: FontWeight.normal,
    );
  }

  // ========== أنماط التركيز ==========

  /// نمط التركيز للعناصر التفاعلية
  static BoxDecoration focusDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.primaryGreen,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    );
  }

  /// نمط التحديد للعناصر
  static BoxDecoration selectionDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.primaryGreen.withValues(alpha: 0.1),
      border: Border.all(
        color: AppColors.primaryGreen,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    );
  }

  // ========== أنماط الحالات ==========

  /// نمط حالة النجاح
  static BoxDecoration successStateDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.success.withValues(alpha: 0.1),
      border: Border.all(
        color: AppColors.success,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    );
  }

  /// نمط حالة الخطأ
  static BoxDecoration errorStateDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.error.withValues(alpha: 0.1),
      border: Border.all(
        color: AppColors.error,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    );
  }

  /// نمط حالة التحذير
  static BoxDecoration warningStateDecoration(BuildContext context) {
    return BoxDecoration(
      color: AppColors.warning.withValues(alpha: 0.1),
      border: Border.all(
        color: AppColors.warning,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    );
  }

  // ========== أنماط الأيقونات ==========

  /// حجم الأيقونة مع إمكانية الوصول
  static double accessibleIconSize(BuildContext context, {double baseSize = 24}) {
    return AccessibilityHelper.getAdaptiveFontSize(context, baseSize);
  }

  /// لون الأيقونة مع تباين مناسب
  static Color accessibleIconColor(BuildContext context, {Color? preferredColor}) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final iconColor = preferredColor ?? AppColors.textPrimary;
    
    final hasValidContrast = AccessibilityHelper.isValidContrast(iconColor, backgroundColor);
    return hasValidContrast 
        ? iconColor 
        : AccessibilityHelper.getContrastingColor(backgroundColor);
  }

  // ========== دوال مساعدة ==========

  /// التحقق من صحة النمط لإمكانية الوصول
  static Map<String, bool> validateStyle({
    required BuildContext context,
    required double width,
    required double height,
    required Color foreground,
    required Color background,
    required double fontSize,
    bool isLargeText = false,
  }) {
    return AccessibilityHelper.validateAccessibility(
      width: width,
      height: height,
      foreground: foreground,
      background: background,
      fontSize: fontSize,
      isLargeText: isLargeText,
    );
  }

  /// إنشاء نمط متكيف حسب إعدادات النظام
  static T adaptiveStyle<T>(
    BuildContext context, {
    required T normalStyle,
    required T highContrastStyle,
    required T largeTextStyle,
    required T reducedMotionStyle,
  }) {
    if (AccessibilityHelper.isHighContrastEnabled(context)) {
      return highContrastStyle;
    }
    
    if (AccessibilityHelper.isLargeTextEnabled(context)) {
      return largeTextStyle;
    }
    
    if (AccessibilityHelper.isReduceMotionEnabled(context)) {
      return reducedMotionStyle;
    }
    
    return normalStyle;
  }
}
