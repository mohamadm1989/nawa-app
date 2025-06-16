import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// زر مخصص لتطبيق نِواة
/// يطبق نظام التصميم المحدد
class NawaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final NawaButtonType type;
  final NawaButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const NawaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = NawaButtonType.primary,
    this.size = NawaButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  /// زر أساسي
  const NawaButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = NawaButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : type = NawaButtonType.primary;

  /// زر ثانوي
  const NawaButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = NawaButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  }) : type = NawaButtonType.secondary;

  /// زر نص
  const NawaButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = NawaButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : type = NawaButtonType.text;

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (type) {
      case NawaButtonType.primary:
        button = _buildElevatedButton(context);
        break;
      case NawaButtonType.secondary:
        button = _buildOutlinedButton(context);
        break;
      case NawaButtonType.text:
        button = _buildTextButton(context);
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildElevatedButton(BuildContext context) {
    return InteractionFeedback.createTapEffect(
      onTap: isLoading ? null : () {
        InteractionFeedback.haptic(InteractionType.tap);
        onPressed?.call();
      },
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          minimumSize: Size(0, _getButtonHeight()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          elevation: 2,
          shadowColor: AppColors.shadowLight,
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return InteractionFeedback.createTapEffect(
      onTap: isLoading ? null : () {
        InteractionFeedback.haptic(InteractionType.tap);
        onPressed?.call();
      },
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(
            color: AppColors.primaryGreen,
            width: AppConstants.borderWidthMedium,
          ),
          minimumSize: Size(0, _getButtonHeight()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        minimumSize: Size(0, _getButtonHeight()),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return LoadingIndicators.button(
        size: 20,
        color: type == NawaButtonType.primary
            ? AppColors.textOnColor
            : AppColors.primaryGreen,
      );
    }

    if (icon != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl, // للعربية
            children: [
              Flexible(
                child: Text(
                  text,
                  style: _getTextStyle(context),
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: AppConstants.spacingSmall),
              Icon(icon, size: _getIconSize()),
            ],
          );
        },
      );
    }

    return Text(
      text,
      style: _getTextStyle(context),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    switch (size) {
      case NawaButtonSize.small:
        return AppTextStyles.labelMedium;
      case NawaButtonSize.medium:
        return AppTextStyles.labelLarge;
      case NawaButtonSize.large:
        return AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600);
    }
  }

  double _getButtonHeight() {
    switch (size) {
      case NawaButtonSize.small:
        return 36.0;
      case NawaButtonSize.medium:
        return AppConstants.buttonHeight;
      case NawaButtonSize.large:
        return 56.0;
    }
  }

  double _getIconSize() {
    switch (size) {
      case NawaButtonSize.small:
        return 16.0;
      case NawaButtonSize.medium:
        return 20.0;
      case NawaButtonSize.large:
        return 24.0;
    }
  }
}

/// أنواع الأزرار
enum NawaButtonType {
  primary,   // زر أساسي
  secondary, // زر ثانوي
  text,      // زر نص
}

/// أحجام الأزرار
enum NawaButtonSize {
  small,  // صغير
  medium, // متوسط
  large,  // كبير
}
