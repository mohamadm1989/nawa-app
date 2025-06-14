import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/models/project_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/animations/nawa_animations.dart';
import '../../core/services/projects_service.dart';

/// صفحة البحث الشاملة
/// تحتوي على تبويبات متعددة وفلاتر متقدمة
class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final int? initialTabIndex;

  const SearchScreen({
    super.key,
    this.initialQuery,
    this.initialTabIndex,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {

  // ========== Controllers ==========
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  final ProjectsService _projectsService = ProjectsService.instance;

  // ========== State Variables ==========
  bool _isSearching = false;
  bool _showFilters = false;
  String _currentQuery = '';
  bool _isInitialized = false;

  // ========== Search Results ==========
  List<ProjectModel> _projectResults = [];
  List<Map<String, dynamic>> _locationResults = [];
  List<Map<String, dynamic>> _peopleResults = [];
  List<Map<String, dynamic>> _newsResults = [];
  
  // ========== Filters ==========
  String _selectedCategory = 'all';
  String _selectedGovernorate = 'all';
  RangeValues _amountRange = const RangeValues(0, 1000000);
  DateTime? _startDate;
  DateTime? _endDate;
  String _sortBy = 'newest';
  
  // ========== Recent Searches ==========
  List<String> _recentSearches = [];
  
  // ========== Popular Suggestions ==========
  final List<String> _popularSuggestions = [
    'مشاريع تعليمية',
    'مستشفيات',
    'مياه شرب',
    'مدارس',
    'طاقة شمسية',
    'إسكان',
    'تدريب مهني',
    'بنية تحتية',
  ];

  @override
  void initState() {
    super.initState();

    // إنشاء TabController مع حماية من الأخطاء
    try {
      final initialIndex = widget.initialTabIndex ?? 0;
      _tabController = TabController(
        length: 4,
        vsync: this,
        initialIndex: (initialIndex >= 0 && initialIndex < 4) ? initialIndex : 0,
      );
    } catch (e) {
      debugPrint('خطأ في إنشاء TabController: $e');
      _tabController = TabController(length: 4, vsync: this);
    }

    _initializeData();
  }

  Future<void> _initializeData() async {
    // تحميل المشاريع
    await _projectsService.loadAllProjects();

    // تحميل البحث الحديث
    await _loadRecentSearches();

    setState(() {
      _isInitialized = true;
    });

    // إذا كان هناك استعلام أولي
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _currentQuery = widget.initialQuery!;
      _performSearch();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // ========== Header مع شريط البحث ==========
            _buildSearchHeader(),
            
            // ========== Filters Panel ==========
            if (_showFilters) _buildFiltersPanel(),
            
            // ========== Tab Bar ==========
            _buildTabBar(),
            
            // ========== Content ==========
            Expanded(
              child: _currentQuery.isEmpty
                  ? _buildEmptyState()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),

      // ========== البار السفلي الموحد ==========
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
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
          // شريط البحث الرئيسي
          Row(
            children: [
              // زر الرجوع
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textPrimary,
                ),
              ),
              
              // حقل البحث
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundPrimary,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    border: Border.all(
                      color: _isSearching 
                          ? AppColors.primaryGreen 
                          : AppColors.helperGray.withValues(alpha: 0.3),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onSubmitted: _onSearchSubmitted,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'ابحث في جميع المحتويات...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textHint,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.primaryGreen,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: _clearSearch,
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.helperGray,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMedium,
                        vertical: AppConstants.spacingSmall,
                      ),
                    ),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ),
              
              // زر الفلاتر
              IconButton(
                onPressed: _toggleFilters,
                icon: AnimatedRotation(
                  turns: _showFilters ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.tune,
                    color: _showFilters 
                        ? AppColors.primaryGreen 
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          
          // إحصائيات البحث
          if (_currentQuery.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingSmall),
            _buildSearchStats(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchStats() {
    final totalResults = _projectResults.length + 
                        _locationResults.length + 
                        _peopleResults.length + 
                        _newsResults.length;
    
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppConstants.spacingSmall),
        Text(
          'تم العثور على $totalResults نتيجة لـ "$_currentQuery"',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        if (_isSearching)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
      ],
    );
  }

  Widget _buildFiltersPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showFilters ? 200 : 0,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          border: Border(
            bottom: BorderSide(
              color: AppColors.helperGray.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان الفلاتر
              Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Text(
                    'فلاتر البحث المتقدم',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'all';
                        _selectedGovernorate = 'all';
                        _amountRange = const RangeValues(0, 1000000);
                        _startDate = null;
                        _endDate = null;
                        _sortBy = 'newest';
                      });
                      _performSearch();
                    },
                    child: Text(
                      'إعادة تعيين',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // فلاتر الصف الأول
              Row(
                children: [
                  // فلتر الفئة
                  Expanded(
                    child: _buildCategoryFilter(),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  // فلتر المحافظة
                  Expanded(
                    child: _buildGovernorateFilter(),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // فلتر المبلغ
              _buildAmountRangeFilter(),

              const SizedBox(height: AppConstants.spacingMedium),

              // فلاتر الصف الثاني
              Row(
                children: [
                  // فلتر الترتيب
                  Expanded(
                    child: _buildSortFilter(),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  // زر تطبيق الفلاتر
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _performSearch();
                        setState(() {
                          _showFilters = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                      ),
                      child: Text('تطبيق الفلاتر'),
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

  Widget _buildCategoryFilter() {
    final categories = [
      {'key': 'all', 'name': 'جميع الفئات'},
      {'key': 'education', 'name': 'تعليم'},
      {'key': 'health', 'name': 'صحة'},
      {'key': 'water', 'name': 'مياه'},
      {'key': 'training', 'name': 'تدريب'},
      {'key': 'energy', 'name': 'طاقة'},
      {'key': 'housing', 'name': 'إسكان'},
      {'key': 'infrastructure', 'name': 'بنية تحتية'},
    ];

    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'الفئة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall,
        ),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category['key'],
          child: Text(
            category['name']!,
            style: AppTextStyles.bodySmall,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
    );
  }

  Widget _buildGovernorateFilter() {
    final governorates = [
      {'key': 'all', 'name': 'جميع المحافظات'},
      {'key': 'damascus', 'name': 'دمشق'},
      {'key': 'aleppo', 'name': 'حلب'},
      {'key': 'homs', 'name': 'حمص'},
      {'key': 'hama', 'name': 'حماة'},
      {'key': 'lattakia', 'name': 'اللاذقية'},
      {'key': 'tartous', 'name': 'طرطوس'},
    ];

    return DropdownButtonFormField<String>(
      value: _selectedGovernorate,
      decoration: InputDecoration(
        labelText: 'المحافظة',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall,
        ),
      ),
      items: governorates.map((gov) {
        return DropdownMenuItem<String>(
          value: gov['key'],
          child: Text(
            gov['name']!,
            style: AppTextStyles.bodySmall,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGovernorate = value!;
        });
      },
    );
  }

  Widget _buildAmountRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نطاق المبلغ المطلوب (ل.س)',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        RangeSlider(
          values: _amountRange,
          min: 0,
          max: 1000000,
          divisions: 20,
          activeColor: AppColors.primaryGreen,
          inactiveColor: AppColors.helperGray.withValues(alpha: 0.3),
          labels: RangeLabels(
            '${_amountRange.start.round()}',
            '${_amountRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _amountRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSortFilter() {
    final sortOptions = [
      {'key': 'newest', 'name': 'الأحدث'},
      {'key': 'oldest', 'name': 'الأقدم'},
      {'key': 'most_funded', 'name': 'الأكثر تمويلاً'},
      {'key': 'alphabetical', 'name': 'أبجدي'},
    ];

    return DropdownButtonFormField<String>(
      value: _sortBy,
      decoration: InputDecoration(
        labelText: 'ترتيب النتائج',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall,
        ),
      ),
      items: sortOptions.map((option) {
        return DropdownMenuItem<String>(
          value: option['key'],
          child: Text(
            option['name']!,
            style: AppTextStyles.bodySmall,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _sortBy = value!;
        });
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.backgroundCard,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primaryGreen,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium,
        tabs: [
          Tab(
            text: 'المشاريع (${_projectResults.length})',
            icon: const Icon(Icons.business, size: 20),
          ),
          Tab(
            text: 'المواقع (${_locationResults.length})',
            icon: const Icon(Icons.location_on, size: 20),
          ),
          Tab(
            text: 'الأشخاص (${_peopleResults.length})',
            icon: const Icon(Icons.people, size: 20),
          ),
          Tab(
            text: 'الأخبار (${_newsResults.length})',
            icon: const Icon(Icons.article, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: StaggeredAnimation(
        children: [
          const SizedBox(height: AppConstants.spacingLarge),
          
          // أيقونة البحث
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreen.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // العنوان
          Text(
            'ابحث في جميع المحتويات',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingSmall),
          
          // الوصف
          Text(
            'اكتشف المشاريع والمواقع والأشخاص والأخبار\nباستخدام البحث المتقدم',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // عمليات البحث الحديثة
          if (_recentSearches.isNotEmpty) _buildRecentSearches(),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // الاقتراحات الشائعة
          _buildPopularSuggestions(),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Text(
              'عمليات البحث الحديثة',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _clearRecentSearches,
              child: Text(
                'مسح الكل',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.spacingSmall),
        
        Wrap(
          spacing: AppConstants.spacingSmall,
          runSpacing: AppConstants.spacingSmall,
          children: _recentSearches.take(5).map((search) {
            return InteractiveAnimation(
              onTap: () => _selectSuggestion(search),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMedium,
                  vertical: AppConstants.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  border: Border.all(
                    color: AppColors.helperGray.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      search,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: AppColors.primaryGreen,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Text(
              'الاقتراحات الشائعة',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        Wrap(
          spacing: AppConstants.spacingSmall,
          runSpacing: AppConstants.spacingSmall,
          children: _popularSuggestions.map((suggestion) {
            return InteractiveAnimation(
              onTap: () => _selectSuggestion(suggestion),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMedium,
                  vertical: AppConstants.spacingSmall,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen.withValues(alpha: 0.1),
                      AppColors.primaryGreen.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search,
                      size: 16,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      suggestion,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return TabBarView(
      controller: _tabController,
      children: [
        // تبويب المشاريع
        _buildProjectsTab(),
        // تبويب المواقع
        _buildLocationsTab(),
        // تبويب الأشخاص
        _buildPeopleTab(),
        // تبويب الأخبار
        _buildNewsTab(),
      ],
    );
  }

  Widget _buildProjectsTab() {
    if (_projectResults.isEmpty) {
      return _buildEmptyResults('لا توجد مشاريع تطابق البحث', Icons.business);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: _projectResults.length,
      itemBuilder: (context, index) {
        // حماية من تجاوز الحد
        if (index >= _projectResults.length) {
          return const SizedBox.shrink();
        }

        final project = _projectResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
          child: _buildProjectCard(project),
        );
      },
    );
  }

  Widget _buildLocationsTab() {
    if (_locationResults.isEmpty) {
      return _buildEmptyResults('لا توجد مواقع تطابق البحث', Icons.location_on);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: _locationResults.length,
      itemBuilder: (context, index) {
        if (index >= _locationResults.length) {
          return const SizedBox.shrink();
        }
        final location = _locationResults[index];
        return _buildLocationCard(location);
      },
    );
  }

  Widget _buildPeopleTab() {
    if (_peopleResults.isEmpty) {
      return _buildEmptyResults('لا توجد أشخاص يطابقون البحث', Icons.people);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: _peopleResults.length,
      itemBuilder: (context, index) {
        if (index >= _peopleResults.length) {
          return const SizedBox.shrink();
        }
        final person = _peopleResults[index];
        return _buildPersonCard(person);
      },
    );
  }

  Widget _buildNewsTab() {
    if (_newsResults.isEmpty) {
      return _buildEmptyResults('لا توجد أخبار تطابق البحث', Icons.article);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: _newsResults.length,
      itemBuilder: (context, index) {
        if (index >= _newsResults.length) {
          return const SizedBox.shrink();
        }
        final news = _newsResults[index];
        return _buildNewsCard(news);
      },
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: () => _handleProjectTap(project),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان والفئة
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.basic.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSmall,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: Text(
                      _getCategoryName(project.basic.category),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingSmall),

              // الوصف
              Text(
                project.basic.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // شريط التقدم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${project.financial.currentAmount.toStringAsFixed(0)} ل.س',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${project.progressPercentage.toStringAsFixed(1)}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  LinearProgressIndicator(
                    value: project.progressPercentage / 100,
                    backgroundColor: AppColors.helperGray.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleProjectTap(project),
                      child: Text('عرض التفاصيل'),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleDonate(project),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('تبرع الآن'),
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

  String _getCategoryName(String category) {
    switch (category) {
      case 'education':
        return 'تعليم';
      case 'health':
        return 'صحة';
      case 'water':
        return 'مياه';
      case 'training':
        return 'تدريب';
      case 'energy':
        return 'طاقة';
      case 'housing':
        return 'إسكان';
      case 'infrastructure':
        return 'بنية تحتية';
      default:
        return 'عام';
    }
  }

  // ========== Helper Methods ==========

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query;
    });

    if (query.isNotEmpty) {
      _performSearch();
    } else {
      _clearResults();
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _addToRecentSearches(query);
      _performSearch();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
    });
    _clearResults();
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    setState(() {
      _currentQuery = suggestion;
    });
    _addToRecentSearches(suggestion);
    _performSearch();
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
  }



  Future<void> _performSearch() async {
    if (_currentQuery.isEmpty) {
      _clearResults();
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // تأخير قصير لتحسين الأداء
      await Future.delayed(const Duration(milliseconds: 300));

      // البحث في المشاريع باستخدام الخدمة الحقيقية
      _projectResults = _projectsService.searchProjects(
        query: _currentQuery,
        category: _selectedCategory != 'all' ? _selectedCategory : null,
        governorate: _selectedGovernorate != 'all' ? _selectedGovernorate : null,
        minAmount: _amountRange.start,
        maxAmount: _amountRange.end,
        sortBy: _sortBy,
      );

      // البحث في المواقع (مستخرجة من المشاريع)
      _locationResults = _extractLocationsFromProjects(_projectResults);

      // البحث في الأشخاص (مستخرجة من المشاريع)
      _peopleResults = _extractPeopleFromProjects(_projectResults);

      // البحث في الأخبار (مولدة من المشاريع)
      _newsResults = _generateNewsFromProjects(_projectResults);

    } catch (e) {
      debugPrint('خطأ في البحث: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }



  // ========== استخراج البيانات من المشاريع ==========

  List<Map<String, dynamic>> _extractLocationsFromProjects(List<ProjectModel> projects) {
    final Map<String, Map<String, dynamic>> uniqueLocations = {};

    for (int i = 0; i < projects.length; i++) {
      final project = projects[i];
      final locationKey = '${project.location.city}-${project.location.district}';

      if (!uniqueLocations.containsKey(locationKey)) {
        uniqueLocations[locationKey] = {
          'id': locationKey,
          'name': '${project.location.district}، ${project.location.city}',
          'address': project.location.address,
          'type': _getCategoryName(project.basic.category),
          'distance': '${(2.0 + (i * 0.5)).toStringAsFixed(1)} كم',
          'rating': (4.0 + (project.engagement.likes / 100)).clamp(1.0, 5.0),
          'projects_count': 1,
          'coordinates': project.location.coordinates,
        };
      } else {
        uniqueLocations[locationKey]!['projects_count'] =
            (uniqueLocations[locationKey]!['projects_count'] as int) + 1;
      }
    }

    return uniqueLocations.values.toList();
  }

  List<Map<String, dynamic>> _extractPeopleFromProjects(List<ProjectModel> projects) {
    final Map<String, Map<String, dynamic>> uniquePeople = {};

    for (final project in projects) {
      final creator = project.creator;

      if (!uniquePeople.containsKey(creator.uid)) {
        uniquePeople[creator.uid] = {
          'id': creator.uid,
          'name': creator.name,
          'role': creator.role,
          'organization': 'منظمة خيرية',
          'projects_count': 1,
          'total_donations': project.financial.currentAmount.toInt(),
          'avatar': null,
          'contact': creator.contact,
        };
      } else {
        uniquePeople[creator.uid]!['projects_count'] =
            (uniquePeople[creator.uid]!['projects_count'] as int) + 1;
        uniquePeople[creator.uid]!['total_donations'] =
            (uniquePeople[creator.uid]!['total_donations'] as int) +
            project.financial.currentAmount.toInt();
      }
    }

    return uniquePeople.values.toList();
  }

  List<Map<String, dynamic>> _generateNewsFromProjects(List<ProjectModel> projects) {
    final List<Map<String, dynamic>> news = [];

    for (final project in projects) {
      // خبر عن بداية المشروع
      if (project.timeline.startDate != null) {
        news.add({
          'id': '${project.projectId}_start',
          'title': 'بدء العمل في ${project.basic.title}',
          'summary': 'تم البدء رسمياً في تنفيذ مشروع ${project.basic.title} في ${project.location.city}',
          'date': project.timeline.startDate!,
          'category': _getCategoryName(project.basic.category),
          'image': project.media.mainImage,
          'read_time': '${2 + (project.basic.description.length ~/ 100)} دقائق',
          'project_id': project.projectId,
        });
      }

      // خبر عن التقدم إذا كان المشروع متقدم
      if (project.progressPercentage > 25) {
        news.add({
          'id': '${project.projectId}_progress',
          'title': 'تقدم ملحوظ في ${project.basic.title}',
          'summary': 'حقق المشروع ${project.progressPercentage.toStringAsFixed(1)}% من هدفه المالي',
          'date': DateTime.now().subtract(Duration(days: (100 - project.progressPercentage).toInt())),
          'category': _getCategoryName(project.basic.category),
          'image': project.media.mainImage,
          'read_time': '3 دقائق',
          'project_id': project.projectId,
        });
      }
    }

    // ترتيب الأخبار حسب التاريخ (الأحدث أولاً)
    news.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return news.take(10).toList(); // أحدث 10 أخبار
  }

  void _clearResults() {
    setState(() {
      _projectResults.clear();
      _locationResults.clear();
      _peopleResults.clear();
      _newsResults.clear();
    });
  }

  void _addToRecentSearches(String query) {
    if (!_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      });
      _saveRecentSearches();
    }
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
    _saveRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    // TODO: تحميل من SharedPreferences
    setState(() {
      _recentSearches = [
        'مشاريع تعليمية',
        'مستشفيات',
        'مياه شرب',
        'مراكز صحية',
        'ترميم مدارس',
      ];
    });
  }

  Future<void> _saveRecentSearches() async {
    // TODO: حفظ في SharedPreferences
    debugPrint('تم حفظ عمليات البحث: $_recentSearches');
  }



  // ========== UI Helper Methods ==========

  Widget _buildEmptyResults(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.helperGray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            'جرب تغيير كلمات البحث أو الفلاتر',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: InkWell(
        onTap: () => _handleLocationTap(location),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Icon(
                  Icons.location_on,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['name'],
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      location['address'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.warning,
                        ),
                        Text(
                          ' ${location['rating'].toStringAsFixed(1)}',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Text(
                          '${location['projects_count']} مشروع',
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
        ),
      ),
    );
  }

  Widget _buildPersonCard(Map<String, dynamic> person) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: InkWell(
        onTap: () => _handlePersonTap(person),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person['name'],
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${person['role']} - ${person['organization']}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${person['projects_count']} مشروع',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Text(
                          '${person['total_donations']} ل.س',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: InkWell(
        onTap: () => _handleNewsTap(news),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSmall,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: Text(
                      news['category'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    news['read_time'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                news['title'],
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                news['summary'],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                _formatDate(news['date']),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inMinutes} دقيقة';
    }
  }

  // ========== Event Handlers ==========

  void _handleProjectTap(ProjectModel project) {
    // الانتقال لتفاصيل المشروع
    Navigator.of(context).pushNamed(
      AppRoutes.projectDetails,
      arguments: project.projectId,
    );
  }

  void _handleDonate(ProjectModel project) {
    // الانتقال لصفحة التبرع
    Navigator.of(context).pushNamed(
      AppRoutes.donate,
      arguments: project.projectId,
    );
  }

  void _handleLocationTap(Map<String, dynamic> location) {
    // الانتقال لصفحة الخريطة مع التركيز على الموقع
    Navigator.of(context).pushNamed(
      AppRoutes.map,
      arguments: {
        'focus_location': location['coordinates'],
        'search_query': location['name'],
      },
    );
  }

  void _handlePersonTap(Map<String, dynamic> person) {
    // الانتقال لصفحة الملف الشخصي أو المشاريع
    Navigator.of(context).pushNamed(
      AppRoutes.profile,
      arguments: person['id'],
    );
  }

  void _handleNewsTap(Map<String, dynamic> news) {
    // إذا كان الخبر مرتبط بمشروع، انتقل لتفاصيل المشروع
    if (news['project_id'] != null) {
      Navigator.of(context).pushNamed(
        AppRoutes.projectDetails,
        arguments: news['project_id'],
      );
    }
  }

  // ========== البار السفلي الموحد ==========

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // البحث هو الفهرس الأول
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
        // البحث (الصفحة الحالية)
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/favorites');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
    }
  }
}
