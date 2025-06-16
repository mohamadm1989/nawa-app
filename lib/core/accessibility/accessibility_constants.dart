import 'package:flutter/material.dart';

/// ثوابت إمكانية الوصول
/// تحتوي على جميع المعايير والثوابت المطلوبة لضمان إمكانية الوصول
class AccessibilityConstants {
  AccessibilityConstants._();

  // ========== أحجام أهداف اللمس ==========
  
  /// الحد الأدنى لحجم هدف اللمس (44x44 dp حسب WCAG)
  static const double minTouchTargetSize = 44.0;
  
  /// الحد الأدنى المفضل لحجم هدف اللمس (48x48 dp)
  static const double preferredTouchTargetSize = 48.0;
  
  /// حجم هدف اللمس الكبير للعناصر المهمة
  static const double largeTouchTargetSize = 56.0;

  // ========== نسب التباين ==========
  
  /// الحد الأدنى لنسبة التباين للنص العادي (4.5:1 حسب WCAG AA)
  static const double minContrastRatioNormal = 4.5;
  
  /// الحد الأدنى لنسبة التباين للنص الكبير (3:1 حسب WCAG AA)
  static const double minContrastRatioLarge = 3.0;
  
  /// نسبة التباين المحسّنة (7:1 حسب WCAG AAA)
  static const double enhancedContrastRatio = 7.0;

  // ========== أحجام الخطوط ==========
  
  /// الحد الأدنى لحجم الخط للقراءة المريحة
  static const double minFontSize = 14.0;
  
  /// حجم الخط المفضل للنص الأساسي
  static const double preferredFontSize = 16.0;
  
  /// حجم الخط الكبير للعناوين
  static const double largeFontSize = 20.0;
  
  /// حجم الخط الكبير جداً للعناوين الرئيسية
  static const double extraLargeFontSize = 24.0;

  // ========== المسافات والحواف ==========
  
  /// المسافة الدنيا بين العناصر التفاعلية
  static const double minInteractiveSpacing = 8.0;
  
  /// المسافة المفضلة بين العناصر التفاعلية
  static const double preferredInteractiveSpacing = 12.0;
  
  /// المسافة الداخلية الدنيا للعناصر التفاعلية
  static const double minInteractivePadding = 12.0;
  
  /// المسافة الداخلية المفضلة للعناصر التفاعلية
  static const double preferredInteractivePadding = 16.0;

  // ========== مدة الرسوم المتحركة ==========
  
  /// مدة الرسوم المتحركة السريعة
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  
  /// مدة الرسوم المتحركة العادية
  static const Duration normalAnimationDuration = Duration(milliseconds: 300);
  
  /// مدة الرسوم المتحركة البطيئة للمستخدمين الذين يفضلون الحركة المقللة
  static const Duration slowAnimationDuration = Duration(milliseconds: 600);

  // ========== التسميات الدلالية ==========
  
  /// تسميات الأزرار الشائعة
  static const Map<String, String> buttonLabels = {
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'delete': 'حذف',
    'edit': 'تعديل',
    'add': 'إضافة',
    'search': 'بحث',
    'filter': 'فلتر',
    'sort': 'ترتيب',
    'share': 'مشاركة',
    'like': 'إعجاب',
    'comment': 'تعليق',
    'donate': 'تبرع',
    'back': 'رجوع',
    'next': 'التالي',
    'previous': 'السابق',
    'close': 'إغلاق',
    'menu': 'القائمة',
    'settings': 'الإعدادات',
    'profile': 'الملف الشخصي',
    'home': 'الرئيسية',
    'notifications': 'الإشعارات',
    'map': 'الخريطة',
    'projects': 'المشاريع',
    'statistics': 'الإحصائيات',
  };

  /// تسميات الحالات
  static const Map<String, String> stateLabels = {
    'loading': 'جاري التحميل',
    'error': 'حدث خطأ',
    'empty': 'لا توجد بيانات',
    'success': 'تم بنجاح',
    'selected': 'محدد',
    'unselected': 'غير محدد',
    'expanded': 'موسع',
    'collapsed': 'مطوي',
    'enabled': 'مفعل',
    'disabled': 'معطل',
    'required': 'مطلوب',
    'optional': 'اختياري',
  };

  /// تسميات التنقل
  static const Map<String, String> navigationLabels = {
    'tab': 'تبويب',
    'page': 'صفحة',
    'section': 'قسم',
    'item': 'عنصر',
    'list': 'قائمة',
    'grid': 'شبكة',
    'card': 'بطاقة',
    'dialog': 'حوار',
    'popup': 'نافذة منبثقة',
    'drawer': 'درج التنقل',
    'bottomSheet': 'الورقة السفلية',
  };

