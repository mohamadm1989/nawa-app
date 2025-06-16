import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';

/// صفحة سجل التبرعات الكامل
class DonationsHistoryScreen extends StatefulWidget {
  const DonationsHistoryScreen({super.key});

  @override
  State<DonationsHistoryScreen> createState() => _DonationsHistoryScreenState();
}

class _DonationsHistoryScreenState extends State<DonationsHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  String _selectedFilter = 'الكل';
  List<Map<String, dynamic>> _filteredDonations = [];
  
  // بيانات التبرعات التجريبية
  final List<Map<String, dynamic>> _allDonations = [
    {
      'id': 'DON001',
      'projectName': 'إعادة إعمار مدرسة الأمل - حلب',
      'amount': 500.0,
      'currency': 'ل.س',
      'date': '2024-01-15',
      'time': '14:30',
      'method': 'بطاقة ائتمان',
      'status': 'مكتمل',
      'reference': 'TXN123456789',
      'impact': 'ساهم في تعليم 25 طالب',
      'category': 'تعليم',
    },
    {
      'id': 'DON002',
      'projectName': 'مستوصف الرحمة - دمشق',
      'amount': 750.0,
      'currency': 'ل.س',
      'date': '2024-01-10',
      'time': '09:15',
      'method': 'PayPal',
      'status': 'مكتمل',
      'reference': 'TXN987654321',
      'impact': 'وفر علاج لـ 15 مريض',
      'category': 'صحة',
    },
    {
      'id': 'DON003',
      'projectName': 'مشروع الخبز اليومي - حمص',
      'amount': 300.0,
      'currency': 'ل.س',
      'date': '2024-01-05',
      'time': '16:45',
      'method': 'بطاقة ائتمان',
      'status': 'مكتمل',
      'reference': 'TXN456789123',
      'impact': 'أطعم 50 عائلة',
      'category': 'غذاء',
    },
    {
      'id': 'DON004',
      'projectName': 'مأوى الأطفال الأيتام - اللاذقية',
      'amount': 1000.0,
      'currency': 'ل.س',
      'date': '2023-12-28',
      'time': '11:20',
      'method': 'تحويل بنكي',
      'status': 'مكتمل',
      'reference': 'TXN789123456',
      'impact': 'رعى 10 أطفال أيتام',
      'category': 'رعاية اجتماعية',
    },
    {
      'id': 'DON005',
      'projectName': 'مشروع المياه النظيفة - درعا',
      'amount': 400.0,
      'currency': 'ل.س',
      'date': '2023-12-20',
      'time': '13:10',
      'method': 'PayPal',
      'status': 'قيد المعالجة',
      'reference': 'TXN321654987',
      'impact': 'وفر مياه نظيفة لـ 100 شخص',
      'category': 'بنية تحتية',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredDonations = List.from(_allDonations);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterDonations();
  }

  void _filterDonations() {
    setState(() {
      _filteredDonations = _allDonations.where((donation) {
        final matchesSearch = _searchController.text.isEmpty ||
            donation['projectName'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
            donation['category'].toLowerCase().contains(_searchController.text.toLowerCase());
        
        final matchesFilter = _selectedFilter == 'الكل' ||
            donation['category'] == _selectedFilter ||
            donation['status'] == _selectedFilter;
        
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // شريط البحث والفلاتر
          _buildSearchAndFilters(),
          
          // التبويبات
          _buildTabs(),
          
          // المحتوى
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllDonationsTab(),
                _buildStatisticsTab(),
                _buildImpactTab(),
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
          Icon(Icons.history, size: 24),
          SizedBox(width: 8),
          Text(
            'سجل التبرعات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: _exportDonations,
          tooltip: 'تصدير البيانات',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareDonations,
          tooltip: 'مشاركة الإنجازات',
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // شريط البحث
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ابحث في التبرعات...',
              prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // فلاتر سريعة
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'فلترة:',
                  _selectedFilter,
                  ['الكل', 'تعليم', 'صحة', 'غذاء', 'رعاية اجتماعية', 'بنية تحتية', 'مكتمل', 'قيد المعالجة'],
                  (value) {
                    setState(() {
                      _selectedFilter = value!;
                      _filterDonations();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
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
            icon: Icon(Icons.list),
            text: 'جميع التبرعات',
          ),
          Tab(
            icon: Icon(Icons.analytics),
            text: 'الإحصائيات',
          ),
          Tab(
            icon: Icon(Icons.emoji_events),
            text: 'الأثر المحقق',
          ),
        ],
      ),
    );
  }

  Widget _buildAllDonationsTab() {
    if (_filteredDonations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredDonations.length,
      itemBuilder: (context, index) {
        final donation = _filteredDonations[index];
        return _buildDonationCard(donation);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد تبرعات مطابقة',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب تغيير معايير البحث أو الفلترة',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          NawaButton.primary(
            text: 'مسح الفلاتر',
            icon: Icons.clear_all,
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedFilter = 'الكل';
                _filterDonations();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> donation) {
    final isCompleted = donation['status'] == 'مكتمل';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isCompleted ? AppColors.success.withValues(alpha: 0.3) : AppColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showDonationDetails(donation),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف الأول: اسم المشروع والحالة
              Row(
                children: [
                  Expanded(
                    child: Text(
                      donation['projectName'],
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(donation['status']),
                ],
              ),

              const SizedBox(height: 12),

              // الصف الثاني: المبلغ والتاريخ
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: AppColors.rating,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${donation['amount']} ${donation['currency']}',
                    style: AppTextStyles.numberMedium.copyWith(
                      color: AppColors.rating,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    donation['date'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // الصف الثالث: الفئة والأثر
              Row(
                children: [
                  _buildCategoryChip(donation['category']),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      donation['impact'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: NawaButton.secondary(
                      text: 'عرض التفاصيل',
                      icon: Icons.visibility,
                      onPressed: () => _showDonationDetails(donation),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: NawaButton.primary(
                      text: 'عرض الأثر',
                      icon: Icons.emoji_events,
                      onPressed: () => _viewImpact(donation),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isCompleted = status == 'مكتمل';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.success : AppColors.warning,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.schedule,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    const colors = {
      'تعليم': AppColors.primaryGreen,
      'صحة': Colors.red,
      'غذاء': Colors.orange,
      'رعاية اجتماعية': Colors.purple,
      'بنية تحتية': Colors.blue,
    };

    final color = colors[category] ?? AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        category,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    final totalAmount = _allDonations.fold<double>(0, (sum, donation) => sum + (donation['amount'] as num).toDouble());
    final completedDonations = _allDonations.where((d) => d['status'] == 'مكتمل').length;
    final averageAmount = _allDonations.isNotEmpty ? totalAmount / _allDonations.length : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // إحصائيات سريعة
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'إجمالي التبرعات',
                  '${totalAmount.toStringAsFixed(0)} ل.س',
                  Icons.monetization_on,
                  AppColors.rating,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'التبرعات المكتملة',
                  '$completedDonations',
                  Icons.check_circle,
                  AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'متوسط التبرع',
                  '${averageAmount.toStringAsFixed(0)} ل.س',
                  Icons.trending_up,
                  AppColors.primaryGreen,
                ),
              ),
              Expanded(
                child: _buildStatCard(
                  'عدد المشاريع',
                  '${_allDonations.length}',
                  Icons.business,
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.numberMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // إجمالي الأثر
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.primaryGreen.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
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
                const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'إجمالي الأثر المحقق',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildImpactStat('390', 'شخص استفاد', Icons.people),
                    _buildImpactStat('5', 'مشاريع دعمت', Icons.business),
                    _buildImpactStat('100%', 'نجاح التبرعات', Icons.check_circle),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // الأثر حسب المشروع
          ..._allDonations.map((donation) => _buildProjectImpactCard(donation)),
        ],
      ),
    );
  }

  Widget _buildImpactStat(String number, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          number,
          style: AppTextStyles.numberMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProjectImpactCard(Map<String, dynamic> donation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            donation['projectName'],
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: AppColors.like,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  donation['impact'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'مساهمتك: ${donation['amount']} ${donation['currency']}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // وظائف الإجراءات
  void _showDonationDetails(Map<String, dynamic> donation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل التبرع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المشروع: ${donation['projectName']}'),
            const SizedBox(height: 8),
            Text('المبلغ: ${donation['amount']} ${donation['currency']}'),
            const SizedBox(height: 8),
            Text('التاريخ: ${donation['date']}'),
            const SizedBox(height: 8),
            Text('الحالة: ${donation['status']}'),
            const SizedBox(height: 8),
            Text('الأثر: ${donation['impact']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _viewImpact(Map<String, dynamic> donation) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('عرض أثر: ${donation['projectName']}')),
    );
  }

  void _exportDonations() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة التصدير قريباً')),
    );
  }

  void _shareDonations() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة المشاركة قريباً')),
    );
  }
}
