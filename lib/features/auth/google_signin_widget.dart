import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
// import '../../core/services/google_auth_service.dart';
import '../../core/animations/nawa_animations.dart';

/// ويدجت تسجيل الدخول بـ Google
class GoogleSignInWidget extends StatefulWidget {
  final VoidCallback? onSuccess;
  final Function(String)? onError;
  final bool showAsButton;
  final String buttonText;

  const GoogleSignInWidget({
    super.key,
    this.onSuccess,
    this.onError,
    this.showAsButton = true,
    this.buttonText = 'تسجيل الدخول بـ Google',
  });

  @override
  State<GoogleSignInWidget> createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  // final GoogleAuthService _googleAuth = GoogleAuthService.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.showAsButton) {
      return _buildGoogleSignInButton();
    } else {
      return _buildGoogleSignInCard();
    }
  }

  Widget _buildGoogleSignInButton() {
    return InteractiveAnimation(
      onTap: _isLoading ? null : _handleGoogleSignIn,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: AppColors.helperGray.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              LoadingAnimation(
                color: AppColors.primaryGreen,
                size: 24,
                type: LoadingType.dots,
              )
            else ...[
              // شعار Google
              Icon(
                Icons.g_mobiledata,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                widget.buttonText,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignInCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
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
        children: [
          // الأيقونة
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.g_mobiledata,
                color: Colors.red,
                size: 32,
              ),
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // العنوان
          Text(
            'تسجيل الدخول السريع',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingSmall),
          
          // الوصف
          Text(
            'استخدم حساب Google الخاص بك للدخول بسرعة وأمان',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // الزر
          _buildGoogleSignInButton(),
        ],
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // محاكاة تسجيل الدخول (مؤقت)
      await Future.delayed(const Duration(seconds: 2));

      // نجح تسجيل الدخول (محاكاة)
      _showSuccessMessage('تم تسجيل الدخول بنجاح! (محاكاة)');
      widget.onSuccess?.call();

    } catch (e) {
      // فشل تسجيل الدخول
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showErrorMessage(errorMessage);
      widget.onError?.call(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        margin: const EdgeInsets.all(AppConstants.spacingMedium),
      ),
    );
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        margin: const EdgeInsets.all(AppConstants.spacingMedium),
      ),
    );
  }

  void _showInfoMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        margin: const EdgeInsets.all(AppConstants.spacingMedium),
      ),
    );
  }
}

/// ويدجت بسيط لتسجيل الدخول بـ Google
class SimpleGoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const SimpleGoogleSignInButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.text = 'Google',
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      elevation: 2,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMedium,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGreen,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.g_mobiledata,
                  color: Colors.red,
                  size: 24,
                ),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                text,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
