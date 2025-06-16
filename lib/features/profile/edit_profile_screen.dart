import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';

/// صفحة تعديل الملف الشخصي
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  
  bool _isLoading = false;
  bool _hasChanges = false;
  String? _selectedAvatar;
  
  // البيانات الحالية
  late Map<String, dynamic> _currentUserData;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _loadCurrentData() {
    _currentUserData = UserDataManager.getSafeUserData();
    
    // تعبئة الحقول بالبيانات الحالية
    _nameController.text = _currentUserData['name'] ?? '';
    _bioController.text = _currentUserData['bio'] ?? '';
    _phoneController.text = _currentUserData['phone'] ?? '';
    _emailController.text = _currentUserData['email'] ?? '';
    _locationController.text = _currentUserData['location'] ?? '';
    _selectedAvatar = _currentUserData['avatar'];
    
    // مراقبة التغييرات
    _nameController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges = _nameController.text != (_currentUserData['name'] ?? '') ||
        _bioController.text != (_currentUserData['bio'] ?? '') ||
        _phoneController.text != (_currentUserData['phone'] ?? '') ||
        _emailController.text != (_currentUserData['email'] ?? '') ||
        _locationController.text != (_currentUserData['location'] ?? '') ||
        _selectedAvatar != _currentUserData['avatar'];
    
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 2.0,
      title: Text(
        'تعديل الملف الشخصي',
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.textOnColor,
        ),
      ),
      actions: [
        if (_hasChanges)
          TextButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: Text(
              'حفظ',
              style: AppTextStyles.buttonPrimary.copyWith(
                color: AppColors.textOnColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: AppConstants.paddingMedium,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // صورة الملف الشخصي
            _buildAvatarSection(),

            AppLayouts.largeSpacing,

            // معلومات أساسية
            _buildBasicInfoSection(),

            AppLayouts.largeSpacing,

            // معلومات الاتصال
            _buildContactInfoSection(),

            AppLayouts.largeSpacing,
            
            // معلومات إضافية
            _buildAdditionalInfoSection(),

            const SizedBox(height: 100), // مساحة للشريط السفلي
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'الصورة الشخصية',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // الصورة الحالية
          GestureDetector(
            onTap: _selectAvatar,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.primaryGreen,
                  width: 3,
                ),
              ),
              child: _selectedAvatar == null
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primaryGreen,
                    )
                  : ClipOval(
                      child: Image.network(
                        _selectedAvatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.primaryGreen,
                          );
                        },
                      ),
                    ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          TextButton.icon(
            onPressed: _selectAvatar,
            icon: const Icon(Icons.camera_alt),
            label: const Text('تغيير الصورة'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'المعلومات الأساسية',
      icon: Icons.person,
      children: [
        // الاسم
        _buildTextField(
          controller: _nameController,
          label: 'الاسم الكامل',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'الاسم مطلوب';
            }
            if (value.trim().length < 2) {
              return 'الاسم يجب أن يكون أكثر من حرفين';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // الوصف
        _buildTextField(
          controller: _bioController,
          label: 'نبذة عنك',
          icon: Icons.description_outlined,
          maxLines: 3,
          maxLength: 200,
          validator: (value) {
            if (value != null && value.length > 200) {
              return 'الوصف يجب أن يكون أقل من 200 حرف';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return _buildSection(
      title: 'معلومات الاتصال',
      icon: Icons.contact_phone,
      children: [
        // رقم الهاتف
        _buildTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                return 'رقم الهاتف غير صحيح';
              }
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // البريد الإلكتروني
        _buildTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'البريد الإلكتروني غير صحيح';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection() {
    return _buildSection(
      title: 'معلومات إضافية',
      icon: Icons.location_on,
      children: [
        // الموقع
        _buildTextField(
          controller: _locationController,
          label: 'الموقع',
          icon: Icons.location_on_outlined,
          validator: (value) {
            if (value != null && value.length > 100) {
              return 'الموقع يجب أن يكون أقل من 100 حرف';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.backgroundPrimary,
      ),
    );
  }

  Widget _buildBottomBar() {
    if (!_hasChanges) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: NawaButton.secondary(
                text: 'إلغاء',
                icon: Icons.close,
                onPressed: _isLoading ? null : _discardChanges,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: NawaButton.primary(
                text: _isLoading ? 'جاري الحفظ...' : 'حفظ التغييرات',
                icon: _isLoading ? null : Icons.save,
                onPressed: _isLoading ? null : _saveChanges,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // وظائف التفاعل
  void _selectAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAvatarSelectionSheet(),
    );
  }

  Widget _buildAvatarSelectionSheet() {
    final avatarOptions = [
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_nameController.text)}&background=4A7C59&color=fff&size=200',
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_nameController.text)}&background=E4B896&color=000&size=200',
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_nameController.text)}&background=8B7D6B&color=fff&size=200',
    ];

    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // مقبض السحب
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // العنوان
          Text(
            'اختر صورة شخصية',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // خيارات الصور
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: avatarOptions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // خيار إزالة الصورة
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = null;
                        _onFieldChanged();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error.withValues(alpha: 0.1),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: const Icon(
                        Icons.person_off,
                        color: AppColors.error,
                        size: 40,
                      ),
                    ),
                  );
                }

                final avatarUrl = avatarOptions[index - 1];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = avatarUrl;
                      _onFieldChanged();
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedAvatar == avatarUrl
                            ? AppColors.primaryGreen
                            : AppColors.border,
                        width: _selectedAvatar == avatarUrl ? 3 : 1,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryGreen.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.person,
                              color: AppColors.primaryGreen,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // تحضير البيانات المحدثة
      final updates = <String, dynamic>{};

      if (_nameController.text.trim() != (_currentUserData['name'] ?? '')) {
        updates['name'] = _nameController.text.trim();
      }

      if (_bioController.text.trim() != (_currentUserData['bio'] ?? '')) {
        updates['bio'] = _bioController.text.trim();
      }

      if (_phoneController.text.trim() != (_currentUserData['phone'] ?? '')) {
        updates['phone'] = _phoneController.text.trim();
      }

      if (_emailController.text.trim() != (_currentUserData['email'] ?? '')) {
        updates['email'] = _emailController.text.trim();
      }

      if (_locationController.text.trim() != (_currentUserData['location'] ?? '')) {
        updates['location'] = _locationController.text.trim();
      }

      if (_selectedAvatar != _currentUserData['avatar']) {
        updates['avatar'] = _selectedAvatar;
      }

      // حفظ التحديثات
      if (updates.isNotEmpty) {
        final updatedData = UserDataManager.updateProfile(updates);
        _currentUserData = updatedData;
      }

      // إظهار رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التغييرات بنجاح'),
            backgroundColor: AppColors.success,
          ),
        );

        // العودة للصفحة السابقة
        Navigator.pop(context, true); // true يعني تم الحفظ
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء حفظ التغييرات'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _discardChanges() {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تجاهل التغييرات؟'),
          content: const Text('سيتم فقدان جميع التغييرات غير المحفوظة'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الحوار
                Navigator.pop(context); // العودة للصفحة السابقة
              },
              child: const Text('تجاهل'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
