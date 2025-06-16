import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/safety/safe_widget.dart';
import '../../core/services/advanced_notification_service.dart';
import '../../shared/models/notification_model.dart';

/// صفحة إعدادات الإشعارات
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final AdvancedNotificationService _notificationService = AdvancedNotificationService.instance;
  
  late NotificationSettings _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// تحميل الإعدادات
  Future<void> _loadSettings() async {
    try {
      setState(() => _isLoading = true);
      
      await _notificationService.initialize();
      _settings = _notificationService.settings;
      
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('❌ خطأ في تحميل إعدادات الإشعارات: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeWidget(
      widgetName: 'NotificationSettingsScreen',
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          title: const Text('إعدادات الإشعارات'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          elevation: 0,
        ),
        body: _isLoading ? _buildLoadingState() : _buildContent(),
      ),
    );
  }

  /// بناء حالة التحميل
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل الإعدادات...'),
        ],
      ),
    );
  }

  /// بناء المحتوى الرئيسي
  Widget _buildContent() {
    return SafeWidget(
      widgetName: 'SettingsContent',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // الإعدادات العامة
          _buildSectionCard(
            title: 'الإعدادات العامة',
            icon: Icons.settings,
            children: [
              _buildSwitchTile(
                title: 'تفعيل الإشعارات',
                subtitle: 'تلقي جميع الإشعارات',
                value: _settings.enableNotifications,
                onChanged: (value) => _updateSettings(
                  _settings.copyWith(enableNotifications: value),
                ),
              ),
              _buildSwitchTile(
                title: 'الأصوات',
                subtitle: 'تشغيل أصوات الإشعارات',
                value: _settings.enableSound,
                onChanged: (value) => _updateSettings(
                  _settings.copyWith(enableSound: value),
                ),
              ),
              _buildSwitchTile(
                title: 'الاهتزاز',
                subtitle: 'اهتزاز الجهاز عند الإشعار',
                value: _settings.enableVibration,
                onChanged: (value) => _updateSettings(
                  _settings.copyWith(enableVibration: value),
                ),
              ),
              _buildSwitchTile(
                title: 'معاينة المحتوى',
                subtitle: 'إظهار محتوى الإشعار في المعاينة',
                value: _settings.enablePreview,
                onChanged: (value) => _updateSettings(
                  _settings.copyWith(enablePreview: value),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // إعدادات أنواع الإشعارات
          _buildSectionCard(
            title: 'أنواع الإشعارات',
            icon: Icons.category,
            children: NotificationType.values.map((type) {
              final isEnabled = _settings.typeSettings[type] ?? true;
              return _buildSwitchTile(
                title: _getTypeDisplayName(type),
                subtitle: _getTypeDescription(type),
                value: isEnabled,
                onChanged: (value) {
                  final newTypeSettings = Map<NotificationType, bool>.from(_settings.typeSettings);
                  newTypeSettings[type] = value;
                  _updateSettings(_settings.copyWith(typeSettings: newTypeSettings));
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // إعدادات متقدمة
          _buildSectionCard(
            title: 'إعدادات متقدمة',
            icon: Icons.tune,
            children: [
              _buildSliderTile(
                title: 'الحد الأقصى للإشعارات',
                subtitle: 'عدد الإشعارات المحفوظة: ${_settings.maxNotifications}',
                value: _settings.maxNotifications.toDouble(),
                min: 50,
                max: 500,
                divisions: 9,
                onChanged: (value) => _updateSettings(
                  _settings.copyWith(maxNotifications: value.round()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // أزرار الإجراءات
          _buildActionButtons(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// بناء بطاقة قسم
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // محتوى القسم
            ...children,
          ],
        ),
      ),
    );
  }

  /// بناء مفتاح تبديل
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SafeWidget(
      widgetName: 'SwitchTile_$title',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryGreen,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء شريط تمرير
  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return SafeWidget(
      widgetName: 'SliderTile_$title',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              activeColor: AppColors.primaryGreen,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء أزرار الإجراءات
  Widget _buildActionButtons() {
    return SafeWidget(
      widgetName: 'ActionButtons',
      child: Column(
        children: [
          // زر اختبار الإشعارات
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sendTestNotification,
              icon: const Icon(Icons.notification_add),
              label: const Text('اختبار إشعار'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.textOnColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // زر إعادة تعيين الإعدادات
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetSettings,
              icon: const Icon(Icons.restore),
              label: const Text('إعادة تعيين الإعدادات'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                side: BorderSide(color: AppColors.primaryGreen),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// الحصول على اسم النوع
  String _getTypeDisplayName(NotificationType type) {
    switch (type) {
      case NotificationType.donation:
        return 'التبرعات';
      case NotificationType.project:
        return 'المشاريع';
      case NotificationType.system:
        return 'النظام';
      case NotificationType.update:
        return 'التحديثات';
      case NotificationType.achievement:
        return 'الإنجازات';
      case NotificationType.reminder:
        return 'التذكيرات';
      case NotificationType.social:
        return 'الاجتماعية';
      case NotificationType.security:
        return 'الأمان';
      case NotificationType.general:
        return 'العامة';
    }
  }

  /// الحصول على وصف النوع
  String _getTypeDescription(NotificationType type) {
    switch (type) {
      case NotificationType.donation:
        return 'إشعارات التبرعات والمساهمات';
      case NotificationType.project:
        return 'تحديثات المشاريع والفرص الجديدة';
      case NotificationType.system:
        return 'إشعارات النظام والصيانة';
      case NotificationType.update:
        return 'تحديثات التطبيق والميزات';
      case NotificationType.achievement:
        return 'الإنجازات والجوائز';
      case NotificationType.reminder:
        return 'التذكيرات والمواعيد';
      case NotificationType.social:
        return 'التفاعلات الاجتماعية';
      case NotificationType.security:
        return 'تنبيهات الأمان';
      case NotificationType.general:
        return 'الإشعارات العامة';
    }
  }

  /// تحديث الإعدادات
  Future<void> _updateSettings(NotificationSettings newSettings) async {
    try {
      setState(() => _settings = newSettings);
      await _notificationService.updateSettings(newSettings);
      _showMessage('تم حفظ الإعدادات بنجاح', isSuccess: true);
    } catch (e) {
      debugPrint('❌ خطأ في تحديث الإعدادات: $e');
      _showMessage('حدث خطأ في حفظ الإعدادات', isSuccess: false);
    }
  }

  /// إرسال إشعار تجريبي
  Future<void> _sendTestNotification() async {
    try {
      await _notificationService.sendTestNotification();
      _showMessage('تم إرسال إشعار تجريبي بنجاح! 🔔', isSuccess: true);
    } catch (e) {
      debugPrint('❌ خطأ في إرسال الإشعار التجريبي: $e');
      _showMessage('حدث خطأ في إرسال الإشعار التجريبي', isSuccess: false);
    }
  }

  /// إعادة تعيين الإعدادات
  Future<void> _resetSettings() async {
    try {
      final confirmed = await _showResetConfirmation();
      if (confirmed == true) {
        const defaultSettings = NotificationSettings();
        await _updateSettings(defaultSettings);
        _showMessage('تم إعادة تعيين الإعدادات بنجاح', isSuccess: true);
      }
    } catch (e) {
      debugPrint('❌ خطأ في إعادة تعيين الإعدادات: $e');
      _showMessage('حدث خطأ في إعادة تعيين الإعدادات', isSuccess: false);
    }
  }

  /// عرض تأكيد إعادة التعيين
  Future<bool?> _showResetConfirmation() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين الإعدادات'),
        content: const Text('هل أنت متأكد من إعادة تعيين جميع إعدادات الإشعارات إلى القيم الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  /// عرض رسالة
  void _showMessage(String message, {required bool isSuccess}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
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
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
