import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
// import '../../core/services/auth_service.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/local_storage_manager.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/mobile_responsive.dart';
import '../../core/animations/nawa_animations.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/models/project_model.dart';
// import '../../shared/models/user_model.dart';

/// الصفحة الرئيسية
/// تعرض قائمة المشاريع مع إمكانية البحث والتصفية
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final LocalStorageManager _storage = LocalStorageManager.instance;
  Map<String, dynamic>? _currentUser;
  List<ProjectModel> _projects = [];
  List<ProjectModel> _filteredProjects = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ========== الهيدر ==========
            _buildHeader(),
            
            // ========== البحث والتصفية ==========
            _buildSearchAndFilter(),
            
            // ========== قائمة المشاريع ==========
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildProjectsList(),
            ),
          ],
        ),
      ),
      // ========== التنقل السفلي ==========
      bottomNavigationBar: _buildBottomNavigation(),
      
      // ========== زر إضافة مشروع ==========
      floatingActionButton: MobileResponsive.shouldShowFAB(context)
          ? _buildAddProjectFAB()
          : null,
      floatingActionButtonLocation: MobileResponsive.getFABLocation(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.borderRadiusLarge),
          bottomRight: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف العلوي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الترحيب
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textOnColor.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      _currentUser?['name'] ?? 'مستخدم',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textOnColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // الإشعارات والملف الشخصي
              Row(
                children: [
                  IconButton(
                    onPressed: _handleNotifications,
                    icon: const Icon(
                      Icons.notifications,
                      color: AppColors.textOnColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleProfile,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.secondaryBeige,
                      backgroundImage: _currentUser?['avatar'] != null
                          ? NetworkImage(_currentUser!['avatar']!)
                          : null,
                      child: _currentUser?['avatar'] == null
                          ? Text(
                              (_currentUser?['name'] as String?)?.substring(0, 1) ?? 'م',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // الرسالة التحفيزية
          Text(
            'شو رأيك نساعد اليوم؟',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textOnColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Column(
        children: [
          // شريط البحث
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ابحث عن مشروع...',
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
            ),
            onChanged: (_) => _filterProjects(),
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // فلاتر التصنيف
          _buildCategoryFilters(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      {'key': 'all', 'name': 'الكل', 'icon': Icons.apps},
      {'key': 'education', 'name': 'تعليم', 'icon': Icons.school},
      {'key': 'health', 'name': 'صحة', 'icon': Icons.local_hospital},
      {'key': 'infrastructure', 'name': 'بنية تحتية', 'icon': Icons.construction},
      {'key': 'environment', 'name': 'بيئة', 'icon': Icons.eco},
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['key'];
          
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSmall),
            child: FilterChip(
              selected: isSelected,
              label: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 16,
                      color: isSelected ? AppColors.textOnColor : AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        category['name'] as String,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category['key'] as String;
                });
                _filterProjects();
              },
              backgroundColor: AppColors.backgroundCard,
              selectedColor: AppColors.primaryGreen,
              labelStyle: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.textOnColor : AppColors.primaryGreen,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectsList() {
    if (_filteredProjects.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ResponsiveHelper.isMobile(context)
          ? _buildMobileList()
          : _buildGridLayout(),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: MobileResponsive.shouldShowFAB(context) ? 80 : 16,
        left: MobileResponsive.getResponsivePadding(context, 16),
        right: MobileResponsive.getResponsivePadding(context, 16),
      ),
      itemCount: _filteredProjects.length,
      itemBuilder: (context, index) {
        final project = _filteredProjects[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          transform: Matrix4.translationValues(0, 0, 0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: MobileResponsive.getSpacing(context, 6),
            ),
            child: InteractiveAnimation(
              onTap: () => _handleProjectTap(project),
              child: ProjectCard(
                project: project,
                onTap: () => _handleProjectTap(project),
                onDonate: () => _handleDonate(project),
                onLike: () => _handleLike(project),
                isLiked: _storage.isFavorite(project.projectId),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridLayout() {
    return ResponsiveContainer(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.getGridColumns(
                  context,
                  mobileColumns: 1,
                  tabletColumns: 2,
                  desktopColumns: 3,
                ),
                childAspectRatio: ResponsiveHelper.getCardAspectRatio(context),
                crossAxisSpacing: ResponsiveHelper.getSpacing(context),
                mainAxisSpacing: ResponsiveHelper.getSpacing(context),
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final project = _filteredProjects[index];
                  return ProjectCard(
                    project: project,
                    onTap: () => _handleProjectTap(project),
                    onDonate: () => _handleDonate(project),
                    onLike: () => _handleLike(project),
                    isLiked: _storage.isFavorite(project.projectId),
                  );
                },
                childCount: _filteredProjects.length,
              ),
            ),
          ),
          // مساحة إضافية في الأسفل
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoadingAnimation(
            color: AppColors.primaryGreen,
            size: 60,
            type: LoadingType.pulse,
          ),
          const SizedBox(height: 24),
          StaggeredAnimation(
            children: const [
              Text(
                'جاري تحميل المشاريع...',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'شوي صبر... 😊',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.helperGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'لا توجد مشاريع تطابق البحث',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            'جرب تغيير كلمات البحث أو الفلاتر',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
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
      onTap: _handleBottomNavTap,
    );
  }

  Widget _buildAddProjectFAB() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "manage_projects",
          onPressed: _handleManageProjects,
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          mini: true,
          tooltip: 'إدارة المشاريع',
          child: const Icon(Icons.folder_open),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: "test_font",
          onPressed: _handleTestFont,
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          mini: true,
          tooltip: 'اختبار الخط',
          child: const Icon(Icons.font_download),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: "map",
          onPressed: _handleMapView,
          backgroundColor: AppColors.secondaryBeige,
          foregroundColor: AppColors.primaryGreen,
          mini: true,
          tooltip: 'خريطة المشاريع',
          child: const Icon(Icons.map),
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: "add",
          onPressed: _handleAddProject,
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          icon: const Icon(Icons.add),
          label: const Text('مشروع جديد'),
        ),
      ],
    );
  }

  // ========== معالجات الأحداث ==========

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // تحميل بيانات المستخدم الآمنة
      _currentUser = UserDataManager.getSafeUserData();
      
      // تحميل المشاريع (بيانات تجريبية)
      await Future.delayed(const Duration(seconds: 1)); // محاكاة التحميل
      _projects = _generateSampleProjects();
      _filteredProjects = _projects;
      
    } catch (e) {
      _showErrorSnackBar('خطأ في تحميل البيانات');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterProjects() {
    setState(() {
      _filteredProjects = _projects.where((project) {
        // فلترة حسب النص
        bool matchesSearch = _searchController.text.isEmpty ||
            project.basic.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            project.basic.description.toLowerCase().contains(_searchController.text.toLowerCase());
        
        // فلترة حسب التصنيف
        bool matchesCategory = _selectedCategory == 'all' ||
            project.basic.category == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return 'مساء الخير';
    } else {
      return 'مساء الخير';
    }
  }

  void _handleProjectTap(ProjectModel project) {
    AppRoutes.pushProjectDetails(context, project.projectId);
  }

  void _handleDonate(ProjectModel project) {
    AppRoutes.pushDonate(context, project.projectId);
  }

  Future<void> _handleLike(ProjectModel project) async {
    final success = await _storage.toggleFavorite(project.projectId);
    if (success) {
      setState(() {}); // إعادة بناء الواجهة لتحديث حالة القلب
      final isFavorite = _storage.isFavorite(project.projectId);
      _showInfoSnackBar(
        isFavorite ? 'تم إضافة المشروع للمفضلة' : 'تم إزالة المشروع من المفضلة'
      );
    } else {
      _showErrorSnackBar('فشل في تحديث المفضلة');
    }
  }

  void _handleNotifications() {
    AppRoutes.pushNotifications(context);
  }

  void _handleProfile() {
    AppRoutes.pushProfile(context);
  }

  void _handleBottomNavTap(int index) {
    switch (index) {
      case 0:
        // الرئيسية (الصفحة الحالية)
        break;
      case 1:
        AppRoutes.pushSearch(context);
        break;
      case 2:
        AppRoutes.pushFavorites(context);
        break;
      case 3:
        AppRoutes.pushProfile(context);
        break;
    }
  }

  void _handleAddProject() {
    AppRoutes.pushAddProject(context);
  }

  void _handleMapView() {
    Navigator.pushNamed(context, AppRoutes.map);
  }

  void _handleTestFont() {
    Navigator.pushNamed(context, AppRoutes.testFont);
  }

  void _handleManageProjects() {
    Navigator.pushNamed(context, AppRoutes.manageProjects);
  }

  // ========== البيانات التجريبية ==========

  List<ProjectModel> _generateSampleProjects() {
    return [
      // مشروع تعليمي
      ProjectModel(
        projectId: '1',
        basic: const ProjectBasic(
          title: 'ترميم مدرسة الأمل',
          description: 'مشروع لترميم مدرسة الأمل في حي الصالحين لتوفير بيئة تعليمية آمنة للأطفال',
          category: 'education',
          status: 'active',
          priority: 'high',
          tags: ['school', 'renovation', 'children'],
        ),
        location: ProjectLocation(
          city: 'حلب',
          district: 'الصالحين',
          address: 'شارع المدرسة، بناء رقم 15',
          coordinates: GeoCoordinates(lat: 36.2021, lng: 37.1343),
        ),
        financial: const ProjectFinancial(
          targetAmount: 5000.0,
          currentAmount: 2500.0,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 3000.0,
            labor: 1500.0,
            other: 500.0,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          startDate: DateTime.now().subtract(const Duration(days: 5)),
          expectedEndDate: DateTime.now().add(const Duration(days: 30)),
        ),
        creator: const ProjectCreator(
          uid: 'creator1',
          name: 'أبو محمد',
          role: 'مدير المدرسة',
          contact: '+963912345678',
        ),
        media: const ProjectMedia(
          mainImage: null,
          gallery: [],
          documents: [],
        ),
        engagement: const ProjectEngagement(
          supporters: 25,
          likes: 45,
          comments: 12,
          shares: 8,
          views: 234,
        ),
        verification: ProjectVerification(
          status: 'verified',
          verifiedBy: 'admin1',
          verificationDate: DateTime.now().subtract(const Duration(days: 8)),
          documents: [],
        ),
      ),
      
      // مشروع صحي
      ProjectModel(
        projectId: '2',
        basic: const ProjectBasic(
          title: 'مركز صحي متنقل',
          description: 'توفير خدمات صحية أساسية للمناطق النائية من خلال مركز صحي متنقل',
          category: 'health',
          status: 'active',
          priority: 'urgent',
          tags: ['health', 'mobile', 'rural'],
        ),
        location: ProjectLocation(
          city: 'دمشق',
          district: 'الغوطة الشرقية',
          address: 'المناطق الريفية',
          coordinates: GeoCoordinates(lat: 33.5138, lng: 36.2765),
        ),
        financial: const ProjectFinancial(
          targetAmount: 8000.0,
          currentAmount: 1200.0,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 5000.0,
            labor: 2000.0,
            other: 1000.0,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          startDate: DateTime.now().add(const Duration(days: 10)),
          expectedEndDate: DateTime.now().add(const Duration(days: 60)),
        ),
        creator: const ProjectCreator(
          uid: 'creator2',
          name: 'د. فاطمة أحمد',
          role: 'طبيبة',
          contact: '+963987654321',
        ),
        media: const ProjectMedia(
          mainImage: null,
          gallery: [],
          documents: [],
        ),
        engagement: const ProjectEngagement(
          supporters: 8,
          likes: 15,
          comments: 3,
          shares: 2,
          views: 89,
        ),
        verification: const ProjectVerification(
          status: 'pending',
          documents: [],
        ),
      ),
    ];
  }

  // ========== الرسائل ==========

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
