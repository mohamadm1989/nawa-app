import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../shared/models/notification_model.dart';
import '../storage/local_storage_manager.dart';

/// خدمة إدارة الإشعارات المتقدمة
class AdvancedNotificationService {
  static final AdvancedNotificationService _instance = AdvancedNotificationService._internal();
  factory AdvancedNotificationService() => _instance;
  AdvancedNotificationService._internal();

  static AdvancedNotificationService get instance => _instance;

  // المفاتيح للتخزين المحلي
  static const String _notificationsKey = 'notifications';
  static const String _settingsKey = 'notification_settings';
  static const String _lastReadKey = 'last_read_timestamp';

  // البيانات المحلية
  final List<NotificationModel> _notifications = [];
  NotificationSettings _settings = const NotificationSettings();
  DateTime? _lastReadTimestamp;

  // Stream Controllers
  final StreamController<List<NotificationModel>> _notificationsController = 
      StreamController<List<NotificationModel>>.broadcast();
  final StreamController<NotificationModel> _newNotificationController = 
      StreamController<NotificationModel>.broadcast();
  final StreamController<NotificationSettings> _settingsController = 
      StreamController<NotificationSettings>.broadcast();

  // Getters للـ Streams
  Stream<List<NotificationModel>> get notificationsStream => _notificationsController.stream;
  Stream<NotificationModel> get newNotificationStream => _newNotificationController.stream;
  Stream<NotificationSettings> get settingsStream => _settingsController.stream;

  // Getters للبيانات
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  NotificationSettings get settings => _settings;
  int get unreadCount => _notifications.where((n) => !n.isRead && !n.isArchived).length;
  int get totalCount => _notifications.where((n) => !n.isArchived).length;

  /// تهيئة الخدمة
  Future<void> initialize() async {
    try {
      await _loadNotifications();
      await _loadSettings();
      await _loadLastReadTimestamp();
      
      // إنشاء بعض الإشعارات التجريبية إذا لم تكن موجودة
      if (_notifications.isEmpty) {
        await _createSampleNotifications();
      }
      
      debugPrint('✅ تم تهيئة خدمة الإشعارات المتقدمة');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الإشعارات: $e');
    }
  }

