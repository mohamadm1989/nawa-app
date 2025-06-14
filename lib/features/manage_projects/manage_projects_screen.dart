import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/models/models.dart';
import '../edit_project/edit_project_screen.dart';
import '../add_project/add_project_screen.dart';

/// صفحة إدارة المشاريع
class ManageProjectsScreen extends StatefulWidget {
  const ManageProjectsScreen({super.key});

  @override
  State<ManageProjectsScreen> createState() => _ManageProjectsScreenState();
}

class _ManageProjectsScreenState extends State<ManageProjectsScreen>
    with TickerProviderStateMixin {
  // ========== المتحكمات ==========
  late TabController _tabController;
  final _searchController = TextEditingController();

  // ========== المتغيرات ==========
  List<ProjectModel> _allProjects = [];
  List<ProjectModel> _filteredProjects = [];
  String _selectedFilter = 'all';
  bool _isLoading = true;

  // ========== فلاتر الحالة ==========
  final List<Map<String, dynamic>> _statusFilters = [
    {'value': 'all', 'label': 'الكل', 'color': AppColors.textSecondary},
    {'value': 'pending', 'label': 'في انتظار المراجعة', 'color': AppColors.warning},
    {'value': 'active', 'label': 'نشط', 'color': AppColors.success},
    {'value': 'paused', 'label': 'متوقف', 'color': AppColors.helperGray},
    {'value': 'completed', 'label': 'مكتمل', 'color': AppColors.primaryGreen},
    {'value': 'cancelled', 'label': 'ملغي', 'color': AppColors.error},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProjects();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المشاريع'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textOnColor.withValues(alpha: 0.7),
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
            Tab(text: 'مشاريعي', icon: Icon(Icons.folder)),
            Tab(text: 'المراجعة', icon: Icon(Icons.pending_actions)),
            Tab(text: 'الإحصائيات', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'فلترة',
          ),
          IconButton(
            onPressed: _refreshProjects,
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyProjectsTab(),
          _buildPendingReviewTab(),
          _buildStatisticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProject,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
        icon: const Icon(Icons.add),
        label: const Text('مشروع جديد'),
      ),
    );
  }

  Widget _buildMyProjectsTab() {
    return Column(
      children: [
        // شريط البحث والفلترة
        _buildSearchAndFilterBar(),
        
        // قائمة المشاريع
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredProjects.isEmpty
                  ? _buildEmptyState()
                  : _buildProjectsList(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      color: AppColors.backgroundCard,
      child: Column(
        children: [
          // شريط البحث
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'البحث في المشاريع...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterProjects();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
            onChanged: (value) => _filterProjects(),
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // فلاتر الحالة
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _statusFilters.length,
              itemBuilder: (context, index) {
                final filter = _statusFilters[index];
                final isSelected = _selectedFilter == filter['value'];
                
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter['label']),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter['value'];
                      });
                      _filterProjects();
                    },
                    selectedColor: filter['color'].withValues(alpha: 0.2),
                    checkmarkColor: filter['color'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: _filteredProjects.length,
      itemBuilder: (context, index) {
        final project = _filteredProjects[index];
        return _buildProjectManagementCard(project);
      },
    );
  }

  Widget _buildProjectManagementCard(ProjectModel project) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس الكرت
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.basic.title,
                        style: AppTextStyles.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatusChip(project.basic.status),
                          const SizedBox(width: 8),
                          _buildPriorityChip(project.basic.priority),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (action) => _handleProjectAction(action, project),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 20),
                          SizedBox(width: 8),
                          Text('نسخ'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'archive',
                      child: Row(
                        children: [
                          Icon(Icons.archive, size: 20),
                          SizedBox(width: 8),
                          Text('أرشفة'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // معلومات المشروع
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    'الموقع',
                    '${project.location.city}, ${project.location.district}',
                    Icons.location_on,
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    'المبلغ المطلوب',
                    '${project.financial.targetAmount.toStringAsFixed(0)} ${project.financial.currency}',
                    Icons.attach_money,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // شريط التقدم
            _buildProgressBar(project),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // إحصائيات سريعة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat('متبرعين', '${project.engagement.supporters}', Icons.people),
                _buildQuickStat('إعجابات', '${project.engagement.likes}', Icons.favorite),
                _buildQuickStat('مشاهدات', '${project.engagement.views}', Icons.visibility),
                _buildQuickStat('تعليقات', '${project.engagement.comments}', Icons.comment),
              ],
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editProject(project),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewProjectDetails(project),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('عرض'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final statusData = _statusFilters.firstWhere(
      (filter) => filter['value'] == status,
      orElse: () => _statusFilters.first,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusData['color'].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusData['color'], width: 1),
      ),
      child: Text(
        statusData['label'],
        style: AppTextStyles.bodySmall.copyWith(
          color: statusData['color'],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    String label;

    switch (priority) {
      case 'low':
        color = AppColors.success;
        label = 'منخفضة';
        break;
      case 'medium':
        color = AppColors.warning;
        label = 'متوسطة';
        break;
      case 'high':
        color = AppColors.error;
        label = 'عالية';
        break;
      case 'urgent':
        color = AppColors.error;
        label = 'عاجلة';
        break;
      default:
        color = AppColors.textSecondary;
        label = 'غير محدد';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgressBar(ProjectModel project) {
    final progress = project.financial.currentAmount / project.financial.targetAmount;
    final progressPercentage = (progress * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تقدم التمويل',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${progressPercentage.toStringAsFixed(1)}%',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.progressBackground,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          minHeight: 6,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${project.financial.currentAmount.toStringAsFixed(0)} ${project.financial.currency}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${project.financial.targetAmount.toStringAsFixed(0)} ${project.financial.currency}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryGreen),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPendingReviewTab() {
    final pendingProjects = _allProjects.where((p) => p.basic.status == 'pending').toList();

    if (pendingProjects.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.success,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد مشاريع في انتظار المراجعة',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: pendingProjects.length,
      itemBuilder: (context, index) {
        final project = pendingProjects[index];
        return _buildPendingProjectCard(project);
      },
    );
  }

  Widget _buildPendingProjectCard(ProjectModel project) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.pending_actions,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.basic.title,
                        style: AppTextStyles.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تم الإرسال: ${project.timeline.createdAt.day}/${project.timeline.createdAt.month}/${project.timeline.createdAt.year}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            Text(
              project.basic.description,
              style: AppTextStyles.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editProject(project),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveProject(project),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('موافقة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return Container(
      color: AppColors.backgroundCard,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الصفحة
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.primaryGreen,
                    AppColors.primaryGreen.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.analytics,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingLarge),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'لوحة الإحصائيات',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تحليل شامل لجميع المشاريع والأنشطة',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacingXLarge),

            // إحصائيات عامة
            _buildStatisticsOverview(),

            const SizedBox(height: AppConstants.spacingXLarge),

            // إحصائيات حسب الحالة
            _buildStatusStatistics(),

            const SizedBox(height: AppConstants.spacingXLarge),

            // إحصائيات حسب التصنيف
            _buildCategoryStatistics(),

            const SizedBox(height: AppConstants.spacingXLarge),

            // معلومات إضافية
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsOverview() {
    final totalProjects = _allProjects.length;
    final totalAmount = _allProjects.fold<double>(
      0, (sum, project) => sum + project.financial.targetAmount
    );
    final totalRaised = _allProjects.fold<double>(
      0, (sum, project) => sum + project.financial.currentAmount
    );
    final totalSupporters = _allProjects.fold<int>(
      0, (sum, project) => sum + project.engagement.supporters
    );

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإحصائيات العامة',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نظرة شاملة على جميع المشاريع',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // الإحصائيات في شبكة منظمة
          LayoutBuilder(
            builder: (context, constraints) {
              // تحديد عدد الأعمدة حسب عرض الشاشة
              int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              double childAspectRatio = constraints.maxWidth > 600 ? 2.2 : 2.5; // الحل الجذري: زيادة كبيرة للمساحة

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: AppConstants.spacingMedium,
                mainAxisSpacing: AppConstants.spacingMedium,
                children: [
                  _buildEnhancedStatCard(
                    'إجمالي المشاريع',
                    totalProjects.toString(),
                    'مشروع',
                    Icons.folder_open,
                    AppColors.primaryGreen,
                    'مشروع نشط',
                  ),
                  _buildEnhancedStatCard(
                    'المبلغ المطلوب',
                    _formatCurrency(totalAmount),
                    'دولار',
                    Icons.attach_money,
                    AppColors.warning,
                    'إجمالي التمويل المطلوب',
                  ),
                  _buildEnhancedStatCard(
                    'المبلغ المجمع',
                    _formatCurrency(totalRaised),
                    'دولار',
                    Icons.trending_up,
                    AppColors.success,
                    'تم جمعه بنجاح',
                  ),
                  _buildEnhancedStatCard(
                    'المتبرعين',
                    totalSupporters.toString(),
                    'متبرع',
                    Icons.people,
                    AppColors.info,
                    'يدعمون المشاريع',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // شريط التقدم الإجمالي
          _buildOverallProgressBar(totalRaised, totalAmount),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedStatCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSmall), // تقليل padding الرئيسي
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight( // الحل الجذري: استخدام IntrinsicHeight
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة والعنوان
            Flexible(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 10, // تقليل أكثر
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: FittedBox( // الحل الجذري: استخدام FittedBox
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            // القيمة الرئيسية
            Expanded( // الحل الجذري: استخدام Expanded
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            // النص التوضيحي (اختياري ومبسط)
            if (subtitle.isNotEmpty && subtitle.length < 10) ...[
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                      fontSize: 6,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgressBar(double currentAmount, double targetAmount) {
    final progress = targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
    final progressPercentage = (progress * 100);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'التقدم الإجمالي للتمويل',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${progressPercentage.toStringAsFixed(1)}%',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingSmall),

          // شريط التقدم
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.progressBackground,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.primaryGreen.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.spacingSmall),

          // المبالغ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تم جمع: ${_formatCurrency(currentAmount)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'المطلوب: ${_formatCurrency(targetAmount)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.secondaryBeige.withValues(alpha: 0.3),
            AppColors.secondaryBeige.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(
          color: AppColors.secondaryBeige.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBeige.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات إضافية',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نصائح وإرشادات لإدارة أفضل',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // النصائح والإرشادات
          Row(
            children: [
              Expanded(
                child: _buildInfoTip(
                  'نصيحة',
                  'راجع المشاريع بانتظام لضمان التقدم المستمر',
                  Icons.lightbulb_outline,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildInfoTip(
                  'تذكير',
                  'تواصل مع المتبرعين وأرسل تحديثات دورية',
                  Icons.notifications_outlined,
                  AppColors.info,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          Row(
            children: [
              Expanded(
                child: _buildInfoTip(
                  'هدف',
                  'اسعى لتحقيق 100% من التمويل لجميع المشاريع',
                  Icons.flag_outlined,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildInfoTip(
                  'تطوير',
                  'أضف مشاريع جديدة لتوسيع نطاق التأثير',
                  Icons.trending_up,
                  AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTip(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStatistics() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.pie_chart,
                  color: AppColors.info,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'توزيع المشاريع حسب الحالة',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نظرة على حالة جميع المشاريع',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // قائمة الحالات مع شرائط التقدم
          ..._statusFilters.skip(1).map((status) {
            final count = _allProjects.where((p) => p.basic.status == status['value']).length;
            final percentage = _allProjects.isNotEmpty ? (count / _allProjects.length * 100) : 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              decoration: BoxDecoration(
                color: status['color'].withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                border: Border.all(
                  color: status['color'].withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // الصف الأول: الأيقونة والنص والرقم
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: status['color'],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingMedium),
                      Expanded(
                        child: Text(
                          status['label'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: status['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: status['color'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingSmall),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.spacingSmall),

                  // شريط التقدم
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: status['color'].withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(status['color']),
                    minHeight: 6,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryStatistics() {
    final categories = [
      {'value': 'education', 'label': 'تعليم', 'icon': Icons.school, 'color': AppColors.primaryGreen},
      {'value': 'health', 'label': 'صحة', 'icon': Icons.local_hospital, 'color': AppColors.error},
      {'value': 'infrastructure', 'label': 'بنية تحتية', 'icon': Icons.construction, 'color': AppColors.warning},
      {'value': 'housing', 'label': 'إسكان', 'icon': Icons.home, 'color': AppColors.info},
      {'value': 'social', 'label': 'اجتماعي', 'icon': Icons.people, 'color': AppColors.success},
      {'value': 'economic', 'label': 'اقتصادي', 'icon': Icons.business, 'color': Colors.purple},
    ];

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.category,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'توزيع المشاريع حسب التصنيف',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'أنواع المشاريع المختلفة',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // شبكة التصنيفات
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2, // الحل الجذري النهائي: مساحة كبيرة لإظهار المحتوى بوضوح
              crossAxisSpacing: AppConstants.spacingMedium,
              mainAxisSpacing: AppConstants.spacingMedium,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final count = _allProjects.where((p) => p.basic.category == category['value']).length;
              final percentage = _allProjects.isNotEmpty ? (count / _allProjects.length * 100) : 0.0;

              return Container(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(
                    color: (category['color'] as Color).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ClipRect( // الحل الجذري: إخفاء المحتوى الزائد نهائ<|im_start|>ح
                  child: Padding(
                    padding: const EdgeInsets.all(4.0), // تقليل المساحة الداخلية
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // تقليل الحجم للحد الأدنى
                      children: [
                    // الأيقونة والعنوان
                    Row(
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          color: category['color'] as Color,
                          size: 14, // تقليل حجم الأيقونة
                        ),
                        const SizedBox(width: 6), // تقليل المسافة
                        Expanded(
                          child: Text(
                            category['label'] as String,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 11, // تقليل حجم الخط
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4), // تقليل المسافة

                    // العدد والنسبة
                    Row(
                      children: [
                        Text(
                          '$count',
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: category['color'] as Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // تقليل حجم الخط
                          ),
                        ),
                        const SizedBox(width: 3), // تقليل المسافة
                        Text(
                          'مشروع',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 9, // تقليل حجم الخط
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${percentage.toStringAsFixed(0)}%', // إزالة الكسور العشرية
                          style: AppTextStyles.bodySmall.copyWith(
                            color: category['color'] as Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 11, // تقليل حجم الخط
                          ),
                        ),
                      ],
                    ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد مشاريع',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'اضغط على "مشروع جديد" لإضافة أول مشروع',
            style: TextStyle(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  // ========== الدوال المساعدة ==========

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // محاكاة تحميل المشاريع
      await Future.delayed(const Duration(seconds: 1));

      // TODO: تحميل المشاريع من قاعدة البيانات
      _allProjects = _generateSampleProjects();
      _filterProjects();

    } catch (e) {
      _showErrorSnackBar('حدث خطأ أثناء تحميل المشاريع');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterProjects() {
    setState(() {
      _filteredProjects = _allProjects.where((project) {
        // فلترة حسب النص
        bool matchesSearch = _searchController.text.isEmpty ||
            project.basic.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            project.basic.description.toLowerCase().contains(_searchController.text.toLowerCase());

        // فلترة حسب الحالة
        bool matchesStatus = _selectedFilter == 'all' ||
            project.basic.status == _selectedFilter;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _refreshProjects() async {
    await _loadProjects();
    _showSuccessSnackBar('تم تحديث المشاريع بنجاح');
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('فلترة المشاريع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _statusFilters.map((filter) {
            return RadioListTile<String>(
              title: Text(filter['label']),
              value: filter['value'],
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                _filterProjects();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _addNewProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProjectScreen(),
      ),
    );

    if (result == true) {
      _refreshProjects();
    }
  }

  Future<void> _editProject(ProjectModel project) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProjectScreen(project: project),
      ),
    );

    if (result != null) {
      _refreshProjects();
    }
  }

  void _viewProjectDetails(ProjectModel project) {
    // TODO: الانتقال لصفحة تفاصيل المشروع
    _showInfoSnackBar('عرض تفاصيل المشروع: ${project.basic.title}');
  }

  void _handleProjectAction(String action, ProjectModel project) {
    switch (action) {
      case 'edit':
        _editProject(project);
        break;
      case 'duplicate':
        _duplicateProject(project);
        break;
      case 'archive':
        _archiveProject(project);
        break;
      case 'delete':
        _deleteProject(project);
        break;
    }
  }

  void _duplicateProject(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نسخ المشروع'),
        content: Text('هل تريد إنشاء نسخة من "${project.basic.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تنفيذ نسخ المشروع
              _showSuccessSnackBar('تم نسخ المشروع بنجاح');
              _refreshProjects();
            },
            child: const Text('نسخ'),
          ),
        ],
      ),
    );
  }

  void _archiveProject(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('أرشفة المشروع'),
        content: Text('هل تريد أرشفة "${project.basic.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تنفيذ أرشفة المشروع
              _showSuccessSnackBar('تم أرشفة المشروع بنجاح');
              _refreshProjects();
            },
            child: const Text('أرشفة'),
          ),
        ],
      ),
    );
  }

  void _deleteProject(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المشروع'),
        content: Text('هل أنت متأكد من حذف "${project.basic.title}"؟ هذا الإجراء لا يمكن التراجع عنه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تنفيذ حذف المشروع
              _showSuccessSnackBar('تم حذف المشروع بنجاح');
              _refreshProjects();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _approveProject(ProjectModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('موافقة على المشروع'),
        content: Text('هل تريد الموافقة على "${project.basic.title}" ونشره؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تنفيذ الموافقة على المشروع
              _showSuccessSnackBar('تم الموافقة على المشروع ونشره');
              _refreshProjects();
            },
            child: const Text('موافقة'),
          ),
        ],
      ),
    );
  }

  List<ProjectModel> _generateSampleProjects() {
    // مشاريع سورية حقيقية - بيانات واقعية
    return [
      ProjectModel(
        projectId: 'proj_001',
        basic: const ProjectBasic(
          title: 'إعادة تأهيل مدرسة الشهيد باسل الأسد - حلب',
          description: 'مشروع إعادة تأهيل وترميم مدرسة الشهيد باسل الأسد في حي الصاخور بحلب، تضم 24 صف دراسي وتستوعب 800 طالب وطالبة',
          category: 'education',
          status: 'active',
          priority: 'high',
          tags: ['تعليم', 'إعمار', 'حلب', 'مدارس'],
        ),
        location: const ProjectLocation(
          city: 'حلب',
          district: 'الصاخور',
          address: 'شارع النيل - حي الصاخور',
          coordinates: GeoCoordinates(lat: 36.2021, lng: 37.1343),
        ),
        financial: const ProjectFinancial(
          targetAmount: 450000,
          currentAmount: 285000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 300000,
            labor: 120000,
            other: 30000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          expectedEndDate: DateTime.now().add(const Duration(days: 90)),
        ),
        creator: const ProjectCreator(
          uid: 'creator_001',
          name: 'جمعية نهضة حلب التعليمية',
          role: 'منظمة محلية',
          contact: '+963-21-2234567',
        ),
        media: const ProjectMedia(
          mainImage: 'https://example.com/school_main.jpg',
          gallery: [
            'https://example.com/school1.jpg',
            'https://example.com/school2.jpg',
            'https://example.com/school3.jpg',
          ],
          documents: ['تقرير_المشروع.pdf', 'الميزانية_التفصيلية.pdf'],
        ),
        engagement: const ProjectEngagement(
          supporters: 156,
          likes: 342,
          comments: 89,
          shares: 67,
          views: 2341,
        ),
        verification: ProjectVerification(
          status: 'verified',
          verifiedBy: 'وزارة التربية والتعليم',
          verificationDate: DateTime.now().subtract(const Duration(days: 20)),
          documents: ['ترخيص_البناء.pdf', 'موافقة_الوزارة.pdf'],
        ),
      ),

      ProjectModel(
        projectId: 'proj_002',
        basic: const ProjectBasic(
          title: 'مركز الرعاية الصحية الأولية - إدلب',
          description: 'إنشاء مركز صحي متكامل يقدم خدمات الرعاية الأولية والطوارئ لسكان ريف إدلب الشمالي، يخدم أكثر من 15000 نسمة',
          category: 'health',
          status: 'pending',
          priority: 'urgent',
          tags: ['صحة', 'طوارئ', 'إدلب', 'رعاية أولية'],
        ),
        location: const ProjectLocation(
          city: 'إدلب',
          district: 'سرمدا',
          address: 'الطريق الرئيسي - مدينة سرمدا',
          coordinates: GeoCoordinates(lat: 36.2167, lng: 36.7167),
        ),
        financial: const ProjectFinancial(
          targetAmount: 320000,
          currentAmount: 125000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 200000,
            labor: 80000,
            other: 40000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
          startDate: DateTime.now().add(const Duration(days: 15)),
          expectedEndDate: DateTime.now().add(const Duration(days: 120)),
        ),
        creator: const ProjectCreator(
          uid: 'creator_002',
          name: 'منظمة الإغاثة الطبية السورية',
          role: 'منظمة إنسانية',
          contact: '+90-532-1234567',
        ),
        media: const ProjectMedia(
          mainImage: 'https://example.com/health_center_main.jpg',
          gallery: [
            'https://example.com/health1.jpg',
            'https://example.com/health2.jpg',
          ],
          documents: ['دراسة_الجدوى.pdf', 'التصاميم_الهندسية.pdf'],
        ),
        engagement: const ProjectEngagement(
          supporters: 89,
          likes: 234,
          comments: 45,
          shares: 32,
          views: 1567,
        ),
        verification: const ProjectVerification(
          status: 'pending',
          documents: ['طلب_الترخيص.pdf'],
        ),
      ),

      ProjectModel(
        projectId: 'proj_003',
        basic: const ProjectBasic(
          title: 'مشروع توزيع السلال الغذائية - درعا',
          description: 'توزيع 2000 سلة غذائية شهرياً على العائلات المحتاجة في محافظة درعا، تحتوي كل سلة على مواد غذائية أساسية تكفي عائلة من 5 أفراد لمدة شهر',
          category: 'emergency',
          status: 'completed',
          priority: 'high',
          tags: ['إغاثة', 'غذاء', 'درعا', 'عائلات محتاجة'],
        ),
        location: const ProjectLocation(
          city: 'درعا',
          district: 'درعا البلد',
          address: 'مركز التوزيع الرئيسي - ساحة العمري',
          coordinates: GeoCoordinates(lat: 32.6189, lng: 36.1021),
        ),
        financial: const ProjectFinancial(
          targetAmount: 180000,
          currentAmount: 180000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 150000,
            labor: 20000,
            other: 10000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 120)),
          startDate: DateTime.now().subtract(const Duration(days: 90)),
          expectedEndDate: DateTime.now().subtract(const Duration(days: 30)),
          actualEndDate: DateTime.now().subtract(const Duration(days: 25)),
        ),
        creator: const ProjectCreator(
          uid: 'creator_003',
          name: 'جمعية الهلال الأحمر السوري - فرع درعا',
          role: 'منظمة إنسانية',
          contact: '+963-15-2345678',
        ),
        media: const ProjectMedia(
          mainImage: 'https://example.com/food_distribution_main.jpg',
          gallery: [
            'https://example.com/food1.jpg',
            'https://example.com/food2.jpg',
            'https://example.com/food3.jpg',
            'https://example.com/food4.jpg',
          ],
          documents: ['تقرير_التوزيع_النهائي.pdf', 'قوائم_المستفيدين.pdf'],
        ),
        engagement: const ProjectEngagement(
          supporters: 267,
          likes: 456,
          comments: 123,
          shares: 89,
          views: 3456,
        ),
        verification: ProjectVerification(
          status: 'verified',
          verifiedBy: 'وزارة الشؤون الاجتماعية والعمل',
          verificationDate: DateTime.now().subtract(const Duration(days: 100)),
          documents: ['ترخيص_التوزيع.pdf', 'تقرير_المراقبة.pdf'],
        ),
      ),

      ProjectModel(
        projectId: 'proj_004',
        basic: const ProjectBasic(
          title: 'دار الأيتام "براعم الأمل" - حمص',
          description: 'دار لرعاية الأطفال الأيتام في مدينة حمص، تستوعب 120 طفل وطفلة، تقدم الرعاية الكاملة والتعليم والتأهيل النفسي',
          category: 'social',
          status: 'active',
          priority: 'high',
          tags: ['أيتام', 'رعاية اجتماعية', 'حمص', 'أطفال'],
        ),
        location: const ProjectLocation(
          city: 'حمص',
          district: 'الوعر',
          address: 'شارع الثورة - حي الوعر',
          coordinates: GeoCoordinates(lat: 34.7394, lng: 36.7076),
        ),
        financial: const ProjectFinancial(
          targetAmount: 280000,
          currentAmount: 165000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 180000,
            labor: 70000,
            other: 30000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          startDate: DateTime.now().subtract(const Duration(days: 40)),
          expectedEndDate: DateTime.now().add(const Duration(days: 60)),
        ),
        creator: const ProjectCreator(
          uid: 'creator_004',
          name: 'جمعية براعم الأمل الخيرية',
          role: 'جمعية خيرية',
          contact: '+963-31-3456789',
        ),
        media: const ProjectMedia(
          mainImage: 'https://example.com/orphanage_main.jpg',
          gallery: [
            'https://example.com/orphanage1.jpg',
            'https://example.com/orphanage2.jpg',
            'https://example.com/orphanage3.jpg',
          ],
          documents: ['ترخيص_دار_الأيتام.pdf', 'برنامج_الرعاية.pdf'],
        ),
        engagement: const ProjectEngagement(
          supporters: 198,
          likes: 387,
          comments: 76,
          shares: 54,
          views: 2789,
        ),
        verification: ProjectVerification(
          status: 'verified',
          verifiedBy: 'وزارة الشؤون الاجتماعية والعمل',
          verificationDate: DateTime.now().subtract(const Duration(days: 35)),
          documents: ['ترخيص_الجمعية.pdf', 'موافقة_الوزارة.pdf'],
        ),
      ),

      ProjectModel(
        projectId: 'proj_005',
        basic: const ProjectBasic(
          title: 'مشروع حفر آبار المياه - الرقة',
          description: 'حفر 15 بئر مياه جوفية في قرى ريف الرقة الشرقي لتوفير مياه الشرب النظيفة لأكثر من 8000 نسمة',
          category: 'infrastructure',
          status: 'active',
          priority: 'urgent',
          tags: ['مياه', 'آبار', 'الرقة', 'بنية تحتية'],
        ),
        location: const ProjectLocation(
          city: 'الرقة',
          district: 'تل أبيض',
          address: 'قرى ريف الرقة الشرقي',
          coordinates: GeoCoordinates(lat: 35.9500, lng: 39.0167),
        ),
        financial: const ProjectFinancial(
          targetAmount: 375000,
          currentAmount: 220000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 250000,
            labor: 100000,
            other: 25000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 35)),
          startDate: DateTime.now().subtract(const Duration(days: 20)),
          expectedEndDate: DateTime.now().add(const Duration(days: 75)),
        ),
        creator: const ProjectCreator(
          uid: 'creator_005',
          name: 'منظمة المياه للجميع',
          role: 'منظمة تنموية',
          contact: '+90-533-7654321',
        ),
        media: const ProjectMedia(
          mainImage: 'https://example.com/water_wells_main.jpg',
          gallery: [
            'https://example.com/well1.jpg',
            'https://example.com/well2.jpg',
            'https://example.com/well3.jpg',
          ],
          documents: ['دراسة_المياه_الجوفية.pdf', 'خرائط_المواقع.pdf'],
        ),
        engagement: const ProjectEngagement(
          supporters: 134,
          likes: 298,
          comments: 67,
          shares: 43,
          views: 1987,
        ),
        verification: const ProjectVerification(
          status: 'pending',
          documents: ['طلب_ترخيص_الحفر.pdf'],
        ),
      ),

      ProjectModel(
        projectId: 'proj_006',
        basic: const ProjectBasic(
          title: 'مركز التدريب المهني للشباب - اللاذقية',
          description: 'مركز تدريب مهني يقدم دورات في الحرف اليدوية والتقنية للشباب العاطلين عن العمل، يستوعب 200 متدرب سنوياً',
          category: 'development',
          status: 'pending',
          priority: 'medium',
          tags: ['تدريب مهني', 'شباب', 'اللاذقية', 'تنمية'],
        ),
        location: const ProjectLocation(
          city: 'اللاذقية',
          district: 'الرمل الجنوبي',
          address: 'شارع 8 آذار - الرمل الجنوبي',
          coordinates: GeoCoordinates(lat: 35.5138, lng: 35.7833),
        ),
        financial: const ProjectFinancial(
          targetAmount: 195000,
          currentAmount: 58000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 120000,
            labor: 50000,
            other: 25000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 18)),
          expectedEndDate: DateTime.now().add(const Duration(days: 150)),
        ),
        creator: const ProjectCreator(
          uid: 'creator_006',
          name: 'جمعية تنمية المهارات السورية',
          role: 'جمعية تنموية',
          contact: '+963-41-4567890',
        ),
        media: const ProjectMedia(
          mainImage: 'https://example.com/training_center_main.jpg',
          gallery: [
            'https://example.com/training1.jpg',
            'https://example.com/training2.jpg',
          ],
          documents: ['برنامج_التدريب.pdf', 'دراسة_السوق.pdf'],
        ),
        engagement: const ProjectEngagement(
          supporters: 67,
          likes: 145,
          comments: 23,
          shares: 18,
          views: 892,
        ),
        verification: const ProjectVerification(
          status: 'pending',
          documents: ['طلب_الترخيص.pdf'],
        ),
      ),
    ];
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.fixed, // إصلاح مشكلة off screen
        margin: EdgeInsets.zero,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.fixed, // إصلاح مشكلة off screen
        margin: EdgeInsets.zero,
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.fixed, // إصلاح مشكلة off screen
        margin: EdgeInsets.zero,
      ),
    );
  }
}
