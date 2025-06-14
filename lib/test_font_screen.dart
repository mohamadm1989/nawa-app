import 'package:flutter/material.dart';
import 'core/constants/constants.dart';

/// صفحة اختبار خط Cairo
class TestFontScreen extends StatelessWidget {
  const TestFontScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار خط Cairo'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اختبار خط Cairo المحلي - أوزان مختلفة
            _buildSection(
              'خط Cairo - أوزان مختلفة',
              [
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - ExtraLight',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w200),
                ),
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - Light',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w300),
                ),
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - Regular',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w400),
                ),
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - Medium',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w500),
                ),
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - SemiBold',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w600),
                ),
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - Bold',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w700),
                ),
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - ExtraBold',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w800),
                ),
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة - Black',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // اختبار خط Cairo المحلي
            _buildSection(
              'خط Cairo المحلي',
              [
                _buildTextSample(
                  'مرحباً بكم في تطبيق نِواة',
                  const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildTextSample(
                  'هذا نص تجريبي بخط Cairo المحلي',
                  const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                _buildTextSample(
                  'نص متوسط الوزن',
                  const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _buildTextSample(
                  'نص شبه عريض',
                  const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // اختبار أنماط التطبيق
            _buildSection(
              'أنماط التطبيق',
              [
                _buildTextSample(
                  'عنوان كبير',
                  AppTextStyles.headlineLarge,
                ),
                _buildTextSample(
                  'عنوان متوسط',
                  AppTextStyles.headlineMedium,
                ),
                _buildTextSample(
                  'عنوان صغير',
                  AppTextStyles.headlineSmall,
                ),
                _buildTextSample(
                  'نص كبير',
                  AppTextStyles.bodyLarge,
                ),
                _buildTextSample(
                  'نص متوسط',
                  AppTextStyles.bodyMedium,
                ),
                _buildTextSample(
                  'نص صغير',
                  AppTextStyles.bodySmall,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // اختبار الأرقام العربية
            _buildSection(
              'الأرقام العربية',
              [
                _buildTextSample(
                  '١٢٣٤٥٦٧٨٩٠',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _buildTextSample(
                  'المبلغ: ١٠٠٠ ليرة سورية',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                ),
                _buildTextSample(
                  'التاريخ: ١٤ ديسمبر ٢٠٢٤',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // اختبار النصوص الطويلة
            _buildSection(
              'نص طويل',
              [
                _buildTextSample(
                  'هذا نص طويل لاختبار خط Cairo في الفقرات الطويلة. يجب أن يكون الخط واضحاً ومقروءاً في جميع الأحجام والأوزان. تطبيق نِواة يستخدم خط Cairo لضمان أفضل تجربة قراءة للمستخدمين العرب.',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 16, height: 1.5),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // مقارنة مع خط النظام
            _buildSection(
              'مقارنة مع خط النظام',
              [
                _buildTextSample(
                  'هذا النص بخط Cairo',
                  const TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.w500),
                ),
                _buildTextSample(
                  'هذا النص بخط النظام الافتراضي',
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                _buildTextSample(
                  'هذا النص بخط Tahoma',
                  const TextStyle(fontFamily: 'Tahoma', fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildTextSample(String text, TextStyle style) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: style),
          const SizedBox(height: 4),
          Text(
            'Font: ${style.fontFamily ?? "Default"}, Size: ${style.fontSize ?? "Default"}, Weight: ${style.fontWeight ?? "Default"}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
