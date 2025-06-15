import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/safety/safe_widget.dart';
import '../../core/services/web_notification_service.dart';

/// صفحة إشعارات مبسطة وآمنة
class SimpleNotificationsScreen extends StatefulWidget {
  const SimpleNotificationsScreen({super.key});

  @override
  State<SimpleNotificationsScreen> createState() => _SimpleNotificationsScreenState();
}

class _SimpleNotificationsScreenState extends State<SimpleNotificationsScreen> {
  
  @override
  Widget build(BuildContext context) {
    return SafeWidget(
      widgetName: 'SimpleNotificationsScreen',
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          title: const Text('الإشعارات'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          elevation: 0,
          actions: [
            // زر اختبار الإشعارات
            SafeWidget(
              widgetName: 'TestNotificationButton',
              child: IconButton(
                onPressed: _testNotification,
                icon: const Icon(Icons.notification_add),
                tooltip: 'اختبار إشعار',
              ),
            ),
          ],
        ),
        body: SafeWidget(
          widgetName: 'NotificationsBody',
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة الإشعارات
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications,
                size: 64,
                color: AppColors.primaryGreen,
              ),
            ),

            const SizedBox(height: 24),

            // العنوان
            Text(
              'مركز الإشعارات',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // الوصف
            Text(
              'ستظهر جميع الإشعارات المهمة هنا\nبما في ذلك تحديثات المشاريع والتبرعات',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // زر اختبار الإشعارات
            SafeWidget(
              widgetName: 'TestButton',
              child: ElevatedButton.icon(
                onPressed: _testNotification,
                icon: const Icon(Icons.notification_add),
                label: const Text('اختبار إشعار'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.textOnColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // معلومات إضافية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'سيتم تطوير نظام الإشعارات الكامل قريباً',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// اختبار إشعار آمن
  Future<void> _testNotification() async {
    try {
      if (kIsWeb) {
        // للويب، نستخدم الحل المخصص
        await WebNotificationService.instance.sendTestNotification();
        if (mounted) {
          _showMessage('تم إرسال إشعار تجريبي للويب! 🌐', isSuccess: true);
        }
      } else {
        // للموبايل، رسالة بسيطة
        if (mounted) {
          _showMessage('اختبار الإشعارات متاح على الموبايل فقط', isSuccess: false);
        }
      }
    } catch (e) {
      debugPrint('❌ خطأ في اختبار الإشعار: $e');
      if (mounted) {
        _showMessage('حدث خطأ في اختبار الإشعار', isSuccess: false);
      }
    }
  }

  /// عرض رسالة آمنة
  void _showMessage(String message, {required bool isSuccess}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
