import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';
// import '../../core/services/auth_service.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/widgets/widgets.dart';
import 'google_signin_widget.dart';

/// شاشة تسجيل الدخول
/// تدعم تسجيل الدخول برقم الهاتف والإيميل
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPhoneLogin = true; // true للهاتف، false للإيميل
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========== الترحيب ==========
                _buildWelcomeSection(),
                
                const SizedBox(height: AppConstants.spacingXLarge),
                
                // ========== تبديل نوع تسجيل الدخول ==========
                _buildLoginTypeToggle(),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // ========== نموذج تسجيل الدخول ==========
                _buildLoginForm(),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // ========== زر تسجيل الدخول ==========
                _buildLoginButton(),
                
                const SizedBox(height: AppConstants.spacingMedium),
                
                // ========== روابط إضافية ==========
                _buildAdditionalLinks(),

                const SizedBox(height: AppConstants.spacingLarge),

                // ========== فاصل ==========
                _buildDivider(),

                const SizedBox(height: AppConstants.spacingLarge),

                // ========== تسجيل الدخول بـ Google ==========
                _buildGoogleSignIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أهلاً بعودتك!',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'سجل دخولك عشان نكمل رحلة البناء سوا',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isPhoneLogin = true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingMedium,
                ),
                decoration: BoxDecoration(
                  color: _isPhoneLogin ? AppColors.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Text(
                  'رقم الهاتف',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: _isPhoneLogin ? AppColors.textOnColor : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isPhoneLogin = false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingMedium,
                ),
                decoration: BoxDecoration(
                  color: !_isPhoneLogin ? AppColors.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Text(
                  'الإيميل',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: !_isPhoneLogin ? AppColors.textOnColor : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    if (_isPhoneLogin) {
      return _buildPhoneLoginForm();
    } else {
      return _buildEmailLoginForm();
    }
  }

  Widget _buildPhoneLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رقم الهاتف',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s\(\)]')),
          ],
          decoration: const InputDecoration(
            hintText: '+963 912 345 678',
            prefixIcon: Icon(Icons.phone),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال رقم الهاتف';
            }
            if (!RegExp(AppConstants.phoneRegex).hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
              return 'رقم الهاتف غير صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'سنرسل لك رمز تحقق عبر رسالة نصية',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailLoginForm() {
    return Column(
      children: [
        // حقل الإيميل
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإيميل',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'example@email.com',
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الإيميل';
                }
                if (!RegExp(AppConstants.emailRegex).hasMatch(value)) {
                  return 'الإيميل غير صحيح';
                }
                return null;
              },
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        // حقل كلمة المرور
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'كلمة المرور',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال كلمة المرور';
                }
                if (value.length < 6) {
                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return NawaButton.primary(
      text: _isPhoneLogin ? 'إرسال رمز التحقق' : 'تسجيل الدخول',
      icon: _isPhoneLogin ? Icons.sms : Icons.login,
      isLoading: _isLoading,
      onPressed: _isLoading ? null : _handleLogin,
    );
  }

  Widget _buildAdditionalLinks() {
    return Column(
      children: [
        if (!_isPhoneLogin) ...[
          NawaButton.text(
            text: 'نسيت كلمة المرور؟',
            onPressed: _handleForgotPassword,
          ),
          const SizedBox(height: AppConstants.spacingSmall),
        ],

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ما عندك حساب؟ ',
              style: AppTextStyles.bodyMedium,
            ),
            NawaButton.text(
              text: 'إنشاء حساب جديد',
              onPressed: _handleSignUp,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.helperGray.withValues(alpha: 0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
          child: Text(
            'أو',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.helperGray.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return GoogleSignInWidget(
      onSuccess: () {
        _navigateToHome();
      },
      onError: (error) {
        _showErrorSnackBar(error);
      },
      buttonText: 'تسجيل الدخول بـ Google',
    );
  }

  // ========== معالجات الأحداث ==========

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isPhoneLogin) {
        await _handlePhoneLogin();
      } else {
        await _handleEmailLogin();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handlePhoneLogin() async {
    // محاكاة تسجيل الدخول بالهاتف
    await Future.delayed(const Duration(seconds: 1));
    _showVerificationDialog();
  }

  Future<void> _handleEmailLogin() async {
    // محاكاة تسجيل الدخول بالإيميل
    await Future.delayed(const Duration(seconds: 1));
    _navigateToHome();
  }

  void _handleForgotPassword() {
    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
  }

  void _handleSignUp() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  void _showVerificationDialog() {
    // TODO: عرض حوار إدخال رمز التحقق
    _showInfoSnackBar('تم إرسال رمز التحقق إلى هاتفك');
  }

  void _navigateToHome() {
    _showSuccessSnackBar('تم تسجيل الدخول بنجاح!');
    AppRoutes.pushHome(context);
  }

  // ========== الرسائل ==========

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
