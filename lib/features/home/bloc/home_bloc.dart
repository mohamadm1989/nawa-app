import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/constants.dart';
import '../../../core/services/projects_service.dart';
import '../../../shared/models/models.dart';
import 'home_event.dart';
import 'home_state.dart';

/// BLoC لإدارة حالة الصفحة الرئيسية
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProjectsService _projectsService;
  
  // إعدادات Pagination
  static const int _pageSize = 10;
  int _currentPage = 1;
  bool _hasMoreData = true;

  HomeBloc({
    ProjectsService? projectsService,
  })  : _projectsService = projectsService ?? ProjectsService(),
        super(const HomeInitial()) {
    
    // تسجيل معالجات الأحداث
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<SearchProjects>(_onSearchProjects);
    on<FilterProjectsByCategory>(_onFilterProjectsByCategory);
    on<FilterProjectsByGovernorate>(_onFilterProjectsByGovernorate);
    on<LoadMoreProjects>(_onLoadMoreProjects);
    on<UpdateUserData>(_onUpdateUserData);
    on<ResetFilters>(_onResetFilters);
    on<ChangeSortOrder>(_onChangeSortOrder);
    on<UpdateStatistics>(_onUpdateStatistics);
    on<HandleError>(_onHandleError);
  }

  /// معالج تحميل البيانات الأولية
  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      SafetyMonitor.logInfo('HomeBloc', 'بدء تحميل البيانات الأولية');
      emit(const HomeLoading());

      // تحميل بيانات المستخدم
      final userData = UserDataManager.getSafeUserData();
      SafetyMonitor.logSuccess('User Data Loaded');

      // تحميل المشاريع
      final projects = await _loadProjects(page: 1);
      SafetyMonitor.logSuccess('Projects Loaded');

      // تحميل الإحصائيات
      final statistics = await _loadStatistics();
      SafetyMonitor.logSuccess('Statistics Loaded');

      // إصدار الحالة الجديدة
      emit(HomeLoaded(
        userData: userData,
        projects: projects,
        filteredProjects: projects,
        statistics: statistics,
        currentPage: 1,
        hasMoreProjects: projects.length >= _pageSize,
      ));

      SafetyMonitor.logSuccess('Home Data Loading Complete');
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Home Data Loading', e, stackTrace);
      emit(HomeError(
        message: 'فشل في تحميل البيانات: ${e.toString()}',
        canRetry: true,
      ));
    }
  }

  /// معالج تحديث البيانات
  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeRefreshing(currentState));

        // إعادة تعيين الصفحة
        _currentPage = 1;
        _hasMoreData = true;

        // تحميل البيانات الجديدة
        final projects = await _loadProjects(page: 1);
        final statistics = await _loadStatistics();

        emit(currentState.copyWith(
          projects: projects,
          filteredProjects: _applyFilters(projects, currentState),
          statistics: statistics,
          currentPage: 1,
          hasMoreProjects: projects.length >= _pageSize,
        ));

        SafetyMonitor.logSuccess('Home Data Refresh Complete');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Home Data Refresh', e, stackTrace);
      emit(HomeError(
        message: 'فشل في تحديث البيانات: ${e.toString()}',
        canRetry: true,
      ));
    }
  }

  /// معالج البحث في المشاريع
  Future<void> _onSearchProjects(
    SearchProjects event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeSearching(currentState, event.query));

        // تطبيق البحث والفلاتر
        final filteredProjects = _applyFilters(
          currentState.projects,
          currentState.copyWith(searchQuery: event.query),
        );

        emit(currentState.copyWith(
          searchQuery: event.query,
          filteredProjects: filteredProjects,
        ));

        SafetyMonitor.logSuccess('Project Search Complete');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Project Search', e, stackTrace);
    }
  }

  /// معالج فلترة المشاريع حسب الفئة
  Future<void> _onFilterProjectsByCategory(
    FilterProjectsByCategory event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeFiltering(currentState, 'category', event.category));

        final filteredProjects = _applyFilters(
          currentState.projects,
          currentState.copyWith(selectedCategory: event.category),
        );

        emit(currentState.copyWith(
          selectedCategory: event.category,
          filteredProjects: filteredProjects,
        ));

        SafetyMonitor.logSuccess('Category Filter Applied');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Category Filter', e, stackTrace);
    }
  }

  /// معالج فلترة المشاريع حسب المحافظة
  Future<void> _onFilterProjectsByGovernorate(
    FilterProjectsByGovernorate event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeFiltering(currentState, 'governorate', event.governorate));

        final filteredProjects = _applyFilters(
          currentState.projects,
          currentState.copyWith(selectedGovernorate: event.governorate),
        );

        emit(currentState.copyWith(
          selectedGovernorate: event.governorate,
          filteredProjects: filteredProjects,
        ));

        SafetyMonitor.logSuccess('Governorate Filter Applied');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Governorate Filter', e, stackTrace);
    }
  }

  /// معالج تحميل المزيد من المشاريع
  Future<void> _onLoadMoreProjects(
    LoadMoreProjects event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded && _hasMoreData) {
        final currentState = state as HomeLoaded;
        emit(const HomeLoadingMore());

        final nextPage = _currentPage + 1;
        final newProjects = await _loadProjects(page: nextPage);

        if (newProjects.isNotEmpty) {
          final allProjects = [...currentState.projects, ...newProjects];
          _currentPage = nextPage;
          _hasMoreData = newProjects.length >= _pageSize;

          emit(currentState.copyWith(
            projects: allProjects,
            filteredProjects: _applyFilters(allProjects, currentState),
            currentPage: nextPage,
            hasMoreProjects: _hasMoreData,
          ));

          SafetyMonitor.logSuccess('More Projects Loaded');
        } else {
          _hasMoreData = false;
          emit(currentState.copyWith(hasMoreProjects: false));
        }
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Load More Projects', e, stackTrace);
    }
  }

  /// معالج تحديث بيانات المستخدم
  Future<void> _onUpdateUserData(
    UpdateUserData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(userData: event.userData));
        SafetyMonitor.logSuccess('User Data Updated');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Update User Data', e, stackTrace);
    }
  }

  /// معالج إعادة تعيين الفلاتر
  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(
          selectedCategory: 'all',
          selectedGovernorate: 'all',
          searchQuery: '',
          filteredProjects: currentState.projects,
        ));
        SafetyMonitor.logSuccess('Filters Reset');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Reset Filters', e, stackTrace);
    }
  }

  /// معالج تغيير ترتيب المشاريع
  Future<void> _onChangeSortOrder(
    ChangeSortOrder event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final sortedProjects = _sortProjects(currentState.projects, event.sortBy);
        
        emit(currentState.copyWith(
          projects: sortedProjects,
          filteredProjects: _applyFilters(sortedProjects, currentState),
          sortBy: event.sortBy,
        ));
        
        SafetyMonitor.logSuccess('Sort Order Changed');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Change Sort Order', e, stackTrace);
    }
  }

  /// معالج تحديث الإحصائيات
  Future<void> _onUpdateStatistics(
    UpdateStatistics event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final statistics = await _loadStatistics();
        
        emit(currentState.copyWith(statistics: statistics));
        SafetyMonitor.logSuccess('Statistics Updated');
      }
    } catch (e, stackTrace) {
      SafetyMonitor.logError('Update Statistics', e, stackTrace);
    }
  }

  /// معالج الأخطاء
  Future<void> _onHandleError(
    HandleError event,
    Emitter<HomeState> emit,
  ) async {
    SafetyMonitor.logError('Home Error Handler', event.error);
    emit(HomeError(message: event.error));
  }

  // ========== دوال مساعدة ==========

  /// تحميل المشاريع مع Pagination
  Future<List<ProjectModel>> _loadProjects({required int page}) async {
    if (FeatureFlags.usePagination) {
      // TODO: تطبيق pagination حقيقي لاحقاً
      return _generateSampleProjects();
    } else {
      // الطريقة القديمة (fallback)
      return _generateSampleProjects();
    }
  }

  /// تحميل الإحصائيات
  Future<Map<String, dynamic>> _loadStatistics() async {
    return {
      'totalProjects': 25,
      'activeProjects': 18,
      'completedProjects': 7,
      'totalDonations': 125000.0,
      'totalDonors': 450,
      'averageDonation': 278.0,
    };
  }

  /// إنشاء مشاريع تجريبية
  List<ProjectModel> _generateSampleProjects() {
    return [
      ProjectModel(
        projectId: '1',
        basic: const ProjectBasic(
          title: 'إعادة تأهيل مدرسة الأمل',
          description: 'مشروع لإعادة تأهيل مدرسة الأمل في حي الصالحية لاستيعاب 300 طالب',
          category: 'education',
          status: 'active',
          priority: 'high',
          tags: ['تعليم', 'أطفال', 'مدرسة'],
        ),
        location: const ProjectLocation(
          city: 'دمشق',
          district: 'الصالحية',
          address: 'شارع الثورة، بناء رقم 15',
          coordinates: GeoCoordinates(lat: 33.5138, lng: 36.2765),
        ),
        financial: const ProjectFinancial(
          targetAmount: 15000.0,
          currentAmount: 8500.0,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 10000.0,
            labor: 4000.0,
            other: 1000.0,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          startDate: DateTime.now().subtract(const Duration(days: 10)),
          expectedEndDate: DateTime.now().add(const Duration(days: 45)),
        ),
        creator: const ProjectCreator(
          uid: 'creator1',
          name: 'جمعية الأمل الخيرية',
          role: 'منظمة خيرية',
          contact: 'info@alamal.org',
        ),
        media: const ProjectMedia(
          mainImage: 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=500',
          gallery: [
            'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=500',
            'https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=500',
          ],
        ),
        engagement: const ProjectEngagement(
          supporters: 45,
          likes: 78,
          comments: 12,
          shares: 8,
          views: 234,
        ),
        verification: const ProjectVerification(
          status: 'verified',
          verifiedBy: 'admin',
          communityVotingEnabled: true,
          communityVotes: 15,
          requiredVotes: 10,
        ),
      ),
      // يمكن إضافة المزيد من المشاريع هنا
    ];
  }

  /// تطبيق الفلاتر على المشاريع
  List<ProjectModel> _applyFilters(
    List<ProjectModel> projects,
    HomeLoaded state,
  ) {
    var filtered = projects;

    // فلتر البحث
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((project) =>
          project.basic.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
          project.basic.description.toLowerCase().contains(state.searchQuery.toLowerCase())).toList();
    }

    // فلتر الفئة
    if (state.selectedCategory != 'all') {
      filtered = filtered.where((project) => project.basic.category == state.selectedCategory).toList();
    }

    // فلتر المحافظة
    if (state.selectedGovernorate != 'all') {
      filtered = filtered.where((project) => project.location.city == state.selectedGovernorate).toList();
    }

    return filtered;
  }

  /// ترتيب المشاريع
  List<ProjectModel> _sortProjects(List<ProjectModel> projects, String sortBy) {
    final sorted = List<ProjectModel>.from(projects);
    
    switch (sortBy) {
      case 'newest':
        sorted.sort((a, b) => b.timeline.createdAt.compareTo(a.timeline.createdAt));
        break;
      case 'oldest':
        sorted.sort((a, b) => a.timeline.createdAt.compareTo(b.timeline.createdAt));
        break;
      case 'amount_high':
        sorted.sort((a, b) => b.financial.targetAmount.compareTo(a.financial.targetAmount));
        break;
      case 'amount_low':
        sorted.sort((a, b) => a.financial.targetAmount.compareTo(b.financial.targetAmount));
        break;
      case 'progress':
        sorted.sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));
        break;
      default:
        // الترتيب الافتراضي (الأحدث)
        sorted.sort((a, b) => b.timeline.createdAt.compareTo(a.timeline.createdAt));
    }
    
    return sorted;
  }
}
