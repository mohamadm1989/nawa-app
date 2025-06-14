import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/services/permissions_service.dart';
import '../../shared/widgets/widgets.dart';

/// صفحة إعدادات الأذونات
class PermissionsSettingsScreen extends StatefulWidget {
  const PermissionsSettingsScreen({super.key});

  @override
  State<PermissionsSettingsScreen> createState() => _PermissionsSettingsScreenState();
}

class _PermissionsSettingsScreenState extends State<PermissionsSettingsScreen> {
  Map<String, bool> _permissions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAllPermissions();
  }

  /// التحقق من جميع الأذونات
  Future<void> _checkAllPermissions() async {
    setState(() => _isLoading = true);
    
    try {
      _permissions = await PermissionsService.instance.checkAllEssentialPermissions();
    } catch (e) {
      debugPrint('خطأ في التحقق من الأذونات: $e');
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('إعدادات الأذونات'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _checkAllPermissions,
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث الأذونات',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildPermissionsList(),
                  const SizedBox(height: 24),
                  _buildRequestAllButton(),
                  const SizedBox(height: 16),
                  _buildOpenSettingsButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.1),
            AppColors.secondaryBeige.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.security,
                  color: AppColors.primaryGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أذونات التطبيق',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'إدارة أذونات التطبيق للحصول على أفضل تجربة',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأذونات المطلوبة',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPermissionCard(
          icon: Icons.notifications,
          title: 'الإشعارات',
          description: 'للحصول على إشعارات فورية حول التبرعات والمشاريع',
          isGranted: _permissions['notifications'] ?? false,
          onTap: () => _requestPermission('notifications'),
        ),
        const SizedBox(height: 12),
        _buildPermissionCard(
          icon: Icons.location_on,
          title: 'الموقع',
          description: 'لعرض المشاريع القريبة منك على الخريطة',
          isGranted: _permissions['location'] ?? false,
          onTap: () => _requestPermission('location'),
        ),
        const SizedBox(height: 12),
        _buildPermissionCard(
          icon: Icons.camera_alt,
          title: 'الكاميرا',
          description: 'لالتقاط صور المشاريع ورفع المستندات',
          isGranted: _permissions['camera'] ?? false,
          onTap: () => _requestPermission('camera'),
        ),
      ],
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGranted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.helperGray.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isGranted
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.helperGray.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isGranted ? AppColors.success : AppColors.helperGray,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isGranted ? Icons.check_circle : Icons.cancel,
                  color: isGranted ? AppColors.success : AppColors.error,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isGranted ? 'مُفعل' : 'غير مُفعل',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isGranted ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: isGranted
            ? const Icon(
                Icons.check_circle,
                color: AppColors.success,
              )
            : IconButton(
                onPressed: onTap,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryGreen,
                ),
              ),
        onTap: isGranted ? null : onTap,
      ),
    );
  }

  Widget _buildRequestAllButton() {
    final hasUngranted = _permissions.values.any((granted) => !granted);
    
    if (!hasUngranted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.verified,
              color: AppColors.success,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'جميع الأذونات مُفعلة! 🎉',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _requestAllPermissions,
        icon: const Icon(Icons.security),
        label: const Text('طلب جميع الأذونات'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildOpenSettingsButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => PermissionsService.instance.openAppSettings(),
        icon: const Icon(Icons.settings),
        label: const Text('فتح إعدادات التطبيق'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(color: AppColors.primaryGreen),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// طلب إذن محدد
  Future<void> _requestPermission(String permissionType) async {
    PermissionResult result;
    
    switch (permissionType) {
      case 'notifications':
        result = await PermissionsService.instance.requestNotificationPermission();
        break;
      case 'location':
        result = await PermissionsService.instance.requestLocationPermission();
        break;
      case 'camera':
        result = await PermissionsService.instance.requestCameraPermission();
        break;
      default:
        return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.isGranted ? AppColors.success : AppColors.error,
        ),
      );
    }

    // تحديث الأذونات
    await _checkAllPermissions();
  }

  /// طلب جميع الأذونات
  Future<void> _requestAllPermissions() async {
    final results = await PermissionsService.instance.requestEssentialPermissions();
    
    final grantedCount = results.values.where((result) => result.isGranted).length;
    final totalCount = results.length;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم منح $grantedCount من $totalCount أذونات'),
          backgroundColor: grantedCount == totalCount ? AppColors.success : AppColors.warning,
        ),
      );
    }

    // تحديث الأذونات
    await _checkAllPermissions();
  }
}
