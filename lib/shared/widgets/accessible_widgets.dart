import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// زر يدعم إمكانية الوصول بالكامل
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final String? semanticLabel;
  final String? tooltip;
  final IconData? icon;
  final bool isLoading;
  final bool isPrimary;

  const AccessibleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.semanticLabel,
    this.tooltip,
    this.icon,
    this.isLoading = false,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSemanticLabel = semanticLabel ?? text;
    final effectiveTooltip = tooltip ?? text;
    
    // التحقق من التباين
    final backgroundColor = isPrimary ? AppColors.primaryGreen : AppColors.backgroundCard;
    final foregroundColor = isPrimary ? AppColors.textOnColor : AppColors.textPrimary;
    
    final hasValidContrast = AccessibilityHelper.isValidContrast(
      foregroundColor, 
      backgroundColor,
    );

    // تعديل الألوان إذا كان التباين ضعيفاً
    final finalForegroundColor = hasValidContrast 
        ? foregroundColor 
        : AccessibilityHelper.getContrastingColor(backgroundColor);

    return Semantics(
      label: isLoading ? 'جاري التحميل' : effectiveSemanticLabel,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: Tooltip(
        message: effectiveTooltip,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: AccessibilityConstants.minTouchTargetSize,
            minHeight: AccessibilityConstants.minTouchTargetSize,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : () {
              AccessibilityHelper.provideTactileFeedback(AccessibilityHapticFeedback.lightImpact);
              AccessibilityHelper.announceToScreenReader(context, 'تم الضغط على $text');
              onPressed?.call();
            },
            style: (style ?? (isPrimary 
                ? ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: finalForegroundColor,
                  )
                : OutlinedButton.styleFrom(
                    foregroundColor: finalForegroundColor,
                  ))).copyWith(
              minimumSize: WidgetStateProperty.all(
                const Size(
                  AccessibilityConstants.minTouchTargetSize,
                  AccessibilityConstants.minTouchTargetSize,
                ),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.all(AccessibilityConstants.minInteractivePadding),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: AccessibilityConstants.minFontSize,
                    height: AccessibilityConstants.minFontSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(finalForegroundColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: AccessibilityHelper.getAdaptiveFontSize(context, 18),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: AccessibilityHelper.createAdaptiveTextStyle(
                          context,
                          TextStyle(
                            fontSize: AccessibilityConstants.preferredFontSize,
                            fontWeight: FontWeight.w600,
                            color: finalForegroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// حقل نص يدعم إمكانية الوصول
class AccessibleTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool required;
  final bool enabled;
  final int? maxLines;
  final String? semanticLabel;

  const AccessibleTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.obscureText = false,
    this.keyboardType,
    this.required = false,
    this.enabled = true,
    this.maxLines = 1,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = semanticLabel ?? labelText ?? hintText ?? 'حقل نص';
    final requiredLabel = required ? '$effectiveLabel (مطلوب)' : effectiveLabel;
    
    return Semantics(
      label: requiredLabel,
      textField: true,
      enabled: enabled,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AccessibilityConstants.minTouchTargetSize,
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: () {
            AccessibilityHelper.provideTactileFeedback(AccessibilityHapticFeedback.selectionClick);
            onTap?.call();
          },
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          style: AccessibilityHelper.createAdaptiveTextStyle(
            context,
            const TextStyle(fontSize: AccessibilityConstants.preferredFontSize),
          ),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            filled: true,
            fillColor: enabled ? AppColors.backgroundCard : AppColors.helperGray.withValues(alpha: 0.1),
            contentPadding: const EdgeInsets.all(AccessibilityConstants.preferredInteractivePadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: AppColors.border,
                width: AppConstants.borderWidthThin,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: AppColors.border,
                width: AppConstants.borderWidthThin,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: AppColors.primaryGreen,
                width: AppConstants.borderWidthMedium,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              borderSide: BorderSide(
                color: AppColors.error,
                width: AppConstants.borderWidthThin,
              ),
            ),
            labelStyle: AccessibilityHelper.createAdaptiveTextStyle(
              context,
              AppTextStyles.labelMedium,
            ),
            hintStyle: AccessibilityHelper.createAdaptiveTextStyle(
              context,
              AppTextStyles.hint,
            ),
            helperStyle: AccessibilityHelper.createAdaptiveTextStyle(
              context,
              AppTextStyles.bodySmall,
            ),
            errorStyle: AccessibilityHelper.createAdaptiveTextStyle(
              context,
              AppTextStyles.error,
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة تدعم إمكانية الوصول
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final String? tooltip;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final bool selected;
  final bool enabled;

  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.tooltip,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.selected = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.backgroundCard;
    
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      selected: selected,
      enabled: enabled,
      child: Tooltip(
        message: tooltip ?? semanticLabel ?? '',
        child: Container(
          margin: margin ?? const EdgeInsets.all(8),
          constraints: const BoxConstraints(
            minHeight: AccessibilityConstants.minTouchTargetSize,
          ),
          child: Material(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            elevation: selected ? 4 : 2,
            child: InkWell(
              onTap: enabled ? () {
                AccessibilityHelper.provideTactileFeedback(AccessibilityHapticFeedback.lightImpact);
                if (semanticLabel != null) {
                  AccessibilityHelper.announceToScreenReader(context, 'تم تحديد $semanticLabel');
                }
                onTap?.call();
              } : null,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: Container(
                padding: padding ?? const EdgeInsets.all(AccessibilityConstants.preferredInteractivePadding),
                decoration: selected
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 2,
                        ),
                      )
                    : null,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// أيقونة تدعم إمكانية الوصول
class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;
  final double? size;
  final Color? color;
  final String? tooltip;

  const AccessibleIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.onTap,
    this.size,
    this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? AccessibilityHelper.getAdaptiveFontSize(context, 24);
    final effectiveColor = color ?? AppColors.textPrimary;
    
    // التحقق من التباين
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final hasValidContrast = AccessibilityHelper.isValidContrast(effectiveColor, backgroundColor);
    final finalColor = hasValidContrast 
        ? effectiveColor 
        : AccessibilityHelper.getContrastingColor(backgroundColor);

    return AccessibilityHelper.createAccessibleTouchTarget(
      width: effectiveSize + 16,
      height: effectiveSize + 16,
      onTap: onTap,
      semanticLabel: semanticLabel,
      tooltip: tooltip ?? semanticLabel,
      child: Icon(
        icon,
        size: effectiveSize,
        color: finalColor,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

/// نص يدعم إمكانية الوصول
class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticLabel;
  final bool isHeader;
  final bool isImportant;

  const AccessibleText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.semanticLabel,
    this.isHeader = false,
    this.isImportant = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    final adaptiveStyle = AccessibilityHelper.createAdaptiveTextStyle(context, baseStyle);
    
    // التحقق من التباين
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = adaptiveStyle.color ?? AppColors.textPrimary;
    final hasValidContrast = AccessibilityHelper.isValidContrast(textColor, backgroundColor);
    
    final finalStyle = hasValidContrast 
        ? adaptiveStyle 
        : adaptiveStyle.copyWith(
            color: AccessibilityHelper.getContrastingColor(backgroundColor),
          );

    return Semantics(
      label: semanticLabel ?? text,
      header: isHeader,
      liveRegion: isImportant,
      child: Text(
        text,
        style: finalStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// مفتاح تبديل يدعم إمكانية الوصول
class AccessibleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final String? semanticLabel;
  final bool enabled;

  const AccessibleSwitch({
    super.key,
    required this.value,
    this.onChanged,
    required this.label,
    this.semanticLabel,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = semanticLabel ?? label;
    final stateLabel = value ? 'مفعل' : 'معطل';
    final fullLabel = '$effectiveLabel، $stateLabel';

    return Semantics(
      label: fullLabel,
      toggled: value,
      enabled: enabled,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AccessibilityConstants.minTouchTargetSize,
        ),
        child: SwitchListTile(
          title: AccessibleText(
            label,
            style: AccessibilityHelper.createAdaptiveTextStyle(
              context,
              const TextStyle(fontSize: AccessibilityConstants.preferredFontSize),
            ),
          ),
          value: value,
          onChanged: enabled ? (newValue) {
            AccessibilityHelper.provideTactileFeedback(AccessibilityHapticFeedback.selectionClick);
            final newStateLabel = newValue ? 'مفعل' : 'معطل';
            AccessibilityHelper.announceToScreenReader(context, '$label $newStateLabel');
            onChanged?.call(newValue);
          } : null,
          activeColor: AppColors.primaryGreen,
          contentPadding: const EdgeInsets.all(AccessibilityConstants.minInteractivePadding),
        ),
      ),
    );
  }
}
