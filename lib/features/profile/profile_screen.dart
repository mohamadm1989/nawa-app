import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // لإخفاء رسائل overflow
import '../../core/constants/constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/animations/nawa_animations.dart';
import '../../core/animations/celebration_animations.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/widgets/widgets.dart';

/// صفحة الملف الشخصي
/// تعرض معلومات المستخدم وإنجازاته ومساهماته
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // بيانات المستخدم الآمنة
  Map<String, dynamic> get _userProfile => UserDataManager.getSafeUserData();

  final Map<String, dynamic> _userStats = {
    'totalDonations': 1250.0,
    'projectsSupported': 8,
    'donationsCount': 15,
    'impactPoints': 2340,
    'rank': 'مساهم ذهبي',
    'level': 4,
    'nextLevelPoints': 660, // نقاط للوصول للمستوى التالي
  };

  final List<Map<String, dynamic>> _recentDonations = [
    {
      'projectTitle': 'ترميم مدرسة الأمل',
      'amount': 100.0,
      'date': '10 ديسمبر 2024',
      'status': 'مكتمل',
      'impact': 'ساعدت في تعليم 50 طفل',
    },
    {
      'projectTitle': 'مشروع المياه النظيفة',
      'amount': 75.0,
      'date': '5 ديسمبر 2024',
      'status': 'قيد التنفيذ',
      'impact': 'وفرت مياه نظيفة لـ 20 عائلة',
    },
    {
      'projectTitle': 'إعادة تأهيل المستشفى',
      'amount': 200.0,
      'date': '28 نوفمبر 2024',
      'status': 'مكتمل',
      'impact': 'ساعدت في علاج 100 مريض',
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'أول مساهمة',
      'description': 'قمت بأول تبرع في التطبيق',
      'icon': Icons.star,
      'color': AppColors.warning,
      'earned': true,
      'date': '15 يناير 2024',
    },
    {
      'title': 'مساهم نشط',
      'description': 'ساهمت في 5 مشاريع مختلفة',
      'icon': Icons.favorite,
      'color': AppColors.error,
      'earned': true,
      'date': '20 فبراير 2024',
    },
    {
      'title': 'قلب كبير',
      'description': 'تبرعت بأكثر من 1000 دولار',
      'icon': Icons.volunteer_activism,
      'color': AppColors.primaryGreen,
      'earned': true,
      'date': '15 مارس 2024',
    },
    {
      'title': 'سفير الخير',
      'description': 'ساهمت في 10 مشاريع مختلفة',
      'icon': Icons.emoji_events,
      'color': AppColors.warning,
      'earned': false,
      'date': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    // إخفاء رسائل overflow في وضع التطوير
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // تعطيل رسائل overflow
      debugDisableClipLayers = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeWidget(
      widgetName: 'ProfileScreen',
      child: Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 2.0,
        leading: Container(),
        title: AccessibleText(
          'الملف الشخصي',
          style: AccessibilityStyles.accessibleHeadlineStyle(context).copyWith(
            color: AppColors.textOnColor,
          ),
          semanticLabel: 'صفحة الملف الشخصي',
          isHeader: true,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.textOnColor,
          size: AppConstants.iconSizeMedium,
        ),
        actions: [
          InteractionFeedback.createTapEffect(
            onTap: () {
              InteractionFeedback.showInfoFeedback(context, message: 'فتح صفحة تعديل الملف الشخصي');
              _showEditProfile();
            },
            child: AccessibleIcon(
              icon: Icons.edit,
              semanticLabel: 'تعديل الملف الشخصي',
              onTap: () {
                AccessibilityHelper.announceToScreenReader(context, 'فتح صفحة تعديل الملف الشخصي');
                _showEditProfile();
              },
              color: AppColors.textOnColor,
              tooltip: 'تعديل الملف الشخصي',
            ),
          ),
          AccessibleIcon(
            icon: Icons.settings,
            semanticLabel: 'الإعدادات',
            onTap: () {
              AccessibilityHelper.announceToScreenReader(context, 'فتح الإعدادات');
              _showSettings();
            },
            color: AppColors.textOnColor,
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // معلومات المستخدم
            _buildUserProfileHeader(),

            // الإحصائيات
            _buildQuickStats(),

            // التبويبات
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  // شريط التبويبات
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCard,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
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
                        Tab(text: 'التبرعات'),
                        Tab(text: 'الإنجازات'),
                        Tab(text: 'المعلومات'),
                      ],
                    ),
                  ),

                  // محتوى التبويبات مع ارتفاع محدد
                  Container(
                    height: 600, // ارتفاع ثابت لمنع التداخل
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBarView(
                      children: [
                        _buildDonationsTab(),
                        _buildAchievementsTab(),
                        _buildInfoTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ========== البار السفلي الموحد ==========
      bottomNavigationBar: _buildBottomNavigation(),
    ),
    );
  }

  // ========== بناء هيدر المستخدم البسيط ==========

  Widget _buildUserProfileHeader() {
    return Container(
      width: double.infinity,
      padding: ResponsiveConstants.getLargePadding(context),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          // صورة المستخدم
          AppStyles.circularImage(
            imageUrl: _userProfile['avatar'] ?? 'https://via.placeholder.com/150',
            size: ResponsiveConstants.getLargeAvatarSize(context),
          ),

          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),

          // اسم المستخدم
          AccessibleText(
            _userProfile['name'] ?? 'أحمد محمد الطيبي',
            style: AccessibilityStyles.accessibleHeadlineStyle(context).copyWith(
              color: AppColors.textOnColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            semanticLabel: 'اسم المستخدم: ${_userProfile['name'] ?? 'أحمد محمد الطيبي'}',
            isHeader: true,
          ),

          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),

          // المستوى والنقاط
          AppStyles.statusBadge(
            text: 'المستوى 4 • 1250 نقطة',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }





  // ========== بناء الهيدر كـ SliverAppBar ==========

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 200.0, // ارتفاع مناسب
      floating: false,
      pinned: true, // يبقى مثبت في الأعلى
      snap: false,
      backgroundColor: AppColors.primaryGreen,
      elevation: innerBoxIsScrolled ? 4.0 : 0.0,
      leading: Container(), // إزالة زر الرجوع
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: _showEditProfile,
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: _showSettings,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryGreen,
                AppColors.primaryGreen.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), // مساحة للأزرار

                  // صورة المستخدم
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.8),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // اسم المستخدم
                  const Text(
                    'أحمد محمد الطيبي',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),

                  const SizedBox(height: 6),

                  // المستوى والنقاط
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'المستوى 4 • 1250 نقطة',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 280.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryGreen,
                AppColors.primaryGreen.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // شريط الأدوات العلوي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: _showSettings,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: _shareProfile,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // صورة المستخدم
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.8),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // اسم المستخدم
                  const Text(
                    'أحمد محمد الطيبي',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),

                  const SizedBox(height: 8),

                  // المستوى والنقاط
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'المستوى 4 • 1250 نقطة',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: _showEditProfile,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180, // ارتفاع ثابت ومحدود بدقة - أصغر لمنع التداخل
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16), // تقليل المساحة
          child: Column(
            children: [
              // شريط الأزرار العلوي
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _showEditProfile,
                    icon: const Icon(Icons.edit, color: AppColors.textOnColor),
                  ),
                  IconButton(
                    onPressed: _showSettings,
                    icon: const Icon(Icons.settings, color: AppColors.textOnColor),
                  ),
                ],
              ),

              // صورة المستخدم
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40, // تقليل الحجم
                    backgroundColor: AppColors.secondaryBeige,
                    backgroundImage: UserDataManager.getSafeString(_userProfile, 'avatar', '').isNotEmpty
                        ? NetworkImage(UserDataManager.getSafeString(_userProfile, 'avatar', ''))
                        : null,
                    child: UserDataManager.getSafeString(_userProfile, 'avatar', '').isEmpty
                        ? Text(
                            UserDataManager.getSafeString(_userProfile, 'name', 'م').substring(0, 1),
                            style: const TextStyle(
                              fontSize: 28, // تقليل الحجم
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          )
                        : null,
                  ),

                  // شارة التحقق
                  if (UserDataManager.getSafeBool(_userProfile, 'verified', false))
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16, // تقليل الحجم
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12), // تقليل المسافة

              // اسم المستخدم
              Text(
                _userProfile['name'] ?? 'مستخدم',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textOnColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20, // تقليل الحجم
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6), // تقليل المسافة

              // الرتبة والمستوى
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBeige.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: AppColors.warning,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${UserDataManager.getSafeString(_userStats, 'rank', 'مبتدئ')} - المستوى ${UserDataManager.getSafeInt(_userStats, 'level', 1)}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8), // تقليل المسافة

              // الوصف
              Text(
                _userProfile['bio'] ?? 'مرحباً بكم في نوى',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textOnColor.withValues(alpha: 0.9),
                  fontSize: 14, // تقليل الحجم
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: ResponsiveConstants.getMediumPadding(context),
      padding: ResponsiveConstants.getMediumPadding(context),
      decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
      child: ResponsiveHelper.needsCompactLayout(context)
          ? _buildCompactStats()
          : ResponsiveHelper.isMobile(context)
              ? _buildMobileStats()
              : _buildTabletDesktopStats(),
    );
  }

  Widget _buildCompactStats() {
    // تخطيط مضغوط للشاشات الصغيرة جداً
    return Column(
      children: [
        _buildStatCard(
          title: 'إجمالي التبرعات',
          value: '\$${UserDataManager.getSafeDouble(_userStats, 'totalDonations', 0.0).toStringAsFixed(0)}',
          icon: Icons.attach_money,
          color: AppColors.success,
        ),
        SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),
        _buildStatCard(
          title: 'المشاريع المدعومة',
          value: '${UserDataManager.getSafeInt(_userStats, 'projectsSupported', 0)}',
          icon: Icons.favorite,
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildMobileStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'إجمالي التبرعات',
                value: '\$${UserDataManager.getSafeDouble(_userStats, 'totalDonations', 0.0).toStringAsFixed(0)}',
                icon: Icons.attach_money,
                color: AppColors.success,
              ),
            ),
            SizedBox(width: ResponsiveConstants.getSmallSpacing(context)),
            Expanded(
              child: _buildStatCard(
                title: 'المشاريع المدعومة',
                value: '${UserDataManager.getSafeInt(_userStats, 'projectsSupported', 0)}',
                icon: Icons.favorite,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'نقاط التأثير',
                value: '${UserDataManager.getSafeInt(_userStats, 'impactPoints', 0)}',
                icon: Icons.star,
                color: AppColors.warning,
              ),
            ),
            SizedBox(width: ResponsiveConstants.getSmallSpacing(context)),
            Expanded(
              child: _buildStatCard(
                title: 'المستوى',
                value: '${UserDataManager.getSafeInt(_userStats, 'level', 1)}',
                icon: Icons.trending_up,
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletDesktopStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'إجمالي التبرعات',
            value: '\$${UserDataManager.getSafeDouble(_userStats, 'totalDonations', 0.0).toStringAsFixed(0)}',
            icon: Icons.attach_money,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 8), // تقليل المسافة لحل overflow
        Expanded(
          child: _buildStatCard(
            title: 'المشاريع المدعومة',
            value: '${UserDataManager.getSafeInt(_userStats, 'projectsSupported', 0)}',
            icon: Icons.favorite,
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 8), // تقليل المسافة لحل overflow
        Expanded(
          child: _buildStatCard(
            title: 'نقاط التأثير',
            value: '${UserDataManager.getSafeInt(_userStats, 'impactPoints', 0)}',
            icon: Icons.star,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return AppLayouts.statisticCard(
      title: title,
      value: value,
      icon: icon,
      color: color,
    );
  }

  Widget _buildTabSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // شريط التبويبات
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
                Tab(text: 'التبرعات'),
                Tab(text: 'الإنجازات'),
                Tab(text: 'المعلومات'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // محتوى التبويبات - بارتفاع محدود ومستقر
          Container(
            height: 400, // ارتفاع ثابت ومحدود
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDonationsTab(),
                  _buildAchievementsTab(),
                  _buildInfoTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط التقدم للمستوى التالي
          _buildLevelProgress(),

          const SizedBox(height: 20),

          // عنوان التبرعات الأخيرة
          Row(
            children: [
              const Icon(Icons.history, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(
                'التبرعات الأخيرة',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // قائمة التبرعات
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentDonations.length,
            itemBuilder: (context, index) {
              final donation = _recentDonations[index];
              return _buildDonationCard(donation);
            },
          ),

          const SizedBox(height: 16),

          // زر عرض جميع التبرعات
          Center(
            child: NawaButton.secondary(
              text: 'عرض جميع التبرعات',
              icon: Icons.list,
              onPressed: () {
                AppRoutes.pushDonationsHistory(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress() {
    final currentPoints = UserDataManager.getSafeInt(_userStats, 'impactPoints', 0);
    final nextLevelPoints = UserDataManager.getSafeInt(_userStats, 'nextLevelPoints', 100);
    final totalPointsForNextLevel = currentPoints + nextLevelPoints;
    final progress = totalPointsForNextLevel > 0 ? currentPoints / totalPointsForNextLevel : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.1),
            AppColors.secondaryBeige.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المستوى ${UserDataManager.getSafeInt(_userStats, 'level', 1)}',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
              Text(
                'المستوى ${UserDataManager.getSafeInt(_userStats, 'level', 1) + 1}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: AppColors.progressBackground,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'تحتاج ${nextLevelPoints} نقطة للوصول للمستوى التالي',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.info),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'كل دولار تبرع = نقطة واحدة، كل مشروع جديد = 50 نقطة',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> donation) {
    Color statusColor;
    IconData statusIcon;

    switch (donation['status']) {
      case 'مكتمل':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case 'قيد التنفيذ':
        statusColor = AppColors.warning;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = AppColors.helperGray;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والمبلغ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  donation['projectTitle'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '\$${donation['amount'].toStringAsFixed(0)}',
                style: AppTextStyles.numberMedium.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // التاريخ والحالة
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.helperGray),
              const SizedBox(width: 4),
              Text(
                donation['date'],
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(statusIcon, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                donation['status'],
                style: AppTextStyles.bodySmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // التأثير
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondaryBeige.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, size: 16, color: AppColors.error),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    donation['impact'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان الإنجازات
          Row(
            children: [
              const Icon(Icons.emoji_events, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                'شارات الإنجاز',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'اجمع الشارات واكسب نقاط إضافية! 🏆',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // شبكة الإنجازات
          ResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            spacing: ResponsiveHelper.getSpacing(context),
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 2.0 : 1.8, // زيادة النسبة لمساحة أكبر
            children: _achievements.map((achievement) {
              return _buildAchievementCard(achievement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isEarned = UserDataManager.getSafeBool(achievement, 'earned', false);

    return InteractiveAnimation(
      onTap: isEarned ? () => _showAchievementDetails(achievement) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEarned
              ? AppColors.backgroundCard
              : AppColors.backgroundCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned
                ? achievement['color'].withValues(alpha: 0.3)
                : AppColors.helperGray,
            width: 2,
          ),
          boxShadow: isEarned ? [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
      child: ClipRect( // إخفاء المحتوى الزائد بصري<|im_start|>ح
        child: Padding(
          padding: const EdgeInsets.all(4.0), // تقليل المساحة الداخلية
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // تقليل الحجم للحد الأدنى
            children: [
              // الأيقونة
              Container(
                padding: const EdgeInsets.all(8), // تقليل المساحة
                decoration: BoxDecoration(
                  color: isEarned
                      ? achievement['color'].withValues(alpha: 0.1)
                      : AppColors.helperGray.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement['icon'],
                  color: isEarned ? achievement['color'] : AppColors.helperGray,
                  size: 24, // تقليل حجم الأيقونة
                ),
              ),

              const SizedBox(height: 8), // تقليل المسافة

              // العنوان
              Text(
                achievement['title'],
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isEarned ? AppColors.textPrimary : AppColors.helperGray,
                  fontSize: 14, // تقليل حجم الخط
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4), // تقليل المسافة

              // الوصف
              Text(
                achievement['description'],
                style: AppTextStyles.bodySmall.copyWith(
                  color: isEarned ? AppColors.textSecondary : AppColors.helperGray,
                  fontSize: 11, // تقليل حجم الخط
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              if (isEarned && UserDataManager.getSafeString(achievement, 'date', '').isNotEmpty) ...[
                const SizedBox(height: 6), // تقليل المسافة
                Text(
                  UserDataManager.getSafeString(achievement, 'date', ''),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: achievement['color'] as Color? ?? AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 10, // تقليل حجم الخط
                  ),
                ),
              ],
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // المعلومات الشخصية
          _buildInfoSection(
            title: 'المعلومات الشخصية',
            icon: Icons.person,
            items: [
              {'label': 'الاسم', 'value': _userProfile['name'] ?? 'غير محدد'},
              {'label': 'البريد الإلكتروني', 'value': _userProfile['email'] ?? 'محمي للأمان'},
              {'label': 'رقم الهاتف', 'value': _userProfile['phone'] ?? 'محمي للأمان'},
              {'label': 'الموقع', 'value': _userProfile['location'] ?? 'محمي للأمان'},
              {'label': 'تاريخ الانضمام', 'value': _userProfile['joinDate'] ?? 'غير محدد'},
            ],
          ),

          const SizedBox(height: 20),

          // إحصائيات مفصلة
          _buildInfoSection(
            title: 'الإحصائيات التفصيلية',
            icon: Icons.analytics,
            items: [
              {'label': 'إجمالي التبرعات', 'value': '\$${UserDataManager.getSafeDouble(_userStats, 'totalDonations', 0.0).toStringAsFixed(0)}'},
              {'label': 'عدد التبرعات', 'value': '${UserDataManager.getSafeInt(_userStats, 'donationsCount', 0)}'},
              {'label': 'المشاريع المدعومة', 'value': '${UserDataManager.getSafeInt(_userStats, 'projectsSupported', 0)}'},
              {'label': 'نقاط التأثير', 'value': '${UserDataManager.getSafeInt(_userStats, 'impactPoints', 0)}'},
              {'label': 'الرتبة الحالية', 'value': UserDataManager.getSafeString(_userStats, 'rank', 'غير محدد')},
            ],
          ),

          const SizedBox(height: 20),

          // أزرار الإعدادات
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Map<String, String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // العناصر
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${item['label']}:',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item['value']!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        NawaButton.primary(
          text: 'تعديل الملف الشخصي',
          icon: Icons.edit,
          onPressed: _showEditProfile,
        ),

        const SizedBox(height: 12),

        NawaButton.secondary(
          text: 'الإعدادات',
          icon: Icons.settings,
          onPressed: _showSettings,
        ),

        const SizedBox(height: 12),

        NawaButton.secondary(
          text: 'مشاركة الملف الشخصي',
          icon: Icons.share,
          onPressed: _shareProfile,
        ),
      ],
    );
  }

  // ========== البار السفلي الموحد ==========

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 3, // الملف الشخصي هو الفهرس الثالث
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: AppColors.backgroundCard,
      elevation: 8,
      onTap: _handleBottomNavTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'البحث',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'المفضلة',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'الملف الشخصي',
        ),
      ],
    );
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/search');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/favorites');
        break;
      case 3:
        // الملف الشخصي (الصفحة الحالية)
        break;
    }
  }

  // ========== معالجات الأحداث ==========

  void _showEditProfile() async {
    try {
      // استخدام دالة التوجيه المحدثة مع النوع الصحيح
      final result = await AppRoutes.pushEditProfile(context);

      // إذا تم حفظ التغييرات، قم بتحديث الواجهة
      if (result == true) {
        setState(() {
          // إعادة بناء الواجهة لتحديث البيانات
        });
      }
    } catch (e) {
      SafetyMonitor.logError('Navigation Error in _showEditProfile', e);
    }
  }

  void _showSettings() {
    AppRoutes.pushSettings(context);
  }

  void _shareProfile() {
    AppRoutes.pushShareProfile(context);
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    CelebrationAnimations.showAchievementCelebration(
      context,
      achievement['title'],
    );
  }
}


