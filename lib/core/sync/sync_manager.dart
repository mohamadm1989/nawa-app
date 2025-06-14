import 'dart:async';
import 'package:flutter/foundation.dart';
import '../storage/local_storage_manager.dart';
import '../network/connectivity_manager.dart';

/// مدير المزامنة للبيانات بين المحلي والسحابي
class SyncManager {
  static SyncManager? _instance;
  
  final LocalStorageManager _storage = LocalStorageManager.instance;
  final ConnectivityManager _connectivity = ConnectivityManager.instance;
  
  // Stream controllers
  final StreamController<SyncStatus> _syncStatusController = StreamController<SyncStatus>.broadcast();
  final StreamController<double> _syncProgressController = StreamController<double>.broadcast();
  
  // Current status
  SyncStatus _currentStatus = SyncStatus.idle;
  bool _autoSyncEnabled = true;
  Timer? _autoSyncTimer;

  SyncManager._();

  static SyncManager get instance {
    _instance ??= SyncManager._();
    return _instance!;
  }

  // ========== Getters ==========
  
  SyncStatus get currentStatus => _currentStatus;
  bool get autoSyncEnabled => _autoSyncEnabled;
  Stream<SyncStatus> get statusStream => _syncStatusController.stream;
  Stream<double> get progressStream => _syncProgressController.stream;

  // ========== تهيئة المدير ==========

  /// تهيئة مدير المزامنة
  Future<void> initialize() async {
    // تحميل إعدادات المزامنة
    await _loadSyncSettings();
    
    // مراقبة حالة الاتصال
    _connectivity.connectionStream.listen(_onConnectionChanged);
    
    // بدء المزامنة التلقائية إذا كانت مفعلة
    if (_autoSyncEnabled) {
      _startAutoSync();
    }
    
    debugPrint('🔄 تم تهيئة مدير المزامنة');
  }

  /// تحميل إعدادات المزامنة
  Future<void> _loadSyncSettings() async {
    final settings = _storage.getSettings();
    _autoSyncEnabled = settings['auto_sync'] ?? true;
  }

  // ========== المزامنة الرئيسية ==========

  /// بدء المزامنة الكاملة
  Future<SyncResult> startFullSync() async {
    if (_currentStatus == SyncStatus.syncing) {
      return SyncResult(
        success: false,
        message: 'المزامنة جارية بالفعل',
        syncedItems: 0,
        failedItems: 0,
      );
    }

    if (!_connectivity.isConnected) {
      return SyncResult(
        success: false,
        message: 'لا يوجد اتصال بالإنترنت',
        syncedItems: 0,
        failedItems: 0,
      );
    }

    _updateStatus(SyncStatus.syncing);
    _updateProgress(0.0);

    try {
      debugPrint('🔄 بدء المزامنة الكاملة...');
      
      int totalItems = 0;
      int syncedItems = 0;
      int failedItems = 0;

      // 1. مزامنة الإجراءات المؤجلة
      _updateProgress(0.1);
      final offlineResult = await _syncOfflineActions();
      totalItems += offlineResult.totalItems;
      syncedItems += offlineResult.syncedItems;
      failedItems += offlineResult.failedItems;

      // 2. مزامنة المشاريع
      _updateProgress(0.3);
      final projectsResult = await _syncProjects();
      totalItems += projectsResult.totalItems;
      syncedItems += projectsResult.syncedItems;
      failedItems += projectsResult.failedItems;

      // 3. مزامنة الإشعارات
      _updateProgress(0.6);
      final notificationsResult = await _syncNotifications();
      totalItems += notificationsResult.totalItems;
      syncedItems += notificationsResult.syncedItems;
      failedItems += notificationsResult.failedItems;

      // 4. مزامنة بيانات المستخدم
      _updateProgress(0.8);
      final userResult = await _syncUserData();
      totalItems += userResult.totalItems;
      syncedItems += userResult.syncedItems;
      failedItems += userResult.failedItems;

      // 5. حفظ وقت المزامنة
      _updateProgress(0.9);
      await _storage.setLastSyncTime(DateTime.now());

      _updateProgress(1.0);
      _updateStatus(SyncStatus.completed);

      final result = SyncResult(
        success: failedItems == 0,
        message: failedItems == 0 
            ? 'تمت المزامنة بنجاح'
            : 'تمت المزامنة مع بعض الأخطاء',
        syncedItems: syncedItems,
        failedItems: failedItems,
        totalItems: totalItems,
      );

      debugPrint('✅ انتهت المزامنة: ${result.message}');
      return result;

    } catch (e) {
      debugPrint('❌ خطأ في المزامنة: $e');
      _updateStatus(SyncStatus.failed);
      
      return SyncResult(
        success: false,
        message: 'فشلت المزامنة: $e',
        syncedItems: 0,
        failedItems: 0,
      );
    }
  }

  // ========== مزامنة الأقسام المختلفة ==========

  /// مزامنة الإجراءات المؤجلة
  Future<SyncResult> _syncOfflineActions() async {
    try {
      final actions = _storage.getOfflineActions();
      int syncedCount = 0;
      int failedCount = 0;

      for (final action in actions) {
        try {
          // محاكاة إرسال الإجراء للخادم
          await _sendActionToServer(action);
          await _storage.removeOfflineAction(action['id']);
          syncedCount++;
        } catch (e) {
          debugPrint('فشل في مزامنة الإجراء ${action['id']}: $e');
          failedCount++;
        }
      }

      return SyncResult(
        success: failedCount == 0,
        message: 'مزامنة الإجراءات المؤجلة',
        syncedItems: syncedCount,
        failedItems: failedCount,
        totalItems: actions.length,
      );
    } catch (e) {
      debugPrint('خطأ في مزامنة الإجراءات المؤجلة: $e');
      return SyncResult(
        success: false,
        message: 'فشل في مزامنة الإجراءات المؤجلة',
        syncedItems: 0,
        failedItems: 0,
      );
    }
  }

