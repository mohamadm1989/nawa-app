import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import '../../shared/constants/app_text_styles.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/models/project_model.dart';

/// صفحة أثر المساهمة - تظهر للمتبرعين نتائج مساهماتهم
class DonationImpactScreen extends StatefulWidget {
  final String projectId;
  final String donationId;

  const DonationImpactScreen({
    super.key,
    required this.projectId,
    required this.donationId,
  });

  @override
  State<DonationImpactScreen> createState() => _DonationImpactScreenState();
}

class _DonationImpactScreenState extends State<DonationImpactScreen> {
  Project? _project;
  Map<String, dynamic>? _donationDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImpactData();
  }

  Future<void> _loadImpactData() async {
    setState(() => _isLoading = true);
    
    // محاكاة تحميل البيانات
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _project = _getSampleProject();
      _donationDetails = _getSampleDonation();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      title: const Text('أثر مساهمتك'),
      elevation: 0,
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
      ),
    );
  }

  Widget _buildBody() {
    if (_project == null || _donationDetails == null) {
      return _buildErrorState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رسالة الشكر
          _buildThankYouMessage(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // تفاصيل المساهمة
          _buildDonationDetails(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // تقدم المشروع
          _buildProjectProgress(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // صور قبل وبعد
          _buildBeforeAfterImages(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // فيديو الشكر
          _buildThankYouVideo(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // الأثر المحقق
          _buildImpactAchieved(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // أزرار العمل
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          ElevatedButton(
            onPressed: _loadImpactData,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouMessage() {
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
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'شكراً لك من القلب! 💚',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            'مساهمتك الكريمة ساعدت في تحقيق تغيير حقيقي في حياة الناس',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDonationDetails() {
    final donation = _donationDetails!;
    
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
              Icon(Icons.receipt, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'تفاصيل مساهمتك',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          
          _buildDetailRow('المبلغ المساهم', '${donation['amount']} ل.س'),
          _buildDetailRow('تاريخ المساهمة', donation['date']),
          _buildDetailRow('طريقة الدفع', donation['method']),
          _buildDetailRow('رقم المرجع', donation['reference']),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectProgress() {
    final project = _project!;
    final progress = project.funding.progress;
    
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
              Icon(Icons.trending_up, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'تقدم المشروع',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          
          Text(
            project.title,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          
          // شريط التقدم
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.progressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}% مكتمل',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${project.funding.raised.toStringAsFixed(0)} / ${project.funding.target.toStringAsFixed(0)} ل.س',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeforeAfterImages() {
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
              Icon(Icons.compare, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'صور قبل وبعد',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAccent,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40, color: AppColors.textSecondary),
                            SizedBox(height: 8),
                            Text('قبل الترميم', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      'الحالة السابقة',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Icon(Icons.arrow_forward, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40, color: AppColors.primaryGreen),
                            const SizedBox(height: 8),
                            Text(
                              'بعد الترميم',
                              style: TextStyle(color: AppColors.primaryGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      'النتيجة المحققة',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouVideo() {
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
              Icon(Icons.video_library, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'رسالة شكر خاصة',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.backgroundAccent,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(color: AppColors.border),
            ),
            child: InkWell(
              onTap: _playThankYouVideo,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_filled, size: 64, color: AppColors.primaryGreen),
                  const SizedBox(height: 8),
                  Text(
                    'شاهد رسالة الشكر من المستفيدين',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactAchieved() {
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
              Icon(Icons.emoji_events, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'الأثر المحقق',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          Row(
            children: [
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.school,
                  number: '250',
                  label: 'طالب استفاد',
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.class_,
                  number: '12',
                  label: 'صف دراسي',
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            children: [
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.people,
                  number: '15',
                  label: 'معلم',
                  color: AppColors.accentRed,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildImpactCard(
                  icon: Icons.family_restroom,
                  number: '180',
                  label: 'عائلة',
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard({
    required IconData icon,
    required String number,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            number,
            style: AppTextStyles.headlineMedium.copyWith(
              color: color,
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        // زر مشاركة الأثر
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _shareImpact,
            icon: const Icon(Icons.share),
            label: const Text('شارك أثر مساهمتك'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // زر العودة للمشروع
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _goToProject,
            icon: const Icon(Icons.arrow_back),
            label: const Text('العودة للمشروع'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              side: const BorderSide(color: AppColors.primaryGreen),
              padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // زر المساهمة مرة أخرى
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: _donateAgain,
            icon: const Icon(Icons.favorite),
            label: const Text('ساهم مرة أخرى'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accentGold,
              padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
            ),
          ),
        ),
      ],
    );
  }

  // ========== دوال العمل ==========

  void _playThankYouVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة مشغل الفيديو قريباً'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _shareImpact() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رابط المشاركة'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _goToProject() {
    Navigator.of(context).pop();
  }

  void _donateAgain() {
    Navigator.of(context).pushNamed('/donate', arguments: widget.projectId);
  }
  
  Project _getSampleProject() {
    // بيانات تجريبية للمشروع
    return Project(
      id: widget.projectId,
      title: 'ترميم مدرسة الأمل الابتدائية',
      description: 'مشروع ترميم وتأهيل مدرسة الأمل الابتدائية في حي الصالحين',
      category: 'تعليم',
      location: const ProjectLocation(
        governorate: 'حلب',
        city: 'حلب',
        district: 'الصالحين',
        coordinates: GeoCoordinates(lat: 36.2021, lng: 37.1343),
      ),
      funding: const ProjectFunding(
        target: 500000,
        raised: 350000,
        currency: 'SYP',
      ),
      timeline: ProjectTimeline(
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      contact: const ProjectContact(
        name: 'أحمد محمد الأحمد',
        phone: '+963912345678',
        role: 'مدير المدرسة',
      ),
      media: const ProjectMedia(
        mainImage: 'https://via.placeholder.com/400x300/4A7C59/FFFFFF?text=مدرسة+الأمل',
        gallery: [
          'https://via.placeholder.com/400x300/4A7C59/FFFFFF?text=قبل+الترميم',
          'https://via.placeholder.com/400x300/E4B896/000000?text=بعد+الترميم',
        ],
        documents: [],
      ),
      verification: const ProjectVerification(
        status: 'verified',
      ),
    );
  }

  Map<String, dynamic> _getSampleDonation() {
    return {
      'amount': '50,000',
      'date': '15/12/2024',
      'method': 'بطاقة ائتمان',
      'reference': 'DON-2024-001234',
    };
  }
}
