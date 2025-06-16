import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// نوع الخطأ
enum ErrorType {
  network,          // خطأ شبكة
  validation,       // خطأ تحقق
  authentication,   // خطأ مصادقة
  permission,       // خطأ صلاحية
  server,          // خطأ خادم
  unknown,         // خطأ غير معروف
  timeout,         // انتهاء وقت
  notFound,        // غير موجود
  conflict,        // تضارب
  maintenance,     // صيانة
}

/// شدة الخطأ
enum ErrorSeverity {
  low,      // منخفض
  medium,   // متوسط
  high,     // عالي
  critical, // حرج
}

/// نظام رسائل الخطأ الواضحة
/// يوفر رسائل خطأ مفهومة وقابلة للتنفيذ
class ErrorMessages {
  ErrorMessages._();

  // ========== رسائل الأخطاء ==========

  /// رسائل الأخطاء الأساسية
  static const Map<ErrorType, Map<String, String>> _errorMessages = {
    ErrorType.network: {
      'title': 'مشكلة في الاتصال',
      'message': 'تعذر الاتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
      'action': 'إعادة المحاولة',
      'icon': 'wifi_off',
    },
    ErrorType.validation: {
      'title': 'بيانات غير صحيحة',
      'message': 'يرجى التحقق من البيانات المدخلة وإصلاح الأخطاء.',
      'action': 'تصحيح البيانات',
      'icon': 'error_outline',
    },
    ErrorType.authentication: {
      'title': 'خطأ في المصادقة',
      'message': 'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.',
      'action': 'تسجيل الدخول',
      'icon': 'lock_outline',
    },
    ErrorType.permission: {
      'title': 'غير مسموح',
      'message': 'ليس لديك صلاحية للوصول إلى هذا المحتوى.',
      'action': 'طلب الصلاحية',
      'icon': 'block',
    },
    ErrorType.server: {
      'title': 'خطأ في الخادم',
      'message': 'حدث خطأ في الخادم. نعمل على إصلاحه، يرجى المحاولة لاحقاً.',
      'action': 'المحاولة لاحقاً',
      'icon': 'dns',
    },
    ErrorType.timeout: {
      'title': 'انتهى وقت الانتظار',
      'message': 'استغرقت العملية وقتاً أطول من المتوقع. يرجى المحاولة مرة أخرى.',
      'action': 'إعادة المحاولة',
      'icon': 'schedule',
    },
    ErrorType.notFound: {
      'title': 'غير موجود',
      'message': 'المحتوى المطلوب غير موجود أو تم حذفه.',
      'action': 'العودة للرئيسية',
      'icon': 'search_off',
    },
    ErrorType.conflict: {
      'title': 'تضارب في البيانات',
      'message': 'تم تعديل البيانات من قبل مستخدم آخر. يرجى تحديث الصفحة.',
      'action': 'تحديث الصفحة',
      'icon': 'sync_problem',
    },
    ErrorType.maintenance: {
      'title': 'صيانة مجدولة',
      'message': 'الخدمة متوقفة مؤقتاً للصيانة. سنعود قريباً.',
      'action': 'المحاولة لاحقاً',
      'icon': 'build',
    },
    ErrorType.unknown: {
      'title': 'حدث خطأ غير متوقع',
      'message': 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى أو الاتصال بالدعم.',
      'action': 'إعادة المحاولة',
      'icon': 'help_outline',
    },
  };

  // ========== الحصول على رسائل الخطأ ==========

  /// الحصول على عنوان الخطأ
  static String getTitle(ErrorType type) {
    return _errorMessages[type]?['title'] ?? _errorMessages[ErrorType.unknown]!['title']!;
  }

  /// الحصول على رسالة الخطأ
  static String getMessage(ErrorType type, [String? customMessage]) {
    return customMessage ?? 
           _errorMessages[type]?['message'] ?? 
           _errorMessages[ErrorType.unknown]!['message']!;
  }

  /// الحصول على نص الإجراء
  static String getActionText(ErrorType type) {
    return _errorMessages[type]?['action'] ?? _errorMessages[ErrorType.unknown]!['action']!;
  }

  /// الحصول على أيقونة الخطأ
  static IconData getIcon(ErrorType type) {
    final iconName = _errorMessages[type]?['icon'] ?? _errorMessages[ErrorType.unknown]!['icon']!;
    return _getIconData(iconName);
  }

