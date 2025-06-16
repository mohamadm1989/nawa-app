import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// نوع الحالة الفارغة
enum EmptyStateType {
  noData,           // لا توجد بيانات
  noResults,        // لا توجد نتائج بحث
  noNotifications,  // لا توجد إشعارات
  noProjects,       // لا توجد مشاريع
  noDonations,      // لا توجد تبرعات
  noFavorites,      // لا توجد مفضلة
  noHistory,        // لا يوجد تاريخ
  noMessages,       // لا توجد رسائل
  noConnection,     // لا يوجد اتصال
  maintenance,      // صيانة
  comingSoon,       // قريباً
  underConstruction, // تحت الإنشاء
}

/// نظام الحالات الفارغة
/// يوفر واجهات جذابة للحالات الفارغة
class EmptyStates {
  EmptyStates._();

  // ========== بيانات الحالات الفارغة ==========

  /// بيانات الحالات الفارغة
  static const Map<EmptyStateType, Map<String, String>> _emptyStateData = {
    EmptyStateType.noData: {
      'title': 'لا توجد بيانات',
      'message': 'لم يتم العثور على أي بيانات لعرضها حالياً.',
      'action': 'تحديث',
      'icon': 'inbox',
    },
    EmptyStateType.noResults: {
      'title': 'لا توجد نتائج',
      'message': 'لم نجد أي نتائج تطابق بحثك. جرب كلمات مختلفة أو قم بتوسيع البحث.',
      'action': 'إعادة البحث',
      'icon': 'search_off',
    },
    EmptyStateType.noNotifications: {
      'title': 'لا توجد إشعارات',
      'message': 'ستظهر إشعاراتك هنا عند وصولها. تأكد من تفعيل الإشعارات.',
      'action': 'تفعيل الإشعارات',
      'icon': 'notifications_off',
    },
    EmptyStateType.noProjects: {
      'title': 'لا توجد مشاريع',
      'message': 'لم يتم إنشاء أي مشاريع بعد. ابدأ بإنشاء مشروعك الأول.',
      'action': 'إنشاء مشروع',
      'icon': 'work_off',
    },
    EmptyStateType.noDonations: {
      'title': 'لا توجد تبرعات',
      'message': 'لم تقم بأي تبرعات بعد. ساهم في المشاريع الخيرية.',
      'action': 'تصفح المشاريع',
      'icon': 'volunteer_activism',
    },
    EmptyStateType.noFavorites: {
      'title': 'لا توجد مفضلة',
      'message': 'لم تضف أي مشاريع للمفضلة. أضف المشاريع التي تهمك.',
      'action': 'تصفح المشاريع',
      'icon': 'favorite_border',
    },
    EmptyStateType.noHistory: {
      'title': 'لا يوجد تاريخ',
      'message': 'لا يوجد تاريخ للأنشطة. ستظهر أنشطتك هنا.',
      'action': 'بدء النشاط',
      'icon': 'history',
    },
    EmptyStateType.noMessages: {
      'title': 'لا توجد رسائل',
      'message': 'صندوق الرسائل فارغ. ستصلك الرسائل هنا.',
      'action': 'إرسال رسالة',
      'icon': 'mail_outline',
    },
    EmptyStateType.noConnection: {
      'title': 'لا يوجد اتصال',
      'message': 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
      'action': 'إعادة المحاولة',
      'icon': 'wifi_off',
    },
    EmptyStateType.maintenance: {
      'title': 'صيانة مجدولة',
      'message': 'نعمل على تحسين الخدمة. سنعود قريباً بتحديثات رائعة.',
      'action': 'المحاولة لاحقاً',
      'icon': 'build',
    },
    EmptyStateType.comingSoon: {
      'title': 'قريباً',
      'message': 'هذه الميزة قيد التطوير. ترقب التحديثات القادمة.',
      'action': 'العودة',
      'icon': 'schedule',
    },
    EmptyStateType.underConstruction: {
      'title': 'تحت الإنشاء',
      'message': 'نعمل على إنشاء هذا القسم. سيكون متاحاً قريباً.',
      'action': 'العودة للرئيسية',
      'icon': 'construction',
    },
  };

  // ========== الحصول على بيانات الحالة الفارغة ==========

  /// الحصول على عنوان الحالة الفارغة
  static String getTitle(EmptyStateType type) {
    return _emptyStateData[type]?['title'] ?? _emptyStateData[EmptyStateType.noData]!['title']!;
  }

  /// الحصول على رسالة الحالة الفارغة
  static String getMessage(EmptyStateType type, [String? customMessage]) {
    return customMessage ?? 
           _emptyStateData[type]?['message'] ?? 
           _emptyStateData[EmptyStateType.noData]!['message']!;
  }

  /// الحصول على نص الإجراء
  static String getActionText(EmptyStateType type) {
    return _emptyStateData[type]?['action'] ?? _emptyStateData[EmptyStateType.noData]!['action']!;
  }

  /// الحصول على أيقونة الحالة الفارغة
  static IconData getIcon(EmptyStateType type) {
    final iconName = _emptyStateData[type]?['icon'] ?? _emptyStateData[EmptyStateType.noData]!['icon']!;
    return _getIconData(iconName);
  }

