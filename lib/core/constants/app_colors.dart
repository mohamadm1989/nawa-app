import 'package:flutter/material.dart';

/// نظام الألوان لتطبيق نِواة
/// مستخرج من الهوية البصرية المصممة
class AppColors {
  // منع إنشاء كائن من هذا الكلاس
  AppColors._();

  // ========== الألوان الأساسية ==========
  
  /// 🟢 أخضر سوريا - اللون الأساسي
  /// يرمز للأرض والنمو والأمل
  static const Color primaryGreen = Color(0xFF4A7C59);
  
  /// 🟤 بيج الحنان - اللون الثانوي  
  /// يرمز للدفء والحنان والأمان
  static const Color secondaryBeige = Color(0xFFE4B896);
  
  /// ⚪ أبيض نقي - اللون المحايد
  /// يرمز للنقاء والوضوح والشفافية
  static const Color neutralWhite = Color(0xFFFFFFFF);
  
  /// 🔘 رمادي دافئ - اللون المساعد
  /// يرمز للاستقرار والموثوقية
  static const Color helperGray = Color(0xFF8B7D6B);

  // ========== تدرجات الألوان الأساسية ==========
  
  /// تدرجات الأخضر السوري
  static const Color primaryGreenLight = Color(0xFF6B9B7A);
  static const Color primaryGreenDark = Color(0xFF3A5F47);
  static const Color primaryGreenLighter = Color(0xFF8CB89B);
  
  /// تدرجات البيج الحنان
  static const Color secondaryBeigeLight = Color(0xFFEDC7A7);
  static const Color secondaryBeigeDark = Color(0xFFD4A485);
  
  /// تدرجات الرمادي الدافئ
  static const Color helperGrayLight = Color(0xFFA39688);
  static const Color helperGrayDark = Color(0xFF6F6B5E);

  // ========== الألوان الوظيفية ==========
  
  /// ✅ أخضر النجاح
  static const Color success = Color(0xFF4CAF50);
  
  /// ⚠️ أصفر التحذير
  static const Color warning = Color(0xFFFF9800);
  
  /// ❌ أحمر الخطر
  static const Color error = Color(0xFFF44336);
  
  /// ℹ️ أزرق المعلومات
  static const Color info = Color(0xFF2196F3);

  // ========== ألوان النصوص ==========
  
  /// نص أساسي - أسود داكن
  static const Color textPrimary = Color(0xFF212121);
  
  /// نص ثانوي - رمادي متوسط
  static const Color textSecondary = Color(0xFF757575);
  
  /// نص مساعد - رمادي فاتح
  static const Color textHint = Color(0xFF9E9E9E);
  
  /// نص على خلفية ملونة - أبيض
  static const Color textOnColor = Color(0xFFFFFFFF);

  // ========== ألوان الخلفيات ==========
  
  /// خلفية التطبيق الرئيسية
  static const Color backgroundPrimary = Color(0xFFFAFAFA);
  
  /// خلفية الكروت والعناصر
  static const Color backgroundCard = Color(0xFFFFFFFF);
  
  /// خلفية الأقسام المميزة
  static const Color backgroundAccent = Color(0xFFF5F5F5);
  
  /// خلفية الأزرار المعطلة
  static const Color backgroundDisabled = Color(0xFFE0E0E0);

  // ========== ألوان الحدود والفواصل ==========
  
  /// حدود العناصر
  static const Color border = Color(0xFFE0E0E0);
  
  /// فواصل القوائم
  static const Color divider = Color(0xFFBDBDBD);
  
  /// حدود مميزة
  static const Color borderAccent = Color(0xFFCCCCCC);

  // ========== ألوان الظلال ==========
  
  /// ظل خفيف للكروت
  static const Color shadowLight = Color(0x1A000000);
  
  /// ظل متوسط للعناصر المرفوعة
  static const Color shadowMedium = Color(0x33000000);
  
  /// ظل داكن للحوارات
  static const Color shadowDark = Color(0x4D000000);

  // ========== ألوان خاصة بالتطبيق ==========
  
  /// لون شريط التقدم
  static const Color progressBar = primaryGreen;
  
  /// لون خلفية شريط التقدم
  static const Color progressBackground = Color(0xFFE8F5E8);
  
  /// لون النجوم والتقييمات
  static const Color rating = Color(0xFFFFD700);
  
  /// لون الإعجابات والقلوب
  static const Color like = Color(0xFFE91E63);
  
  /// لون الروابط
  static const Color link = Color(0xFF1976D2);

  // ========== دوال مساعدة ==========
  
  /// الحصول على لون بشفافية معينة
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  
  /// الحصول على تدرج لوني
  static LinearGradient getGradient({
    required Color startColor,
    required Color endColor,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [startColor, endColor],
    );
  }
  
  /// تدرج الأخضر السوري
  static LinearGradient get primaryGradient => getGradient(
    startColor: primaryGreenLight,
    endColor: primaryGreenDark,
  );
  
  /// تدرج البيج الحنان
  static LinearGradient get secondaryGradient => getGradient(
    startColor: secondaryBeigeLight,
    endColor: secondaryBeigeDark,
  );
}
