import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// صفحة الدعم الفني
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  String _selectedCategory = 'مشكلة تقنية';
  String _selectedPriority = 'متوسط';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'مشكلة تقنية',
    'مشكلة في الدفع',
    'مشكلة في المشاريع',
    'اقتراح تحسين',
    'شكوى',
    'أخرى',
  ];

  final List<String> _priorities = [
    'منخفض',
    'متوسط',
    'عالي',
    'عاجل',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      title: const Text('الدعم الفني'),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رسالة ترحيبية
          _buildWelcomeMessage(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // طرق التواصل السريع
          _buildQuickContactMethods(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // نموذج إرسال رسالة
          _buildContactForm(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // معلومات إضافية
          _buildAdditionalInfo(),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.support_agent, color: Colors.white, size: 32),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Text(
                  'نحن هنا لمساعدتك',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'فريق الدعم الفني في نوى مستعد لمساعدتك في أي وقت. لا تتردد في التواصل معنا لأي استفسار أو مشكلة.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طرق التواصل السريع',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        
        Row(
          children: [
            Expanded(
              child: _buildContactMethodCard(
                icon: Icons.phone,
                title: 'اتصال مباشر',
                subtitle: '+963 11 123 4567',
                color: AppColors.primaryGreen,
                onTap: _makePhoneCall,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: _buildContactMethodCard(
                icon: Icons.email,
                title: 'البريد الإلكتروني',
                subtitle: 'support@nawa.sy',
                color: Colors.blue,
                onTap: _sendEmail,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        Row(
          children: [
            Expanded(
              child: _buildContactMethodCard(
                icon: Icons.chat,
                title: 'الدردشة المباشرة',
                subtitle: 'متاح 24/7',
                color: Colors.green,
                onTap: _startLiveChat,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: _buildContactMethodCard(
                icon: Icons.help_center,
                title: 'الأسئلة الشائعة',
                subtitle: 'إجابات سريعة',
                color: Colors.orange,
                onTap: () => Navigator.pushNamed(context, '/faq'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إرسال رسالة للدعم الفني',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            
            // الاسم
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'الاسم الكامل *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال الاسم';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // البريد الإلكتروني
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني *',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال البريد الإلكتروني';
                }
                if (!value.contains('@')) {
                  return 'يرجى إدخال بريد إلكتروني صحيح';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // فئة المشكلة
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'فئة المشكلة',
                prefixIcon: Icon(Icons.category),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // الأولوية
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'الأولوية',
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: _priorities.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // موضوع الرسالة
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'موضوع الرسالة *',
                prefixIcon: Icon(Icons.subject),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال موضوع الرسالة';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // محتوى الرسالة
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'تفاصيل المشكلة *',
                prefixIcon: Icon(Icons.message),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال تفاصيل المشكلة';
                }
                if (value.trim().length < 10) {
                  return 'يرجى إدخال تفاصيل أكثر (10 أحرف على الأقل)';
                }
                return null;
              },
            ),
            
            const SizedBox(height: AppConstants.spacingLarge),
            
            // زر الإرسال
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSupportRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('إرسال الرسالة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات مهمة',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          
          _buildInfoItem(
            icon: Icons.schedule,
            title: 'أوقات العمل',
            description: 'الأحد - الخميس: 9:00 ص - 6:00 م',
          ),
          
          _buildInfoItem(
            icon: Icons.reply,
            title: 'وقت الاستجابة',
            description: 'نرد عادة خلال 24 ساعة',
          ),
          
          _buildInfoItem(
            icon: Icons.language,
            title: 'اللغات المدعومة',
            description: 'العربية والإنجليزية',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== معالجات الأحداث ==========

  void _makePhoneCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم فتح تطبيق الهاتف قريباً')),
    );
  }

  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم فتح تطبيق البريد الإلكتروني قريباً')),
    );
  }

  void _startLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة الدردشة المباشرة قريباً')),
    );
  }

  Future<void> _submitSupportRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // محاكاة إرسال الرسالة
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    // مسح النموذج
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();

    // إظهار رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال رسالتك بنجاح! سنرد عليك قريباً.'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
