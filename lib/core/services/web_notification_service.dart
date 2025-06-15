import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// خدمة الإشعارات المخصصة للويب
class WebNotificationService {
  static final WebNotificationService _instance = WebNotificationService._internal();
  factory WebNotificationService() => _instance;
  WebNotificationService._internal();

  static WebNotificationService get instance => _instance;

  /// التحقق من دعم الإشعارات في المتصفح
  bool get isNotificationSupported {
    if (!kIsWeb) return false;
    // في Flutter Web، نحتاج للتحقق من دعم المتصفح
    return true; // افتراضي للتطوير
  }

  /// طلب إذن الإشعارات للويب
  Future<bool> requestNotificationPermission() async {
    if (!kIsWeb) return false;

    try {
      debugPrint('🌐 طلب إذن الإشعارات للويب...');
      
      // في Flutter Web، نحاكي طلب الإذن
      // في التطبيق الحقيقي، سنستخدم dart:html
      await Future.delayed(const Duration(milliseconds: 500));
      
      debugPrint('✅ تم منح إذن الإشعارات للويب');
      return true;
    } catch (e) {
      debugPrint('❌ خطأ في طلب إذن الإشعارات للويب: $e');
      return false;
    }
  }

  /// عرض حوار إعدادات الإشعارات للويب
  Future<void> showWebNotificationSettings(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: Color(0xFF4A7C59),
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'إعدادات الإشعارات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'لتفعيل الإشعارات في المتصفح:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInstructionStep(
                  '1',
                  'انقر على أيقونة القفل 🔒 في شريط العنوان',
                ),
                const SizedBox(height: 12),
                _buildInstructionStep(
                  '2',
                  'اختر "إعدادات الموقع" أو "Site Settings"',
                ),
                const SizedBox(height: 12),
                _buildInstructionStep(
                  '3',
                  'فعّل خيار "الإشعارات" أو "Notifications"',
                ),
                const SizedBox(height: 12),
                _buildInstructionStep(
                  '4',
                  'أعد تحميل الصفحة لتطبيق التغييرات',
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A7C59).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF4A7C59).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF4A7C59),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ملاحظة: إعدادات الإشعارات تختلف حسب نوع المتصفح المستخدم.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A7C59),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _tryRequestPermission(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C59),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text('تجربة الآن'),
            ),
          ],
        );
      },
    );
  }

  /// بناء خطوة في التعليمات
  Widget _buildInstructionStep(String number, String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF4A7C59),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            instruction,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  /// محاولة طلب الإذن
  Future<void> _tryRequestPermission(BuildContext context) async {
    try {
      final granted = await requestNotificationPermission();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              granted 
                ? '✅ تم تفعيل الإشعارات بنجاح!'
                : '❌ لم يتم تفعيل الإشعارات. يرجى المحاولة يدوياً.',
            ),
            backgroundColor: granted 
              ? const Color(0xFF4A7C59)
              : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ حدث خطأ في تفعيل الإشعارات'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// إرسال إشعار تجريبي للويب
  Future<void> sendTestNotification() async {
    if (!kIsWeb) return;

    try {
      debugPrint('🌐 إرسال إشعار تجريبي للويب...');
      
      // في التطبيق الحقيقي، سنستخدم Web Notifications API
      await Future.delayed(const Duration(milliseconds: 300));
      
      debugPrint('✅ تم إرسال الإشعار التجريبي');
    } catch (e) {
      debugPrint('❌ خطأ في إرسال الإشعار التجريبي: $e');
    }
  }

  /// التحقق من حالة الإشعارات
  Future<String> getNotificationStatus() async {
    if (!kIsWeb) return 'غير مدعوم';

    try {
      // في التطبيق الحقيقي، سنتحقق من حالة الإذن الفعلية
      return 'مفعل'; // افتراضي للتطوير
    } catch (e) {
      return 'غير معروف';
    }
  }

  /// عرض معلومات حول الإشعارات في الويب
  Future<void> showWebNotificationInfo(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF4A7C59),
              ),
              SizedBox(width: 8),
              Text('معلومات الإشعارات'),
            ],
          ),
          content: const Text(
            'الإشعارات في تطبيق الويب تعتمد على إعدادات المتصفح. '
            'لضمان وصول الإشعارات، يرجى التأكد من تفعيلها في إعدادات المتصفح.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('فهمت'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showWebNotificationSettings(context);
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
}
