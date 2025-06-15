import 'dart:io';
import 'package:flutter/foundation.dart';
import 'safety_monitor.dart';

/// طبقة حماية للمنصات المختلفة
/// تحل مشكلة Platform.isAndroid على الويب وتوفر فحص آمن للمنصات
class PlatformSafe {
  // منع إنشاء كائن من هذا الكلاس
  PlatformSafe._();

  // ========== فحص المنصات الآمن ==========

  /// فحص آمن لنظام Android
  static bool get isAndroid {
    try {
      if (kIsWeb) return false;
      return Platform.isAndroid;
    } catch (e) {
      SafetyMonitor.logError('Platform Check', 'خطأ في فحص Android: $e');
      return false;
    }
  }

  /// فحص آمن لنظام iOS
  static bool get isIOS {
    try {
      if (kIsWeb) return false;
      return Platform.isIOS;
    } catch (e) {
      SafetyMonitor.logError('Platform Check', 'خطأ في فحص iOS: $e');
      return false;
    }
  }

  /// فحص آمن لنظام Windows
  static bool get isWindows {
    try {
      if (kIsWeb) return false;
      return Platform.isWindows;
    } catch (e) {
      SafetyMonitor.logError('Platform Check', 'خطأ في فحص Windows: $e');
      return false;
    }
  }

  /// فحص آمن لنظام macOS
  static bool get isMacOS {
    try {
      if (kIsWeb) return false;
      return Platform.isMacOS;
    } catch (e) {
      SafetyMonitor.logError('Platform Check', 'خطأ في فحص macOS: $e');
      return false;
    }
  }

  /// فحص آمن لنظام Linux
  static bool get isLinux {
    try {
      if (kIsWeb) return false;
      return Platform.isLinux;
    } catch (e) {
      SafetyMonitor.logError('Platform Check', 'خطأ في فحص Linux: $e');
      return false;
    }
  }

  /// فحص الويب
  static bool get isWeb => kIsWeb;

  // ========== فحص أنواع الأجهزة ==========

  /// فحص إذا كان جهاز محمول
  static bool get isMobile {
    return isAndroid || isIOS;
  }

  /// فحص إذا كان جهاز سطح مكتب
  static bool get isDesktop {
    return isWindows || isMacOS || isLinux;
  }

  /// فحص إذا كان يدعم الإشعارات المحلية
  static bool get supportsLocalNotifications {
    return isMobile || isDesktop;
  }

  /// فحص إذا كان يدعم الكاميرا
  static bool get supportsCamera {
    return isMobile;
  }

  /// فحص إذا كان يدعم GPS
  static bool get supportsGPS {
    return isMobile;
  }

  /// فحص إذا كان يدعم الملفات المحلية
  static bool get supportsFileSystem {
    return !isWeb;
  }

  // ========== معلومات النظام ==========

  /// الحصول على اسم النظام
  static String get platformName {
    try {
      if (isWeb) return 'Web';
      if (isAndroid) return 'Android';
      if (isIOS) return 'iOS';
      if (isWindows) return 'Windows';
      if (isMacOS) return 'macOS';
      if (isLinux) return 'Linux';
      return 'Unknown';
    } catch (e) {
      SafetyMonitor.logError('Platform Name', e);
      return 'Unknown';
    }
  }

  /// الحصول على إصدار النظام (آمن)
  static String get operatingSystemVersion {
    try {
      if (isWeb) return 'Web Browser';
      return Platform.operatingSystemVersion;
    } catch (e) {
      SafetyMonitor.logError('OS Version', e);
      return 'Unknown Version';
    }
  }

  /// الحصول على معلومات البيئة
  static Map<String, String> get environment {
    try {
      if (isWeb) return {'platform': 'web'};
      return Platform.environment;
    } catch (e) {
      SafetyMonitor.logError('Environment', e);
      return {'platform': 'unknown'};
    }
  }

  // ========== دوال مساعدة للميزات ==========

  /// تنفيذ كود خاص بـ Android بأمان
  static T? runOnAndroid<T>(T Function() androidCode, [T? fallback]) {
    try {
      if (isAndroid) {
        return androidCode();
      }
      return fallback;
    } catch (e) {
      SafetyMonitor.logError('Android Code', e);
      return fallback;
    }
  }

  /// تنفيذ كود خاص بـ iOS بأمان
  static T? runOnIOS<T>(T Function() iosCode, [T? fallback]) {
    try {
      if (isIOS) {
        return iosCode();
      }
      return fallback;
    } catch (e) {
      SafetyMonitor.logError('iOS Code', e);
      return fallback;
    }
  }

  /// تنفيذ كود خاص بالويب بأمان
  static T? runOnWeb<T>(T Function() webCode, [T? fallback]) {
    try {
      if (isWeb) {
        return webCode();
      }
      return fallback;
    } catch (e) {
      SafetyMonitor.logError('Web Code', e);
      return fallback;
    }
  }

  /// تنفيذ كود خاص بسطح المكتب بأمان
  static T? runOnDesktop<T>(T Function() desktopCode, [T? fallback]) {
    try {
      if (isDesktop) {
        return desktopCode();
      }
      return fallback;
    } catch (e) {
      SafetyMonitor.logError('Desktop Code', e);
      return fallback;
    }
  }

  /// تنفيذ كود خاص بالأجهزة المحمولة بأمان
  static T? runOnMobile<T>(T Function() mobileCode, [T? fallback]) {
    try {
      if (isMobile) {
        return mobileCode();
      }
      return fallback;
    } catch (e) {
      SafetyMonitor.logError('Mobile Code', e);
      return fallback;
    }
  }

  // ========== تشخيص المنصة ==========

  /// طباعة معلومات المنصة للتشخيص
  static void printPlatformInfo() {
    SafetyMonitor.logInfo('Platform Info', 'بدء تشخيص المنصة');
    
    debugPrint('🖥️ Platform Information:');
    debugPrint('📱 Platform: $platformName');
    debugPrint('🌐 Is Web: $isWeb');
    debugPrint('📱 Is Mobile: $isMobile');
    debugPrint('🖥️ Is Desktop: $isDesktop');
    debugPrint('🔔 Supports Notifications: $supportsLocalNotifications');
    debugPrint('📷 Supports Camera: $supportsCamera');
    debugPrint('📍 Supports GPS: $supportsGPS');
    debugPrint('📁 Supports File System: $supportsFileSystem');
    debugPrint('🔢 OS Version: $operatingSystemVersion');
    
    SafetyMonitor.logSuccess('Platform Info');
  }

  /// فحص توافق الميزات
  static Map<String, bool> getFeatureCompatibility() {
    return {
      'local_notifications': supportsLocalNotifications,
      'camera': supportsCamera,
      'gps': supportsGPS,
      'file_system': supportsFileSystem,
      'platform_channels': !isWeb,
      'background_tasks': isMobile,
      'system_ui': isMobile,
      'app_lifecycle': !isWeb,
    };
  }
}
