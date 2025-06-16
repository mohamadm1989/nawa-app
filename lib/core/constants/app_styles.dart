import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_constants.dart';
import 'app_text_styles.dart';

/// أنماط العناصر المشتركة لضمان الاتساق في التصميم
class AppStyles {
  // منع إنشاء كائن من هذا الكلاس
  AppStyles._();

  // ========== أنماط الكروت ==========
  
  /// كرت أساسي مع ظل خفيف
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.backgroundCard,
    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ],
  );

  /// كرت مرفوع مع ظل متوسط
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: AppColors.backgroundCard,
    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowMedium,
        blurRadius: 12.0,
        offset: const Offset(0, 4),
      ),
    ],
  );

  /// كرت مميز مع حدود ملونة
  static BoxDecoration get accentCardDecoration => BoxDecoration(
    color: AppColors.backgroundCard,
    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    border: Border.all(
      color: AppColors.primaryGreen,
      width: AppConstants.borderWidthThin,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // ========== أنماط الأزرار ==========
  
  /// زر أساسي
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryGreen,
    foregroundColor: AppColors.textOnColor,
    minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    ),
    elevation: 2.0,
    textStyle: AppTextStyles.buttonPrimary,
  );

  /// زر ثانوي
  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: AppColors.primaryGreen,
    minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    ),
    side: const BorderSide(
      color: AppColors.primaryGreen,
      width: AppConstants.borderWidthThin,
    ),
    textStyle: AppTextStyles.buttonSecondary,
  );

  /// زر نصي
  static ButtonStyle get textButtonStyle => TextButton.styleFrom(
    foregroundColor: AppColors.primaryGreen,
    minimumSize: const Size(0, AppConstants.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
    ),
    textStyle: AppTextStyles.buttonSecondary,
  );

  // ========== أنماط حقول الإدخال ==========
  
  /// حقل إدخال أساسي
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: AppColors.backgroundCard,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      borderSide: const BorderSide(
        color: AppColors.border,
        width: AppConstants.borderWidthThin,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      borderSide: const BorderSide(
        color: AppColors.border,
        width: AppConstants.borderWidthThin,
      ),
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
      borderSide: const BorderSide(
        color: AppColors.error,
        width: AppConstants.borderWidthThin,
      ),
    ),
    contentPadding: AppConstants.paddingMedium,
    hintStyle: AppTextStyles.hint,
    labelStyle: AppTextStyles.labelMedium,
    errorStyle: AppTextStyles.error,
  );

  // ========== أنماط الحوارات ==========
  
  /// حوار أساسي
  static ShapeBorder get dialogShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
  );

  /// خلفية الحوار
  static Color get dialogBarrierColor => AppColors.shadowDark;

  // ========== أنماط شريط التطبيق ==========
  
  /// شريط تطبيق أساسي
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: AppColors.primaryGreen,
    foregroundColor: AppColors.textOnColor,
    elevation: 2.0,
    centerTitle: true,
    titleTextStyle: AppTextStyles.headlineSmall.copyWith(
      color: AppColors.textOnColor,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textOnColor,
      size: AppConstants.iconSizeMedium,
    ),
  );

  // ========== أنماط القوائم ==========
  
  /// عنصر قائمة أساسي
  static ListTileThemeData get listTileTheme => ListTileThemeData(
    contentPadding: AppConstants.paddingMedium,
    minVerticalPadding: AppConstants.spacingSmall,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
    ),
    titleTextStyle: AppTextStyles.bodyLarge,
    subtitleTextStyle: AppTextStyles.bodySmall,
    iconColor: AppColors.primaryGreen,
  );

  // ========== أنماط الفواصل ==========
  
  /// فاصل أفقي
  static Widget get horizontalDivider => Container(
    height: AppConstants.borderWidthThin,
    color: AppColors.divider,
    margin: const EdgeInsets.symmetric(
      vertical: AppConstants.spacingSmall,
    ),
  );

  /// فاصل عمودي
  static Widget get verticalDivider => Container(
    width: AppConstants.borderWidthThin,
    color: AppColors.divider,
    margin: const EdgeInsets.symmetric(
      horizontal: AppConstants.spacingSmall,
    ),
  );

  // ========== أنماط الصور ==========
  
  /// صورة دائرية صغيرة
  static Widget circularImage({
    required String imageUrl,
    double size = AppConstants.avatarSizeMedium,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.border,
          width: AppConstants.borderWidthThin,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.backgroundAccent,
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ========== أنماط شرائط التقدم ==========
  
  /// شريط تقدم أساسي
  static Widget progressBar({
    required double progress,
    double height = 8.0,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.progressBackground,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.progressBar,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }

  // ========== أنماط الشارات ==========
  
  /// شارة حالة
  static Widget statusBadge({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSmall,
        vertical: AppConstants.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        border: Border.all(
          color: color,
          width: AppConstants.borderWidthThin,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }

  // ========== أنماط الأيقونات ==========
  
  /// أيقونة دائرية
  static Widget circularIcon({
    required IconData icon,
    Color? backgroundColor,
    Color? iconColor,
    double size = AppConstants.iconSizeLarge,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primaryGreen.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor ?? AppColors.primaryGreen,
        size: size * 0.6,
      ),
    );
  }
}
