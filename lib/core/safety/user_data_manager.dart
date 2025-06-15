import '../config/feature_flags.dart';
import 'safety_monitor.dart';

/// مدير البيانات الآمن للمستخدمين
/// يحمي البيانات الحساسة ويوفر طبقة أمان إضافية
class UserDataManager {
  // منع إنشاء كائن من هذا الكلاس
  UserDataManager._();

  // ========== البيانات التجريبية الآمنة ==========

  /// الحصول على بيانات المستخدم الآمنة
  static Map<String, dynamic> getSafeUserData() {
    try {
      // البيانات الأصلية (محمية)
      final originalData = _getOriginalUserData();
      
      // تطبيق طبقة الحماية
      final safeData = _sanitizeUserData(originalData);
      
      SafetyMonitor.logSuccess('User Data Retrieval');
      return safeData;
    } catch (e) {
      SafetyMonitor.logError('User Data Retrieval', e);
      return _getFallbackUserData();
    }
  }

  /// البيانات الأصلية (سيتم استبدالها بـ Firebase لاحقاً)
  static Map<String, dynamic> _getOriginalUserData() {
    // هذه البيانات ستأتي من Firebase لاحقاً
    return {
      'uid': 'user_${DateTime.now().millisecondsSinceEpoch}',
      'name': 'أحمد محمد الحلبي',
      'phone': FeatureFlags.useSecureData ? null : '+963912345678',
      'email': FeatureFlags.useSecureData ? null : 'ahmed.halabi@example.com',
      'avatar': null,
      'location': FeatureFlags.useSecureData ? null : 'حلب، سوريا',
      'joinDate': '15 يناير 2024',
      'bio': 'مهندس مدني، أحب أساعد في إعادة إعمار سوريا الحبيبة 🇸🇾',
      'verified': true,
      'isVerified': true,
      'role': 'user',
    };
  }

  /// تنظيف البيانات الحساسة
  static Map<String, dynamic> _sanitizeUserData(Map<String, dynamic> data) {
    final sanitized = Map<String, dynamic>.from(data);
    
    if (FeatureFlags.useSecureData) {
      // إزالة البيانات الحساسة تدريجياً
      sanitized.remove('phone');
      sanitized.remove('email');
      sanitized.remove('location');
      
      // استبدال بقيم آمنة
      sanitized['phone_verified'] = true;
      sanitized['email_verified'] = true;
      sanitized['location_set'] = true;
      
      SafetyMonitor.logInfo('Data Sanitization', 'تم تنظيف البيانات الحساسة');
    }
    
    return sanitized;
  }

  /// بيانات احتياطية في حالة الخطأ
  static Map<String, dynamic> _getFallbackUserData() {
    return {
      'uid': 'fallback_user',
      'name': 'مستخدم',
      'avatar': null,
      'isVerified': false,
      'role': 'guest',
      'joinDate': DateTime.now().toIso8601String(),
    };
  }

  // ========== إدارة الجلسة ==========

  /// فحص صحة جلسة المستخدم
  static bool isValidSession() {
    try {
      final userData = getSafeUserData();
      
      // فحص البيانات الأساسية
      if (userData['uid'] == null || userData['name'] == null) {
        return false;
      }
      
      // فحص انتهاء الجلسة (مثال: 24 ساعة)
      if (userData['joinDate'] != null) {
        final joinDate = DateTime.parse(userData['joinDate']);
        final sessionAge = DateTime.now().difference(joinDate);
        
        if (sessionAge.inHours > 24) {
          SafetyMonitor.logWarning('Session Check', 'جلسة منتهية الصلاحية');
          return false;
        }
      }
      
      SafetyMonitor.logSuccess('Session Validation');
      return true;
    } catch (e) {
      SafetyMonitor.logError('Session Validation', e);
      return false;
    }
  }

