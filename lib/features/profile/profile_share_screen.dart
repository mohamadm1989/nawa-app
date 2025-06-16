import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/safety/user_data_manager.dart';

/// صفحة مشاركة الملف الشخصي
class ProfileShareScreen extends StatefulWidget {
  const ProfileShareScreen({super.key});

  @override
  State<ProfileShareScreen> createState() => _ProfileShareScreenState();
}

class _ProfileShareScreenState extends State<ProfileShareScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // بيانات المستخدم
  late Map<String, dynamic> _userData;
  late Map<String, dynamic> _userStats;
  
  // خيارات المشاركة
  bool _shareAchievements = true;
  bool _shareStats = true;
  bool _shareImpact = true;
  bool _shareMessage = true;
  
  // رسالة مخصصة
  final TextEditingController _messageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserData();
    _messageController.text = 'انضموا إلي في دعم المشاريع الخيرية عبر تطبيق نِواة! 🌱';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    _userData = UserDataManager.getSafeUserData();
    _userStats = UserDataManager.getUserStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // التبويبات
          _buildTabs(),
          
          // المحتوى
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShareOptionsTab(),
                _buildPreviewTab(),
                _buildShareMethodsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 0,
      title: const Row(
        children: [
          Icon(Icons.share, size: 24),
          SizedBox(width: 8),
          Text(
            'مشاركة الملف الشخصي',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.backgroundCard,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primaryGreen,
        tabs: const [
          Tab(
            icon: Icon(Icons.tune),
            text: 'خيارات المشاركة',
          ),
          Tab(
            icon: Icon(Icons.preview),
            text: 'معاينة',
          ),
          Tab(
            icon: Icon(Icons.send),
            text: 'طرق المشاركة',
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رسالة مخصصة
          _buildCustomMessageSection(),
          
          const SizedBox(height: 24),
          
          // خيارات المحتوى
          _buildContentOptionsSection(),
          
          const SizedBox(height: 24),
          
          // معاينة سريعة
          _buildQuickPreview(),
        ],
      ),
    );
  }

  Widget _buildCustomMessageSection() {
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
              Icon(Icons.edit, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                'رسالة مخصصة',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          TextField(
            controller: _messageController,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'اكتب رسالة شخصية للمشاركة...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
              ),
              filled: true,
              fillColor: AppColors.backgroundPrimary,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // أزرار الرسائل المقترحة
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSuggestedMessage('انضموا إلي في دعم المشاريع الخيرية! 🌱'),
              _buildSuggestedMessage('معاً نبني سوريا الجديدة 🇸🇾'),
              _buildSuggestedMessage('كل مساهمة تحدث فرقاً 💝'),
              _buildSuggestedMessage('شاركوني رحلة العطاء 🤝'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedMessage(String message) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _messageController.text = message;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
        ),
        child: Text(
          message,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContentOptionsSection() {
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
              Icon(Icons.checklist, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                'محتوى المشاركة',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildContentOption(
            icon: Icons.emoji_events,
            title: 'الإنجازات',
            subtitle: 'مشاركة الإنجازات والأوسمة المحققة',
            value: _shareAchievements,
            onChanged: (value) {
              setState(() {
                _shareAchievements = value;
              });
            },
          ),
          
          const Divider(height: 24),
          
          _buildContentOption(
            icon: Icons.analytics,
            title: 'الإحصائيات',
            subtitle: 'عدد التبرعات والمبلغ الإجمالي',
            value: _shareStats,
            onChanged: (value) {
              setState(() {
                _shareStats = value;
              });
            },
          ),
          
          const Divider(height: 24),
          
          _buildContentOption(
            icon: Icons.favorite,
            title: 'الأثر المحقق',
            subtitle: 'عدد الأشخاص المستفيدين والمشاريع المدعومة',
            value: _shareImpact,
            onChanged: (value) {
              setState(() {
                _shareImpact = value;
              });
            },
          ),
          
          const Divider(height: 24),
          
          _buildContentOption(
            icon: Icons.message,
            title: 'الرسالة الشخصية',
            subtitle: 'تضمين الرسالة المخصصة',
            value: _shareMessage,
            onChanged: (value) {
              setState(() {
                _shareMessage = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryGreen,
        ),
      ],
    );
  }

  Widget _buildQuickPreview() {
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
              Icon(Icons.visibility, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                'معاينة سريعة',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_shareMessage && _messageController.text.isNotEmpty) ...[
                  Text(
                    _messageController.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                
                Text(
                  '👤 ${_userData['name']}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                if (_shareStats) ...[
                  const SizedBox(height: 8),
                  Text(
                    '💝 ${_userStats['totalDonations']} تبرع • ${_userStats['totalAmount']} ل.س',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
                
                if (_shareImpact) ...[
                  const SizedBox(height: 8),
                  Text(
                    '🌟 ساهم في مساعدة ${_userStats['peopleHelped']} شخص',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
                
                const SizedBox(height: 12),
                Text(
                  'تطبيق نِواة - معاً نبني سوريا الجديدة 🇸🇾',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // معاينة كاملة للمشاركة
          _buildFullPreview(),

          const SizedBox(height: 24),

          // أزرار الإجراءات
          _buildPreviewActions(),
        ],
      ),
    );
  }

  Widget _buildFullPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس المعاينة
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.primaryGreen, width: 2),
                ),
                child: _userData['avatar'] != null
                    ? ClipOval(
                        child: Image.network(
                          _userData['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.primaryGreen,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primaryGreen,
                      ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userData['name'],
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'متطوع في تطبيق نِواة',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // الرسالة الشخصية
          if (_shareMessage && _messageController.text.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: Text(
                _messageController.text,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // الإحصائيات
          if (_shareStats) ...[
            _buildStatsSection(),
            const SizedBox(height: 20),
          ],

          // الإنجازات
          if (_shareAchievements) ...[
            _buildAchievementsSection(),
            const SizedBox(height: 20),
          ],

          // الأثر المحقق
          if (_shareImpact) ...[
            _buildImpactSection(),
            const SizedBox(height: 20),
          ],

          // دعوة للانضمام
          _buildCallToAction(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائياتي في العطاء 📊',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.volunteer_activism,
                label: 'التبرعات',
                value: '${_userStats['totalDonations']}',
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.monetization_on,
                label: 'المبلغ الإجمالي',
                value: '${_userStats['totalAmount']} ل.س',
                color: AppColors.rating,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.business,
                label: 'المشاريع',
                value: '${_userStats['projectsSupported']}',
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                label: 'الأشخاص المساعدون',
                value: '${_userStats['peopleHelped']}',
                color: AppColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
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

  Widget _buildAchievementsSection() {
    final achievements = [
      {'title': 'أول مساهمة', 'icon': Icons.star, 'color': AppColors.warning},
      {'title': 'مساهم نشط', 'icon': Icons.favorite, 'color': AppColors.error},
      {'title': 'قلب كبير', 'icon': Icons.volunteer_activism, 'color': AppColors.primaryGreen},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إنجازاتي 🏆',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: achievements.map((achievement) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (achievement['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: (achievement['color'] as Color).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    achievement['icon'] as IconData,
                    color: achievement['color'] as Color,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    achievement['title'] as String,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: achievement['color'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImpactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أثري في المجتمع 🌟',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.success.withValues(alpha: 0.1), AppColors.primaryGreen.withValues(alpha: 0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildImpactStat('${_userStats['peopleHelped']}', 'شخص استفاد', Icons.people),
                  _buildImpactStat('${_userStats['projectsSupported']}', 'مشروع دعمت', Icons.business),
                  _buildImpactStat('100%', 'نجاح التبرعات', Icons.check_circle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImpactStat(String number, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.success, size: 24),
        const SizedBox(height: 4),
        Text(
          number,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.success,
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
    );
  }

  Widget _buildCallToAction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.primaryGreen.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.volunteer_activism,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'انضم إلي في رحلة العطاء',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'حمّل تطبيق نِواة وابدأ مساهمتك اليوم',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewActions() {
    return Row(
      children: [
        Expanded(
          child: NawaButton.secondary(
            text: 'تعديل المحتوى',
            icon: Icons.edit,
            onPressed: () {
              _tabController.animateTo(0);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: NawaButton.primary(
            text: 'مشاركة الآن',
            icon: Icons.share,
            onPressed: () {
              _tabController.animateTo(2);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShareMethodsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // طرق المشاركة
          _buildShareMethods(),

          const SizedBox(height: 24),

          // نسخ الرابط
          _buildCopyLinkSection(),

          const SizedBox(height: 24),

          // إحصائيات المشاركة
          _buildShareStats(),
        ],
      ),
    );
  }

  Widget _buildShareMethods() {
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
              Icon(Icons.share, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                'طرق المشاركة',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // شبكة طرق المشاركة
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildShareMethodCard(
                icon: Icons.message,
                label: 'الرسائل',
                color: AppColors.info,
                onTap: () => _shareVia('sms'),
              ),
              _buildShareMethodCard(
                icon: Icons.email,
                label: 'البريد الإلكتروني',
                color: AppColors.warning,
                onTap: () => _shareVia('email'),
              ),
              _buildShareMethodCard(
                icon: Icons.public,
                label: 'فيسبوك',
                color: const Color(0xFF1877F2),
                onTap: () => _shareVia('facebook'),
              ),
              _buildShareMethodCard(
                icon: Icons.send,
                label: 'تيليجرام',
                color: const Color(0xFF0088CC),
                onTap: () => _shareVia('telegram'),
              ),
              _buildShareMethodCard(
                icon: Icons.chat,
                label: 'واتساب',
                color: const Color(0xFF25D366),
                onTap: () => _shareVia('whatsapp'),
              ),
              _buildShareMethodCard(
                icon: Icons.more_horiz,
                label: 'المزيد',
                color: AppColors.textSecondary,
                onTap: () => _shareVia('more'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareMethodCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyLinkSection() {
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
              Icon(Icons.link, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                'رابط الملف الشخصي',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'https://nawa.app/profile/${_userData['id']}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _copyProfileLink,
                  icon: const Icon(Icons.copy, color: AppColors.primaryGreen),
                  tooltip: 'نسخ الرابط',
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: NawaButton.primary(
              text: 'نسخ الرابط',
              icon: Icons.copy,
              onPressed: _copyProfileLink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareStats() {
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
              Icon(Icons.trending_up, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                'إحصائيات المشاركة',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildShareStatCard(
                  icon: Icons.visibility,
                  label: 'المشاهدات',
                  value: '127',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildShareStatCard(
                  icon: Icons.share,
                  label: 'المشاركات',
                  value: '23',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildShareStatCard(
                  icon: Icons.people,
                  label: 'الوصول',
                  value: '89',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
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

  // دوال الإجراءات
  String _generateShareText() {
    String shareText = '';

    if (_shareMessage && _messageController.text.isNotEmpty) {
      shareText += '${_messageController.text}\n\n';
    }

    shareText += '👤 ${_userData['name']}\n';
    shareText += 'متطوع في تطبيق نِواة\n\n';

    if (_shareStats) {
      shareText += '📊 إحصائياتي في العطاء:\n';
      shareText += '💝 ${_userStats['totalDonations']} تبرع\n';
      shareText += '💰 ${_userStats['totalAmount']} ل.س إجمالي التبرعات\n';
      shareText += '🏢 ${_userStats['projectsSupported']} مشروع دعمت\n\n';
    }

    if (_shareImpact) {
      shareText += '🌟 أثري في المجتمع:\n';
      shareText += '👥 ساهمت في مساعدة ${_userStats['peopleHelped']} شخص\n';
      shareText += '✅ نجاح 100% في جميع التبرعات\n\n';
    }

    if (_shareAchievements) {
      shareText += '🏆 إنجازاتي:\n';
      shareText += '⭐ أول مساهمة\n';
      shareText += '❤️ مساهم نشط\n';
      shareText += '💝 قلب كبير\n\n';
    }

    shareText += 'انضم إلي في رحلة العطاء!\n';
    shareText += 'حمّل تطبيق نِواة وابدأ مساهمتك اليوم 🌱\n\n';
    shareText += 'https://nawa.app/profile/${_userData['id']}';

    return shareText;
  }

  void _shareVia(String method) {
    final shareText = _generateShareText();

    switch (method) {
      case 'sms':
        _showSuccessMessage('سيتم فتح تطبيق الرسائل قريباً');
        break;
      case 'email':
        _showSuccessMessage('سيتم فتح تطبيق البريد الإلكتروني قريباً');
        break;
      case 'facebook':
        _showSuccessMessage('سيتم فتح فيسبوك قريباً');
        break;
      case 'telegram':
        _showSuccessMessage('سيتم فتح تيليجرام قريباً');
        break;
      case 'whatsapp':
        _showSuccessMessage('سيتم فتح واتساب قريباً');
        break;
      case 'more':
        _showNativeShareDialog(shareText);
        break;
    }
  }

  void _copyProfileLink() async {
    final link = 'https://nawa.app/profile/${_userData['id']}';
    await Clipboard.setData(ClipboardData(text: link));
    _showSuccessMessage('تم نسخ الرابط بنجاح');
  }

  void _showNativeShareDialog(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مشاركة الملف الشخصي'),
        content: SingleChildScrollView(
          child: Text(text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: text));
              if (mounted) {
                Navigator.pop(context);
                _showSuccessMessage('تم نسخ النص بنجاح');
              }
            },
            child: const Text('نسخ النص'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
