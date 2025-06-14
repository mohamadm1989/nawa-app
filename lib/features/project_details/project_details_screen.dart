import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/local_storage_manager.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/models/project_model.dart';

/// صفحة تفاصيل المشروع
/// تعرض جميع تفاصيل المشروع بشكل جميل ومفصل
class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen>
    with TickerProviderStateMixin {
  final LocalStorageManager _storage = LocalStorageManager.instance;
  ProjectModel? _project;
  bool _isLoading = true;
  bool _isLiked = false;
  bool _isFollowing = false;
  late TabController _tabController;
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;

  // متغيرات التوثيق والمراجعة
  List<Map<String, dynamic>> _reviews = [];
  bool _hasUserVoted = false;

  // متغيرات التعليقات والتقييم
  int _userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // زيادة عدد التبويبات لتشمل التوثيق
    _loadProjectDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل المشروع')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('المشروع غير موجود')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ========== الهيدر مع الصور ==========
          _buildSliverAppBar(),
          
          // ========== محتوى الصفحة ==========
          SliverToBoxAdapter(
            child: Column(
              children: [
                // معلومات أساسية
                _buildBasicInfo(),
                
                // شريط التقدم والإحصائيات
                _buildProgressSection(),
                
                // التبويبات
                _buildTabSection(),
              ],
            ),
          ),
        ],
      ),
      
      // ========== الأزرار السفلية ==========
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // معرض الصور
            _buildImageGallery(),
            
            // تدرج لوني في الأسفل
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
            
            // مؤشر الصور
            if (_project!.media.gallery.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: _buildImageIndicator(),
              ),
          ],
        ),
      ),
      actions: [
        // زر المشاركة
        IconButton(
          onPressed: _handleShare,
          icon: const Icon(Icons.share, color: AppColors.textOnColor),
        ),
        
        // زر الإعجاب
        IconButton(
          onPressed: _handleLike,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? AppColors.like : AppColors.textOnColor,
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery() {
    final images = _project!.media.gallery.isNotEmpty 
        ? _project!.media.gallery 
        : [_project!.media.mainImage ?? 'https://via.placeholder.com/400x300'];

    return PageView.builder(
      controller: _imageController,
      onPageChanged: (index) {
        setState(() => _currentImageIndex = index);
      },
      itemCount: images.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: images[index],
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.backgroundAccent,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.backgroundAccent,
            child: const Icon(Icons.image, size: 64, color: AppColors.helperGray),
          ),
        );
      },
    );
  }

  Widget _buildImageIndicator() {
    final images = _project!.media.gallery.isNotEmpty 
        ? _project!.media.gallery 
        : [_project!.media.mainImage ?? ''];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(images.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentImageIndex == index 
                ? AppColors.textOnColor 
                : AppColors.textOnColor.withValues(alpha: 0.5),
          ),
        );
      }),
    );
  }

  Widget _buildBasicInfo() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والحالة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _project!.basic.title,
                  style: AppTextStyles.headlineLarge,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              _buildStatusBadge(),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // الموقع والمنشئ
          _buildLocationAndCreator(),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // الوصف
          Text(
            _project!.basic.description,
            style: AppTextStyles.bodyLarge,
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // التصنيفات
          _buildTags(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String statusText;
    IconData statusIcon;

    switch (_project!.basic.status) {
      case 'active':
        badgeColor = AppColors.success;
        statusText = 'نشط';
        statusIcon = Icons.play_circle;
        break;
      case 'completed':
        badgeColor = AppColors.primaryGreen;
        statusText = 'مكتمل';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        badgeColor = AppColors.warning;
        statusText = 'قيد المراجعة';
        statusIcon = Icons.pending;
        break;
      default:
        badgeColor = AppColors.helperGray;
        statusText = 'غير محدد';
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMedium,
        vertical: AppConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: AppColors.textOnColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textOnColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationAndCreator() {
    return Column(
      children: [
        // الموقع
        Row(
          children: [
            const Icon(Icons.location_on, size: 20, color: AppColors.helperGray),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(
                '${_project!.location.city} - ${_project!.location.district}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (_project!.verification.isVerified)
              const Icon(Icons.verified, color: AppColors.success, size: 20),
          ],
        ),
        
        const SizedBox(height: AppConstants.spacingSmall),
        
        // المنشئ
        Row(
          children: [
            const Icon(Icons.person, size: 20, color: AppColors.helperGray),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Text(
                '${_project!.creator.name} - ${_project!.creator.role}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: AppConstants.spacingSmall,
      runSpacing: AppConstants.spacingSmall,
      children: _project!.basic.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMedium,
            vertical: AppConstants.spacingSmall,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondaryBeige.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
            border: Border.all(color: AppColors.secondaryBeige),
          ),
          child: Text(
            '#$tag',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressSection() {
    final progress = _project!.progressPercentage;
    final current = _project!.financial.currentAmount;
    final target = _project!.financial.targetAmount;
    final remaining = _project!.remainingAmount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // النسبة المئوية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم المحرز',
                style: AppTextStyles.headlineSmall,
              ),
              Text(
                '${progress.toStringAsFixed(1)}%',
                style: AppTextStyles.numberLarge.copyWith(fontSize: 24),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // شريط التقدم
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 12,
              backgroundColor: AppColors.progressBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressBar),
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // الإحصائيات المالية
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'تم جمع',
                  value: '\$${current.toStringAsFixed(0)}',
                  color: AppColors.success,
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildStatCard(
                  title: 'المتبقي',
                  value: '\$${remaining.toStringAsFixed(0)}',
                  color: AppColors.warning,
                  icon: Icons.schedule,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildStatCard(
                  title: 'مساهم',
                  value: '${_project!.engagement.supporters}',
                  color: AppColors.info,
                  icon: Icons.people,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            value,
            style: AppTextStyles.numberMedium.copyWith(color: color),
          ),
          Text(
            title,
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        // شريط التبويبات
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLarge,
            vertical: AppConstants.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.backgroundAccent,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Cairo',
              fontSize: 14,
            ),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            tabs: const [
              Tab(text: 'التفاصيل'),
              Tab(text: 'التوثيق'),
              Tab(text: 'التحديثات'),
              Tab(text: 'التعليقات'),
              Tab(text: 'المساهمون'),
            ],
          ),
        ),
        
        // محتوى التبويبات
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(),
              _buildVerificationTab(),
              _buildUpdatesTab(),
              _buildCommentsTab(),
              _buildSupportersTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تفصيل الميزانية
          _buildBudgetBreakdown(),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // الجدول الزمني
          _buildTimeline(),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // معلومات الاتصال
          _buildContactInfo(),
        ],
      ),
    );
  }

  Widget _buildBudgetBreakdown() {
    final breakdown = _project!.financial.breakdown;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفصيل الميزانية',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        
        _buildBudgetItem('المواد', breakdown.materials, Icons.build),
        _buildBudgetItem('العمالة', breakdown.labor, Icons.engineering),
        _buildBudgetItem('أخرى', breakdown.other, Icons.more_horiz),
        
        const Divider(height: AppConstants.spacingLarge),
        
        _buildBudgetItem(
          'المجموع', 
          breakdown.total, 
          Icons.calculate,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildBudgetItem(String title, double amount, IconData icon, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.helperGray),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Text(
              title,
              style: isTotal 
                  ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                  : AppTextStyles.bodyMedium,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: isTotal
                ? AppTextStyles.numberMedium.copyWith(color: AppColors.primaryGreen)
                : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجدول الزمني',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        
        _buildTimelineItem(
          'تاريخ الإنشاء',
          _project!.timeline.createdAt,
          Icons.create,
          true,
        ),
        
        if (_project!.timeline.startDate != null)
          _buildTimelineItem(
            'تاريخ البدء',
            _project!.timeline.startDate!,
            Icons.play_arrow,
            true,
          ),
        
        if (_project!.timeline.expectedEndDate != null)
          _buildTimelineItem(
            'التاريخ المتوقع للانتهاء',
            _project!.timeline.expectedEndDate!,
            Icons.schedule,
            false,
          ),
      ],
    );
  }

  Widget _buildTimelineItem(String title, DateTime date, IconData icon, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
      child: Row(
        children: [
          Icon(
            icon, 
            size: 20, 
            color: isCompleted ? AppColors.success : AppColors.helperGray,
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Text(title, style: AppTextStyles.bodyMedium),
          ),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات الاتصال',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        
        ListTile(
          leading: const Icon(Icons.phone, color: AppColors.primaryGreen),
          title: Text(_project!.creator.contact),
          subtitle: const Text('رقم الهاتف'),
          onTap: () {
            // TODO: فتح تطبيق الهاتف
          },
        ),
        
        ListTile(
          leading: const Icon(Icons.location_on, color: AppColors.primaryGreen),
          title: Text(_project!.location.address),
          subtitle: const Text('العنوان'),
          onTap: () {
            // TODO: فتح الخريطة
          },
        ),
      ],
    );
  }

  Widget _buildVerificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // حالة التوثيق
          _buildVerificationStatus(),

          const SizedBox(height: AppConstants.spacingLarge),

          // التصويت المجتمعي (إذا كان مفعل)
          if (_project!.verification.communityVotingEnabled)
            _buildCommunityVoting(),

          const SizedBox(height: AppConstants.spacingLarge),

          // الوسائط والمستندات
          _buildVerificationMedia(),

          const SizedBox(height: AppConstants.spacingLarge),

          // معلومات المراجع
          _buildVerifierInfo(),
        ],
      ),
    );
  }

  Widget _buildVerificationStatus() {
    final verification = _project!.verification;
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String statusDescription;

    switch (verification.status) {
      case 'verified':
        statusColor = AppColors.success;
        statusIcon = Icons.verified;
        statusText = 'مشروع موثّق';
        statusDescription = 'تم التحقق من صحة هذا المشروع من قبل فريق المراجعة';
        break;
      case 'pending':
        statusColor = AppColors.warning;
        statusIcon = Icons.pending;
        statusText = 'قيد المراجعة';
        statusDescription = 'المشروع في انتظار المراجعة والتوثيق';
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        statusText = 'مرفوض';
        statusDescription = 'لم يتم قبول هذا المشروع للأسف';
        break;
      default:
        statusColor = AppColors.helperGray;
        statusIcon = Icons.help;
        statusText = 'غير محدد';
        statusDescription = 'حالة التوثيق غير واضحة';
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusDescription,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (verification.verificationDate != null) ...[
            const SizedBox(height: AppConstants.spacingMedium),
            const Divider(),
            const SizedBox(height: AppConstants.spacingMedium),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'تاريخ التوثيق: ${verification.verificationDate!.day}/${verification.verificationDate!.month}/${verification.verificationDate!.year}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommunityVoting() {
    final verification = _project!.verification;
    final progress = verification.votingProgress;

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
              Icon(Icons.how_to_vote, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Text(
                  'التصويت المجتمعي',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              if (verification.hasEnoughVotes)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'مكتمل',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          Text(
            'يحتاج هذا المشروع لموافقة ${verification.requiredVotes} أشخاص من المجتمع المحلي',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // شريط التقدم
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.progressBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      verification.hasEnoughVotes ? AppColors.success : AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                '${verification.communityVotes}/${verification.requiredVotes}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: verification.hasEnoughVotes ? AppColors.success : AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // زر التصويت
          if (!_hasUserVoted && !verification.hasEnoughVotes)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleCommunityVote,
                icon: const Icon(Icons.thumb_up),
                label: const Text('أؤيد هذا المشروع'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            )
          else if (_hasUserVoted)
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'شكراً لك! لقد صوّت لهذا المشروع',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerificationMedia() {
    final media = _project!.media;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الوسائط والمستندات',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        // الفيديو التعريفي
        if (media.video != null) ...[
          _buildVideoSection(media.video!),
          const SizedBox(height: AppConstants.spacingLarge),
        ],

        // المستندات الداعمة
        if (media.documents.isNotEmpty) ...[
          _buildDocumentsSection(media.documents),
          const SizedBox(height: AppConstants.spacingLarge),
        ],

        // معرض الصور
        if (media.gallery.isNotEmpty)
          _buildGallerySection(media.gallery),
      ],
    );
  }

  Widget _buildVideoSection(String videoUrl) {
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
              Icon(Icons.play_circle, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'فيديو تعريفي',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.backgroundAccent,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(color: AppColors.border),
            ),
            child: InkWell(
              onTap: () => _playVideo(videoUrl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_filled, size: 64, color: AppColors.primaryGreen),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط لتشغيل الفيديو',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsSection(List<String> documents) {
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
              Icon(Icons.description, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'المستندات الداعمة',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          ...documents.map((doc) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundAccent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doc,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => _downloadDocument(doc),
                  icon: const Icon(Icons.download, size: 20),
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildGallerySection(List<String> gallery) {
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
              Icon(Icons.photo_library, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'معرض الصور',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gallery.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: AppColors.backgroundAccent,
                      child: InkWell(
                        onTap: () => _viewImage(gallery[index]),
                        child: const Icon(
                          Icons.image,
                          color: AppColors.textSecondary,
                          size: 40,
                        ),
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

  Widget _buildVerifierInfo() {
    final verification = _project!.verification;

    if (verification.verifiedBy == null) {
      return const SizedBox.shrink();
    }

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
              Icon(Icons.admin_panel_settings, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Text(
                'معلومات المراجع',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryGreen,
                child: Text(
                  verification.verifiedBy!.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مراجع معتمد',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${verification.verifiedBy}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'موثوق',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatesTab() {
    return const Center(
      child: Text('سيتم إضافة التحديثات قريباً'),
    );
  }

  Widget _buildCommentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إحصائيات التقييم
          _buildRatingStats(),

          const SizedBox(height: AppConstants.spacingLarge),

          // نموذج إضافة تعليق
          _buildAddCommentForm(),

          const SizedBox(height: AppConstants.spacingLarge),

          // قائمة التعليقات
          _buildCommentsList(),
        ],
      ),
    );
  }

  Widget _buildRatingStats() {
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
            'تقييمات المجتمع',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),

          Row(
            children: [
              // التقييم العام
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      '4.8',
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 5 ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      '124 تقييم',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // توزيع النجوم
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.8, 98),
                    _buildRatingBar(4, 0.15, 19),
                    _buildRatingBar(3, 0.03, 4),
                    _buildRatingBar(2, 0.01, 2),
                    _buildRatingBar(1, 0.01, 1),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, color: Colors.amber, size: 12),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 4,
                backgroundColor: AppColors.progressBackground,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportersTab() {
    return const Center(
      child: Text('سيتم إضافة قائمة المساهمين قريباً'),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر المتابعة
          Expanded(
            child: NawaButton.secondary(
              text: _isFollowing ? 'إلغاء المتابعة' : 'متابعة',
              icon: _isFollowing ? Icons.notifications_off : Icons.notifications,
              onPressed: _handleFollow,
            ),
          ),
          
          const SizedBox(width: AppConstants.spacingMedium),
          
          // زر التبرع
          Expanded(
            flex: 2,
            child: NawaButton.primary(
              text: 'ساهم الآن',
              icon: Icons.favorite,
              onPressed: _handleDonate,
            ),
          ),
        ],
      ),
    );
  }

  // ========== معالجات الأحداث ==========

  Future<void> _loadProjectDetails() async {
    // محاكاة تحميل البيانات
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _project = _generateSampleProject();
      _isLiked = _storage.isFavorite(widget.projectId);
      _isLoading = false;
    });
  }

  void _handleShare() {
    // TODO: مشاركة المشروع
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة المشاركة قريباً')),
    );
  }

  Future<void> _handleLike() async {
    final success = await _storage.toggleFavorite(widget.projectId);
    if (!mounted) return;

    if (success) {
      setState(() {
        _isLiked = _storage.isFavorite(widget.projectId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLiked ? 'تم إضافة المشروع للمفضلة' : 'تم إزالة المشروع من المفضلة'),
          backgroundColor: _isLiked ? AppColors.success : AppColors.warning,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في تحديث المفضلة'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleFollow() {
    setState(() => _isFollowing = !_isFollowing);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing ? 'تم متابعة المشروع' : 'تم إلغاء المتابعة'),
      ),
    );
  }

  void _handleDonate() {
    AppRoutes.pushDonate(context, widget.projectId);
  }

  // ========== دوال التعليقات والتقييم ==========

  void _setRating(int rating) {
    setState(() {
      _userRating = rating;
    });
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى كتابة تعليق'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (_userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار تقييم'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final newComment = {
      'userName': 'المستخدم الحالي',
      'rating': _userRating,
      'text': _commentController.text.trim(),
      'date': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    };

    setState(() {
      _comments.insert(0, newComment);
      _commentController.clear();
      _userRating = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة تعليقك بنجاح'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildAddCommentForm() {
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
            'أضف تقييمك وتعليقك',
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          // تقييم بالنجوم
          Row(
            children: [
              Text(
                'التقييم:',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => _setRating(index + 1),
                    child: Icon(
                      index < _userRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 24,
                    ),
                  );
                }),
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                _userRating > 0 ? '$_userRating/5' : '',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          // حقل التعليق
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'شاركنا رأيك في هذا المشروع...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          // زر الإرسال
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitComment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('إرسال التعليق'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (_comments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppConstants.spacingXLarge),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.comment_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              'لا توجد تعليقات بعد',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              'كن أول من يعلق على هذا المشروع',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التعليقات (${_comments.length})',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        ...List.generate(_comments.length, (index) {
          final comment = _comments[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
            child: _buildCommentCard(comment),
          );
        }),
      ],
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryGreen,
                child: Text(
                  comment['userName'].substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['userName'],
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < comment['rating'] ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                        ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Text(
                          comment['date'],
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            comment['text'],
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  // ========== دوال التوثيق الجديدة ==========

  void _handleCommunityVote() {
    setState(() {
      _hasUserVoted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('شكراً لك! تم تسجيل تأييدك للمشروع'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _playVideo(String videoUrl) {
    // TODO: تشغيل الفيديو
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة مشغل الفيديو قريباً')),
    );
  }

  void _downloadDocument(String documentUrl) {
    // TODO: تحميل المستند
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة تحميل المستندات قريباً')),
    );
  }

  void _viewImage(String imageUrl) {
    // TODO: عرض الصورة بحجم كامل
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة عارض الصور قريباً')),
    );
  }

  // ========== البيانات التجريبية ==========

  ProjectModel _generateSampleProject() {
    return ProjectModel(
      projectId: widget.projectId,
      basic: const ProjectBasic(
        title: 'ترميم مدرسة الأمل في حي الصالحين',
        description: 'مشروع شامل لترميم وتأهيل مدرسة الأمل في حي الصالحين بحلب، لتوفير بيئة تعليمية آمنة ومناسبة للأطفال. يشمل المشروع ترميم الصفوف، تجديد المرافق الصحية، وتوفير الأثاث المدرسي اللازم.',
        category: 'education',
        status: 'active',
        priority: 'high',
        tags: ['school', 'renovation', 'children', 'education', 'aleppo'],
      ),
      location: const ProjectLocation(
        city: 'حلب',
        district: 'الصالحين',
        address: 'شارع المدرسة، بناء رقم 15، حي الصالحين',
        coordinates: GeoCoordinates(lat: 36.2021, lng: 37.1343),
      ),
      financial: const ProjectFinancial(
        targetAmount: 5000.0,
        currentAmount: 3250.0,
        currency: 'USD',
        breakdown: ProjectBreakdown(
          materials: 3000.0,
          labor: 1500.0,
          other: 500.0,
        ),
      ),
      timeline: ProjectTimeline(
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        expectedEndDate: DateTime.now().add(const Duration(days: 45)),
      ),
      creator: const ProjectCreator(
        uid: 'creator1',
        name: 'أبو محمد الحلبي',
        role: 'مدير المدرسة',
        contact: '+963912345678',
      ),
      media: const ProjectMedia(
        mainImage: 'https://via.placeholder.com/400x300/4A7C59/FFFFFF?text=مدرسة+الأمل',
        gallery: [
          'https://via.placeholder.com/400x300/4A7C59/FFFFFF?text=مدرسة+الأمل',
          'https://via.placeholder.com/400x300/E4B896/000000?text=الصفوف',
          'https://via.placeholder.com/400x300/4A7C59/FFFFFF?text=الساحة',
        ],
        documents: [
          'موافقة_مختار_الحي.pdf',
          'تقرير_فني_للمبنى.pdf',
          'خطاب_دعم_جمعية_الأمل.pdf',
        ],
        video: 'فيديو_تعريفي_مدرسة_الأمل.mp4',
      ),
      engagement: const ProjectEngagement(
        supporters: 42,
        likes: 89,
        comments: 23,
        shares: 15,
        views: 456,
      ),
      verification: ProjectVerification(
        status: 'verified',
        verifiedBy: 'admin1',
        verificationDate: DateTime.now().subtract(const Duration(days: 12)),
        documents: [
          'موافقة_مختار_الحي.pdf',
          'تقرير_فني_للمبنى.pdf',
          'خطاب_دعم_جمعية_الأمل.pdf',
        ],
        communityVotingEnabled: true,
        communityVotes: 12,
        requiredVotes: 10,
      ),
    );
  }
}
