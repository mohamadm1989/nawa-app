import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

/// خدمة إدارة أذونات النظام
class PermissionsService {
  static final PermissionsService _instance = PermissionsService._internal();
  factory PermissionsService() => _instance;
  PermissionsService._internal();

  static PermissionsService get instance => _instance;

  /// طلب إذن الإشعارات
  Future<PermissionResult> requestNotificationPermission() async {
    try {
      debugPrint('📱 طلب إذن الإشعارات...');

      if (Platform.isAndroid) {
        final status = await permission_handler.Permission.notification.request();
        return _mapPermissionStatus(status, 'الإشعارات');
      } else if (Platform.isIOS) {
        // في iOS، الإذن يُطلب من خلال flutter_local_notifications
        final status = await permission_handler.Permission.notification.request();
        return _mapPermissionStatus(status, 'الإشعارات');
      }

      return PermissionResult(
        isGranted: true,
        message: 'الإذن متاح بشكل افتراضي',
      );
    } catch (e) {
      debugPrint('❌ خطأ في طلب إذن الإشعارات: $e');
      return PermissionResult(
        isGranted: false,
        message: 'حدث خطأ في طلب الإذن: $e',
      );
    }
  }

  /// طلب إذن الموقع
  Future<PermissionResult> requestLocationPermission() async {
    try {
      debugPrint('📍 طلب إذن الموقع...');

      final status = await permission_handler.Permission.location.request();
      return _mapPermissionStatus(status, 'الموقع');
    } catch (e) {
      debugPrint('❌ خطأ في طلب إذن الموقع: $e');
      return PermissionResult(
        isGranted: false,
        message: 'حدث خطأ في طلب إذن الموقع: $e',
      );
    }
  }

  /// طلب إذن الكاميرا
  Future<PermissionResult> requestCameraPermission() async {
    try {
      debugPrint('📷 طلب إذن الكاميرا...');

      final status = await permission_handler.Permission.camera.request();
      return _mapPermissionStatus(status, 'الكاميرا');
    } catch (e) {
      debugPrint('❌ خطأ في طلب إذن الكاميرا: $e');
      return PermissionResult(
        isGranted: false,
        message: 'حدث خطأ في طلب إذن الكاميرا: $e',
      );
    }
  }

  /// طلب إذن معرض الصور
  Future<PermissionResult> requestPhotosPermission() async {
    try {
      debugPrint('🖼️ طلب إذن معرض الصور...');

      final status = await permission_handler.Permission.photos.request();
      return _mapPermissionStatus(status, 'معرض الصور');
    } catch (e) {
      debugPrint('❌ خطأ في طلب إذن معرض الصور: $e');
      return PermissionResult(
        isGranted: false,
        message: 'حدث خطأ في طلب إذن معرض الصور: $e',
      );
    }
  }

  /// طلب إذن التخزين
  Future<PermissionResult> requestStoragePermission() async {
    try {
      debugPrint('💾 طلب إذن التخزين...');

      final status = await permission_handler.Permission.storage.request();
      return _mapPermissionStatus(status, 'التخزين');
    } catch (e) {
      debugPrint('❌ خطأ في طلب إذن التخزين: $e');
      return PermissionResult(
        isGranted: false,
        message: 'حدث خطأ في طلب إذن التخزين: $e',
      );
    }
  }

  /// طلب إذن الميكروفون
  Future<PermissionResult> requestMicrophonePermission() async {
    try {
      debugPrint('🎤 طلب إذن الميكروفون...');

      final status = await permission_handler.Permission.microphone.request();
      return _mapPermissionStatus(status, 'الميكروفون');
    } catch (e) {
      debugPrint('❌ خطأ في طلب إذن الميكروفون: $e');
      return PermissionResult(
        isGranted: false,
        message: 'حدث خطأ في طلب إذن الميكروفون: $e',
      );
    }
  }

  /// التحقق من حالة إذن الإشعارات
  Future<bool> isNotificationPermissionGranted() async {
    try {
      final status = await permission_handler.Permission.notification.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من إذن الإشعارات: $e');
      return false;
    }
  }

  /// التحقق من حالة إذن الموقع
  Future<bool> isLocationPermissionGranted() async {
    try {
      final status = await permission_handler.Permission.location.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من إذن الموقع: $e');
      return false;
    }
  }

  /// التحقق من حالة إذن الكاميرا
  Future<bool> isCameraPermissionGranted() async {
    try {
      final status = await permission_handler.Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من إذن الكاميرا: $e');
      return false;
    }
  }