  /// تحميل الإشعارات من التخزين المحلي
  Future<void> _loadNotifications() async {
    try {
      final notificationsJson = await LocalStorageManager.instance.getString(_notificationsKey);
      if (notificationsJson != null) {
        final List<dynamic> notificationsList = jsonDecode(notificationsJson);
        _notifications.clear();
        _notifications.addAll(
          notificationsList.map((json) => NotificationModel.fromJson(json)).toList(),
        );
        
        // ترتيب الإشعارات حسب التاريخ (الأحدث أولاً)
        _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        
        _notificationsController.add(_notifications);
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الإشعارات: $e');
    }
  }

  /// حفظ الإشعارات في التخزين المحلي
  Future<void> _saveNotifications() async {
    try {
      final notificationsJson = jsonEncode(
        _notifications.map((n) => n.toJson()).toList(),
      );
      await LocalStorageManager.instance.setString(_notificationsKey, notificationsJson);
    } catch (e) {
      debugPrint('❌ خطأ في حفظ الإشعارات: $e');
    }
  }

  /// تحميل الإعدادات
  Future<void> _loadSettings() async {
    try {
      final settingsJson = await LocalStorageManager.instance.getString(_settingsKey);
      if (settingsJson != null) {
        _settings = NotificationSettings.fromJson(jsonDecode(settingsJson));
        _settingsController.add(_settings);
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحميل إعدادات الإشعارات: $e');
    }
  }

  /// حفظ الإعدادات
  Future<void> _saveSettings() async {
    try {
      final settingsJson = jsonEncode(_settings.toJson());
      await LocalStorageManager.instance.setString(_settingsKey, settingsJson);
      _settingsController.add(_settings);
    } catch (e) {
      debugPrint('❌ خطأ في حفظ إعدادات الإشعارات: $e');
    }
  }

  /// تحميل آخر وقت قراءة
  Future<void> _loadLastReadTimestamp() async {
    try {
      final timestamp = await LocalStorageManager.instance.getString(_lastReadKey);
      if (timestamp != null) {
        _lastReadTimestamp = DateTime.parse(timestamp);
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحميل آخر وقت قراءة: $e');
    }
  }

  /// حفظ آخر وقت قراءة
  Future<void> _saveLastReadTimestamp() async {
    try {
      _lastReadTimestamp = DateTime.now();
      await LocalStorageManager.instance.setString(
        _lastReadKey, 
        _lastReadTimestamp!.toIso8601String(),
      );
    } catch (e) {
      debugPrint('❌ خطأ في حفظ آخر وقت قراءة: $e');
    }
  }

  /// إنشاء إشعارات تجريبية
  Future<void> _createSampleNotifications() async {
    final sampleNotifications = [
      NotificationModel(
        id: '1',
        title: 'مرحباً بك في نوى! 🎉',
        message: 'شكراً لانضمامك إلى منصة نوى للعمل الخيري. ابدأ رحلتك في صنع الفرق!',
        type: NotificationType.general,
        priority: NotificationPriority.high,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        tags: ['ترحيب', 'بداية'],
      ),
      NotificationModel(
        id: '2',
        title: 'تم استلام تبرعك بنجاح! 💝',
        message: 'شكراً لك! تبرعك بمبلغ 100 ريال لمشروع "ترميم مدرسة الأمل" تم استلامه بنجاح',
        type: NotificationType.donation,
        priority: NotificationPriority.high,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        projectId: 'project_1',
        actionData: {'projectId': 'project_1', 'amount': 100},
        tags: ['تبرع', 'نجاح'],
      ),
      NotificationModel(
        id: '3',
        title: 'مشروع جديد متاح للتبرع 🏗️',
        message: 'تم إضافة مشروع "بناء مركز صحي" في منطقتك. ساهم في تحسين الخدمات الصحية!',
        type: NotificationType.project,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        projectId: 'project_2',
        actionData: {'projectId': 'project_2'},
        tags: ['مشروع جديد', 'صحة'],
      ),
      NotificationModel(
        id: '4',
        title: 'تحديث في إعدادات الأمان 🔒',
        message: 'تم تحديث إعدادات الأمان في حسابك. راجع التغييرات للتأكد من أمان حسابك.',
        type: NotificationType.security,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['أمان', 'تحديث'],
      ),
      NotificationModel(
        id: '5',
        title: 'إنجاز رائع! 🏆',
        message: 'تهانينا! لقد ساهمت في 5 مشاريع خيرية. أنت تصنع فرقاً حقيقياً في المجتمع!',
        type: NotificationType.achievement,
        priority: NotificationPriority.info,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['إنجاز', 'تهنئة'],
      ),
    ];

    for (final notification in sampleNotifications) {
      await addNotification(notification);
    }
  }

  /// إضافة إشعار جديد
  Future<void> addNotification(NotificationModel notification) async {
    try {
      // التحقق من عدم وجود إشعار بنفس المعرف
      if (_notifications.any((n) => n.id == notification.id)) {
        debugPrint('⚠️ إشعار بنفس المعرف موجود بالفعل: ${notification.id}');
        return;
      }

      _notifications.insert(0, notification); // إضافة في المقدمة
      
      // تحديد الحد الأقصى للإشعارات
      if (_notifications.length > _settings.maxNotifications) {
        _notifications.removeRange(_settings.maxNotifications, _notifications.length);
      }

      await _saveNotifications();
      _notificationsController.add(_notifications);
      _newNotificationController.add(notification);

      debugPrint('✅ تم إضافة إشعار جديد: ${notification.title}');
    } catch (e) {
      debugPrint('❌ خطأ في إضافة الإشعار: $e');
    }
  }

  /// تحديث إشعار موجود
  Future<void> updateNotification(NotificationModel updatedNotification) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == updatedNotification.id);
      if (index != -1) {
        _notifications[index] = updatedNotification;
        await _saveNotifications();
        _notificationsController.add(_notifications);
        debugPrint('✅ تم تحديث الإشعار: ${updatedNotification.id}');
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحديث الإشعار: $e');
    }
  }

  /// تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      final notification = _notifications.firstWhere((n) => n.id == notificationId);
      if (!notification.isRead) {
        final updatedNotification = notification.copyWith(isRead: true);
        await updateNotification(updatedNotification);
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحديد الإشعار كمقروء: $e');
    }
  }

