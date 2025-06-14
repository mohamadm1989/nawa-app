import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';

/// شاشة الترحيب والتعريف
/// أول شاشة يراها المستخدم عند فتح التطبيق
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ========== اللوغو ==========
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusXLarge),
                ),
                child: Icon(
                  Icons.favorite,
                  size: 60,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXLarge),
              
              // ========== العنوان الترحيبي ==========
              Text(
                'أهلاً وسهلاً فيك',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.spacingMedium),
              
              // ========== الوصف ==========
              Text(
                'سوا نبني وطننا من جديد',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.spacingSmall),
              
              Text(
                'منصة تربط بين السوريين داخل وخارج البلد\nلتحقيق مشاريع إعادة الإعمار المجتمعي',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.spacingXXLarge),
              
              // ========== زر البدء ==========
              NawaButton.primary(
                text: 'يلا نبدأ سوا',
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
              
              const SizedBox(height: AppConstants.spacingMedium),
              
              // ========== رابط المعلومات ==========
              NawaButton.text(
                text: 'معرفة المزيد عن نِواة',
                onPressed: () => _showAboutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// عرض حوار معلومات التطبيق
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('عن تطبيق نِواة'),
        content: const Text(
          'نِواة هي منصة رقمية تهدف إلى ربط السوريين داخل وخارج البلد '
          'لتحقيق مشاريع إعادة الإعمار المجتمعي بشفافية كاملة وتأثير قابل للقياس.\n\n'
          'نؤمن بأن كل مساهمة، مهما كانت صغيرة، يمكن أن تحدث فرقاً كبيراً '
          'في حياة المجتمعات السورية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}