  /// طلب جميع الأذونات الأساسية
  Future<Map<String, PermissionResult>> requestEssentialPermissions() async {
    debugPrint('🔐 طلب الأذونات الأساسية...');

    final results = <String, PermissionResult>{};

    // إذن الإشعارات
    results['notifications'] = await requestNotificationPermission();

    // إذن الموقع (للخرائط)
    results['location'] = await requestLocationPermission();

    // إذن الكاميرا (لرفع صور المشاريع)
    results['camera'] = await requestCameraPermission();

    // إذن معرض الصور
    results['photos'] = await requestPhotosPermission();

    debugPrint('✅ تم طلب جميع الأذونات الأساسية');
    return results;
  }

  /// عرض حوار طلب الأذونات
  Future<bool> showPermissionDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String permissionName,
    required Future<PermissionResult> Function() requestPermission,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.security,
                color: Color(0xFF4A7C59), // AppColors.primaryGreen
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'لاحقاً',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                final permissionResult = await requestPermission();
                
                if (!permissionResult.isGranted) {
                  // عرض رسالة في حالة رفض الإذن
                  if (context.mounted) {
                    _showPermissionDeniedDialog(context, permissionName);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                foregroundColor: Colors.white,
              ),
              child: const Text('منح الإذن'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// عرض حوار رفض الإذن
  void _showPermissionDeniedDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.orange,
              ),
              SizedBox(width: 8),
              Text('إذن مطلوب'),
            ],
          ),
          content: Text(
            'لاستخدام هذه الميزة، يرجى منح إذن $permissionName من إعدادات التطبيق.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                foregroundColor: Colors.white,
              ),
              child: const Text('فتح الإعدادات'),
            ),
          ],
        );
      },
    );
  }

  /// تحويل حالة الإذن إلى نتيجة
  PermissionResult _mapPermissionStatus(permission_handler.PermissionStatus status, String permissionName) {
    switch (status) {
      case permission_handler.PermissionStatus.granted:
        debugPrint('✅ تم منح إذن $permissionName');
        return PermissionResult(
          isGranted: true,
          message: 'تم منح الإذن بنجاح',
        );
      case permission_handler.PermissionStatus.denied:
        debugPrint('❌ تم رفض إذن $permissionName');
        return PermissionResult(
          isGranted: false,
          message: 'تم رفض الإذن',
        );
      case permission_handler.PermissionStatus.permanentlyDenied:
        debugPrint('🚫 تم رفض إذن $permissionName نهائياً');
        return PermissionResult(
          isGranted: false,
          message: 'تم رفض الإذن نهائياً. يرجى تفعيله من الإعدادات',
          isPermanentlyDenied: true,
        );
      case permission_handler.PermissionStatus.restricted:
        debugPrint('⚠️ إذن $permissionName مقيد');
        return PermissionResult(
          isGranted: false,
          message: 'الإذن مقيد من قبل النظام',
        );
      case permission_handler.PermissionStatus.limited:
        debugPrint('⚠️ إذن $permissionName محدود');
        return PermissionResult(
          isGranted: true,
          message: 'تم منح إذن محدود',
        );
      default:
        return PermissionResult(
          isGranted: false,
          message: 'حالة إذن غير معروفة',
        );
    }
  }

  /// فتح إعدادات التطبيق
  Future<void> openAppSettings() async {
    try {
      // التحقق من المنصة أولاً
      if (kIsWeb) {
        // على الويب، نعرض رسالة توضيحية
        debugPrint('🌐 فتح إعدادات التطبيق غير مدعوم على الويب');
        return;
      }

      // استخدام مكتبة permission_handler لفتح الإعدادات
      await permission_handler.openAppSettings();
      debugPrint('📱 تم محاولة فتح إعدادات التطبيق');
    } catch (e) {
      debugPrint('❌ خطأ في فتح إعدادات التطبيق: $e');
    }
  }

  /// التحقق من جميع الأذونات الأساسية
  Future<Map<String, bool>> checkAllEssentialPermissions() async {
    return {
      'notifications': await isNotificationPermissionGranted(),
      'location': await isLocationPermissionGranted(),
      'camera': await isCameraPermissionGranted(),
    };
  }
}

/// نتيجة طلب الإذن
class PermissionResult {
  final bool isGranted;
  final String message;
  final bool isPermanentlyDenied;

  const PermissionResult({
    required this.isGranted,
    required this.message,
    this.isPermanentlyDenied = false,
  });

  @override
  String toString() {
    return 'PermissionResult(isGranted: $isGranted, message: $message, isPermanentlyDenied: $isPermanentlyDenied)';
  }
}