  /// تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    try {
      bool hasChanges = false;
      for (int i = 0; i < _notifications.length; i++) {
        if (!_notifications[i].isRead && !_notifications[i].isArchived) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
          hasChanges = true;
        }
      }
      
      if (hasChanges) {
        await _saveNotifications();
        await _saveLastReadTimestamp();
        _notificationsController.add(_notifications);
        debugPrint('✅ تم تحديد جميع الإشعارات كمقروءة');
      }
    } catch (e) {
      debugPrint('❌ خطأ في تحديد جميع الإشعارات كمقروءة: $e');
    }
  }

  /// حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    try {
      _notifications.removeWhere((n) => n.id == notificationId);
      await _saveNotifications();
      _notificationsController.add(_notifications);
      debugPrint('✅ تم حذف الإشعار: $notificationId');
    } catch (e) {
      debugPrint('❌ خطأ في حذف الإشعار: $e');
    }
  }

  /// أرشفة إشعار
  Future<void> archiveNotification(String notificationId) async {
    try {
      final notification = _notifications.firstWhere((n) => n.id == notificationId);
      if (!notification.isArchived) {
        final updatedNotification = notification.copyWith(isArchived: true);
        await updateNotification(updatedNotification);
      }
    } catch (e) {
      debugPrint('❌ خطأ في أرشفة الإشعار: $e');
    }
  }

  /// تثبيت/إلغاء تثبيت إشعار
  Future<void> togglePinNotification(String notificationId) async {
    try {
      final notification = _notifications.firstWhere((n) => n.id == notificationId);
      final updatedNotification = notification.copyWith(isPinned: !notification.isPinned);
      await updateNotification(updatedNotification);
    } catch (e) {
      debugPrint('❌ خطأ في تثبيت/إلغاء تثبيت الإشعار: $e');
    }
  }

  /// تحديث الإعدادات
  Future<void> updateSettings(NotificationSettings newSettings) async {
    try {
      _settings = newSettings;
      await _saveSettings();
      debugPrint('✅ تم تحديث إعدادات الإشعارات');
    } catch (e) {
      debugPrint('❌ خطأ في تحديث إعدادات الإشعارات: $e');
    }
  }

  /// الحصول على الإشعارات حسب النوع
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type && !n.isArchived).toList();
  }

  /// الحصول على الإشعارات غير المقروءة
  List<NotificationModel> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead && !n.isArchived).toList();
  }

  /// الحصول على الإشعارات المهمة
  List<NotificationModel> getImportantNotifications() {
    return _notifications.where((n) => 
      (n.priority == NotificationPriority.high || n.isPinned) && !n.isArchived
    ).toList();
  }

  /// الحصول على الإشعارات المؤرشفة
  List<NotificationModel> getArchivedNotifications() {
    return _notifications.where((n) => n.isArchived).toList();
  }

  /// البحث في الإشعارات
  List<NotificationModel> searchNotifications(String query) {
    if (query.isEmpty) return notifications;
    
    final lowerQuery = query.toLowerCase();
    return _notifications.where((n) => 
      !n.isArchived && (
        n.title.toLowerCase().contains(lowerQuery) ||
        n.message.toLowerCase().contains(lowerQuery) ||
        n.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
      )
    ).toList();
  }

  /// تنظيف الإشعارات المنتهية الصلاحية
  Future<void> cleanupExpiredNotifications() async {
    try {
      final initialCount = _notifications.length;
      _notifications.removeWhere((n) => n.isExpired);
      
      if (_notifications.length != initialCount) {
        await _saveNotifications();
        _notificationsController.add(_notifications);
        debugPrint('✅ تم تنظيف ${initialCount - _notifications.length} إشعار منتهي الصلاحية');
      }
    } catch (e) {
      debugPrint('❌ خطأ في تنظيف الإشعارات المنتهية الصلاحية: $e');
    }
  }

  /// إرسال إشعار تجريبي
  Future<void> sendTestNotification() async {
    final testNotification = NotificationModel(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'إشعار تجريبي 🔔',
      message: 'هذا إشعار تجريبي للتأكد من عمل النظام بشكل صحيح. تم إرساله في ${DateTime.now().toString().substring(11, 16)}',
      type: NotificationType.general,
      priority: NotificationPriority.info,
      timestamp: DateTime.now(),
      tags: ['تجريبي', 'اختبار'],
    );

    await addNotification(testNotification);
  }

  /// تنظيف الموارد
  void dispose() {
    _notificationsController.close();
    _newNotificationController.close();
    _settingsController.close();
  }
}
