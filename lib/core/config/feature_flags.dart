/// نظام مفاتيح الميزات للتحكم الآمن في التحديثات
/// يسمح بتفعيل/إيقاف الميزات الجديدة بدون كسر الكود الموجود
class FeatureFlags {
  // منع إنشاء كائن من هذا الكلاس
  FeatureFlags._();

  // ========== إدارة الحالة ==========
  
  /// استخدام BLoC بدلاً من setState
  static const bool useNewStateManagement = true; // تفعيل BLoC تدريجياً
  
  /// استخدام Provider للبيانات المشتركة
  static const bool useProviderPattern = false;

  // ========== Firebase والخدمات السحابية ==========
  
  /// تفعيل Firebase Core
  static const bool useFirebase = false;
  
  /// تفعيل Firebase Authentication
  static const bool useFirebaseAuth = false;
  
  /// تفعيل Firestore Database
  static const bool useFirestore = false;
  
  /// تفعيل Firebase Storage
  static const bool useFirebaseStorage = false;
  
  /// تفعيل Firebase Messaging
  static const bool useFirebaseMessaging = false;

  // ========== الأمان والحماية ==========
  
  /// استخدام البيانات الآمنة (إزالة البيانات الحساسة)
  static const bool useSecureData = true; // تفعيل الأمان
  
  /// تفعيل تشفير البيانات المحلية
  static const bool useEncryptedStorage = false;
  
  /// تفعيل التحقق من صحة المدخلات
  static const bool useInputValidation = false;

  // ========== معالجة الأخطاء ==========
  
  /// نظام معالجة الأخطاء الجديد
  static const bool useNewErrorHandling = true; // تفعيل معالجة الأخطاء
  
  /// تفعيل مراقبة الأداء
  static const bool usePerformanceMonitoring = true; // تفعيل مراقبة الأداء
  
  /// تفعيل تقارير الأخطاء
  static const bool useCrashReporting = false;

  // ========== تحسينات الأداء ==========
  
  /// استخدام Pagination للبيانات
  static const bool usePagination = true; // تفعيل التحميل التدريجي
  
  /// تفعيل الذاكرة التخزينية المحسنة
  static const bool useAdvancedCaching = false;
  
  /// تحسين تحميل الصور
  static const bool useOptimizedImageLoading = false;

  // ========== تجربة المستخدم ==========
  
  /// دعم الوضع المظلم
  static const bool useDarkMode = false;
  
  /// دعم اللغات المتعددة
  static const bool useMultiLanguage = false;
  
  /// تحسين إمكانية الوصول
  static const bool useAccessibilityFeatures = false;

  // ========== الميزات التجريبية ==========
  
  /// ميزات تجريبية للاختبار
  static const bool useExperimentalFeatures = false;
  
  /// واجهة المطور للاختبار
  static const bool useDeveloperMode = false;
  
  /// تفعيل الإحصائيات المفصلة
  static const bool useDetailedAnalytics = false;

  // ========== الشبكة والاتصال ==========
  
  /// تفعيل الوضع غير المتصل المحسن
  static const bool useAdvancedOfflineMode = false;
  
  /// إعادة المحاولة التلقائية للطلبات
  static const bool useAutoRetry = false;
  
  /// ضغط البيانات
  static const bool useDataCompression = false;

  // ========== دوال مساعدة ==========
  
  /// التحقق من تفعيل أي ميزة جديدة
  static bool get hasAnyNewFeatureEnabled {
    return useNewStateManagement ||
           useFirebase ||
           useSecureData ||
           useNewErrorHandling ||
           usePagination ||
           useDarkMode ||
           useAdvancedOfflineMode;
  }
  
  /// التحقق من تفعيل الميزات الحرجة
  static bool get hasCriticalFeaturesEnabled {
    return useFirebase ||
           useNewStateManagement ||
           useSecureData;
  }
  
  /// الحصول على قائمة الميزات المفعلة
  static List<String> get enabledFeatures {
    final List<String> enabled = [];
    
    if (useNewStateManagement) enabled.add('State Management');
    if (useFirebase) enabled.add('Firebase');
    if (useSecureData) enabled.add('Secure Data');
    if (useNewErrorHandling) enabled.add('Error Handling');
    if (usePagination) enabled.add('Pagination');
    if (useDarkMode) enabled.add('Dark Mode');
    if (useAdvancedOfflineMode) enabled.add('Offline Mode');
    
    return enabled;
  }
  
  /// طباعة حالة الميزات (للتطوير)
  static void printStatus() {
    print('🏁 Feature Flags Status:');
    print('📊 State Management: $useNewStateManagement');
    print('🔥 Firebase: $useFirebase');
    print('🔒 Secure Data: $useSecureData');
    print('⚠️ Error Handling: $useNewErrorHandling');
    print('📄 Pagination: $usePagination');
    print('🌙 Dark Mode: $useDarkMode');
    print('📱 Offline Mode: $useAdvancedOfflineMode');
    print('✨ Total Enabled: ${enabledFeatures.length}');
  }
}
