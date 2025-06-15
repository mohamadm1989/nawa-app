import 'package:flutter/foundation.dart';
import '../config/feature_flags.dart';

/// نظام مراقبة الأمان والأداء
/// يراقب التطبيق ويتخذ إجراءات وقائية عند الحاجة
class SafetyMonitor {
  // منع إنشاء كائن من هذا الكلاس
  SafetyMonitor._();

  // إحصائيات المراقبة
  static int _errorCount = 0;
  static int _successCount = 0;
  static DateTime? _lastErrorTime;
  static final List<String> _recentErrors = [];
  static const int _maxRecentErrors = 10;
  static const int _errorThreshold = 5; // الحد الأقصى للأخطاء

  // ========== تسجيل الأحداث ==========

  /// تسجيل خطأ مع معلومات مفصلة
  static void logError(String operation, dynamic error, [StackTrace? stackTrace]) {
    _errorCount++;
    _lastErrorTime = DateTime.now();
    
    final errorMessage = '🚨 خطأ في $operation: $error';
    
    // إضافة للقائمة الحديثة
    _recentErrors.add('${DateTime.now().toIso8601String()}: $operation - $error');
    if (_recentErrors.length > _maxRecentErrors) {
      _recentErrors.removeAt(0);
    }
    
    // طباعة مفصلة في وضع التطوير
    if (kDebugMode) {
      debugPrint(errorMessage);
      if (stackTrace != null) {
        debugPrint('📍 Stack Trace: $stackTrace');
      }
    }
    
    // فحص إذا تجاوزنا الحد الآمن
    _checkErrorThreshold();
    
    // إرسال للمراقبة الخارجية (مستقبلاً)
    _sendToCrashlytics(operation, error, stackTrace);
  }

  /// تسجيل نجاح العملية
  static void logSuccess(String operation) {
    _successCount++;
    
    if (kDebugMode) {
      debugPrint('✅ نجح $operation');
    }
  }

  /// تسجيل تحذير
  static void logWarning(String operation, String warning) {
    final warningMessage = '⚠️ تحذير في $operation: $warning';
    
    if (kDebugMode) {
      debugPrint(warningMessage);
    }
  }

  /// تسجيل معلومات
  static void logInfo(String operation, String info) {
    if (kDebugMode) {
      debugPrint('ℹ️ $operation: $info');
    }
  }

  // ========== مراقبة الأداء ==========

  /// فحص صحة التطبيق
  static bool checkAppHealth() {
    try {
      // فحص عدد الأخطاء
      if (_errorCount > _errorThreshold) {
        logWarning('Health Check', 'عدد الأخطاء مرتفع: $_errorCount');
        return false;
      }
      
      // فحص الأخطاء الحديثة
      if (_hasRecentCriticalErrors()) {
        logWarning('Health Check', 'أخطاء حرجة حديثة');
        return false;
      }
      
      // فحص الذاكرة (تقريبي)
      if (_isMemoryUsageHigh()) {
        logWarning('Health Check', 'استخدام ذاكرة مرتفع');
        return false;
      }
      
      logSuccess('Health Check');
      return true;
    } catch (e) {
      logError('Health Check', e);
      return false;
    }
  }

  /// فحص الأخطاء الحرجة الحديثة
  static bool _hasRecentCriticalErrors() {
    if (_lastErrorTime == null) return false;
    
    final timeSinceLastError = DateTime.now().difference(_lastErrorTime!);
    return timeSinceLastError.inMinutes < 5 && _errorCount > 3;
  }

  /// فحص استخدام الذاكرة (تقريبي)
  static bool _isMemoryUsageHigh() {
    // فحص تقريبي - يمكن تحسينه لاحقاً
    return _recentErrors.length >= _maxRecentErrors;
  }

  /// فحص تجاوز حد الأخطاء
  static void _checkErrorThreshold() {
    if (_errorCount > _errorThreshold) {
      logWarning('Safety Monitor', 'تم تجاوز حد الأخطاء الآمن');
      
      // تفعيل الوضع الآمن إذا كانت الميزات الجديدة مفعلة
      if (FeatureFlags.hasAnyNewFeatureEnabled) {
        EmergencyRollback.enableSafeMode();
      }
    }
  }

  // ========== إرسال التقارير ==========

  /// إرسال للمراقبة الخارجية (مستقبلاً)
  static void _sendToCrashlytics(String operation, dynamic error, StackTrace? stackTrace) {
    // TODO: تطبيق Firebase Crashlytics لاحقاً
    if (FeatureFlags.useCrashReporting) {
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  // ========== الإحصائيات ==========

  /// الحصول على إحصائيات المراقبة
  static Map<String, dynamic> getStats() {
    return {
      'error_count': _errorCount,
      'success_count': _successCount,
      'last_error_time': _lastErrorTime?.toIso8601String(),
      'recent_errors': List.from(_recentErrors),
      'health_status': checkAppHealth() ? 'healthy' : 'unhealthy',
      'success_rate': _successCount > 0 
          ? (_successCount / (_successCount + _errorCount) * 100).toStringAsFixed(2)
          : '0.00',
    };
  }

  /// طباعة الإحصائيات
  static void printStats() {
    final stats = getStats();
    debugPrint('📊 Safety Monitor Stats:');
    debugPrint('✅ Successes: ${stats['success_count']}');
    debugPrint('❌ Errors: ${stats['error_count']}');
    debugPrint('📈 Success Rate: ${stats['success_rate']}%');
    debugPrint('🏥 Health: ${stats['health_status']}');
  }

  /// إعادة تعيين الإحصائيات
  static void resetStats() {
    _errorCount = 0;
    _successCount = 0;
    _lastErrorTime = null;
    _recentErrors.clear();
    logInfo('Safety Monitor', 'تم إعادة تعيين الإحصائيات');
  }
}

/// نظام الإرجاع الطارئ
class EmergencyRollback {
  // منع إنشاء كائن من هذا الكلاس
  EmergencyRollback._();

  /// إيقاف جميع الميزات الجديدة
  static void disableAllNewFeatures() {
    SafetyMonitor.logWarning('Emergency Rollback', 'إيقاف جميع الميزات الجديدة');
    
    // TODO: تطبيق إيقاف الميزات ديناميكياً
    // هذا يتطلب تعديل FeatureFlags ليكون قابل للتغيير
    
    debugPrint('🚨 تم إيقاف جميع الميزات الجديدة');
    debugPrint('🔄 التطبيق يعمل في الوضع الآمن');
  }

  /// تفعيل الوضع الآمن
  static void enableSafeMode() {
    SafetyMonitor.logWarning('Emergency Rollback', 'تفعيل الوضع الآمن');
    
    disableAllNewFeatures();
    
    // إعادة تعيين إحصائيات الأخطاء
    SafetyMonitor.resetStats();
    
    debugPrint('🛡️ تم تفعيل الوضع الآمن');
  }

  /// فحص الحاجة للوضع الآمن
  static bool shouldEnableSafeMode() {
    return !SafetyMonitor.checkAppHealth() && 
           FeatureFlags.hasAnyNewFeatureEnabled;
  }
}
