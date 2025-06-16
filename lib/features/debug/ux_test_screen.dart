import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';

/// شاشة اختبار تجربة المستخدم
/// تعرض عينات من تحسينات UX
class UXTestScreen extends StatefulWidget {
  const UXTestScreen({super.key});

  @override
  State<UXTestScreen> createState() => _UXTestScreenState();
}

class _UXTestScreenState extends State<UXTestScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmpty = false;
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('اختبار تجربة المستخدم'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInteractionSection(),
            const SizedBox(height: 24),
            _buildLoadingSection(),
            const SizedBox(height: 24),
            _buildErrorSection(),
            const SizedBox(height: 24),
            _buildEmptyStateSection(),
            const SizedBox(height: 24),
            _buildAnimationSection(),
            const SizedBox(height: 24),
            _buildFeedbackSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التفاعل البصري',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // أزرار مع تفاعل محسّن
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                InteractionFeedback.createTapEffect(
                  onTap: () => _showFeedback('تم الضغط على الزر الأساسي'),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('زر أساسي'),
                  ),
                ),
                
                InteractionFeedback.createTapEffect(
                  onTap: () => _showFeedback('تم الضغط على الزر الثانوي'),
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('زر ثانوي'),
                  ),
                ),
                
                InteractionFeedback.createTapEffect(
                  onTap: () => _showFeedback('تم الضغط على الزر النصي'),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('زر نصي'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // بطاقة تفاعلية
            InteractionFeedback.createRippleEffect(
              onTap: () => _showFeedback('تم الضغط على البطاقة'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.touch_app, color: AppColors.primaryGreen),
                        const SizedBox(width: 8),
                        const Text('بطاقة تفاعلية'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'اضغط على هذه البطاقة لرؤية تأثير الموجة',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مؤشرات التحميل',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => _isLoading = !_isLoading);
                  },
                  child: Text(_isLoading ? 'إيقاف التحميل' : 'بدء التحميل'),
                ),
                const SizedBox(width: 16),
                if (_isLoading) LoadingIndicators.circular(size: 20),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // أنواع مختلفة من مؤشرات التحميل
            if (_isLoading) ...[
              const Text('مؤشر دائري:'),
              const SizedBox(height: 8),
              LoadingIndicators.circular(),
              
              const SizedBox(height: 16),
              const Text('مؤشر خطي:'),
              const SizedBox(height: 8),
              LoadingIndicators.linear(),
              
              const SizedBox(height: 16),
              const Text('مؤشر نقطي:'),
              const SizedBox(height: 8),
              LoadingIndicators.dots(),
              
              const SizedBox(height: 16),
              const Text('مؤشر موجي:'),
              const SizedBox(height: 8),
              LoadingIndicators.wave(),
              
              const SizedBox(height: 16),
              const Text('مؤشر مع نص:'),
              const SizedBox(height: 8),
              LoadingIndicators.withText(text: 'جاري التحميل...'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رسائل الخطأ',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => ErrorMessages.showSnackBar(
                    context,
                    type: ErrorType.network,
                    onAction: () => _showFeedback('إعادة المحاولة'),
                  ),
                  child: const Text('خطأ شبكة'),
                ),
                
                ElevatedButton(
                  onPressed: () => ErrorMessages.showSnackBar(
                    context,
                    type: ErrorType.validation,
                    customMessage: 'يرجى ملء جميع الحقول المطلوبة',
                  ),
                  child: const Text('خطأ تحقق'),
                ),
                
                ElevatedButton(
                  onPressed: () => ErrorMessages.showErrorDialog(
                    context,
                    type: ErrorType.server,
                    onAction: () => _showFeedback('تم الإبلاغ عن المشكلة'),
                  ),
                  child: const Text('خطأ خادم'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // عرض خطأ في بطاقة
            if (_hasError)
              ErrorMessages.cardError(
                type: ErrorType.unknown,
                customMessage: 'حدث خطأ في تحميل البيانات',
                onRetry: () {
                  setState(() => _hasError = false);
                  _showFeedback('تم إعادة المحاولة');
                },
              ),
            
            if (!_hasError)
              ElevatedButton(
                onPressed: () => setState(() => _hasError = true),
                child: const Text('عرض خطأ في بطاقة'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الحالات الفارغة',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _isEmpty = !_isEmpty),
                  child: Text(_isEmpty ? 'إخفاء الحالة الفارغة' : 'عرض الحالة الفارغة'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (_isEmpty)
              EmptyStates.card(
                type: EmptyStateType.noData,
                onAction: () {
                  setState(() => _isEmpty = false);
                  _showFeedback('تم تحديث البيانات');
                },
                height: 250,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرسوم المتحركة',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            // رسوم متحركة للظهور
            UXAnimations.fadeSlideIn(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('عنصر برسوم متحركة للظهور'),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // رسوم متحركة للقائمة
            ...List.generate(3, (index) {
              return UXAnimations.listItemAnimation(
                index: index,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text('عنصر قائمة ${index + 1}'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التغذية الراجعة',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => InteractionFeedback.showSuccessFeedback(
                    context,
                    message: 'تم الحفظ بنجاح!',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('نجاح'),
                ),
                
                ElevatedButton(
                  onPressed: () => InteractionFeedback.showErrorFeedback(
                    context,
                    message: 'حدث خطأ أثناء الحفظ',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text('خطأ'),
                ),
                
                ElevatedButton(
                  onPressed: () => InteractionFeedback.showWarningFeedback(
                    context,
                    message: 'تحذير: تأكد من البيانات',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                  ),
                  child: const Text('تحذير'),
                ),
                
                ElevatedButton(
                  onPressed: () => InteractionFeedback.showInfoFeedback(
                    context,
                    message: 'معلومة: تم تحديث النظام',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                  child: const Text('معلومات'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
