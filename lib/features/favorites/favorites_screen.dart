import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/storage/local_storage_manager.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/models/project_model.dart';
import '../../core/utils/responsive_helper.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with TickerProviderStateMixin {
  final LocalStorageManager _storage = LocalStorageManager.instance;
  
  List<ProjectModel> _favoriteProjects = [];
  List<ProjectModel> _filteredProjects = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = [
    'الكل',
    'تعليم',
    'صحة',
    'إغاثة',
    'بنية تحتية',
    'بيئة',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadFavoriteProjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'المفضلة',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: AppColors.textOnColor,
        ),
      ),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 0,
      actions: [
        // زر البحث
        IconButton(
          onPressed: _showSearchDialog,
          icon: const Icon(Icons.search),
          tooltip: 'البحث',
        ),
        
        // زر المشاركة
        IconButton(
          onPressed: _shareFavorites,
          icon: const Icon(Icons.share),
          tooltip: 'مشاركة المفضلة',
        ),
        
        // زر الخيارات
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.clear_all, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('مسح الكل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download, color: AppColors.primaryGreen),
                  SizedBox(width: 8),
                  Text('تصدير القائمة'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildBody() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // إحصائيات سريعة
          _buildQuickStats(),
          
          // شريط الفلترة
          _buildFilterBar(),
          
          // قائمة المشاريع
          Expanded(
            child: _favoriteProjects.isEmpty
                ? _buildEmptyState()
                : _buildProjectsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalProjects = _favoriteProjects.length;
    final categories = _favoriteProjects
        .map((p) => p.basic.category)
        .toSet()
        .length;

    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.favorite,
              label: 'إجمالي المفضلة',
              value: totalProjects.toString(),
              color: AppColors.like,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.category,
              label: 'الفئات',
              value: categories.toString(),
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
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
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) => _filterByCategory(category),
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
      return _buildNoResultsState();
    }

    return RefreshIndicator(
      onRefresh: _loadFavoriteProjects,
      child: ResponsiveHelper.isMobile(context)
          ? _buildMobileList()
          : _buildGridLayout(),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: _filteredProjects.length,
      itemBuilder: (context, index) {
        final project = _filteredProjects[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
          child: ProjectCard(
            project: project,
            onTap: () => _handleProjectTap(project),
            onDonate: () => _handleDonate(project),
            onLike: () => _handleRemoveFromFavorites(project),
            isLiked: true, // دائماً true في صفحة المفضلة
          ),
        );
      },
    );
  }

  Widget _buildGridLayout() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppConstants.spacingMedium,
        mainAxisSpacing: AppConstants.spacingMedium,
      ),
      itemCount: _filteredProjects.length,
      itemBuilder: (context, index) {
        final project = _filteredProjects[index];
        return ProjectCard(
          project: project,
          onTap: () => _handleProjectTap(project),
          onDonate: () => _handleDonate(project),
          onLike: () => _handleRemoveFromFavorites(project),
          isLiked: true,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.helperGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'لا توجد مشاريع مفضلة',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            'ابدأ بإضافة مشاريع لمفضلتك لتظهر هنا',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          NawaButton.primary(
            text: 'استكشف المشاريع',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
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
            'لا توجد نتائج',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            'لم نجد مشاريع تطابق البحث أو الفلتر المحدد',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          NawaButton.secondary(
            text: 'مسح الفلاتر',
            onPressed: _clearFilters,
          ),
        ],
      ),
    );
  }

  // ========== معالجات الأحداث ==========

  Future<void> _loadFavoriteProjects() async {
    setState(() => _isLoading = true);

    try {
      // محاكاة تحميل البيانات
      await Future.delayed(const Duration(milliseconds: 500));

      var favoriteIds = _storage.getFavoriteProjects();

      // إضافة بيانات تجريبية إذا كانت المفضلة فارغة
      if (favoriteIds.isEmpty) {
        await _storage.addToFavorites('proj_1');
        await _storage.addToFavorites('proj_2');
        favoriteIds = _storage.getFavoriteProjects();
      }

      // محاكاة تحميل تفاصيل المشاريع المفضلة
      _favoriteProjects = favoriteIds.map((id) => _generateSampleProject(id)).toList();

      _filterProjects();
      _animationController.forward();
    } catch (e) {
      _showErrorMessage('خطأ في تحميل المفضلة: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterProjects() {
    setState(() {
      _filteredProjects = _favoriteProjects.where((project) {
        final matchesSearch = _searchQuery.isEmpty ||
            project.basic.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            project.basic.description.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesCategory = _selectedCategory == 'الكل' ||
            _getCategoryDisplayName(project.basic.category) == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterProjects();
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'الكل';
      _searchQuery = '';
      _searchController.clear();
    });
    _filterProjects();
  }

  void _handleProjectTap(ProjectModel project) {
    AppRoutes.pushProjectDetails(context, project.projectId);
  }

  void _handleDonate(ProjectModel project) {
    AppRoutes.pushDonate(context, project.projectId);
  }

  Future<void> _handleRemoveFromFavorites(ProjectModel project) async {
    final success = await _storage.removeFromFavorites(project.projectId);
    if (success) {
      setState(() {
        _favoriteProjects.removeWhere((p) => p.projectId == project.projectId);
      });
      _filterProjects();
      _showSuccessMessage('تم إزالة المشروع من المفضلة');
    } else {
      _showErrorMessage('فشل في إزالة المشروع من المفضلة');
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث في المفضلة'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'ابحث عن مشروع...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            _searchQuery = value;
            _filterProjects();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearFilters();
              Navigator.of(context).pop();
            },
            child: const Text('مسح'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _shareFavorites() {
    if (_favoriteProjects.isEmpty) {
      _showErrorMessage('لا توجد مشاريع لمشاركتها');
      return;
    }

    // TODO: تنفيذ مشاركة المفضلة
    _showSuccessMessage('سيتم إضافة المشاركة قريباً');
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear_all':
        _showClearAllDialog();
        break;
      case 'export':
        _exportFavorites();
        break;
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح جميع المفضلة'),
        content: const Text('هل أنت متأكد من مسح جميع المشاريع المفضلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await _storage.clearFavorites();
              if (success) {
                setState(() {
                  _favoriteProjects.clear();
                  _filteredProjects.clear();
                });
                _showSuccessMessage('تم مسح جميع المفضلة');
              } else {
                _showErrorMessage('فشل في مسح المفضلة');
              }
            },
            child: const Text('مسح', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _exportFavorites() {
    // TODO: تنفيذ تصدير المفضلة
    _showSuccessMessage('سيتم إضافة التصدير قريباً');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  // ========== دوال مساعدة ==========

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'education':
        return 'تعليم';
      case 'health':
        return 'صحة';
      case 'relief':
        return 'إغاثة';
      case 'infrastructure':
        return 'بنية تحتية';
      case 'environment':
        return 'بيئة';
      default:
        return 'أخرى';
    }
  }

  // ========== بيانات تجريبية ==========

  ProjectModel _generateSampleProject(String id) {
    final sampleProjects = {
      'proj_1': ProjectModel(
        projectId: 'proj_1',
        basic: const ProjectBasic(
          title: 'بناء مدرسة في ريف حلب',
          description: 'مشروع لبناء مدرسة ابتدائية في منطقة ريفية لتوفير التعليم للأطفال',
          category: 'education',
          status: 'active',
          priority: 'high',
          tags: ['تعليم', 'أطفال', 'بناء'],
        ),
        location: const ProjectLocation(
          city: 'حلب',
          district: 'ريف حلب',
          address: 'قرية الأمل - ريف حلب الشرقي',
          coordinates: GeoCoordinates(lat: 36.2021, lng: 37.1343),
        ),
        financial: const ProjectFinancial(
          targetAmount: 50000,
          currentAmount: 35000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 30000,
            labor: 15000,
            other: 5000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          startDate: DateTime.now().subtract(const Duration(days: 20)),
          expectedEndDate: DateTime.now().add(const Duration(days: 60)),
        ),
        creator: const ProjectCreator(
          uid: 'user_1',
          name: 'جمعية التعليم للجميع',
          role: 'منظمة غير ربحية',
          contact: 'info@education.org',
        ),
        media: const ProjectMedia(
          mainImage: 'assets/images/projects/school.jpg',
          gallery: ['assets/images/projects/school1.jpg', 'assets/images/projects/school2.jpg'],
        ),
        engagement: const ProjectEngagement(
          supporters: 120,
          likes: 89,
          comments: 32,
          shares: 45,
          views: 1250,
        ),
        verification: const ProjectVerification(
          status: 'verified',
          verifiedBy: 'admin',
        ),
      ),
      'proj_2': ProjectModel(
        projectId: 'proj_2',
        basic: const ProjectBasic(
          title: 'مركز صحي متنقل',
          description: 'توفير خدمات صحية أساسية للمناطق النائية',
          category: 'health',
          status: 'active',
          priority: 'urgent',
          tags: ['صحة', 'طوارئ', 'متنقل'],
        ),
        location: const ProjectLocation(
          city: 'دمشق',
          district: 'ريف دمشق',
          address: 'المناطق النائية - ريف دمشق',
          coordinates: GeoCoordinates(lat: 33.5138, lng: 36.2765),
        ),
        financial: const ProjectFinancial(
          targetAmount: 30000,
          currentAmount: 22000,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 20000,
            labor: 8000,
            other: 2000,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
          startDate: DateTime.now().subtract(const Duration(days: 10)),
          expectedEndDate: DateTime.now().add(const Duration(days: 45)),
        ),
        creator: const ProjectCreator(
          uid: 'user_2',
          name: 'الهلال الأحمر السوري',
          role: 'منظمة إنسانية',
          contact: 'info@redcrescent.org',
        ),
        media: const ProjectMedia(
          mainImage: 'assets/images/projects/health.jpg',
          gallery: ['assets/images/projects/health1.jpg'],
        ),
        engagement: const ProjectEngagement(
          supporters: 85,
          likes: 67,
          comments: 19,
          shares: 28,
          views: 890,
        ),
        verification: const ProjectVerification(
          status: 'verified',
          verifiedBy: 'admin',
        ),
      ),
    };

    return sampleProjects[id] ?? ProjectModel(
      projectId: id,
      basic: const ProjectBasic(
        title: 'مشروع تجريبي',
        description: 'وصف المشروع التجريبي',
        category: 'relief',
        status: 'active',
        priority: 'medium',
        tags: ['تجريبي'],
      ),
      location: const ProjectLocation(
        city: 'دمشق',
        district: 'المزة',
        address: 'شارع الثورة',
        coordinates: GeoCoordinates(lat: 33.5138, lng: 36.2765),
      ),
      financial: const ProjectFinancial(
        targetAmount: 10000,
        currentAmount: 5000,
        currency: 'USD',
        breakdown: ProjectBreakdown(
          materials: 6000,
          labor: 3000,
          other: 1000,
        ),
      ),
      timeline: ProjectTimeline(
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        expectedEndDate: DateTime.now().add(const Duration(days: 30)),
      ),
      creator: const ProjectCreator(
        uid: 'user_default',
        name: 'منظمة تجريبية',
        role: 'منظمة محلية',
        contact: 'test@example.com',
      ),
      media: const ProjectMedia(
        mainImage: 'assets/images/projects/default.jpg',
      ),
      engagement: const ProjectEngagement(
        supporters: 25,
        likes: 15,
        comments: 8,
        shares: 5,
        views: 320,
      ),
      verification: const ProjectVerification(
        status: 'pending',
      ),
    );
  }

  // ========== البار السفلي الموحد ==========

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 2, // المفضلة هي الفهرس الثاني
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
        // المفضلة (الصفحة الحالية)
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
    }
  }
}
