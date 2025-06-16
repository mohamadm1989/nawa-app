import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../storage/local_storage_manager.dart';
import '../../shared/models/notification_model.dart';
import '../constants/app_constants.dart';
import 'permissions_service.dart';

/// خدمة إدارة الإشعارات المحلية والخارجية
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<NotificationModel> _notificationStreamController =
      StreamController<NotificationModel>.broadcast();

  /// Stream للاستماع للإشعارات الجديدة
  Stream<NotificationModel> get notificationStream =>
      _notificationStreamController.stream;

  bool _isInitialized = false;
  List<NotificationModel> _notifications = [];

  /// تهيئة خدمة الإشعارات
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      debugPrint('🔔 تهيئة خدمة الإشعارات...');

      // تهيئة المناطق الزمنية
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Damascus'));

      // تهيئة الإشعارات المحلية
      await _initializeLocalNotifications();

      // طلب الأذونات
      await _requestPermissions();

      // تحميل الإشعارات المحفوظة
      await _loadSavedNotifications();

      _isInitialized = true;
      debugPrint('✅ تم تهيئة خدمة الإشعارات بنجاح');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الإشعارات: $e');
      return false;
    }
  }

  /// تهيئة الإشعارات المحلية
  Future<void> _initializeLocalNotifications() async {
    // إعدادات Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // الإعدادات العامة
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // إنشاء قناة الإشعارات لـ Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// إنشاء قنوات الإشعارات لـ Android
  Future<void> _createNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // قناة الإشعارات العامة
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'general_notifications',
          'الإشعارات العامة',
          description: 'إشعارات عامة من تطبيق نوى',
          importance: Importance.defaultImportance,
          sound: RawResourceAndroidNotificationSound('notification'),
        ),
      );

      // قناة إشعارات التبرعات
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'donation_notifications',
          'إشعارات التبرعات',
          description: 'إشعارات متعلقة بالتبرعات والمساهمات',
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('donation_sound'),
        ),
      );

      // قناة إشعارات المشاريع
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'project_notifications',
          'إشعارات المشاريع',
          description: 'تحديثات وإشعارات المشاريع',
          importance: Importance.high,
        ),
      );

      // قناة الإشعارات العاجلة
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'urgent_notifications',
          'الإشعارات العاجلة',
          description: 'إشعارات عاجلة ومهمة',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('urgent_sound'),
        ),
      );
    }
  }

  /// طلب أذونات الإشعارات
  Future<bool> _requestPermissions() async {
    try {
      debugPrint('📱 طلب أذونات الإشعارات...');

      if (Platform.isAndroid) {
        // Android 13+ يحتاج إذن صريح للإشعارات
        final status = await Permission.notification.request();
        if (status.isDenied) {
          debugPrint('⚠️ تم رفض أذونات الإشعارات');
          return false;
        }
      } else if (Platform.isIOS) {
        // طلب أذونات iOS
        final bool? result = await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        
        if (result != true) {
          debugPrint('⚠️ تم رفض أذونات الإشعارات في iOS');
          return false;
        }
      }

      debugPrint('✅ تم منح أذونات الإشعارات');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في طلب أذونات الإشعارات: $e');
      return false;
    }
  }

  /// تحميل الإشعارات المحفوظة
  Future<void> _loadSavedNotifications() async {
    try {
      final savedNotifications = LocalStorageManager.instance.getCachedNotifications();
      _notifications = savedNotifications
          .map((json) => NotificationModel.fromJson(json))
          .toList();
      
      debugPrint('📥 تم تحميل ${_notifications.length} إشعار محفوظ');
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الإشعارات المحفوظة: $e');
    }
  }

  /// معالجة النقر على الإشعار
  void _onNotificationTapped(NotificationResponse response) {
    try {
      debugPrint('👆 تم النقر على إشعار: ${response.id}');
      
      if (response.payload != null) {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        final notification = NotificationModel.fromJson(data);
        
        // إضافة الإشعار للـ stream
        _notificationStreamController.add(notification);
        
        // تحديث حالة القراءة
        _markAsRead(notification.id);
      }
    } catch (e) {
      debugPrint('❌ خطأ في معالجة النقر على الإشعار: $e');
    }
  }

  /// إرسال إشعار محلي
  Future<bool> showLocalNotification({
    required String title,
    required String body,
    NotificationType type = NotificationType.general,
    Map<String, dynamic>? data,
    DateTime? scheduledDate,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: body,
        type: type,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now(),
        userId: 'current_user', // TODO: استخدام ID المستخدم الحقيقي
        actionData: data,
      );

      // حفظ الإشعار
      await _saveNotification(notification);

      // تحديد تفاصيل الإشعار
      final notificationDetails = _getNotificationDetails(type);
      
      if (scheduledDate != null) {
        // إشعار مجدول
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          notification.id.hashCode,
          title,
          body,
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails,
          payload: jsonEncode(notification.toJson()),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } else {
        // إشعار فوري
        await _flutterLocalNotificationsPlugin.show(
          notification.id.hashCode,
          title,
          body,
          notificationDetails,
          payload: jsonEncode(notification.toJson()),
        );
      }

      debugPrint('📤 تم إرسال إشعار: $title');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في إرسال الإشعار: $e');
      return false;
    }
  }

  /// الحصول على تفاصيل الإشعار حسب النوع
  dynamic _getNotificationDetails(NotificationType type) {
    // مؤقت<|im_start|> - سيتم تطوير هذا لاحق<|im_start|>
    return null;
  }

  /// حفظ الإشعار محلي<|im_start|>
  Future<void> _saveNotification(NotificationModel notification) async {
    _notifications.add(notification);
    
    // حفظ في التخزين المحلي
    final notificationsJson = _notifications.map((n) => n.toJson()).toList();
    await LocalStorageManager.instance.saveNotifications(notificationsJson);
  }

  /// تحديد الإشعار كمقروء
  Future<void> _markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);

      // حفظ التحديث
      final notificationsJson = _notifications.map((n) => n.toJson()).toList();
      await LocalStorageManager.instance.saveNotifications(notificationsJson);
    }
  }

  /// الحصول على جميع الإشعارات
  List<NotificationModel> getAllNotifications() {
    return List.from(_notifications);
  }

  /// الحصول على الإشعارات غير المقروءة
  List<NotificationModel> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  /// الحصول على عدد الإشعارات غير المقروءة
  int getUnreadCount() {
    return _notifications.where((n) => !n.isRead).length;
  }

  /// حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);

    // إلغاء الإشعار المجدول إن وجد
    await _flutterLocalNotificationsPlugin.cancel(notificationId.hashCode);

    // حفظ التحديث
    final notificationsJson = _notifications.map((n) => n.toJson()).toList();
    await LocalStorageManager.instance.saveNotifications(notificationsJson);
  }

  /// حذف جميع الإشعارات
  Future<void> clearAllNotifications() async {
    _notifications.clear();
    await _flutterLocalNotificationsPlugin.cancelAll();
    await LocalStorageManager.instance.saveNotifications([]);
  }

  /// تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();

    final notificationsJson = _notifications.map((n) => n.toJson()).toList();
    await LocalStorageManager.instance.saveNotifications(notificationsJson);
  }

  /// جدولة تذكير
  Future<bool> scheduleReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? data,
  }) async {
    return await showLocalNotification(
      title: title,
      body: body,
      type: NotificationType.general,
      data: data,
      scheduledDate: scheduledDate,
    );
  }

  /// إرسال إشعار تبرع ناجح
  Future<void> sendDonationSuccessNotification({
    required String projectName,
    required double amount,
    required String currency,
  }) async {
    await showLocalNotification(
      title: 'تم استلام تبرعك بنجاح! 💝',
      body: 'شكراً لك! تبرعك بمبلغ $amount $currency لمشروع "$projectName" تم استلامه بنجاح',
      type: NotificationType.donation,
      data: {
        'action': 'view_donation_impact',
        'project_name': projectName,
        'amount': amount,
        'currency': currency,
      },
    );
  }

  /// إرسال إشعار تحديث مشروع
  Future<void> sendProjectUpdateNotification({
    required String projectName,
    required String updateMessage,
    required String projectId,
  }) async {
    await showLocalNotification(
      title: 'تحديث في مشروعك 🏗️',
      body: 'مشروع "$projectName": $updateMessage',
      type: NotificationType.project,
      data: {
        'action': 'view_project',
        'project_id': projectId,
        'project_name': projectName,
      },
    );
  }

  /// إرسال إشعار إنجاز مشروع
  Future<void> sendProjectCompletedNotification({
    required String projectName,
    required String projectId,
  }) async {
    await showLocalNotification(
      title: 'مشروع مكتمل! 🎉',
      body: 'تم إنجاز مشروع "$projectName" بنجاح! شكراً لمساهمتك في هذا الإنجاز',
      type: NotificationType.project,
      data: {
        'action': 'view_project_completion',
        'project_id': projectId,
        'project_name': projectName,
      },
    );
  }

  /// التحقق من حالة الأذونات
  Future<bool> areNotificationsEnabled() async {
    // مؤقت<|im_start|> - سيتم تطوير هذا لاحق<|im_start|>
    return true;
  }

  /// فتح إعدادات الإشعارات في النظام
  Future<void> openNotificationSettings() async {
    try {
      if (kIsWeb) {
        debugPrint('🌐 فتح إعدادات الإشعارات غير مدعوم على الويب');
        return;
      }
      await PermissionsService.instance.openAppSettings();
    } catch (e) {
      debugPrint('❌ خطأ في فتح إعدادات الإشعارات: $e');
    }
  }

  /// تنظيف الموارد
  void dispose() {
    _notificationStreamController.close();
  }
}
