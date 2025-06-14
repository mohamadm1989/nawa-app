import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// صفحة عن التطبيق
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
      title: const Text('عن التطبيق'),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شعار التطبيق ومعلومات أساسية
          _buildAppHeader(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // رسالة التطبيق
          _buildMissionSection(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // الميزات الرئيسية
          _buildFeaturesSection(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // فريق العمل
          _buildTeamSection(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // الإحصائيات
          _buildStatsSection(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // معلومات التطبيق التقنية
          _buildTechnicalInfo(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // روابط مهمة
          _buildImportantLinks(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // شكر وتقدير
          _buildAcknowledgments(),
        ],
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXLarge),
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
        children: [
          // شعار التطبيق
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'نوى',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          Text(
            'نِواة',
            style: AppTextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingSmall),
          
          Text(
            'منصة إعادة الإعمار المجتمعي السوري',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMedium,
              vertical: AppConstants.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Text(
              'الإصدار 1.0.0',
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
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
          Row(
            children: [
              Icon(Icons.favorite, color: AppColors.primaryGreen, size: 28),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'رسالتنا',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'نوى هو أكثر من مجرد تطبيق - إنه جسر الأمل الذي يربط بين قلوب المتبرعين الكريمة والمشاريع التنموية التي تحتاجها سوريا. نؤمن بأن كل مساهمة، مهما كانت صغيرة، يمكن أن تكون نواة لتغيير إيجابي كبير.',
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'هدفنا هو بناء مجتمع شفاف وموثوق حيث يمكن للجميع المساهمة في إعادة بناء سوريا، مشروع واحد في كل مرة.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الميزات الرئيسية',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        
        _buildFeatureCard(
          icon: Icons.verified,
          title: 'مشاريع موثقة',
          description: 'جميع المشاريع تخضع لمراجعة دقيقة وتوثيق شامل',
          color: AppColors.primaryGreen,
        ),
        
        _buildFeatureCard(
          icon: Icons.visibility,
          title: 'شفافية كاملة',
          description: 'تتبع تقدم مشاريعك وتأثير تبرعاتك بالتفصيل',
          color: Colors.blue,
        ),
        
        _buildFeatureCard(
          icon: Icons.security,
          title: 'دفع آمن',
          description: 'معاملات مالية آمنة ومشفرة مع إيصالات فورية',
          color: Colors.orange,
        ),
        
        _buildFeatureCard(
          icon: Icons.people,
          title: 'مجتمع متفاعل',
          description: 'تقييمات وتعليقات من المجتمع لضمان الجودة',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
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

  Widget _buildTeamSection() {
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
          Row(
            children: [
              Icon(Icons.group, color: AppColors.primaryGreen, size: 28),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'فريق العمل',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'تطبيق نوى من تطوير فريق من المطورين والمصممين السوريين المتحمسين لخدمة وطنهم. نحن نعمل بدافع الحب والانتماء لسوريا، ونسعى لتقديم أفضل تجربة ممكنة للمستخدمين.',
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'إذا كنت مطوراً أو مصمماً وتريد المساهمة في تطوير التطبيق، نرحب بك في فريقنا!',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
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
            'إنجازاتنا حتى الآن',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard('1,250', 'مستخدم نشط', Icons.people),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildStatCard('89', 'مشروع مكتمل', Icons.check_circle),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard('2.5M', 'ليرة سورية', Icons.attach_money),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildStatCard('15', 'محافظة', Icons.location_on),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 32),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            number,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfo() {
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
            'معلومات تقنية',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          
          _buildInfoRow('الإصدار', '1.0.0'),
          _buildInfoRow('تاريخ الإصدار', '15 ديسمبر 2024'),
          _buildInfoRow('حجم التطبيق', '25 ميجابايت'),
          _buildInfoRow('الأنظمة المدعومة', 'Android 7.0+, iOS 12.0+'),
          _buildInfoRow('اللغات', 'العربية، الإنجليزية'),
          _buildInfoRow('آخر تحديث', '15 ديسمبر 2024'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantLinks() {
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
            'روابط مهمة',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          
          _buildLinkTile(
            icon: Icons.web,
            title: 'الموقع الإلكتروني',
            subtitle: 'www.nawa.sy',
            onTap: _openWebsite,
          ),
          
          _buildLinkTile(
            icon: Icons.email,
            title: 'البريد الإلكتروني',
            subtitle: 'info@nawa.sy',
            onTap: _sendEmail,
          ),
          
          _buildLinkTile(
            icon: Icons.privacy_tip,
            title: 'سياسة الخصوصية',
            subtitle: 'اطلع على كيفية حماية بياناتك',
            onTap: () => Navigator.pushNamed(context, '/privacy'),
          ),
          
          _buildLinkTile(
            icon: Icons.description,
            title: 'الشروط والأحكام',
            subtitle: 'شروط استخدام التطبيق',
            onTap: () => Navigator.pushNamed(context, '/terms'),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildAcknowledgments() {
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
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red, size: 28),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'شكر وتقدير',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'نتقدم بالشكر الجزيل لكل من ساهم في إنجاح هذا المشروع:',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            '• جميع المتبرعين الكرام الذين وثقوا بنا\n'
            '• منشئي المشاريع الذين يعملون لخدمة المجتمع\n'
            '• فريق التطوير والتصميم المتفاني\n'
            '• المراجعين والمختبرين الذين ساعدوا في تحسين التطبيق\n'
            '• كل من قدم اقتراحات وملاحظات بناءة',
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'معاً نبني سوريا الجديدة 🇸🇾',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ========== معالجات الأحداث ==========

  void _openWebsite() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم فتح الموقع الإلكتروني قريباً')),
    );
  }

  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم فتح تطبيق البريد الإلكتروني قريباً')),
    );
  }
}
