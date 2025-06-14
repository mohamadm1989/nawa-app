import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
// import '../../core/animations/nawa_animations.dart';
// import '../../shared/widgets/widgets.dart';

/// صفحة استعادة كلمة المرور
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.spacingLarge),
                
                // العنوان والشعار
                _buildHeader(),
                
                const SizedBox(height: AppConstants.spacingXLarge),
                
                if (!_emailSent) ...[
                  // نموذج إدخال البريد الإلكتروني
                  _buildEmailForm(),
                ] else ...[
                  // رسالة تأكيد الإرسال
                  _buildEmailSentMessage(),
                ],
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // زر العودة لتسجيل الدخول
                _buildBackToLoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // الشعار
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.info,
                AppColors.info.withValues(alpha: 0.8),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.info.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.lock_reset,
            color: Colors.white,
            size: 40,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        // العنوان
        Text(
          _emailSent ? 'تم إرسال الرابط!' : 'استعادة كلمة المرور',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppConstants.spacingSmall),
        
        // الوصف
        Text(
          _emailSent 
              ? 'تحقق من بريدك الإلكتروني واتبع التعليمات'
              : 'أدخل بريدك الإلكتروني وسنرسل لك رابط استعادة كلمة المرور',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        // البريد الإلكتروني
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              labelText: 'البريد الإلكتروني',
              hintText: 'أدخل بريدك الإلكتروني',
              prefixIcon: Icon(
                Icons.email,
                color: AppColors.primaryGreen,
              ),
              suffixIcon: _emailController.text.isNotEmpty
                  ? Icon(
                      _isValidEmail(_emailController.text)
                          ? Icons.check_circle
                          : Icons.error,
                      color: _isValidEmail(_emailController.text)
                          ? AppColors.success
                          : AppColors.error,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                borderSide: BorderSide(
                  color: AppColors.helperGray.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                borderSide: BorderSide(
                  color: AppColors.helperGray.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                borderSide: BorderSide(
                  color: AppColors.primaryGreen,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'البريد الإلكتروني مطلوب';
              }
              if (!_isValidEmail(value)) {
                return 'البريد الإلكتروني غير صحيح';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingLarge),
        
        // زر الإرسال
        _buildSendButton(),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        // معلومات إضافية
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            border: Border.all(
              color: AppColors.info.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              Expanded(
                child: Text(
                  'سيتم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني خلال دقائق قليلة',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailSentMessage() {
    return Column(
      children: [
        // أيقونة النجاح
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.mark_email_read,
            color: AppColors.success,
            size: 50,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingLarge),
        
        // رسالة النجاح
        Text(
          'تم إرسال رابط استعادة كلمة المرور إلى:',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppConstants.spacingSmall),
        
        // البريد الإلكتروني
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMedium,
            vertical: AppConstants.spacingSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          ),
          child: Text(
            _emailController.text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingLarge),
        
        // تعليمات
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            border: Border.all(
              color: AppColors.helperGray.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الخطوات التالية:',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              _buildStep('1', 'تحقق من صندوق الوارد في بريدك الإلكتروني'),
              _buildStep('2', 'اضغط على رابط استعادة كلمة المرور'),
              _buildStep('3', 'أدخل كلمة المرور الجديدة'),
              _buildStep('4', 'سجل الدخول بكلمة المرور الجديدة'),
            ],
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingLarge),
        
        // زر إعادة الإرسال
        _buildResendButton(),
      ],
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleSendResetEmail,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isLoading
                ? [AppColors.helperGray, AppColors.helperGray]
                : [AppColors.primaryGreen, AppColors.primaryGreen.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'إرسال رابط الاستعادة',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildResendButton() {
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _handleSendResetEmail,
      icon: Icon(
        Icons.refresh,
        color: _isLoading ? AppColors.helperGray : AppColors.primaryGreen,
        size: 20,
      ),
      label: Text(
        'إعادة الإرسال',
        style: AppTextStyles.labelMedium.copyWith(
          color: _isLoading ? AppColors.helperGray : AppColors.primaryGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLarge,
          vertical: AppConstants.spacingMedium,
        ),
        side: BorderSide(
          color: _isLoading ? AppColors.helperGray : AppColors.primaryGreen,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'تذكرت كلمة المرور؟ ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          },
          child: Text(
            'تسجيل الدخول',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSendResetEmail() async {
    if (!_emailSent && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // محاكاة إرسال البريد الإلكتروني
      await Future.delayed(const Duration(seconds: 2));

      // TODO: تنفيذ إرسال البريد الإلكتروني الحقيقي مع Firebase

      if (mounted) {
        setState(() {
          _emailSent = true;
        });

        _showSuccessMessage(
          _emailSent
              ? 'تم إعادة إرسال الرابط بنجاح!'
              : 'تم إرسال رابط استعادة كلمة المرور!'
        );
      }

    } catch (e) {
      if (mounted) {
        _showErrorMessage('حدث خطأ أثناء إرسال البريد الإلكتروني. حاول مرة أخرى.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  // ========== دوال مساعدة ==========

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