  /// تحويل اسم الأيقونة إلى IconData
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wifi_off': return Icons.wifi_off;
      case 'error_outline': return Icons.error_outline;
      case 'lock_outline': return Icons.lock_outline;
      case 'block': return Icons.block;
      case 'dns': return Icons.dns;
      case 'schedule': return Icons.schedule;
      case 'search_off': return Icons.search_off;
      case 'sync_problem': return Icons.sync_problem;
      case 'build': return Icons.build;
      default: return Icons.help_outline;
    }
  }

  // ========== عرض رسائل الخطأ ==========

  /// عرض رسالة خطأ في SnackBar
  static void showSnackBar(
    BuildContext context, {
    required ErrorType type,
    String? customMessage,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: _getColorForType(type),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: onAction != null
            ? SnackBarAction(
                label: actionText,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  /// عرض رسالة خطأ في حوار
  static void showErrorDialog(
    BuildContext context, {
    required ErrorType type,
    String? customMessage,
    VoidCallback? onAction,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);

    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        title: Row(
          children: [
            Icon(
              icon,
              color: _getColorForType(type),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: _getColorForType(type),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          if (onCancel != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel();
              },
              child: const Text('إلغاء'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onAction?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getColorForType(type),
              foregroundColor: Colors.white,
            ),
            child: Text(actionText),
          ),
        ],
      ),
    );
  }

  /// عرض صفحة خطأ كاملة
  static Widget fullPageError({
    required ErrorType type,
    String? customMessage,
    VoidCallback? onRetry,
    Widget? illustration,
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الرسم التوضيحي أو الأيقونة
            illustration ?? Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _getColorForType(type).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: _getColorForType(type),
              ),
            ),
            const SizedBox(height: 24),
            
            // العنوان
            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: _getColorForType(type),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
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
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(_getActionIcon(type)),
                label: Text(actionText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColorForType(type),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// عرض خطأ مضمن في البطاقة
  static Widget cardError({
    required ErrorType type,
    String? customMessage,
    VoidCallback? onRetry,
    double height = 200,
  }) {
    final title = getTitle(type);
    final message = getMessage(type, customMessage);
    final actionText = getActionText(type);
    final icon = getIcon(type);

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
          Icon(
            icon,
            size: 48,
            color: _getColorForType(type),
          ),
          const SizedBox(height: 16),
          
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: _getColorForType(type),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
          
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: Icon(_getActionIcon(type)),
              label: Text(actionText),
              style: TextButton.styleFrom(
                foregroundColor: _getColorForType(type),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ========== دوال مساعدة ==========

  /// الحصول على لون حسب نوع الخطأ
  static Color _getColorForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return AppColors.warning;
      case ErrorType.validation:
        return AppColors.error;
      case ErrorType.authentication:
        return AppColors.primaryGreen;
      case ErrorType.permission:
        return AppColors.error;
      case ErrorType.server:
        return AppColors.error;
      case ErrorType.timeout:
        return AppColors.warning;
      case ErrorType.notFound:
        return AppColors.textSecondary;
      case ErrorType.conflict:
        return AppColors.warning;
      case ErrorType.maintenance:
        return AppColors.primaryGreen;
      default:
        return AppColors.error;
    }
  }

  /// الحصول على أيقونة الإجراء
  static IconData _getActionIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
      case ErrorType.server:
      case ErrorType.timeout:
      case ErrorType.unknown:
        return Icons.refresh;
      case ErrorType.authentication:
        return Icons.login;
      case ErrorType.validation:
        return Icons.edit;
      case ErrorType.permission:
        return Icons.security;
      case ErrorType.notFound:
        return Icons.home;
      case ErrorType.conflict:
        return Icons.sync;
      case ErrorType.maintenance:
        return Icons.schedule;
      default:
        return Icons.refresh;
    }
  }

  /// تحديد نوع الخطأ من كود الحالة
  static ErrorType getTypeFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ErrorType.validation;
      case 401:
        return ErrorType.authentication;
      case 403:
        return ErrorType.permission;
      case 404:
        return ErrorType.notFound;
      case 408:
        return ErrorType.timeout;
      case 409:
        return ErrorType.conflict;
      case 500:
      case 502:
      case 503:
        return ErrorType.server;
      case 503:
        return ErrorType.maintenance;
      default:
        return ErrorType.unknown;
    }
  }

  /// تحديد نوع الخطأ من الاستثناء
  static ErrorType getTypeFromException(Exception exception) {
    final message = exception.toString().toLowerCase();

    if (message.contains('network') || message.contains('connection')) {
      return ErrorType.network;
    } else if (message.contains('timeout')) {
      return ErrorType.timeout;
    } else if (message.contains('auth')) {
      return ErrorType.authentication;
    } else if (message.contains('permission')) {
      return ErrorType.permission;
    } else {
      return ErrorType.unknown;
    }
  }

  /// إنشاء رسالة خطأ مخصصة
  static Widget customError({
    required String title,
    required String message,
    required IconData icon,
    Color? color,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (color ?? AppColors.error).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: color ?? AppColors.error,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: color ?? AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

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
                  backgroundColor: color ?? AppColors.error,
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