  // ========== رسائل إمكانية الوصول ==========
  
  /// رسائل التغذية الراجعة
  static const Map<String, String> feedbackMessages = {
    'itemSelected': 'تم تحديد العنصر',
    'itemDeselected': 'تم إلغاء تحديد العنصر',
    'pageChanged': 'تم تغيير الصفحة',
    'filterApplied': 'تم تطبيق الفلتر',
    'sortChanged': 'تم تغيير الترتيب',
    'dataLoaded': 'تم تحميل البيانات',
    'actionCompleted': 'تم إنجاز العملية',
    'errorOccurred': 'حدث خطأ، يرجى المحاولة مرة أخرى',
    'formSubmitted': 'تم إرسال النموذج',
    'fieldRequired': 'هذا الحقل مطلوب',
    'invalidInput': 'المدخل غير صحيح',
    'passwordWeak': 'كلمة المرور ضعيفة',
    'passwordStrong': 'كلمة المرور قوية',
  };

  /// تسميات الإجراءات
  static const Map<String, String> actionLabels = {
    'tap': 'اضغط',
    'doubleTap': 'اضغط مرتين',
    'longPress': 'اضغط مطولاً',
    'swipe': 'اسحب',
    'scroll': 'مرر',
    'pinch': 'قرص للتكبير أو التصغير',
    'drag': 'اسحب وأفلت',
    'activate': 'فعل',
    'dismiss': 'أغلق',
    'expand': 'وسع',
    'collapse': 'اطو',
  };

  // ========== تلميحات الاستخدام ==========
  
  /// تلميحات للعناصر التفاعلية
  static const Map<String, String> usageHints = {
    'button': 'اضغط للتفعيل',
    'link': 'اضغط للانتقال',
    'textField': 'اضغط للكتابة',
    'dropdown': 'اضغط لفتح القائمة',
    'checkbox': 'اضغط للتحديد أو إلغاء التحديد',
    'radio': 'اضغط للاختيار',
    'slider': 'اسحب لتغيير القيمة',
    'switch': 'اضغط للتبديل',
    'tab': 'اضغط للانتقال للتبويب',
    'card': 'اضغط لعرض التفاصيل',
    'image': 'صورة',
    'icon': 'أيقونة',
    'avatar': 'صورة شخصية',
    'badge': 'شارة',
    'chip': 'رقاقة',
  };

  // ========== قيم دلالية للعناصر ==========
  
  /// قيم دلالية للحالات
  static const Map<String, String> semanticValues = {
    'progress': 'التقدم',
    'percentage': 'النسبة المئوية',
    'count': 'العدد',
    'level': 'المستوى',
    'rating': 'التقييم',
    'score': 'النقاط',
    'amount': 'المبلغ',
    'date': 'التاريخ',
    'time': 'الوقت',
    'duration': 'المدة',
    'distance': 'المسافة',
    'size': 'الحجم',
    'weight': 'الوزن',
    'temperature': 'درجة الحرارة',
  };

  // ========== دوال مساعدة ==========
  
  /// التحقق من حجم هدف اللمس
  static bool isValidTouchTarget(double size) {
    return size >= minTouchTargetSize;
  }

  /// التحقق من نسبة التباين
  static bool isValidContrast(double ratio, {bool isLargeText = false}) {
    final minRatio = isLargeText ? minContrastRatioLarge : minContrastRatioNormal;
    return ratio >= minRatio;
  }

  /// التحقق من حجم الخط
  static bool isValidFontSize(double fontSize) {
    return fontSize >= minFontSize;
  }

  /// الحصول على تسمية دلالية آمنة
  static String getSafeSemanticLabel(String key, String fallback) {
    return buttonLabels[key] ?? 
           stateLabels[key] ?? 
           navigationLabels[key] ?? 
           actionLabels[key] ?? 
           usageHints[key] ?? 
           fallback;
  }

  /// الحصول على رسالة تغذية راجعة
  static String getFeedbackMessage(String key, [String? customMessage]) {
    return customMessage ?? feedbackMessages[key] ?? 'تم تنفيذ الإجراء';
  }

  /// تنسيق القيمة الدلالية
  static String formatSemanticValue(String type, dynamic value) {
    final typeLabel = semanticValues[type] ?? type;
    return '$typeLabel: $value';
  }
}
