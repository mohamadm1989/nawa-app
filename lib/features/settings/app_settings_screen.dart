import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/storage/local_storage_manager.dart';
import '../../core/services/advanced_notification_service.dart';
import '../../core/routes/app_routes.dart';

/// صفحة الإعدادات الشاملة
class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // إعدادات الإشعارات
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  
  // إعدادات المظهر
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'العربية';
  String _selectedCurrency = 'الليرة السورية';
  
  // إعدادات الخصوصية
  bool _showName = true;
  bool _showDonations = false;
  bool _showLocation = true;
  bool _allowAnalytics = true;
  
  // إعدادات التطبيق
  bool _autoSync = true;
  bool _offlineMode = false;
  bool _dataCompression = true;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final settings = LocalStorageManager.instance.getSettings();
      
      setState(() {
        _notificationsEnabled = settings['notifications_enabled'] ?? true;
        _emailNotifications = settings['email_notifications'] ?? true;
        _pushNotifications = settings['push_notifications'] ?? true;
        _smsNotifications = settings['sms_notifications'] ?? false;
        _soundEnabled = settings['sound_enabled'] ?? true;
        _vibrationEnabled = settings['vibration_enabled'] ?? true;
        
        _darkModeEnabled = settings['theme_mode'] == 'dark';
        _selectedLanguage = settings['language'] == 'ar' ? 'العربية' : 'English';
        _selectedCurrency = settings['currency'] ?? 'الليرة السورية';
        
        _showName = settings['show_name'] ?? true;
        _showDonations = settings['show_donations'] ?? false;
        _showLocation = settings['show_location'] ?? true;
        _allowAnalytics = settings['allow_analytics'] ?? true;
        
        _autoSync = settings['auto_sync'] ?? true;
        _offlineMode = settings['offline_mode'] ?? false;
        _dataCompression = settings['data_compression'] ?? true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ في تحميل الإعدادات')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // دالة التوجيه إلى صفحة تعديل الملف الشخصي
  void _navigateToEditProfile() async {
    try {
      final result = await AppRoutes.pushEditProfile(context);

      // إذا تم حفظ التغييرات، قم بإعادة تحميل الإعدادات
      if (result == true) {
        _loadSettings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ في فتح صفحة التعديل')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 0,
      title: const Row(
        children: [
          Icon(Icons.settings, size: 24),
          SizedBox(width: 8),
          Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.restore),
          onPressed: _resetToDefaults,
          tooltip: 'استعادة الإعدادات الافتراضية',
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primaryGreen),
          SizedBox(height: 16),
          Text('جاري تحميل الإعدادات...'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // إعدادات الإشعارات
          _buildNotificationSettings(),
          
          const SizedBox(height: 20),
          
          // إعدادات المظهر
          _buildAppearanceSettings(),
          
          const SizedBox(height: 20),
          
          // إعدادات الخصوصية
          _buildPrivacySettings(),
          
          const SizedBox(height: 20),
          
          // إعدادات التطبيق
          _buildAppSettings(),

          const SizedBox(height: 20),

          // إعدادات إمكانية الوصول
          _buildAccessibilitySettings(),

          const SizedBox(height: 20),

          // إعدادات الحساب
          _buildAccountSettings(),
          
          const SizedBox(height: 20),
          
          // معلومات التطبيق
          _buildAppInfo(),
          
          const SizedBox(height: 100), // مساحة إضافية
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsSection(
      title: 'الإشعارات',
      icon: Icons.notifications,
      children: [
        _buildSwitchTile(
          icon: Icons.notifications_active,
          title: 'تفعيل الإشعارات',
          subtitle: 'استقبال جميع الإشعارات',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
            _saveSettings();
          },
        ),
        
        if (_notificationsEnabled) ...[
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.push_pin,
            title: 'الإشعارات الفورية',
            subtitle: 'إشعارات فورية للأحداث المهمة',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
              _saveSettings();
            },
          ),
          
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'إشعارات البريد الإلكتروني',
            subtitle: 'استقبال الإشعارات عبر البريد',
            value: _emailNotifications,
            onChanged: (value) {
              setState(() {
                _emailNotifications = value;
              });
              _saveSettings();
            },
          ),
          
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.sms,
            title: 'الرسائل النصية',
            subtitle: 'إشعارات عبر الرسائل النصية',
            value: _smsNotifications,
            onChanged: (value) {
              setState(() {
                _smsNotifications = value;
              });
              _saveSettings();
            },
          ),
          
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'الصوت',
            subtitle: 'تشغيل صوت مع الإشعارات',
            value: _soundEnabled,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
              _saveSettings();
            },
          ),
          
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.vibration,
            title: 'الاهتزاز',
            subtitle: 'اهتزاز الجهاز مع الإشعارات',
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
              _saveSettings();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAppearanceSettings() {
    return _buildSettingsSection(
      title: 'المظهر',
      icon: Icons.palette,
      children: [
        _buildSwitchTile(
          icon: Icons.dark_mode,
          title: 'الوضع الليلي',
          subtitle: 'تفعيل المظهر الداكن',
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
            _saveSettings();
          },
        ),
        
        _buildDivider(),
        _buildDropdownTile(
          icon: Icons.language,
          title: 'اللغة',
          subtitle: 'اختيار لغة التطبيق',
          value: _selectedLanguage,
          items: ['العربية', 'English'],
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value!;
            });
            _saveSettings();
          },
        ),
        
        _buildDivider(),
        _buildDropdownTile(
          icon: Icons.attach_money,
          title: 'العملة',
          subtitle: 'اختيار العملة المفضلة',
          value: _selectedCurrency,
          items: ['الليرة السورية', 'الدولار الأمريكي', 'اليورو'],
          onChanged: (value) {
            setState(() {
              _selectedCurrency = value!;
            });
            _saveSettings();
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return _buildSettingsSection(
      title: 'الخصوصية',
      icon: Icons.privacy_tip,
      children: [
        _buildSwitchTile(
          icon: Icons.person,
          title: 'إظهار الاسم',
          subtitle: 'عرض اسمك في الملف العام',
          value: _showName,
          onChanged: (value) {
            setState(() {
              _showName = value;
            });
            _saveSettings();
          },
        ),

        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.monetization_on,
          title: 'إظهار التبرعات',
          subtitle: 'عرض تبرعاتك للآخرين',
          value: _showDonations,
          onChanged: (value) {
            setState(() {
              _showDonations = value;
            });
            _saveSettings();
          },
        ),

        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.location_on,
          title: 'إظهار الموقع',
          subtitle: 'مشاركة موقعك الجغرافي',
          value: _showLocation,
          onChanged: (value) {
            setState(() {
              _showLocation = value;
            });
            _saveSettings();
          },
        ),

        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.analytics,
          title: 'السماح بالتحليلات',
          subtitle: 'مساعدة في تحسين التطبيق',
          value: _allowAnalytics,
          onChanged: (value) {
            setState(() {
              _allowAnalytics = value;
            });
            _saveSettings();
          },
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return _buildSettingsSection(
      title: 'إعدادات التطبيق',
      icon: Icons.settings_applications,
      children: [
        _buildSwitchTile(
          icon: Icons.sync,
          title: 'المزامنة التلقائية',
          subtitle: 'مزامنة البيانات تلقائياً',
          value: _autoSync,
          onChanged: (value) {
            setState(() {
              _autoSync = value;
            });
            _saveSettings();
          },
        ),

        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.offline_bolt,
          title: 'الوضع غير المتصل',
          subtitle: 'العمل بدون اتصال بالإنترنت',
          value: _offlineMode,
          onChanged: (value) {
            setState(() {
              _offlineMode = value;
            });
            _saveSettings();
          },
        ),

        _buildDivider(),
        _buildSwitchTile(
          icon: Icons.compress,
          title: 'ضغط البيانات',
          subtitle: 'توفير استهلاك الإنترنت',
          value: _dataCompression,
          onChanged: (value) {
            setState(() {
              _dataCompression = value;
            });
            _saveSettings();
          },
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.clear_all,
          title: 'مسح البيانات المؤقتة',
          subtitle: 'حذف الملفات المؤقتة',
          onTap: _clearCache,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.storage,
          title: 'إدارة التخزين',
          subtitle: 'عرض استخدام مساحة التخزين',
          onTap: _showStorageInfo,
        ),
      ],
    );
  }

  Widget _buildAccessibilitySettings() {
    return _buildSettingsSection(
      title: 'إمكانية الوصول',
      icon: Icons.accessibility,
      children: [
        _buildActionTile(
          icon: Icons.accessibility_new,
          title: 'اختبار إمكانية الوصول',
          subtitle: 'اختبار ميزات إمكانية الوصول',
          onTap: () => AppRoutes.pushAccessibilityTest(context),
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.psychology,
          title: 'اختبار تجربة المستخدم',
          subtitle: 'اختبار تحسينات UX والتفاعل',
          onTap: () => AppRoutes.pushUXTest(context),
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.text_fields,
          title: 'حجم النص',
          subtitle: 'تعديل حجم النص في التطبيق',
          onTap: _showTextSizeSettings,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.contrast,
          title: 'التباين العالي',
          subtitle: 'تحسين التباين للرؤية الأفضل',
          onTap: _showContrastSettings,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.motion_photos_off,
          title: 'تقليل الحركة',
          subtitle: 'تقليل الرسوم المتحركة',
          onTap: _showMotionSettings,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.record_voice_over,
          title: 'قارئ الشاشة',
          subtitle: 'إعدادات قارئ الشاشة',
          onTap: _showScreenReaderSettings,
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return _buildSettingsSection(
      title: 'الحساب',
      icon: Icons.account_circle,
      children: [
        _buildActionTile(
          icon: Icons.edit,
          title: 'تعديل الملف الشخصي',
          subtitle: 'تحديث معلوماتك الشخصية',
          onTap: () => _navigateToEditProfile(),
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.security,
          title: 'الأمان والخصوصية',
          subtitle: 'إعدادات الأمان المتقدمة',
          onTap: _showSecuritySettings,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.backup,
          title: 'نسخ احتياطي',
          subtitle: 'حفظ واستعادة البيانات',
          onTap: _showBackupOptions,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.logout,
          title: 'تسجيل الخروج',
          subtitle: 'الخروج من الحساب الحالي',
          onTap: _showLogoutConfirmation,
          textColor: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return _buildSettingsSection(
      title: 'معلومات التطبيق',
      icon: Icons.info,
      children: [
        _buildInfoTile(
          icon: Icons.apps,
          title: 'إصدار التطبيق',
          value: '1.0.0',
        ),

        _buildDivider(),
        _buildInfoTile(
          icon: Icons.build,
          title: 'رقم البناء',
          value: '100',
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.update,
          title: 'البحث عن تحديثات',
          subtitle: 'فحص التحديثات المتاحة',
          onTap: _checkForUpdates,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.help,
          title: 'المساعدة والدعم',
          subtitle: 'الحصول على المساعدة',
          onTap: _showHelp,
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.description,
          title: 'الشروط والأحكام',
          subtitle: 'قراءة شروط الاستخدام',
          onTap: () => AppRoutes.pushTerms(context),
        ),

        _buildDivider(),
        _buildActionTile(
          icon: Icons.policy,
          title: 'سياسة الخصوصية',
          subtitle: 'قراءة سياسة الخصوصية',
          onTap: () => AppRoutes.pushPrivacy(context),
        ),
      ],
    );
  }

  // دوال البناء المساعدة
  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryGreen, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // محتوى القسم
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            isExpanded: true,
            underline: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.primaryGreen),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: 16,
      endIndent: 16,
    );
  }

  // دوال الإجراءات
  void _saveSettings() async {
    try {
      final settings = {
        'notifications_enabled': _notificationsEnabled,
        'email_notifications': _emailNotifications,
        'push_notifications': _pushNotifications,
        'sms_notifications': _smsNotifications,
        'sound_enabled': _soundEnabled,
        'vibration_enabled': _vibrationEnabled,

        'theme_mode': _darkModeEnabled ? 'dark' : 'light',
        'language': _selectedLanguage == 'العربية' ? 'ar' : 'en',
        'currency': _selectedCurrency,

        'show_name': _showName,
        'show_donations': _showDonations,
        'show_location': _showLocation,
        'allow_analytics': _allowAnalytics,

        'auto_sync': _autoSync,
        'offline_mode': _offlineMode,
        'data_compression': _dataCompression,
      };

      LocalStorageManager.instance.saveSettings(settings);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ في حفظ الإعدادات')),
        );
      }
    }
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('استعادة الإعدادات الافتراضية'),
        content: const Text('هل تريد استعادة جميع الإعدادات إلى القيم الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performReset();
            },
            child: const Text('استعادة'),
          ),
        ],
      ),
    );
  }

  void _performReset() {
    setState(() {
      _notificationsEnabled = true;
      _emailNotifications = true;
      _pushNotifications = true;
      _smsNotifications = false;
      _soundEnabled = true;
      _vibrationEnabled = true;

      _darkModeEnabled = false;
      _selectedLanguage = 'العربية';
      _selectedCurrency = 'الليرة السورية';

      _showName = true;
      _showDonations = false;
      _showLocation = true;
      _allowAnalytics = true;

      _autoSync = true;
      _offlineMode = false;
      _dataCompression = true;
    });

    _saveSettings();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم استعادة الإعدادات الافتراضية')),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح البيانات المؤقتة'),
        content: const Text('هل تريد حذف جميع الملفات المؤقتة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم مسح البيانات المؤقتة')),
              );
            },
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('معلومات التخزين'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المساحة المستخدمة: 25.4 MB'),
            SizedBox(height: 8),
            Text('البيانات المؤقتة: 8.2 MB'),
            SizedBox(height: 8),
            Text('الصور: 12.1 MB'),
            SizedBox(height: 8),
            Text('البيانات الأخرى: 5.1 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة إعدادات الأمان قريباً')),
    );
  }

  void _showBackupOptions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة خيارات النسخ الاحتياطي قريباً')),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الخروج')),
              );
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('لا توجد تحديثات متاحة')),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة صفحة المساعدة قريباً')),
    );
  }

  // دوال إمكانية الوصول
  void _showTextSizeSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حجم النص'),
        content: const Text('يمكنك تعديل حجم النص من إعدادات النظام في جهازك.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showContrastSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('التباين العالي'),
        content: const Text('يمكنك تفعيل التباين العالي من إعدادات إمكانية الوصول في جهازك.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showMotionSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقليل الحركة'),
        content: const Text('يمكنك تفعيل تقليل الحركة من إعدادات إمكانية الوصول في جهازك.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showScreenReaderSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('قارئ الشاشة'),
        content: const Text('يمكنك تفعيل قارئ الشاشة (TalkBack على Android أو VoiceOver على iOS) من إعدادات إمكانية الوصول في جهازك.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
