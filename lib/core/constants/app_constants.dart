/// الثوابت العامة لتطبيق نِواة
class AppConstants {
  // منع إنشاء كائن من هذا الكلاس
  AppConstants._();

  // ========== معلومات التطبيق ==========
  
  static const String appName = 'نِواة';
  static const String appNameEnglish = 'Nawa';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'منصة إعادة الإعمار المجتمعي السوري';

  // ========== المسافات والأبعاد ==========
  
  /// نظام المسافات المبني على 8px
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  /// حواف الكروت والعناصر
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  /// سماكة الحدود
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  /// ارتفاع العناصر
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;

  // ========== الرسوم المتحركة ==========
  
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationXSlow = Duration(milliseconds: 800);

  // ========== الشبكة والاتصال ==========
  
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 24);
  static const int maxRetries = 3;
  static const int itemsPerPage = 20;

  // ========== التخزين المحلي ==========
  
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';
  static const String onboardingKey = 'onboarding_completed';

  // ========== Firebase Collections ==========
  
  static const String usersCollection = 'users';
  static const String projectsCollection = 'projects';
  static const String donationsCollection = 'donations';
  static const String commentsCollection = 'comments';
  static const String notificationsCollection = 'notifications';

  // ========== أنواع المشاريع ==========
  
  static const List<String> projectCategories = [
    'education',      // تعليم
    'health',         // صحة
    'infrastructure', // بنية تحتية
    'environment',    // بيئة
    'social',         // اجتماعي
    'economic',       // اقتصادي
    'cultural',       // ثقافي
    'emergency',      // طوارئ
  ];

  // ========== حالات المشاريع ==========
  
  static const String projectStatusPending = 'pending';
  static const String projectStatusActive = 'active';
  static const String projectStatusCompleted = 'completed';
  static const String projectStatusCancelled = 'cancelled';
  static const String projectStatusSuspended = 'suspended';

  // ========== أولويات المشاريع ==========
  
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';
  static const String priorityUrgent = 'urgent';

  // ========== طرق الدفع ==========
  
  static const List<String> paymentMethods = [
    'credit_card',
    'debit_card',
    'paypal',
    'bank_transfer',
    'mobile_wallet',
  ];

  // ========== العملات ==========
  
  static const String defaultCurrency = 'USD';
  static const String localCurrency = 'SYP';
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'SYP',
    'TRY',
    'SAR',
  ];

  // ========== اللغات المدعومة ==========
  
  static const String defaultLanguage = 'ar';
  static const List<String> supportedLanguages = [
    'ar', // العربية
    'en', // الإنجليزية
    'de', // الألمانية
    'fr', // الفرنسية
  ];

  // ========== أنواع المستخدمين ==========
  
  static const String userTypeLocal = 'local';        // داخل سوريا
  static const String userTypeDiaspora = 'diaspora';  // مغترب
  static const String userTypeOrg = 'organization';   // منظمة
  static const String userTypeAdmin = 'admin';        // مدير

  // ========== أنواع الإشعارات ==========
  
  static const String notificationTypeProjectUpdate = 'project_update';
  static const String notificationTypeDonationReceived = 'donation_received';
  static const String notificationTypeProjectCompleted = 'project_completed';
  static const String notificationTypeNewComment = 'new_comment';
  static const String notificationTypeSystemMessage = 'system_message';

  // ========== حدود التطبيق ==========
  
  static const int maxProjectTitleLength = 100;
  static const int maxProjectDescriptionLength = 1000;
  static const int maxCommentLength = 500;
  static const int maxImageSizeMB = 5;
  static const int maxImagesPerProject = 10;

  // ========== المبالغ الافتراضية للتبرع ==========
  
  static const List<double> defaultDonationAmounts = [
    10.0,
    25.0,
    50.0,
    100.0,
    250.0,
    500.0,
  ];

  // ========== الروابط المهمة ==========
  
  static const String websiteUrl = 'https://nawa.syria.org';
  static const String supportEmail = 'support@nawa.syria.org';
  static const String privacyPolicyUrl = 'https://nawa.syria.org/privacy';
  static const String termsOfServiceUrl = 'https://nawa.syria.org/terms';
  static const String facebookUrl = 'https://facebook.com/NawaSyria';
  static const String twitterUrl = 'https://twitter.com/NawaSyria';
  static const String instagramUrl = 'https://instagram.com/NawaSyria';

  // ========== رسائل النظام ==========
  
  static const String noInternetMessage = 'تأكد من اتصالك بالإنترنت';
  static const String serverErrorMessage = 'حدث خطأ في الخادم، حاول مرة أخرى';
  static const String unknownErrorMessage = 'حدث خطأ غير متوقع';
  static const String loadingMessage = 'جاري التحميل...';
  static const String noDataMessage = 'لا توجد بيانات للعرض';

  // ========== تعبيرات منتظمة للتحقق ==========
  
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const String urlRegex = r'^https?:\/\/[^\s/$.?#].[^\s]*$';

  // ========== إعدادات الخريطة ==========
  
  static const double defaultLatitude = 36.2021;  // حلب
  static const double defaultLongitude = 37.1343; // حلب
  static const double defaultZoom = 10.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 5.0;
}
