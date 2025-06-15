import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// نظام تحسينات UI/UX
class UIImprovements {
  // منع إنشاء كائن من هذا الكلاس
  UIImprovements._();

  // ========== تحسينات الألوان ==========

  /// الحصول على لون مع شفافية آمنة
  static Color getColorWithAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha.clamp(0.0, 1.0));
  }

  /// الحصول على لون الظل المناسب
  static Color getShadowColor(Color baseColor, {double opacity = 0.1}) {
    return baseColor.withValues(alpha: opacity);
  }

  /// الحصول على لون الحدود المناسب
  static Color getBorderColor(Color baseColor, {double opacity = 0.2}) {
    return baseColor.withValues(alpha: opacity);
  }

  // ========== تحسينات الحاويات ==========

  /// إنشاء حاوية محسنة مع ظل وحدود
  static Container buildEnhancedContainer({
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = 12,
    double borderWidth = 1,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool withShadow = true,
    double shadowBlur = 8,
    Offset shadowOffset = const Offset(0, 2),
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: shadowBlur,
                  offset: shadowOffset,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  /// إنشاء بطاقة محسنة
  static Widget buildEnhancedCard({
    required Widget child,
    VoidCallback? onTap,
    Color? backgroundColor,
    double borderRadius = 12,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    bool isSelected = false,
    bool isHoverable = true,
  }) {
    final cardColor = backgroundColor ?? AppColors.backgroundCard;
    final borderColor = isSelected
        ? AppColors.primaryGreen
        : getBorderColor(AppColors.helperGray);

    Widget card = buildEnhancedContainer(
      backgroundColor: cardColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      borderWidth: isSelected ? 2 : 1,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      child: child,
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          hoverColor: isHoverable
              ? getColorWithAlpha(AppColors.primaryGreen, 0.05)
              : null,
          child: card,
        ),
      );
    }

    return card;
  }

  // ========== تحسينات الأزرار ==========

  /// إنشاء زر محسن
  static Widget buildEnhancedButton({
    required String text,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    IconData? icon,
    double borderRadius = 12,
    EdgeInsetsGeometry? padding,
    bool isLoading = false,
    bool isOutlined = false,
    double? width,
    double? height,
  }) {
    final buttonColor = backgroundColor ?? AppColors.primaryGreen;
    final textColor = foregroundColor ?? AppColors.textOnColor;

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else if (icon != null)
          Icon(icon, size: 18, color: textColor),
        
        if ((isLoading || icon != null) && text.isNotEmpty)
          const SizedBox(width: 8),
        
        if (text.isNotEmpty)
          Text(
            text,
            style: AppTextStyles.labelLarge.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor),
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: buttonChild,
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 2,
          ),
          child: buttonChild,
        ),
      );
    }
  }

  // ========== تحسينات النصوص ==========

  /// إنشاء عنوان محسن
  static Widget buildEnhancedTitle({
    required String text,
    TextStyle? style,
    Color? color,
    int? maxLines,
    TextAlign? textAlign,
    IconData? icon,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? AppColors.primaryGreen,
            size: 24,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            text,
            style: style ?? AppTextStyles.headlineSmall.copyWith(
              color: color ?? AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
            textAlign: textAlign,
          ),
        ),
      ],
    );
  }

  /// إنشاء نص فرعي محسن
  static Widget buildEnhancedSubtitle({
    required String text,
    TextStyle? style,
    Color? color,
    int? maxLines,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      style: style ?? AppTextStyles.bodyMedium.copyWith(
        color: color ?? AppColors.textSecondary,
      ),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
    );
  }

  // ========== تحسينات التخطيط ==========

  /// إنشاء فاصل محسن
  static Widget buildEnhancedDivider({
    double height = 1,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16),
      color: color ?? getBorderColor(AppColors.helperGray),
    );
  }

  /// إنشاء مساحة فارغة محسنة
  static Widget buildEnhancedSpacer({
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height ?? AppConstants.spacingMedium,
    );
  }

  // ========== تحسينات الحالات الفارغة ==========

  /// إنشاء حالة فارغة محسنة
  static Widget buildEnhancedEmptyState({
    required IconData icon,
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
    Color? iconColor,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? AppColors.helperGray,
            ),
            buildEnhancedSpacer(height: 16),
            buildEnhancedTitle(text: title),
            buildEnhancedSpacer(height: 8),
            buildEnhancedSubtitle(
              text: message,
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              buildEnhancedSpacer(height: 24),
              buildEnhancedButton(
                text: actionText,
                onPressed: onAction,
                isOutlined: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ========== تحسينات التحميل ==========

  /// إنشاء مؤشر تحميل محسن
  static Widget buildEnhancedLoadingIndicator({
    String? message,
    Color? color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: color ?? AppColors.primaryGreen,
          ),
          if (message != null) ...[
            buildEnhancedSpacer(height: 16),
            buildEnhancedSubtitle(
              text: message,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
