import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/animations/nawa_animations.dart';
// import '../../shared/widgets/widgets.dart';

/// صفحة إنشاء حساب جديد
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String _selectedUserType = 'local';

  final List<Map<String, dynamic>> _userTypes = [
    {
      'value': 'local',
      'label': 'مقيم في سوريا',
      'icon': Icons.home,
      'description': 'أعيش داخل سوريا',
    },
    {
      'value': 'diaspora',
      'label': 'مغترب سوري',
      'icon': Icons.flight_takeoff,
      'description': 'أعيش خارج سوريا',
    },
    {
      'value': 'organization',
      'label': 'منظمة',
      'icon': Icons.business,
      'description': 'أمثل منظمة أو مؤسسة',
    },
  ];

  @override
  void initState() {
    super.initState();
    // إضافة listener لتحديث مؤشر قوة كلمة المرور
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Form(
            key: _formKey,
            child: StaggeredAnimation(
              delay: const Duration(milliseconds: 100),
              duration: NawaAnimations.normal,
              curve: NawaAnimations.easeOut,
              children: [
                const SizedBox(height: AppConstants.spacingLarge),

                // العنوان والشعار
                _buildHeader(),

                const SizedBox(height: AppConstants.spacingXLarge),

                // نوع المستخدم
                _buildUserTypeSelection(),

                const SizedBox(height: AppConstants.spacingLarge),

                // حقول الإدخال
                _buildInputFields(),

                const SizedBox(height: AppConstants.spacingLarge),

                // الشروط والأحكام
                _buildTermsCheckbox(),

                const SizedBox(height: AppConstants.spacingLarge),

                // زر إنشاء الحساب
                _buildRegisterButton(),

                const SizedBox(height: AppConstants.spacingMedium),

                // رابط تسجيل الدخول
                _buildLoginLink(),
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
                AppColors.primaryGreen,
                AppColors.primaryGreen.withValues(alpha: 0.8),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add,
            color: Colors.white,
            size: 40,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        // العنوان
        Text(
          'إنشاء حساب جديد',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppConstants.spacingSmall),
        
        // الوصف
        Text(
          'انضم لمجتمع نِواة وساهم في إعادة الإعمار',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الحساب',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        ...(_userTypes.map((type) => _buildUserTypeCard(type)).toList()),
      ],
    );
  }

  Widget _buildUserTypeCard(Map<String, dynamic> type) {
    final isSelected = _selectedUserType == type['value'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          onTap: () {
            setState(() {
              _selectedUserType = type['value'];
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primaryGreen.withValues(alpha: 0.1)
                  : AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(
                color: isSelected 
                    ? AppColors.primaryGreen
                    : AppColors.helperGray.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primaryGreen
                        : AppColors.helperGray.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    type['icon'],
                    color: isSelected ? Colors.white : AppColors.helperGray,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: AppConstants.spacingMedium),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type['label'],
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isSelected 
                              ? AppColors.primaryGreen
                              : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        type['description'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        // الاسم الكامل
        _buildTextField(
          controller: _nameController,
          label: 'الاسم الكامل',
          hint: 'أدخل اسمك الكامل',
          icon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الاسم مطلوب';
            }
            if (value.length < 3) {
              return 'الاسم يجب أن يكون 3 أحرف على الأقل';
            }
            return null;
          },
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // البريد الإلكتروني
        _buildTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          hint: 'example@email.com',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'البريد الإلكتروني مطلوب';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'البريد الإلكتروني غير صحيح';
            }
            return null;
          },
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // رقم الهاتف
        _buildTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          hint: '+963 XXX XXX XXX',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'رقم الهاتف مطلوب';
            }
            if (value.length < 10) {
              return 'رقم الهاتف غير صحيح';
            }
            return null;
          },
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // كلمة المرور
        _buildTextField(
          controller: _passwordController,
          label: 'كلمة المرور',
          hint: 'أدخل كلمة مرور قوية',
          icon: Icons.lock,
          obscureText: !_isPasswordVisible,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: AppColors.helperGray,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'كلمة المرور مطلوبة';
            }
            if (value.length < 8) {
              return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
            }
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return 'كلمة المرور يجب أن تحتوي على حروف كبيرة وصغيرة وأرقام';
            }
            return null;
          },
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // تأكيد كلمة المرور
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'تأكيد كلمة المرور',
          hint: 'أعد إدخال كلمة المرور',
          icon: Icons.lock_outline,
          obscureText: !_isConfirmPasswordVisible,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: AppColors.helperGray,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'تأكيد كلمة المرور مطلوب';
            }
            if (value != _passwordController.text) {
              return 'كلمة المرور غير متطابقة';
            }
            return null;
          },
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // مؤشر قوة كلمة المرور
        _buildPasswordStrengthIndicator(),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppColors.primaryGreen,
        ),

        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'أوافق على '),
                    TextSpan(
                      text: 'الشروط والأحكام',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' و '),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return InteractiveAnimation(
      onTap: _isLoading ? null : _handleRegister,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isLoading || !_acceptTerms
                ? [AppColors.helperGray, AppColors.helperGray]
                : [AppColors.primaryGreen, AppColors.primaryGreen.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          boxShadow: _isLoading || !_acceptTerms
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
              ? LoadingAnimation(
                  color: Colors.white,
                  size: 24,
                  type: LoadingType.dots,
                )
              : Text(
                  'إنشاء الحساب',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟ ',
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showErrorMessage('يجب الموافقة على الشروط والأحكام');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // محاكاة عملية التسجيل
      await Future.delayed(const Duration(seconds: 2));

      // TODO: تنفيذ التسجيل الحقيقي مع Firebase

      if (mounted) {
        _showSuccessMessage('تم إنشاء الحساب بنجاح!');

        // الانتقال لصفحة التحقق من الهاتف
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.phoneVerification,
          arguments: {
            'phoneNumber': _phoneController.text,
            'isNewUser': true,
          },
        );
      }

    } catch (e) {
      _showErrorMessage('حدث خطأ أثناء إنشاء الحساب. حاول مرة أخرى.');
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

  // ========== دوال مساعدة للتصميم ==========

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
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
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: AppColors.primaryGreen,
          ),
          suffixIcon: suffixIcon,
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
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    final strength = _calculatePasswordStrength(password);

    return Container(
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
          Row(
            children: [
              Icon(
                Icons.security,
                color: _getStrengthColor(strength),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'قوة كلمة المرور: ${_getStrengthText(strength)}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: _getStrengthColor(strength),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // شريط التقدم
          LinearProgressIndicator(
            value: strength / 4,
            backgroundColor: AppColors.helperGray.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor(strength)),
            minHeight: 4,
          ),

          const SizedBox(height: 8),

          // نصائح
          Text(
            _getPasswordTips(password),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength.clamp(0, 4);
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.info;
      case 4:
        return AppColors.success;
      default:
        return AppColors.helperGray;
    }
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'ضعيفة';
      case 2:
        return 'متوسطة';
      case 3:
        return 'قوية';
      case 4:
        return 'قوية جداً';
      default:
        return 'غير محددة';
    }
  }

  String _getPasswordTips(String password) {
    List<String> tips = [];

    if (password.length < 8) {
      tips.add('• يجب أن تكون 8 أحرف على الأقل');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      tips.add('• أضف حروف صغيرة (a-z)');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      tips.add('• أضف حروف كبيرة (A-Z)');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      tips.add('• أضف أرقام (0-9)');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      tips.add('• أضف رموز خاصة (!@#\$%^&*)');
    }

    if (tips.isEmpty) {
      return '✅ كلمة مرور ممتازة!';
    }

    return tips.join('\n');
  }
}
