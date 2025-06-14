import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../core/constants/constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/mobile_responsive.dart';
import '../../core/animations/nawa_animations.dart';
import '../../shared/widgets/widgets.dart';

/// صفحة خريطة المشاريع التفاعلية
/// تعرض جميع المشاريع على خريطة سوريا مع إمكانية التفاعل
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late MapController _mapController;
  late AnimationController _fabController;
  late AnimationController _filterController;

  // إعدادات الخريطة
  static const LatLng _initialCenter = LatLng(35.2131, 38.9968); // وسط سوريا
  static const double _initialZoom = 7.0;

  // المشاريع التجريبية مع المواقع
  final List<Map<String, dynamic>> _projects = [
    {
      'id': '1',
      'name': 'ترميم مدرسة الأمل',
      'description': 'إعادة تأهيل مدرسة الأمل في حي الصالحين لاستيعاب 300 طالب',
      'category': 'تعليم',
      'targetAmount': 5000.0,
      'currentAmount': 3250.0,
      'location': 'حلب - الصالحين',
      'latitude': 36.2021, // حلب
      'longitude': 37.1343,
      'imageUrl': 'https://via.placeholder.com/400x200?text=مدرسة+الأمل',
      'status': 'نشط',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)),
      'endDate': DateTime.now().add(const Duration(days: 60)),
      'donorsCount': 45,
      'updatesCount': 8,
    },
    {
      'id': '2',
      'name': 'مشروع المياه النظيفة',
      'description': 'توفير مياه نظيفة وآمنة لـ 500 عائلة في ريف دمشق',
      'category': 'مياه',
      'targetAmount': 8000.0,
      'currentAmount': 6400.0,
      'location': 'ريف دمشق - الغوطة',
      'latitude': 33.5138, // دمشق
      'longitude': 36.2765,
      'imageUrl': 'https://via.placeholder.com/400x200?text=مياه+نظيفة',
      'status': 'نشط',
      'createdAt': DateTime.now().subtract(const Duration(days: 45)),
      'endDate': DateTime.now().add(const Duration(days: 30)),
      'donorsCount': 67,
      'updatesCount': 12,
    },
    {
      'id': '3',
      'name': 'إعادة تأهيل المستشفى',
      'description': 'تجهيز وإعادة تأهيل مستشفى الشفاء لخدمة المنطقة',
      'category': 'صحة',
      'targetAmount': 15000.0,
      'currentAmount': 4500.0,
      'location': 'حمص - الخالدية',
      'latitude': 34.7394, // حمص
      'longitude': 36.7163,
      'imageUrl': 'https://via.placeholder.com/400x200?text=مستشفى+الشفاء',
      'status': 'نشط',
      'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      'endDate': DateTime.now().add(const Duration(days: 90)),
      'donorsCount': 23,
      'updatesCount': 5,
    },
    {
      'id': '4',
      'name': 'مركز تدريب مهني',
      'description': 'إنشاء مركز لتدريب الشباب على المهن والحرف',
      'category': 'تدريب',
      'targetAmount': 12000.0,
      'currentAmount': 8400.0,
      'location': 'اللاذقية - الرمل الجنوبي',
      'latitude': 35.5138, // اللاذقية
      'longitude': 35.7831,
      'imageUrl': 'https://via.placeholder.com/400x200?text=مركز+تدريب',
      'status': 'نشط',
      'createdAt': DateTime.now().subtract(const Duration(days: 60)),
      'endDate': DateTime.now().add(const Duration(days: 45)),
      'donorsCount': 89,
      'updatesCount': 15,
    },
    {
      'id': '5',
      'name': 'مشروع الطاقة الشمسية',
      'description': 'تركيب ألواح شمسية لتوفير الكهرباء للمنازل',
      'category': 'طاقة',
      'targetAmount': 20000.0,
      'currentAmount': 12000.0,
      'location': 'درعا - المدينة',
      'latitude': 32.6189, // درعا
      'longitude': 36.1021,
      'imageUrl': 'https://via.placeholder.com/400x200?text=طاقة+شمسية',
      'status': 'نشط',
      'createdAt': DateTime.now().subtract(const Duration(days: 20)),
      'endDate': DateTime.now().add(const Duration(days: 75)),
      'donorsCount': 156,
      'updatesCount': 22,
    },
  ];

  List<Marker> _markers = [];
  List<Map<String, dynamic>> _filteredProjects = [];
  String _selectedCategory = 'الكل';
  bool _showFilters = false;
  Map<String, dynamic>? _selectedProject;

  // متغيرات الموقع الحالي
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;

  // متغيرات البحث
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  List<Map<String, dynamic>> _searchResults = [];

  // متغيرات طبقات الخريطة
  String _currentMapLayer = 'openstreetmap';

  // متغيرات الإحصائيات
  bool _showStats = false;

  final List<String> _categories = [
    'الكل',
    'تعليم',
    'صحة',
    'مياه',
    'تدريب',
    'طاقة',
    'إسكان',
    'بنية تحتية',
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeAnimations();
    _filteredProjects = _projects;
    _createMarkers();
  }

  void _initializeAnimations() {
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _filterController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // الخريطة
          _buildMap(),
          
          // شريط البحث
          if (_showSearch) _buildSearchPanel(),

          // فلاتر المشاريع
          if (_showFilters) _buildFiltersPanel(),
          
          // لوحة الإحصائيات
          if (_showStats) _buildStatsPanel(),

          // معلومات المشروع المختار
          if (_selectedProject != null) _buildProjectInfo(),
        ],
      ),
      floatingActionButton: MobileResponsive.shouldShowFAB(context)
          ? _buildFloatingButtons()
          : null,
      floatingActionButtonLocation: MobileResponsive.getFABLocation(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.map, color: AppColors.textOnColor),
          const SizedBox(width: 8),
          const Text('خريطة المشاريع'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryBeige.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_filteredProjects.length} مشروع',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: _toggleSearch,
          icon: AnimatedRotation(
            turns: _showSearch ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.search),
          ),
          tooltip: 'البحث في الخريطة',
        ),
        IconButton(
          onPressed: _toggleFilters,
          icon: AnimatedRotation(
            turns: _showFilters ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.tune),
          ),
          tooltip: 'فلاتر البحث',
        ),
        IconButton(
          onPressed: _toggleStats,
          icon: const Icon(Icons.analytics),
          tooltip: 'إحصائيات الخريطة',
        ),
        IconButton(
          onPressed: _centerOnSyria,
          icon: const Icon(Icons.my_location),
          tooltip: 'العودة لسوريا',
        ),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _initialCenter,
        initialZoom: _initialZoom,
        onTap: (tapPosition, point) {
          setState(() {
            _selectedProject = null;
          });
        },

      ),
      children: [
        // طبقة الخريطة الأساسية
        TileLayer(
          urlTemplate: _getMapLayerUrl(),
          userAgentPackageName: 'com.nawa.app',
          maxZoom: 19,
        ),

        // طبقة العلامات
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }

  Widget _buildSearchPanel() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        height: _showSearch ? 80 : 0,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.primaryGreen),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مشروع أو موقع...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear, color: AppColors.helperGray),
                  iconSize: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        height: _showFilters ? 120 : 0,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.filter_list, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'تصفية المشاريع',
                    style: AppTextStyles.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InteractiveAnimation(
                        onTap: () => _filterByCategory(category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.backgroundPrimary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.helperGray,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.textOnColor
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
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
        ),
      ),
    );
  }

  Widget _buildProjectInfo() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان والإغلاق
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedProject!['name'],
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedProject = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // الموقع والفئة
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.helperGray),
                  const SizedBox(width: 4),
                  Text(
                    _selectedProject!['location'],
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBeige.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedProject!['category'],
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // شريط التقدم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تم جمع: \$${_selectedProject!['currentAmount'].toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'الهدف: \$${_selectedProject!['targetAmount'].toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _selectedProject!['currentAmount'] / _selectedProject!['targetAmount'],
                    backgroundColor: AppColors.progressBackground,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    minHeight: 6,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // أزرار العمل
              Row(
                children: [
                  Expanded(
                    child: NawaButton.secondary(
                      text: 'عرض التفاصيل',
                      icon: Icons.visibility,
                      onPressed: () => _viewProjectDetails(_selectedProject!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NawaButton.primary(
                      text: 'ساهم الآن',
                      icon: Icons.favorite,
                      onPressed: () => _donateToProject(_selectedProject!),
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

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // زر طبقات الخريطة
        FloatingActionButton(
          heroTag: "layers",
          onPressed: _showMapLayers,
          backgroundColor: AppColors.backgroundCard,
          foregroundColor: AppColors.primaryGreen,
          mini: true,
          child: const Icon(Icons.layers),
        ),

        const SizedBox(height: 12),

        // زر الموقع الحالي
        FloatingActionButton(
          heroTag: "location",
          onPressed: _goToCurrentLocation,
          backgroundColor: AppColors.backgroundCard,
          foregroundColor: AppColors.primaryGreen,
          mini: true,
          child: const Icon(Icons.gps_fixed),
        ),

        const SizedBox(height: 12),

        // زر إضافة مشروع
        AnimatedBuilder(
          animation: _fabController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_fabController.value * 0.1),
              child: FloatingActionButton(
                heroTag: "add",
                onPressed: _addNewProject,
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.textOnColor,
                child: const Icon(Icons.add),
              ),
            );
          },
        ),
      ],
    );
  }

  // ========== معالجات الأحداث ==========

  void _createMarkers() {
    _markers.clear();

    for (var project in _filteredProjects) {
      _markers.add(
        Marker(
          point: LatLng(project['latitude'], project['longitude']),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _selectProject(project),
            child: Container(
              decoration: BoxDecoration(
                color: _getMarkerColor(project['category']),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getMarkerIcon(project['category']),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  IconData _getMarkerIcon(String category) {
    // أيقونات مخصصة لكل فئة
    switch (category) {
      case 'تعليم':
        return Icons.school;
      case 'صحة':
        return Icons.local_hospital;
      case 'مياه':
        return Icons.water_drop;
      case 'طاقة':
        return Icons.solar_power;
      case 'تدريب':
        return Icons.work;
      case 'إسكان':
        return Icons.home;
      case 'بنية تحتية':
        return Icons.construction;
      default:
        return Icons.location_on;
    }
  }

  Color _getMarkerColor(String category) {
    // ألوان مخصصة لكل فئة
    switch (category) {
      case 'تعليم':
        return Colors.blue;
      case 'صحة':
        return Colors.red;
      case 'مياه':
        return Colors.cyan;
      case 'طاقة':
        return Colors.orange;
      case 'تدريب':
        return AppColors.primaryGreen;
      case 'إسكان':
        return Colors.brown;
      case 'بنية تحتية':
        return Colors.grey;
      default:
        return AppColors.primaryGreen;
    }
  }

  void _selectProject(Map<String, dynamic> project) {
    setState(() {
      _selectedProject = project;
    });

    // تحريك الكاميرا للمشروع
    _mapController.move(
      LatLng(project['latitude'], project['longitude']),
      12.0,
    );
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _clearSearch();
      }
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });

    if (_showFilters) {
      _filterController.forward();
    } else {
      _filterController.reverse();
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _filteredProjects = _projects;
      });
      _createMarkers();
      return;
    }

    // البحث في المشاريع
    final results = _projects.where((project) {
      final name = project['name'].toString().toLowerCase();
      final location = project['location'].toString().toLowerCase();
      final category = project['category'].toString().toLowerCase();
      final description = project['description'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
             location.contains(searchQuery) ||
             category.contains(searchQuery) ||
             description.contains(searchQuery);
    }).toList();

    setState(() {
      _searchResults = results;
      _filteredProjects = results;
    });

    _createMarkers();

    // إذا كان هناك نتيجة واحدة، انتقل إليها
    if (results.length == 1) {
      final project = results.first;
      _selectProject(project);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
      _filteredProjects = _projects;
    });
    _createMarkers();
  }

  void _toggleStats() {
    setState(() {
      _showStats = !_showStats;
    });
  }

  Widget _buildStatsPanel() {
    // حساب الإحصائيات
    final totalProjects = _projects.length;
    final activeProjects = _projects.where((p) => p['status'] == 'نشط').length;
    final totalTarget = _projects.fold<double>(0, (sum, p) => sum + p['targetAmount']);
    final totalRaised = _projects.fold<double>(0, (sum, p) => sum + p['currentAmount']);
    final totalDonors = _projects.fold<int>(0, (sum, p) => sum + (p['donorsCount'] as int));
    final completionRate = totalTarget > 0 ? (totalRaised / totalTarget * 100) : 0;

    // إحصائيات الفئات
    final categoryStats = <String, Map<String, dynamic>>{};
    for (var project in _projects) {
      final category = project['category'] as String;
      if (!categoryStats.containsKey(category)) {
        categoryStats[category] = {
          'count': 0,
          'target': 0.0,
          'raised': 0.0,
        };
      }
      categoryStats[category]!['count']++;
      categoryStats[category]!['target'] += project['targetAmount'];
      categoryStats[category]!['raised'] += project['currentAmount'];
    }

    return Positioned(
      top: MobileResponsive.isSmallScreen(context) ? 60 : 80,
      right: MobileResponsive.getResponsivePadding(context, 16),
      left: MobileResponsive.isSmallScreen(context)
          ? MobileResponsive.getResponsivePadding(context, 16)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        width: _showStats
            ? (MobileResponsive.isSmallScreen(context)
                ? null
                : MobileResponsive.getResponsiveWidth(context, 320))
            : 0,
        height: _showStats
            ? MobileResponsive.getResponsiveHeight(context, 400)
            : 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 12,
                offset: const Offset(-4, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                Row(
                  children: [
                    const Icon(Icons.analytics, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Text(
                      'إحصائيات الخريطة',
                      style: AppTextStyles.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // الإحصائيات العامة
                _buildStatCard(
                  'إجمالي المشاريع',
                  totalProjects.toString(),
                  Icons.folder,
                  AppColors.primaryGreen,
                ),
                const SizedBox(height: 8),
                _buildStatCard(
                  'المشاريع النشطة',
                  activeProjects.toString(),
                  Icons.trending_up,
                  AppColors.success,
                ),
                const SizedBox(height: 8),
                _buildStatCard(
                  'إجمالي المبلغ المطلوب',
                  '\$${totalTarget.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildStatCard(
                  'إجمالي المبلغ المجمع',
                  '\$${totalRaised.toStringAsFixed(0)}',
                  Icons.savings,
                  AppColors.success,
                ),
                const SizedBox(height: 8),
                _buildStatCard(
                  'إجمالي المتبرعين',
                  totalDonors.toString(),
                  Icons.people,
                  Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildStatCard(
                  'معدل الإنجاز',
                  '${completionRate.toStringAsFixed(1)}%',
                  Icons.pie_chart,
                  completionRate >= 70 ? AppColors.success :
                  completionRate >= 40 ? Colors.orange : AppColors.error,
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // إحصائيات الفئات
                Text(
                  'إحصائيات الفئات',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...categoryStats.entries.map((entry) {
                  final category = entry.key;
                  final stats = entry.value;
                  final categoryCompletion = stats['target'] > 0
                      ? (stats['raised'] / stats['target'] * 100)
                      : 0.0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getMarkerColor(category),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${stats['count']} مشروع • ${categoryCompletion.toStringAsFixed(1)}%',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.labelSmall.copyWith(
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

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'الكل') {
        _filteredProjects = _projects;
      } else {
        _filteredProjects = _projects
            .where((project) => project['category'] == category)
            .toList();
      }
      _selectedProject = null;
    });

    _createMarkers();
  }

  void _centerOnSyria() {
    _mapController.move(_initialCenter, _initialZoom);
  }



  String _getMapLayerUrl() {
    switch (_currentMapLayer) {
      case 'openstreetmap':
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case 'satellite':
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case 'terrain':
        return 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png';
      case 'dark':
        return 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
      default:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }
  }

  void _showMapLayers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Row(
              children: [
                const Icon(Icons.layers, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'طبقات الخريطة',
                  style: AppTextStyles.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // خيارات الطبقات
            _buildLayerOption(
              'openstreetmap',
              'خريطة عادية',
              Icons.map,
              'الخريطة الأساسية مع الشوارع والمعالم',
            ),
            _buildLayerOption(
              'satellite',
              'صور الأقمار الصناعية',
              Icons.satellite,
              'صور حقيقية من الأقمار الصناعية',
            ),
            _buildLayerOption(
              'terrain',
              'خريطة التضاريس',
              Icons.terrain,
              'عرض التضاريس والارتفاعات',
            ),
            _buildLayerOption(
              'dark',
              'الوضع الليلي',
              Icons.dark_mode,
              'خريطة داكنة مريحة للعين',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerOption(String layerId, String title, IconData icon, String description) {
    final isSelected = _currentMapLayer == layerId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InteractiveAnimation(
        onTap: () {
          setState(() {
            _currentMapLayer = layerId;
          });
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تغيير طبقة الخريطة إلى: $title'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryGreen.withValues(alpha: 0.1)
                : AppColors.backgroundPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryGreen
                  : AppColors.helperGray.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.helperGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
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
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // التحقق من الصلاحيات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('تم رفض صلاحية الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError('صلاحية الموقع مرفوضة نهائياً. يرجى تفعيلها من الإعدادات');
        return;
      }

      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final currentLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = currentLocation;
      });

      // الانتقال للموقع الحالي
      _mapController.move(currentLocation, 15.0);

      // إضافة علامة للموقع الحالي
      _addCurrentLocationMarker();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 8),
              Text('تم تحديد موقعك الحالي'),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );

    } catch (e) {
      _showLocationError('فشل في تحديد الموقع: ${e.toString()}');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentLocation == null) return;

    // إزالة علامة الموقع الحالي السابقة
    _markers.removeWhere((marker) =>
        marker.point == _currentLocation &&
        marker.child is Container &&
        (marker.child as Container).decoration is BoxDecoration &&
        ((marker.child as Container).decoration as BoxDecoration).color == Colors.blue);

    // إضافة علامة جديدة للموقع الحالي
    _markers.add(
      Marker(
        point: _currentLocation!,
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.my_location,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );

    setState(() {});
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _addNewProject() {
    _fabController.forward().then((_) {
      _fabController.reverse();
    });

    // TODO: الانتقال لصفحة إضافة مشروع جديد
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم إضافة إنشاء مشروع جديد قريباً')),
    );
  }

  void _viewProjectDetails(Map<String, dynamic> project) {
    // TODO: الانتقال لصفحة تفاصيل المشروع
    Navigator.pushNamed(
      context,
      '/project-details',
      arguments: project['id'],
    );
  }

  void _donateToProject(Map<String, dynamic> project) {
    // TODO: الانتقال لصفحة التبرع
    Navigator.pushNamed(
      context,
      '/donate',
      arguments: project['id'],
    );
  }
}
