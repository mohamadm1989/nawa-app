import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// تخطيطات الصفحات المشتركة لضمان الاتساق
class AppLayouts {
  // منع إنشاء كائن من هذا الكلاس
  AppLayouts._();

  // ========== تخطيطات الصفحات الأساسية ==========
  
  /// صفحة أساسية مع شريط تطبيق
  static Widget basicPage({
    required String title,
    required Widget body,
    List<Widget>? actions,
    Widget? floatingActionButton,
    bool showBackButton = true,
  }) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        automaticallyImplyLeading: showBackButton,
      ),
      body: SafeArea(
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  /// صفحة مع تمرير
  static Widget scrollablePage({
    required String title,
    required List<Widget> children,
    List<Widget>? actions,
    Widget? floatingActionButton,
    bool showBackButton = true,
    EdgeInsets? padding,
  }) {
    return basicPage(
      title: title,
      actions: actions,
      floatingActionButton: floatingActionButton,
      showBackButton: showBackButton,
      body: SingleChildScrollView(
        padding: padding ?? AppConstants.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  /// صفحة مع قائمة
  static Widget listPage({
    required String title,
    required List<Widget> items,
    List<Widget>? actions,
    Widget? floatingActionButton,
    bool showBackButton = true,
    EdgeInsets? padding,
  }) {
    return basicPage(
      title: title,
      actions: actions,
      floatingActionButton: floatingActionButton,
      showBackButton: showBackButton,
      body: ListView.separated(
        padding: padding ?? AppConstants.paddingMedium,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: AppConstants.spacingMedium,
        ),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }

  // ========== تخطيطات الأقسام ==========
  
  /// قسم مع عنوان
  static Widget section({
    required String title,
    required List<Widget> children,
    EdgeInsets? padding,
    Widget? trailing,
  }) {
    return Container(
      padding: padding ?? AppConstants.paddingMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.headlineSmall,
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          ...children,
        ],
      ),
    );
  }

  /// قسم مع كرت
  static Widget cardSection({
    required String title,
    required List<Widget> children,
    Widget? trailing,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: section(
        title: title,
        trailing: trailing,
        children: children,
      ),
    );
  }

  // ========== تخطيطات الشبكة ==========
  
  /// شبكة من العناصر
  static Widget gridLayout({
    required List<Widget> children,
    int crossAxisCount = 2,
    double crossAxisSpacing = AppConstants.spacingMedium,
    double mainAxisSpacing = AppConstants.spacingMedium,
    EdgeInsets? padding,
  }) {
    return GridView.count(
      padding: padding ?? AppConstants.paddingMedium,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  // ========== تخطيطات الإحصائيات ==========
  
  /// بطاقة إحصائية
  static Widget statisticCard({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    String? subtitle,
  }) {
    final cardColor = color ?? AppColors.primaryGreen;
    
    return Container(
      padding: AppConstants.paddingMedium,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: cardColor.withValues(alpha: 0.3),
          width: AppConstants.borderWidthThin,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: cardColor,
                size: AppConstants.iconSizeMedium,
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            value,
            style: AppTextStyles.numberLarge.copyWith(color: cardColor),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.spacingXSmall),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  // ========== تخطيطات الحالات الفارغة ==========
  
  /// حالة فارغة
  static Widget emptyState({
    required IconData icon,
    required String title,
    required String message,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: AppConstants.paddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppConstants.iconSizeXLarge * 2,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppConstants.spacingLarge),
              action,
            ],
          ],
        ),
      ),
    );
  }

  /// حالة تحميل
  static Widget loadingState({
    String? message,
  }) {
    return Center(
      child: Padding(
        padding: AppConstants.paddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primaryGreen,
            ),
            if (message != null) ...[
              const SizedBox(height: AppConstants.spacingLarge),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// حالة خطأ
  static Widget errorState({
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: AppConstants.paddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppConstants.iconSizeXLarge * 2,
              color: AppColors.error,
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppConstants.spacingLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.textOnColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ========== مسافات متسقة ==========
  
  /// مسافة صغيرة
  static Widget get smallSpacing => const SizedBox(
    height: AppConstants.spacingSmall,
  );

  /// مسافة متوسطة
  static Widget get mediumSpacing => const SizedBox(
    height: AppConstants.spacingMedium,
  );

  /// مسافة كبيرة
  static Widget get largeSpacing => const SizedBox(
    height: AppConstants.spacingLarge,
  );

  /// مسافة أفقية صغيرة
  static Widget get smallHorizontalSpacing => const SizedBox(
    width: AppConstants.spacingSmall,
  );

  /// مسافة أفقية متوسطة
  static Widget get mediumHorizontalSpacing => const SizedBox(
    width: AppConstants.spacingMedium,
  );

  /// مسافة أفقية كبيرة
  static Widget get largeHorizontalSpacing => const SizedBox(
    width: AppConstants.spacingLarge,
  );
}
