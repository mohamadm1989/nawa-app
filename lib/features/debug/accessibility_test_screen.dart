import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';

/// شاشة اختبار إمكانية الوصول
/// تعرض عينات من العناصر مع تحسينات إمكانية الوصول
class AccessibilityTestScreen extends StatefulWidget {
  const AccessibilityTestScreen({super.key});

  @override
  State<AccessibilityTestScreen> createState() => _AccessibilityTestScreenState();
}

class _AccessibilityTestScreenState extends State<AccessibilityTestScreen> {
  bool _switchValue = false;
  bool _checkboxValue = false;
  String _selectedRadio = 'option1';
  double _sliderValue = 50.0;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: AccessibleText(
          'اختبار إمكانية الوصول',
          style: AccessibilityStyles.accessibleHeadlineStyle(context).copyWith(
            color: AppColors.textOnColor,
          ),
          semanticLabel: 'شاشة اختبار إمكانية الوصول',
          isHeader: true,
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccessibilityInfo(),
            const SizedBox(height: 24),
            _buildButtonSamples(),
            const SizedBox(height: 24),
            _buildTextSamples(),
            const SizedBox(height: 24),
            _buildInputSamples(),
            const SizedBox(height: 24),
            _buildInteractiveSamples(),
            const SizedBox(height: 24),
            _buildCardSamples(),
            const SizedBox(height: 24),
            _buildContrastSamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityInfo() {
    final isScreenReaderEnabled = AccessibilityHelper.isScreenReaderEnabled(context);
    final isReduceMotionEnabled = AccessibilityHelper.isReduceMotionEnabled(context);
    final isLargeTextEnabled = AccessibilityHelper.isLargeTextEnabled(context);
    final isHighContrastEnabled = AccessibilityHelper.isHighContrastEnabled(context);

    return AccessibleCard(
      semanticLabel: 'معلومات إمكانية الوصول',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            'معلومات إمكانية الوصول',
            style: AccessibilityStyles.accessibleHeadlineStyle(context),
            isHeader: true,
          ),
          const SizedBox(height: 16),
          _buildInfoRow('قارئ الشاشة', isScreenReaderEnabled ? 'مفعل' : 'معطل'),
          _buildInfoRow('تقليل الحركة', isReduceMotionEnabled ? 'مفعل' : 'معطل'),
          _buildInfoRow('النص الكبير', isLargeTextEnabled ? 'مفعل' : 'معطل'),
          _buildInfoRow('التباين العالي', isHighContrastEnabled ? 'مفعل' : 'معطل'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AccessibleText(
            label,
            style: AccessibilityStyles.accessibleBodyStyle(context),
          ),
          AccessibleText(
            value,
            style: AccessibilityStyles.accessibleBodyStyle(context).copyWith(
              fontWeight: FontWeight.w600,
              color: value == 'مفعل' ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSamples() {
    return AccessibleCard(
      semanticLabel: 'عينات الأزرار',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            'عينات الأزرار',
            style: AccessibilityStyles.accessibleHeadlineStyle(context),
            isHeader: true,
          ),
          const SizedBox(height: 16),
          
          AccessibleButton(
            text: 'زر أساسي',
            onPressed: () => _showFeedback('تم الضغط على الزر الأساسي'),
            isPrimary: true,
            semanticLabel: 'زر أساسي للإجراءات المهمة',
            tooltip: 'اضغط لتنفيذ الإجراء الأساسي',
          ),
          const SizedBox(height: 12),
          
          AccessibleButton(
            text: 'زر ثانوي',
            onPressed: () => _showFeedback('تم الضغط على الزر الثانوي'),
            isPrimary: false,
            semanticLabel: 'زر ثانوي للإجراءات الفرعية',
            tooltip: 'اضغط لتنفيذ الإجراء الثانوي',
          ),
          const SizedBox(height: 12),
          
          AccessibleButton(
            text: 'زر مع أيقونة',
            icon: Icons.star,
            onPressed: () => _showFeedback('تم الضغط على الزر مع الأيقونة'),
            semanticLabel: 'زر مع أيقونة نجمة',
            tooltip: 'زر يحتوي على أيقونة نجمة',
          ),
          const SizedBox(height: 12),
          
          AccessibleButton(
            text: 'زر محمل',
            onPressed: null,
            isLoading: true,
            semanticLabel: 'زر في حالة تحميل',
          ),
        ],
      ),
    );
  }

  Widget _buildTextSamples() {
    return AccessibleCard(
      semanticLabel: 'عينات النصوص',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            'عينات النصوص',
            style: AccessibilityStyles.accessibleHeadlineStyle(context),
            isHeader: true,
          ),
          const SizedBox(height: 16),
          
          AccessibleText(
            'عنوان رئيسي',
            style: AccessibilityStyles.accessibleHeadlineStyle(context),
            semanticLabel: 'عنوان رئيسي للقسم',
            isHeader: true,
          ),
          const SizedBox(height: 8),
          
          AccessibleText(
            'عنوان فرعي',
            style: AccessibilityStyles.accessibleSubheadlineStyle(context),
            semanticLabel: 'عنوان فرعي للقسم',
            isHeader: true,
          ),
          const SizedBox(height: 8),
          
          AccessibleText(
            'نص أساسي - هذا نص تجريبي يوضح كيفية عرض النص الأساسي مع تحسينات إمكانية الوصول. يتم ضمان التباين المناسب وحجم الخط المقروء.',
            style: AccessibilityStyles.accessibleBodyStyle(context),
          ),
          const SizedBox(height: 8),
          
          AccessibleText(
            'نص تفسيري صغير',
            style: AccessibilityStyles.accessibleCaptionStyle(context),
            semanticLabel: 'نص تفسيري إضافي',
          ),
        ],
      ),
    );
  }

  Widget _buildInputSamples() {
    return AccessibleCard(
      semanticLabel: 'عينات حقول الإدخال',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            'عينات حقول الإدخال',
            style: AccessibilityStyles.accessibleHeadlineStyle(context),
            isHeader: true,
          ),
          const SizedBox(height: 16),
          
          AccessibleTextField(
            labelText: 'الاسم',
            hintText: 'أدخل اسمك الكامل',
            controller: _textController,
            required: true,
            semanticLabel: 'حقل إدخال الاسم الكامل',
            onChanged: (value) {
              if (value.isNotEmpty) {
                AccessibilityHelper.announceToScreenReader(context, 'تم إدخال: $value');
              }
            },
          ),
          const SizedBox(height: 16),
          
          AccessibleTextField(
            labelText: 'البريد الإلكتروني',
            hintText: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
            semanticLabel: 'حقل إدخال البريد الإلكتروني',
          ),
          const SizedBox(height: 16),
          
          AccessibleTextField(
            labelText: 'كلمة المرور',
            hintText: 'أدخل كلمة مرور قوية',
            obscureText: true,
            semanticLabel: 'حقل إدخال كلمة المرور',
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveSamples() {
    return AccessibleCard(
      semanticLabel: 'عينات العناصر التفاعلية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            'عينات العناصر التفاعلية',
            style: AccessibilityStyles.accessibleHeadlineStyle(context),
            isHeader: true,
          ),
          const SizedBox(height: 16),
          
          AccessibleSwitch(
            label: 'تفعيل الإشعارات',
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
              });
              _showFeedback('تم ${value ? 'تفعيل' : 'إلغاء'} الإشعارات');
            },
            semanticLabel: 'مفتاح تبديل الإشعارات',
          ),
          const SizedBox(height: 16),
          
          CheckboxListTile(
            title: AccessibleText(
              'أوافق على الشروط والأحكام',
              style: AccessibilityStyles.accessibleBodyStyle(context),
            ),
            value: _checkboxValue,
            onChanged: (value) {
              setState(() {
                _checkboxValue = value ?? false;
              });
              AccessibilityHelper.provideTactileFeedback(AccessibilityHapticFeedback.selectionClick);
              _showFeedback('تم ${value! ? 'قبول' : 'رفض'} الشروط والأحكام');
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.all(8),
          ),
          const SizedBox(height: 16),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccessibleText(
                'اختر خياراً:',
                style: AccessibilityStyles.accessibleBodyStyle(context),
              ),
              RadioListTile<String>(
                title: AccessibleText(
                  'الخيار الأول',
                  style: AccessibilityStyles.accessibleBodyStyle(context),
                ),
                value: 'option1',
                groupValue: _selectedRadio,
                onChanged: (value) {
                  setState(() {
                    _selectedRadio = value!;
                  });
                  AccessibilityHelper.provideTactileFeedback(AccessibilityHapticFeedback.selectionClick);
                  _showFeedback('تم اختيار الخيار الأول');
                },
              ),
              RadioListTile<String>(
                title: AccessibleText(
                  'الخيار الثاني',
                  style: AccessibilityStyles.accessibleBodyStyle(context),
                ),
                value: 'option2',
                groupValue: _selectedRadio,
                onChanged: (value) {
                  setState(() {
                    _selectedRadio = value!;
                  });
                  AccessibilityHelper.provideTactileFeedback(AccessibilityHapticFeedback.selectionClick);
                  _showFeedback('تم اختيار الخيار الثاني');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardSamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccessibleText(
          'عينات الكروت',
          style: AccessibilityStyles.accessibleHeadlineStyle(context),
          isHeader: true,
        ),
        const SizedBox(height: 16),
        
        AccessibleCard(
          semanticLabel: 'كرت قابل للضغط',
          tooltip: 'اضغط لعرض التفاصيل',
          onTap: () => _showFeedback('تم الضغط على الكرت'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AccessibleIcon(
                    icon: Icons.info,
                    semanticLabel: 'أيقونة معلومات',
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AccessibleText(
                      'كرت تفاعلي',
                      style: AccessibilityStyles.accessibleSubheadlineStyle(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AccessibleText(
                'هذا كرت يمكن الضغط عليه ويدعم إمكانية الوصول بالكامل.',
                style: AccessibilityStyles.accessibleBodyStyle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContrastSamples() {
    return AccessibleCard(
      semanticLabel: 'عينات التباين',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            'عينات التباين',
            style: AccessibilityStyles.accessibleHeadlineStyle(context),
            isHeader: true,
          ),
          const SizedBox(height: 16),
          
          _buildContrastExample(
            'تباين جيد',
            AppColors.textPrimary,
            AppColors.backgroundCard,
            true,
          ),
          const SizedBox(height: 8),
          
          _buildContrastExample(
            'تباين ضعيف (سيتم تصحيحه تلقائياً)',
            AppColors.helperGray,
            AppColors.backgroundCard,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildContrastExample(String label, Color textColor, Color backgroundColor, bool isGood) {
    final contrastRatio = AccessibilityHelper.calculateContrastRatio(textColor, backgroundColor);
    final correctedColor = AccessibilityHelper.getContrastingColor(backgroundColor);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isGood ? textColor : correctedColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'نسبة التباين: ${contrastRatio.toStringAsFixed(2)}:1',
            style: TextStyle(
              color: isGood ? textColor : correctedColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showFeedback(String message) {
    AccessibilityHelper.announceToScreenReader(context, message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AccessibleText(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
