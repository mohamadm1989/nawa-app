import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// مدير التخزين المحلي لدعم العمل بدون إنترنت
class LocalStorageManager {
  static LocalStorageManager? _instance;
  static SharedPreferences? _prefs;

  LocalStorageManager._();

  static LocalStorageManager get instance {
    _instance ??= LocalStorageManager._();
    return _instance!;
  }

  /// تهيئة التخزين المحلي
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== مفاتيح التخزين ==========
  static const String _keyUserData = 'user_data';
  static const String _keyProjects = 'cached_projects';
  static const String _keyNotifications = 'cached_notifications';
  static const String _keySettings = 'app_settings';
  static const String _keyOfflineActions = 'offline_actions';
  static const String _keyLastSync = 'last_sync_time';
  static const String _keyIsFirstLaunch = 'is_first_launch';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'app_language';
  static const String _keyFavorites = 'favorite_projects';

  // ========== بيانات المستخدم ==========

  /// حفظ بيانات المستخدم
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      return await _prefs!.setString(_keyUserData, jsonString);
    } catch (e) {
      print('خطأ في حفظ بيانات المستخدم: $e');
      return false;
    }
  }

  /// استرجاع بيانات المستخدم
  Map<String, dynamic>? getUserData() {
    try {
      final jsonString = _prefs!.getString(_keyUserData);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('خطأ في استرجاع بيانات المستخدم: $e');
      return null;
    }
  }

  /// حذف بيانات المستخدم
  Future<bool> clearUserData() async {
    return await _prefs!.remove(_keyUserData);
  }

  // ========== المشاريع المحفوظة ==========

  /// حفظ المشاريع محلياً
  Future<bool> saveProjects(List<Map<String, dynamic>> projects) async {
    try {
      final jsonString = jsonEncode(projects);
      return await _prefs!.setString(_keyProjects, jsonString);
    } catch (e) {
      print('خطأ في حفظ المشاريع: $e');
      return false;
    }
  }

  /// استرجاع المشاريع المحفوظة
  List<Map<String, dynamic>> getCachedProjects() {
    try {
      final jsonString = _prefs!.getString(_keyProjects);
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('خطأ في استرجاع المشاريع: $e');
      return [];
    }
  }

  // ========== الإشعارات المحفوظة ==========

  /// حفظ الإشعارات محلياً
  Future<bool> saveNotifications(List<Map<String, dynamic>> notifications) async {
    try {
      final jsonString = jsonEncode(notifications);
      return await _prefs!.setString(_keyNotifications, jsonString);
    } catch (e) {
      print('خطأ في حفظ الإشعارات: $e');
      return false;
    }
  }

  /// استرجاع الإشعارات المحفوظة
  List<Map<String, dynamic>> getCachedNotifications() {
    try {
      final jsonString = _prefs!.getString(_keyNotifications);
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('خطأ في استرجاع الإشعارات: $e');
      return [];
    }
  }

  // ========== المشاريع المفضلة ==========

  /// إضافة مشروع للمفضلة
  Future<bool> addToFavorites(String projectId) async {
    try {
      if (_prefs == null) return false;
      final favorites = getFavoriteProjects();
      if (!favorites.contains(projectId)) {
        favorites.add(projectId);
        final jsonString = jsonEncode(favorites);
        return await _prefs!.setString(_keyFavorites, jsonString);
      }
      return true; // المشروع موجود بالفعل
    } catch (e) {
      print('خطأ في إضافة المشروع للمفضلة: $e');
      return false;
    }
  }

  /// إزالة مشروع من المفضلة
  Future<bool> removeFromFavorites(String projectId) async {
    try {
      if (_prefs == null) return false;
      final favorites = getFavoriteProjects();
      favorites.remove(projectId);
      final jsonString = jsonEncode(favorites);
      return await _prefs!.setString(_keyFavorites, jsonString);
    } catch (e) {
      print('خطأ في إزالة المشروع من المفضلة: $e');
      return false;
    }
  }

  /// استرجاع قائمة المشاريع المفضلة
  List<String> getFavoriteProjects() {
    try {
      if (_prefs == null) return [];
      final jsonString = _prefs!.getString(_keyFavorites);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      print('خطأ في استرجاع المشاريع المفضلة: $e');
      return [];
    }
  }

  /// التحقق من وجود مشروع في المفضلة
  bool isFavorite(String projectId) {
    if (_prefs == null) return false;
    final favorites = getFavoriteProjects();
    return favorites.contains(projectId);
  }

  /// تبديل حالة المفضلة للمشروع
  Future<bool> toggleFavorite(String projectId) async {
    if (isFavorite(projectId)) {
      return await removeFromFavorites(projectId);
    } else {
      return await addToFavorites(projectId);
    }
  }

  /// مسح جميع المفضلة
  Future<bool> clearFavorites() async {
    return await _prefs!.remove(_keyFavorites);
  }

  // ========== الإعدادات ==========

  /// حفظ إعدادات التطبيق
  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final jsonString = jsonEncode(settings);
      return await _prefs!.setString(_keySettings, jsonString);
    } catch (e) {
      print('خطأ في حفظ الإعدادات: $e');
      return false;
    }
  }

  /// استرجاع إعدادات التطبيق
  Map<String, dynamic> getSettings() {
    try {
      final jsonString = _prefs!.getString(_keySettings);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return _getDefaultSettings();
    } catch (e) {
      print('خطأ في استرجاع الإعدادات: $e');
      return _getDefaultSettings();
    }
  }

  Map<String, dynamic> _getDefaultSettings() {
    return {
      'notifications_enabled': true,
      'email_notifications': true,
      'push_notifications': true,
      'sms_notifications': false,
      'theme_mode': 'light',
      'language': 'ar',
      'auto_sync': true,
    };
  }

  // ========== الإجراءات المؤجلة (Offline Actions) ==========

  /// إضافة إجراء مؤجل
  Future<bool> addOfflineAction(Map<String, dynamic> action) async {
    try {
      final actions = getOfflineActions();
      action['timestamp'] = DateTime.now().toIso8601String();
      action['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      actions.add(action);
      
      final jsonString = jsonEncode(actions);
      return await _prefs!.setString(_keyOfflineActions, jsonString);
    } catch (e) {
      print('خطأ في إضافة إجراء مؤجل: $e');
      return false;
    }
  }

  /// استرجاع الإجراءات المؤجلة
  List<Map<String, dynamic>> getOfflineActions() {
    try {
      final jsonString = _prefs!.getString(_keyOfflineActions);
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('خطأ في استرجاع الإجراءات المؤجلة: $e');
      return [];
    }
  }

  /// حذف إجراء مؤجل
  Future<bool> removeOfflineAction(String actionId) async {
    try {
      final actions = getOfflineActions();
      actions.removeWhere((action) => action['id'] == actionId);
      
      final jsonString = jsonEncode(actions);
      return await _prefs!.setString(_keyOfflineActions, jsonString);
    } catch (e) {
      print('خطأ في حذف إجراء مؤجل: $e');
      return false;
    }
  }

  /// مسح جميع الإجراءات المؤجلة
  Future<bool> clearOfflineActions() async {
    return await _prefs!.remove(_keyOfflineActions);
  }

  // ========== إدارة المزامنة ==========

  /// حفظ وقت آخر مزامنة
  Future<bool> setLastSyncTime(DateTime time) async {
    return await _prefs!.setString(_keyLastSync, time.toIso8601String());
  }

  /// استرجاع وقت آخر مزامنة
  DateTime? getLastSyncTime() {
    try {
      final timeString = _prefs!.getString(_keyLastSync);
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
      return null;
    } catch (e) {
      print('خطأ في استرجاع وقت المزامنة: $e');
      return null;
    }
  }

  // ========== إعدادات عامة ==========

  /// التحقق من أول تشغيل
  bool isFirstLaunch() {
    return _prefs!.getBool(_keyIsFirstLaunch) ?? true;
  }

  /// تعيين أن التطبيق تم تشغيله من قبل
  Future<bool> setNotFirstLaunch() async {
    return await _prefs!.setBool(_keyIsFirstLaunch, false);
  }

  /// حفظ وضع المظهر
  Future<bool> setThemeMode(String mode) async {
    return await _prefs!.setString(_keyThemeMode, mode);
  }

  /// استرجاع وضع المظهر
  String getThemeMode() {
    return _prefs!.getString(_keyThemeMode) ?? 'light';
  }

  /// حفظ اللغة
  Future<bool> setLanguage(String language) async {
    return await _prefs!.setString(_keyLanguage, language);
  }

  /// استرجاع اللغة
  String getLanguage() {
    return _prefs!.getString(_keyLanguage) ?? 'ar';
  }

  // ========== دوال إضافية للإشعارات المتقدمة ==========

  /// حفظ نص
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs!.setString(key, value);
    } catch (e) {
      print('خطأ في حفظ النص: $e');
      return false;
    }
  }

  /// استرجاع نص
  Future<String?> getString(String key) async {
    try {
      return _prefs!.getString(key);
    } catch (e) {
      print('خطأ في استرجاع النص: $e');
      return null;
    }
  }

  /// حفظ رقم صحيح
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs!.setInt(key, value);
    } catch (e) {
      print('خطأ في حفظ الرقم: $e');
      return false;
    }
  }

  /// استرجاع رقم صحيح
  Future<int?> getInt(String key) async {
    try {
      return _prefs!.getInt(key);
    } catch (e) {
      print('خطأ في استرجاع الرقم: $e');
      return null;
    }
  }

  /// حفظ قيمة منطقية
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs!.setBool(key, value);
    } catch (e) {
      print('خطأ في حفظ القيمة المنطقية: $e');
      return false;
    }
  }

  /// استرجاع قيمة منطقية
  Future<bool?> getBool(String key) async {
    try {
      return _prefs!.getBool(key);
    } catch (e) {
      print('خطأ في استرجاع القيمة المنطقية: $e');
      return null;
    }
  }

  /// حذف مفتاح
  Future<bool> remove(String key) async {
    try {
      return await _prefs!.remove(key);
    } catch (e) {
      print('خطأ في حذف المفتاح: $e');
      return false;
    }
  }

  /// التحقق من وجود مفتاح
  bool containsKey(String key) {
    try {
      return _prefs!.containsKey(key);
    } catch (e) {
      print('خطأ في التحقق من المفتاح: $e');
      return false;
    }
  }

  // ========== إدارة التخزين ==========

  /// مسح جميع البيانات المحفوظة
  Future<bool> clearAllData() async {
    try {
      await _prefs!.clear();
      return true;
    } catch (e) {
      print('خطأ في مسح البيانات: $e');
      return false;
    }
  }

  /// حساب حجم البيانات المحفوظة
  int getStorageSize() {
    try {
      int totalSize = 0;
      final keys = _prefs!.getKeys();
      
      for (String key in keys) {
        final value = _prefs!.get(key);
        if (value is String) {
          totalSize += value.length;
        }
      }
      
      return totalSize;
    } catch (e) {
      print('خطأ في حساب حجم التخزين: $e');
      return 0;
    }
  }

  /// تصدير البيانات
  Map<String, dynamic> exportData() {
    try {
      final Map<String, dynamic> exportedData = {};
      final keys = _prefs!.getKeys();
      
      for (String key in keys) {
        exportedData[key] = _prefs!.get(key);
      }
      
      return exportedData;
    } catch (e) {
      print('خطأ في تصدير البيانات: $e');
      return {};
    }
  }
}