  /// تحويل اسم الأيقونة إلى IconData
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'inbox': return Icons.inbox;
      case 'search_off': return Icons.search_off;
      case 'notifications_off': return Icons.notifications_off;
      case 'work_off': return Icons.work_off;
      case 'volunteer_activism': return Icons.volunteer_activism;
      case 'favorite_border': return Icons.favorite_border;
      case 'history': return Icons.history;
      case 'mail_outline': return Icons.mail_outline;
      case 'wifi_off': return Icons.wifi_off;
      case 'build': return Icons.build;
      case 'schedule': return Icons.schedule;
      case 'construction': return Icons.construction;
      default: return Icons.inbox;
    }
  }

  // ========== عرض الحالات الفارغة ==========

  /// عرض حالة فارغة كاملة
  static Widget fullPage({
    required EmptyStateType type,
    String? customMessage,
    VoidCallback? onAction,
    Widget? illustration,
    Color? primaryColor,
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);
    final color = primaryColor ?? _getColorForType(type);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الرسم التوضيحي أو الأيقونة
            illustration ?? Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: color,
              ),
            ),
            const SizedBox(height: 32),
            
            // العنوان
            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // الرسالة
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            
            // زر الإجراء
            if (onAction != null)
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(_getActionIcon(type)),
                label: Text(actionText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// عرض حالة فارغة في بطاقة
  static Widget card({
    required EmptyStateType type,
    String? customMessage,
    VoidCallback? onAction,
    double height = 300,
    Color? primaryColor,
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);
    final color = primaryColor ?? _getColorForType(type);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          if (onAction != null) ...[
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onAction,
              icon: Icon(_getActionIcon(type)),
              label: Text(actionText),
              style: TextButton.styleFrom(
                foregroundColor: color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// عرض حالة فارغة مضغوطة
  static Widget compact({
    required EmptyStateType type,
    String? customMessage,
    VoidCallback? onAction,
    Color? primaryColor,
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);
    final color = primaryColor ?? _getColorForType(type);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: color,
          ),
          const SizedBox(height: 16),
          
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          
          if (onAction != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
              ),
              child: Text(actionText),
            ),
          ],
        ],
      ),
    );
  }

  /// عرض حالة فارغة للقائمة
  static Widget listItem({
    required EmptyStateType type,
    String? customMessage,
    VoidCallback? onAction,
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.helperGray.withValues(alpha: 0.2),
        child: Icon(
          icon,
          color: AppColors.textSecondary,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge,
      ),
      subtitle: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        maxLines: 2,
      ),
      trailing: onAction != null
          ? TextButton(
              onPressed: onAction,
              child: Text(actionText),
            )
          : null,
    );
  }

  // ========== دوال مساعدة ==========

  /// الحصول على لون حسب نوع الحالة الفارغة
  static Color _getColorForType(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.noData:
        return AppColors.textSecondary;
      case EmptyStateType.noResults:
        return AppColors.primaryGreen;
      case EmptyStateType.noNotifications:
        return AppColors.warning;
      case EmptyStateType.noProjects:
        return AppColors.primaryGreen;
      case EmptyStateType.noDonations:
        return AppColors.primaryGreen;
      case EmptyStateType.noFavorites:
        return AppColors.error;
      case EmptyStateType.noHistory:
        return AppColors.textSecondary;
      case EmptyStateType.noMessages:
        return AppColors.primaryGreen;
      case EmptyStateType.noConnection:
        return AppColors.warning;
      case EmptyStateType.maintenance:
        return AppColors.primaryGreen;
      case EmptyStateType.comingSoon:
        return AppColors.primaryGreen;
      case EmptyStateType.underConstruction:
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  /// الحصول على أيقونة الإجراء
  static IconData _getActionIcon(EmptyStateType type) {
    switch (type) {
      case EmptyStateType.noData:
        return Icons.refresh;
      case EmptyStateType.noResults:
        return Icons.search;
      case EmptyStateType.noNotifications:
        return Icons.notifications;
      case EmptyStateType.noProjects:
        return Icons.add;
      case EmptyStateType.noDonations:
        return Icons.explore;
      case EmptyStateType.noFavorites:
        return Icons.explore;
      case EmptyStateType.noHistory:
        return Icons.play_arrow;
      case EmptyStateType.noMessages:
        return Icons.send;
      case EmptyStateType.noConnection:
        return Icons.refresh;
      case EmptyStateType.maintenance:
        return Icons.schedule;
      case EmptyStateType.comingSoon:
        return Icons.arrow_back;
      case EmptyStateType.underConstruction:
        return Icons.home;
      default:
        return Icons.refresh;
    }
  }

  /// إنشاء حالة فارغة مخصصة
  static Widget custom({
    required String title,
    required String message,
    required IconData icon,
    Color? color,
    VoidCallback? onAction,
    String? actionText,
    Widget? illustration,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            illustration ?? Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: (color ?? AppColors.primaryGreen).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 50,
                color: color ?? AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color ?? AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
