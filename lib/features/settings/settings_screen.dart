import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// صفحة الإعدادات
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'العربية';
  String _selectedCurrency = 'الليرة السورية';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      title: const Text('الإعدادات'),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إعدادات الحساب
          _buildSectionHeader('إعدادات الحساب', Icons.person),
          _buildAccountSettings(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // إعدادات الإشعارات
          _buildSectionHeader('الإشعارات', Icons.notifications),
          _buildNotificationSettings(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // إعدادات التطبيق
          _buildSectionHeader('إعدادات التطبيق', Icons.settings),
          _buildAppSettings(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // الخصوصية والأمان
          _buildSectionHeader('الخصوصية والأمان', Icons.security),
          _buildPrivacySettings(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // الدعم والمساعدة
          _buildSectionHeader('الدعم والمساعدة', Icons.help),
          _buildSupportSettings(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // معلومات التطبيق
          _buildSectionHeader('معلومات التطبيق', Icons.info),
          _buildAppInfo(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 24),
          const SizedBox(width: AppConstants.spacingMedium),
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.edit,
            title: 'تعديل الملف الشخصي',
            subtitle: 'تحديث معلوماتك الشخصية',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'تغيير كلمة المرور',
            subtitle: 'تحديث كلمة المرور الخاصة بك',
            onTap: _changePassword,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.phone,
            title: 'تحديث رقم الهاتف',
            subtitle: 'تغيير رقم الهاتف المرتبط بالحساب',
            onTap: _updatePhoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'تفعيل الإشعارات',
            subtitle: 'استقبال إشعارات التطبيق',
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.email,
            title: 'إشعارات البريد الإلكتروني',
            subtitle: 'استقبال إشعارات عبر البريد الإلكتروني',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.sms,
            title: 'إشعارات الرسائل النصية',
            subtitle: 'استقبال إشعارات عبر الرسائل النصية',
            value: _smsNotifications,
            onChanged: (value) => setState(() => _smsNotifications = value),
          ),
          _buildDivider(),
          _buildNavigationTile(
            icon: Icons.security,
            title: 'أذونات التطبيق',
            subtitle: 'إدارة أذونات الإشعارات والموقع والكاميرا',
            onTap: () => Navigator.pushNamed(context, '/permissions-settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'الوضع الليلي',
            subtitle: 'تفعيل المظهر الداكن',
            value: _darkModeEnabled,
            onChanged: (value) => setState(() => _darkModeEnabled = value),
          ),
          _buildDivider(),
          _buildDropdownTile(
            icon: Icons.language,
            title: 'اللغة',
            subtitle: 'اختيار لغة التطبيق',
            value: _selectedLanguage,
            items: ['العربية', 'English'],
            onChanged: (value) => setState(() => _selectedLanguage = value!),
          ),
          _buildDivider(),
          _buildDropdownTile(
            icon: Icons.attach_money,
            title: 'العملة',
            subtitle: 'اختيار العملة المفضلة',
            value: _selectedCurrency,
            items: ['الليرة السورية', 'الدولار الأمريكي', 'اليورو'],
            onChanged: (value) => setState(() => _selectedCurrency = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.privacy_tip,
            title: 'سياسة الخصوصية',
            subtitle: 'اطلع على سياسة الخصوصية',
            onTap: () => Navigator.pushNamed(context, '/privacy'),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.description,
            title: 'الشروط والأحكام',
            subtitle: 'اطلع على شروط الاستخدام',
            onTap: () => Navigator.pushNamed(context, '/terms'),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.delete_forever,
            title: 'حذف الحساب',
            subtitle: 'حذف حسابك نهائياً',
            onTap: _deleteAccount,
            textColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.help_center,
            title: 'مركز المساعدة',
            subtitle: 'الأسئلة الشائعة والدعم',
            onTap: () => Navigator.pushNamed(context, '/faq'),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.contact_support,
            title: 'تواصل معنا',
            subtitle: 'إرسال رسالة للدعم الفني',
            onTap: () => Navigator.pushNamed(context, '/support'),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.star_rate,
            title: 'تقييم التطبيق',
            subtitle: 'قيم التطبيق في المتجر',
            onTap: _rateApp,
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.info,
            title: 'عن التطبيق',
            subtitle: 'معلومات حول تطبيق نوى',
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.update,
            title: 'إصدار التطبيق',
            subtitle: 'الإصدار 1.0.0',
            onTap: _checkForUpdates,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: textColor ?? AppColors.textPrimary,
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.labelLarge,
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
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.labelLarge,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.border,
      indent: 16,
      endIndent: 16,
    );
  }

  // ========== معالجات الأحداث ==========

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة تغيير كلمة المرور قريباً')),
    );
  }

  void _updatePhoneNumber() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة تحديث رقم الهاتف قريباً')),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text('هل أنت متأكد من حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('سيتم إضافة حذف الحساب قريباً'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم فتح متجر التطبيقات قريباً')),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('أنت تستخدم أحدث إصدار من التطبيق')),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryGreen,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.helperGray,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
