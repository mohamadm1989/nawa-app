import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';

/// ثيم تطبيق نِواة
/// يطبق نظام الألوان والخطوط المصمم
class AppTheme {
  // منع إنشاء كائن من هذا الكلاس
  AppTheme._();

  /// الثيم الفاتح للتطبيق
  static ThemeData get lightTheme {
    return ThemeData(
      // ========== الإعدادات الأساسية ==========
      useMaterial3: true,
      brightness: Brightness.light,
      
      // ========== نظام الألوان ==========
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryGreen,
        onPrimary: AppColors.textOnColor,
        secondary: AppColors.secondaryBeige,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.backgroundCard,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: AppColors.textOnColor,
      ),
      
      // ========== الخطوط ==========
      fontFamily: 'Cairo',
      fontFamilyFallback: const ['Cairo'], // فرض استخدام Cairo فقط
      textTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(fontFamily: 'Cairo'),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(fontFamily: 'Cairo'),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(fontFamily: 'Cairo'),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(fontFamily: 'Cairo'),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Cairo'),
        bodySmall: AppTextStyles.bodySmall.copyWith(fontFamily: 'Cairo'),
        labelLarge: AppTextStyles.labelLarge.copyWith(fontFamily: 'Cairo'),
        labelMedium: AppTextStyles.labelMedium.copyWith(fontFamily: 'Cairo'),
        labelSmall: AppTextStyles.labelSmall.copyWith(fontFamily: 'Cairo'),
      ),
      primaryTextTheme: TextTheme(
        headlineLarge: AppTextStyles.headlineLarge.copyWith(fontFamily: 'Cairo'),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(fontFamily: 'Cairo'),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(fontFamily: 'Cairo'),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(fontFamily: 'Cairo'),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Cairo'),
        bodySmall: AppTextStyles.bodySmall.copyWith(fontFamily: 'Cairo'),
        labelLarge: AppTextStyles.labelLarge.copyWith(fontFamily: 'Cairo'),
        labelMedium: AppTextStyles.labelMedium.copyWith(fontFamily: 'Cairo'),
        labelSmall: AppTextStyles.labelSmall.copyWith(fontFamily: 'Cairo'),
      ),
      
      // ========== شريط التطبيق ==========
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textOnColor,
          fontFamily: 'Cairo',
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      
      // ========== الأزرار ==========
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          elevation: 2,
          shadowColor: AppColors.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          textStyle: AppTextStyles.buttonPrimary.copyWith(fontFamily: 'Cairo'),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(
            color: AppColors.primaryGreen,
            width: AppConstants.borderWidthMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
          textStyle: AppTextStyles.buttonSecondary.copyWith(fontFamily: 'Cairo'),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          textStyle: AppTextStyles.labelLarge.copyWith(fontFamily: 'Cairo'),
        ),
      ),
      
      // ========== حقول الإدخال ==========
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: AppConstants.borderWidthMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingMedium,
        ),
        hintStyle: AppTextStyles.hint.copyWith(fontFamily: 'Cairo'),
        labelStyle: AppTextStyles.labelMedium.copyWith(fontFamily: 'Cairo'),
        errorStyle: AppTextStyles.error.copyWith(fontFamily: 'Cairo'),
      ),
      
      // ========== الكروت ==========
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        margin: const EdgeInsets.all(AppConstants.spacingSmall),
      ),
      
      // ========== الفواصل ==========
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppConstants.spacingMedium,
      ),
      
      // ========== التنقل السفلي ==========
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundCard,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // ========== شرائط التقدم ==========
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryGreen,
        linearTrackColor: AppColors.progressBackground,
      ),
      
      // ========== الحوارات ==========
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundCard,
        elevation: 8,
        shadowColor: AppColors.shadowMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(fontFamily: 'Cairo'),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Cairo'),
      ),
      
      // ========== القوائم المنسدلة ==========
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.backgroundCard,
        elevation: 4,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        textStyle: AppTextStyles.bodyMedium.copyWith(fontFamily: 'Cairo'),
      ),
      
      // ========== أشرطة التمرير ==========
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.helperGray),
        trackColor: WidgetStateProperty.all(AppColors.border),
        radius: const Radius.circular(AppConstants.borderRadiusSmall),
      ),
      
      // ========== الرقائق (Chips) ==========
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.secondaryBeige,
        selectedColor: AppColors.primaryGreen,
        labelStyle: AppTextStyles.labelMedium.copyWith(fontFamily: 'Cairo'),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
    );
  }

  /// إعدادات شريط الحالة
  static SystemUiOverlayStyle get systemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.backgroundCard,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
  }
}
