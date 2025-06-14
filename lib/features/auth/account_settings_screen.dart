import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/animations/nawa_animations.dart';
import '../../shared/widgets/widgets.dart';

/// صفحة إعدادات الحساب
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _nameController = TextEditingController(text: 'أحمد محمد');
  final _emailController = TextEditingController(text: 'ahmed@example.com');
  final _phoneController = TextEditingController(text: '+963 XXX XXX XXX');
  
  bool _isLoading = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  String _selectedLanguage = 'ar';
  String _selectedTheme = 'light';

  final List<Map<String, dynamic>> _languages = [
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇾'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  ];

  final List<Map<String, dynamic>> _themes = [
    {'code': 'light', 'name': 'فاتح', 'icon': Icons.light_mode},
    {'code': 'dark', 'name': 'داكن', 'icon': Icons.dark_mode},
    {'code': 'system', 'name': 'النظام', 'icon': Icons.settings_brightness},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الحساب
            _buildAccountInfoSection(),

            const SizedBox(height: AppConstants.spacingLarge),

            // إعدادات الإشعارات
            _buildNotificationSettings(),

            const SizedBox(height: AppConstants.spacingLarge),

            // إعدادات التطبيق
            _buildAppSettings(),

            const SizedBox(height: AppConstants.spacingLarge),

            // إعدادات الأمان
            _buildSecuritySettings(),

            const SizedBox(height: AppConstants.spacingXLarge),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('إعدادات الحساب'),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: _isLoading ? null : _handleSaveSettings,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.save),
          tooltip: 'حفظ التغييرات',
        ),
      ],
    );
  }

  Widget _buildAccountInfoSection() {
    return _buildSection(
      title: 'معلومات الحساب',
      icon: Icons.person,
      children: [
        _buildInfoTile(
          title: 'الاسم',
          value: _nameController.text,
          icon: Icons.person,
          onTap: () => _showEditDialog('الاسم', _nameController),
        ),
        _buildInfoTile(
          title: 'البريد الإلكتروني',
          value: _emailController.text,
          icon: Icons.email,
          onTap: () => _showEditDialog('البريد الإلكتروني', _emailController),
        ),
        _buildInfoTile(
          title: 'رقم الهاتف',
          value: _phoneController.text,
          icon: Icons.phone,
          onTap: () => _showEditDialog('رقم الهاتف', _phoneController),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSection(
      title: 'إعدادات الإشعارات',
      icon: Icons.notifications,
      children: [
        _buildSwitchTile(
          title: 'إشعارات البريد الإلكتروني',
          subtitle: 'تلقي الإشعارات عبر البريد الإلكتروني',
          value: _emailNotifications,
          onChanged: (value) => setState(() => _emailNotifications = value),
        ),
        _buildSwitchTile(
          title: 'الإشعارات الفورية',
          subtitle: 'تلقي الإشعارات على الجهاز',
          value: _pushNotifications,
          onChanged: (value) => setState(() => _pushNotifications = value),
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return _buildSection(
      title: 'إعدادات التطبيق',
      icon: Icons.settings,
      children: [
        _buildInfoTile(
          title: 'اللغة',
          value: 'العربية',
          icon: Icons.language,
          onTap: () => _showInfoMessage('سيتم إضافة تغيير اللغة قريباً'),
        ),
        _buildInfoTile(
          title: 'المظهر',
          value: 'فاتح',
          icon: Icons.palette,
          onTap: () => _showInfoMessage('سيتم إضافة تغيير المظهر قريباً'),
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return _buildSection(
      title: 'الأمان والخصوصية',
      icon: Icons.security,
      children: [
        _buildInfoTile(
          title: 'تغيير كلمة المرور',
          value: 'تحديث كلمة مرور حسابك',
          icon: Icons.lock,
          onTap: _handleChangePassword,
        ),
        _buildInfoTile(
          title: 'التحقق بخطوتين',
          value: 'غير مفعل',
          icon: Icons.verified_user,
          onTap: () => _showInfoMessage('سيتم إضافة التحقق بخطوتين قريباً'),
        ),
      ],
    );
  }

  // ========== دوال معالجة الأحداث ==========

  Future<void> _handleSaveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _showSuccessMessage('تم حفظ الإعدادات بنجاح');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('حدث خطأ أثناء حفظ الإعدادات');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleChangePassword() {
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  void _handleTwoFactorAuth() {
    _showInfoMessage('سيتم إضافة التحقق بخطوتين قريباً');
  }

  void _handleActivityLog() {
    _showInfoMessage('سيتم إضافة سجل النشاط قريباً');
  }

  void _handleExportData() {
    _showInfoMessage('سيتم إضافة تصدير البيانات قريباً');
  }

  void _handleDeactivateAccount() {
    _showInfoMessage('سيتم إضافة إلغاء التفعيل قريباً');
  }

  void _handleDeleteAccount() {
    _showInfoMessage('سيتم إضافة حذف الحساب قريباً');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ========== دوال مساعدة للتصميم ==========

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 20),
              ),
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
          const SizedBox(height: AppConstants.spacingMedium),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(
                color: AppColors.helperGray.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryGreen, size: 24),
                const SizedBox(width: AppConstants.spacingMedium),
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
                        value,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.helperGray,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: AppColors.helperGray.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            value ? Icons.notifications_active : Icons.notifications_off,
            color: value ? AppColors.primaryGreen : AppColors.helperGray,
            size: 24,
          ),
          const SizedBox(width: AppConstants.spacingMedium),
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
    );
  }

  void _showEditDialog(String title, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('تم تحديث $title بنجاح');
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
