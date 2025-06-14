import 'package:flutter/material.dart';
import 'app_colors.dart';

/// أنماط النصوص لتطبيق نِواة
/// باستخدام خط Cairo العربي
class AppTextStyles {
  // منع إنشاء كائن من هذا الكلاس
  AppTextStyles._();

  // ========== الخط الأساسي ==========
  
  /// خط Cairo - الخط الأساسي للتطبيق
  static String get fontFamily => 'Cairo';

  // ========== أحجام الخطوط ==========
  
  /// حجم صغير جداً - 12pt
  static const double fontSizeXSmall = 12.0;
  
  /// حجم صغير - 14pt  
  static const double fontSizeSmall = 14.0;
  
  /// حجم متوسط - 16pt
  static const double fontSizeMedium = 16.0;
  
  /// حجم كبير - 18pt
  static const double fontSizeLarge = 18.0;
  
  /// حجم كبير جداً - 20pt
  static const double fontSizeXLarge = 20.0;
  
  /// حجم العناوين - 24pt
  static const double fontSizeTitle = 24.0;

  // ========== أوزان الخطوط ==========

  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ========== دالة مساعدة لإنشاء TextStyle ==========

  /// إنشاء TextStyle مع خط Cairo المحلي
  static TextStyle _createTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required double height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  // ========== العناوين الرئيسية ==========
  
  /// عنوان كبير - للصفحات الرئيسية
  static TextStyle get headlineLarge => _createTextStyle(
    fontSize: fontSizeTitle,
    fontWeight: bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  /// عنوان متوسط - للأقسام
  static TextStyle get headlineMedium => _createTextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// عنوان صغير - للعناصر
  static TextStyle get headlineSmall => _createTextStyle(
    fontSize: fontSizeLarge,
    fontWeight: medium,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ========== نصوص الجسم ==========
  
  /// نص كبير - للمحتوى المهم
  static TextStyle get bodyLarge => _createTextStyle(
    fontSize: fontSizeMedium,
    fontWeight: regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// نص متوسط - للمحتوى العادي
  static TextStyle get bodyMedium => _createTextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// نص صغير - للتفاصيل
  static TextStyle get bodySmall => _createTextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: regular,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ========== نصوص التسميات ==========
  
  /// تسمية كبيرة - للأزرار الرئيسية
  static TextStyle get labelLarge => _createTextStyle(
    fontSize: fontSizeSmall,
    fontWeight: medium,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// تسمية متوسطة - للأزرار العادية
  static TextStyle get labelMedium => _createTextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: medium,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// تسمية صغيرة - للروابط والملاحظات
  static TextStyle get labelSmall => _createTextStyle(
    fontSize: 11.0,
    fontWeight: medium,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // ========== أنماط خاصة ==========
  
  /// نص الترحيب - للصفحة الرئيسية
  static TextStyle get welcome => _createTextStyle(
    fontSize: fontSizeTitle,
    fontWeight: bold,
    color: AppColors.primaryGreen,
    height: 1.2,
  );

  /// نص الأزرار الرئيسية
  static TextStyle get buttonPrimary => _createTextStyle(
    fontSize: fontSizeMedium,
    fontWeight: semiBold,
    color: AppColors.textOnColor,
    height: 1.2,
  );

  /// نص الأزرار الثانوية
  static TextStyle get buttonSecondary => _createTextStyle(
    fontSize: fontSizeMedium,
    fontWeight: medium,
    color: AppColors.primaryGreen,
    height: 1.2,
  );

  /// نص الروابط
  static TextStyle get link => _createTextStyle(
    fontSize: fontSizeSmall,
    fontWeight: medium,
    color: AppColors.link,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  /// نص التلميحات
  static TextStyle get hint => _createTextStyle(
    fontSize: fontSizeSmall,
    fontWeight: regular,
    color: AppColors.textHint,
    height: 1.4,
  );

  /// نص الأخطاء
  static TextStyle get error => _createTextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: medium,
    color: AppColors.error,
    height: 1.3,
  );

  /// نص النجاح
  static TextStyle get success => _createTextStyle(
    fontSize: fontSizeXSmall,
    fontWeight: medium,
    color: AppColors.success,
    height: 1.3,
  );

  // ========== أنماط الأرقام والإحصائيات ==========
  
  /// أرقام كبيرة - للإحصائيات المهمة
  static TextStyle get numberLarge => _createTextStyle(
    fontSize: 32.0,
    fontWeight: bold,
    color: AppColors.primaryGreen,
    height: 1.0,
  );

  /// أرقام متوسطة - للمبالغ
  static TextStyle get numberMedium => _createTextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  /// نسب مئوية - لشرائط التقدم
  static TextStyle get percentage => _createTextStyle(
    fontSize: fontSizeSmall,
    fontWeight: semiBold,
    color: AppColors.primaryGreen,
    height: 1.2,
  );

  // ========== دوال مساعدة ==========
  
  /// تطبيق لون مخصص على نمط نص
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  /// تطبيق حجم مخصص على نمط نص
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
  
  /// تطبيق وزن مخصص على نمط نص
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
  
  /// الحصول على نمط نص مخصص
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return _createTextStyle(
      fontSize: fontSize ?? fontSizeMedium,
      fontWeight: fontWeight ?? regular,
      color: color ?? AppColors.textPrimary,
      height: height ?? 1.4,
      decoration: decoration,
    );
  }
}