  /// تجديد جلسة المستخدم
  static Map<String, dynamic> refreshSession() {
    try {
      final userData = getSafeUserData();
      userData['lastActivity'] = DateTime.now().toIso8601String();
      
      SafetyMonitor.logSuccess('Session Refresh');
      return userData;
    } catch (e) {
      SafetyMonitor.logError('Session Refresh', e);
      return _getFallbackUserData();
    }
  }

  // ========== إدارة الأذونات ==========

  /// فحص أذونات المستخدم
  static bool hasPermission(String permission) {
    try {
      final userData = getSafeUserData();
      final role = userData['role'] as String?;
      
      switch (permission) {
        case 'create_project':
          return role == 'user' || role == 'admin';
        case 'edit_project':
          return role == 'admin';
        case 'delete_project':
          return role == 'admin';
        case 'view_analytics':
          return role == 'admin';
        default:
          return true; // أذونات عامة
      }
    } catch (e) {
      SafetyMonitor.logError('Permission Check', e);
      return false; // رفض في حالة الخطأ
    }
  }

  /// الحصول على قائمة الأذونات
  static List<String> getUserPermissions() {
    try {
      final userData = getSafeUserData();
      final role = userData['role'] as String?;
      
      switch (role) {
        case 'admin':
          return [
            'create_project',
            'edit_project',
            'delete_project',
            'view_analytics',
            'manage_users',
          ];
        case 'user':
          return [
            'create_project',
            'view_projects',
            'donate',
            'comment',
          ];
        default:
          return [
            'view_projects',
          ];
      }
    } catch (e) {
      SafetyMonitor.logError('Get Permissions', e);
      return ['view_projects']; // أذونات أساسية
    }
  }

  // ========== إدارة الملف الشخصي ==========

  /// تحديث الملف الشخصي بأمان
  static Map<String, dynamic> updateProfile(Map<String, dynamic> updates) {
    try {
      final currentData = getSafeUserData();
      
      // قائمة الحقول المسموح تحديثها
      final allowedFields = ['name', 'avatar'];
      
      for (final field in allowedFields) {
        if (updates.containsKey(field)) {
          currentData[field] = updates[field];
        }
      }
      
      // تحديث وقت آخر تعديل
      currentData['lastUpdated'] = DateTime.now().toIso8601String();
      
      SafetyMonitor.logSuccess('Profile Update');
      return currentData;
    } catch (e) {
      SafetyMonitor.logError('Profile Update', e);
      return getSafeUserData(); // إرجاع البيانات الحالية
    }
  }

  /// التحقق من صحة البيانات
  static bool validateUserData(Map<String, dynamic> data) {
    try {
      // فحص الحقول المطلوبة
      final requiredFields = ['uid', 'name'];
      
      for (final field in requiredFields) {
        if (!data.containsKey(field) || data[field] == null) {
          SafetyMonitor.logWarning('Data Validation', 'حقل مطلوب مفقود: $field');
          return false;
        }
      }
      
      // فحص صحة البريد الإلكتروني
      if (data.containsKey('email') && data['email'] != null) {
        final email = data['email'] as String;
        if (!_isValidEmail(email)) {
          SafetyMonitor.logWarning('Data Validation', 'بريد إلكتروني غير صحيح');
          return false;
        }
      }
      
      SafetyMonitor.logSuccess('Data Validation');
      return true;
    } catch (e) {
      SafetyMonitor.logError('Data Validation', e);
      return false;
    }
  }

  /// فحص صحة البريد الإلكتروني
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // ========== إحصائيات المستخدم ==========

  /// الحصول على إحصائيات المستخدم
  static Map<String, dynamic> getUserStats() {
    try {
      // إحصائيات تجريبية - ستأتي من قاعدة البيانات لاحقاً
      return {
        'projects_created': 3,
        'total_donations': 250.0,
        'projects_supported': 12,
        'impact_score': 85,
        'join_date': getSafeUserData()['joinDate'],
        'last_activity': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      SafetyMonitor.logError('User Stats', e);
      return {
        'projects_created': 0,
        'total_donations': 0.0,
        'projects_supported': 0,
        'impact_score': 0,
      };
    }
  }
}