  /// مزامنة المشاريع
  Future<SyncResult> _syncProjects() async {
    try {
      // محاكاة جلب المشاريع من الخادم
      final serverProjects = await _fetchProjectsFromServer();
      await _storage.saveProjects(serverProjects);

      return SyncResult(
        success: true,
        message: 'مزامنة المشاريع',
        syncedItems: serverProjects.length,
        failedItems: 0,
        totalItems: serverProjects.length,
      );
    } catch (e) {
      debugPrint('خطأ في مزامنة المشاريع: $e');
      return SyncResult(
        success: false,
        message: 'فشل في مزامنة المشاريع',
        syncedItems: 0,
        failedItems: 1,
      );
    }
  }

  /// مزامنة الإشعارات
  Future<SyncResult> _syncNotifications() async {
    try {
      // محاكاة جلب الإشعارات من الخادم
      final serverNotifications = await _fetchNotificationsFromServer();
      await _storage.saveNotifications(serverNotifications);

      return SyncResult(
        success: true,
        message: 'مزامنة الإشعارات',
        syncedItems: serverNotifications.length,
        failedItems: 0,
        totalItems: serverNotifications.length,
      );
    } catch (e) {
      debugPrint('خطأ في مزامنة الإشعارات: $e');
      return SyncResult(
        success: false,
        message: 'فشل في مزامنة الإشعارات',
        syncedItems: 0,
        failedItems: 1,
      );
    }
  }

  /// مزامنة بيانات المستخدم
  Future<SyncResult> _syncUserData() async {
    try {
      final userData = _storage.getUserData();
      if (userData != null) {
        // محاكاة إرسال بيانات المستخدم للخادم
        await _sendUserDataToServer(userData);
      }

      return SyncResult(
        success: true,
        message: 'مزامنة بيانات المستخدم',
        syncedItems: userData != null ? 1 : 0,
        failedItems: 0,
        totalItems: userData != null ? 1 : 0,
      );
    } catch (e) {
      debugPrint('خطأ في مزامنة بيانات المستخدم: $e');
      return SyncResult(
        success: false,
        message: 'فشل في مزامنة بيانات المستخدم',
        syncedItems: 0,
        failedItems: 1,
      );
    }
  }

  // ========== دوال محاكاة الخادم ==========

  Future<void> _sendActionToServer(Map<String, dynamic> action) async {
    // محاكاة إرسال للخادم
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: تنفيذ الإرسال الحقيقي للخادم
  }

  Future<List<Map<String, dynamic>>> _fetchProjectsFromServer() async {
    // محاكاة جلب من الخادم
    await Future.delayed(const Duration(seconds: 1));
    // TODO: تنفيذ الجلب الحقيقي من الخادم
    return [];
  }

  Future<List<Map<String, dynamic>>> _fetchNotificationsFromServer() async {
    // محاكاة جلب من الخادم
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: تنفيذ الجلب الحقيقي من الخادم
    return [];
  }

  Future<void> _sendUserDataToServer(Map<String, dynamic> userData) async {
    // محاكاة إرسال للخادم
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: تنفيذ الإرسال الحقيقي للخادم
  }

  // ========== المزامنة التلقائية ==========

  /// بدء المزامنة التلقائية
  void _startAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      if (_connectivity.isConnected && _currentStatus == SyncStatus.idle) {
        startFullSync();
      }
    });
  }

  /// إيقاف المزامنة التلقائية
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncEnabled = false;
  }

  /// تفعيل المزامنة التلقائية
  void enableAutoSync() {
    _autoSyncEnabled = true;
    _startAutoSync();
  }

  // ========== معالجة الأحداث ==========

  /// عند تغيير حالة الاتصال
  void _onConnectionChanged(bool isConnected) {
    if (isConnected && _autoSyncEnabled && _currentStatus == SyncStatus.idle) {
      // بدء المزامنة عند استعادة الاتصال
      Future.delayed(const Duration(seconds: 2), () {
        startFullSync();
      });
    }
  }

  /// تحديث حالة المزامنة
  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    _syncStatusController.add(status);
  }

  /// تحديث تقدم المزامنة
  void _updateProgress(double progress) {
    _syncProgressController.add(progress);
  }

  // ========== تنظيف الموارد ==========

  void dispose() {
    _autoSyncTimer?.cancel();
    _syncStatusController.close();
    _syncProgressController.close();
  }
}

/// حالة المزامنة
enum SyncStatus {
  idle('في الانتظار'),
  syncing('جاري المزامنة'),
  completed('مكتملة'),
  failed('فشلت');

  const SyncStatus(this.displayName);
  final String displayName;
}

/// نتيجة المزامنة
class SyncResult {
  final bool success;
  final String message;
  final int syncedItems;
  final int failedItems;
  final int totalItems;
  final DateTime timestamp;

  SyncResult({
    required this.success,
    required this.message,
    required this.syncedItems,
    required this.failedItems,
    this.totalItems = 0,
  }) : timestamp = DateTime.now();

  double get successRate => 
      totalItems > 0 ? syncedItems / totalItems : 0.0;

  @override
  String toString() {
    return 'SyncResult(success: $success, message: $message, '
           'synced: $syncedItems, failed: $failedItems, total: $totalItems)';
  }
}
