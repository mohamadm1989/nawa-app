import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import 'app_constants.dart';
import 'app_text_styles.dart';
import 'app_colors.dart';

/// ثوابت التصميم المتجاوب
/// تحتوي على أحجام وأنماط متجاوبة للشاشات المختلفة
class ResponsiveConstants {
  ResponsiveConstants._();

  // ========== أحجام الخطوط المتجاوبة ==========
  
  /// أحجام خطوط العناوين
  static double getHeadlineFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(
      context,
      baseSize: 24.0,
      scaleFactor: 1.0,
    );
  }

  static double getSubheadlineFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(
      context,
      baseSize: 20.0,
      scaleFactor: 1.0,
    );
  }

  static double getBodyFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(
      context,
      baseSize: 16.0,
      scaleFactor: 1.0,
    );
  }

  static double getCaptionFontSize(BuildContext context) {
    return ResponsiveHelper.getResponsiveFontSize(
      context,
      baseSize: 12.0,
      scaleFactor: 1.0,
    );
  }

  // ========== المسافات المتجاوبة ==========
  
  static double getSmallSpacing(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(
      context,
      baseSpacing: AppConstants.spacingSmall,
    );
  }

  static double getMediumSpacing(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(
      context,
      baseSpacing: AppConstants.spacingMedium,
    );
  }

  static double getLargeSpacing(BuildContext context) {
    return ResponsiveHelper.getResponsiveSpacing(
      context,
      baseSpacing: AppConstants.spacingLarge,
    );
  }

  // ========== أحجام العناصر المتجاوبة ==========
  
  static double getButtonHeight(BuildContext context) {
    return ResponsiveHelper.getResponsiveHeight(
      context,
      baseHeight: AppConstants.buttonHeight,
    );
  }

  static double getInputHeight(BuildContext context) {
    return ResponsiveHelper.getResponsiveHeight(
      context,
      baseHeight: AppConstants.inputHeight,
    );
  }

  static double getCardHeight(BuildContext context) {
    return ResponsiveHelper.getResponsiveHeight(
      context,
      baseHeight: AppConstants.cardDefaultHeight,
    );
  }

  // ========== المسافات الداخلية المتجاوبة ==========
  
  static EdgeInsets getSmallPadding(BuildContext context) {
    final spacing = getSmallSpacing(context);
    return EdgeInsets.all(spacing);
  }

  static EdgeInsets getMediumPadding(BuildContext context) {
    final spacing = getMediumSpacing(context);
    return EdgeInsets.all(spacing);
  }

  static EdgeInsets getLargePadding(BuildContext context) {
    final spacing = getLargeSpacing(context);
    return EdgeInsets.all(spacing);
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: ResponsiveHelper.getSidePadding(context),
    );
  }

  static EdgeInsets getVerticalPadding(BuildContext context) {
    final spacing = getMediumSpacing(context);
    return EdgeInsets.symmetric(vertical: spacing);
  }

  // ========== أنماط النصوص المتجاوبة ==========
  
  static TextStyle getHeadlineStyle(BuildContext context) {
    return AppTextStyles.headlineLarge.copyWith(
      fontSize: getHeadlineFontSize(context),
    );
  }

  static TextStyle getSubheadlineStyle(BuildContext context) {
    return AppTextStyles.headlineMedium.copyWith(
      fontSize: getSubheadlineFontSize(context),
    );
  }

  static TextStyle getBodyStyle(BuildContext context) {
    return AppTextStyles.bodyLarge.copyWith(
      fontSize: getBodyFontSize(context),
    );
  }

  static TextStyle getCaptionStyle(BuildContext context) {
    return AppTextStyles.bodySmall.copyWith(
      fontSize: getCaptionFontSize(context),
    );
  }

  // ========== أحجام الأيقونات المتجاوبة ==========
  
  static double getSmallIconSize(BuildContext context) {
    if (ResponsiveHelper.isExtraSmall(context)) return 14.0;
    if (ResponsiveHelper.isSmallMobile(context)) return 16.0;
    return AppConstants.iconSizeSmall;
  }

  static double getMediumIconSize(BuildContext context) {
    if (ResponsiveHelper.isExtraSmall(context)) return 18.0;
    if (ResponsiveHelper.isSmallMobile(context)) return 20.0;
    return AppConstants.iconSizeMedium;
  }

  static double getLargeIconSize(BuildContext context) {
    if (ResponsiveHelper.isExtraSmall(context)) return 24.0;
    if (ResponsiveHelper.isSmallMobile(context)) return 28.0;
    return AppConstants.iconSizeLarge;
  }

  // ========== أحجام الصور الشخصية المتجاوبة ==========
  
  static double getSmallAvatarSize(BuildContext context) {
    return ResponsiveHelper.getAvatarSize(
      context,
      extraSmallSize: 24.0,
      smallMobileSize: 28.0,
      mobileSize: AppConstants.avatarSizeSmall,
    );
  }

  static double getMediumAvatarSize(BuildContext context) {
    return ResponsiveHelper.getAvatarSize(
      context,
      extraSmallSize: 32.0,
      smallMobileSize: 36.0,
      mobileSize: AppConstants.avatarSizeMedium,
    );
  }

  static double getLargeAvatarSize(BuildContext context) {
    return ResponsiveHelper.getAvatarSize(
      context,
      extraSmallSize: 48.0,
      smallMobileSize: 56.0,
      mobileSize: AppConstants.avatarSizeLarge,
    );
  }

  // ========== أنماط الكروت المتجاوبة ==========
  
  static BoxDecoration getResponsiveCardDecoration(BuildContext context) {
    final borderRadius = ResponsiveHelper.needsCompactLayout(context)
        ? AppConstants.borderRadiusSmall
        : AppConstants.borderRadiusMedium;
    
    return BoxDecoration(
      color: AppColors.backgroundCard,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: ResponsiveHelper.needsCompactLayout(context) ? 4.0 : 8.0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ========== أنماط الأزرار المتجاوبة ==========
  
  static ButtonStyle getResponsivePrimaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      minimumSize: Size(
        double.infinity,
        getButtonHeight(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.needsCompactLayout(context)
              ? AppConstants.borderRadiusSmall
              : AppConstants.borderRadiusMedium,
        ),
      ),
      elevation: ResponsiveHelper.needsCompactLayout(context) ? 1.0 : 2.0,
      textStyle: AppTextStyles.buttonPrimary.copyWith(
        fontSize: getBodyFontSize(context),
      ),
    );
  }

  static ButtonStyle getResponsiveSecondaryButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryGreen,
      minimumSize: Size(
        double.infinity,
        getButtonHeight(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.needsCompactLayout(context)
              ? AppConstants.borderRadiusSmall
              : AppConstants.borderRadiusMedium,
        ),
      ),
      side: BorderSide(
        color: AppColors.primaryGreen,
        width: ResponsiveHelper.needsCompactLayout(context) ? 1.0 : 1.5,
      ),
      textStyle: AppTextStyles.buttonSecondary.copyWith(
        fontSize: getBodyFontSize(context),
      ),
    );
  }

  // ========== أنماط حقول الإدخال المتجاوبة ==========
  
  static InputDecoration getResponsiveInputDecoration(BuildContext context) {
    final borderRadius = ResponsiveHelper.needsCompactLayout(context)
        ? AppConstants.borderRadiusSmall
        : AppConstants.borderRadiusMedium;
    
    return InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundCard,
      contentPadding: getMediumPadding(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: AppColors.border,
          width: AppConstants.borderWidthThin,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: AppColors.border,
          width: AppConstants.borderWidthThin,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: AppColors.primaryGreen,
          width: AppConstants.borderWidthMedium,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: AppConstants.borderWidthThin,
        ),
      ),
      hintStyle: AppTextStyles.hint.copyWith(
        fontSize: getBodyFontSize(context),
      ),
      labelStyle: AppTextStyles.labelMedium.copyWith(
        fontSize: getBodyFontSize(context),
      ),
      errorStyle: AppTextStyles.error.copyWith(
        fontSize: getCaptionFontSize(context),
      ),
    );
  }

  // ========== دوال مساعدة للتخطيط ==========
  
  /// الحصول على عدد الأعمدة المناسب للشبكة
  static int getOptimalGridColumns(BuildContext context) {
    return ResponsiveHelper.getCompactGridColumns(context);
  }

  /// الحصول على نسبة العرض إلى الارتفاع للكروت
  static double getOptimalCardAspectRatio(BuildContext context) {
    if (ResponsiveHelper.isExtraSmall(context)) return 2.5;
    if (ResponsiveHelper.isSmallMobile(context)) return 2.2;
    if (ResponsiveHelper.isMobile(context)) return 2.0;
    if (ResponsiveHelper.isTablet(context)) return 1.8;
    return 1.6;
  }

  /// التحقق من الحاجة لتخطيط مضغوط
  static bool shouldUseCompactLayout(BuildContext context) {
    return ResponsiveHelper.needsCompactLayout(context);
  }
}
