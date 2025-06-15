import 'package:equatable/equatable.dart';
import '../../../shared/models/models.dart';

/// حالات الصفحة الرئيسية
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// حالة التحميل
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// حالة تحميل المزيد من البيانات
class HomeLoadingMore extends HomeState {
  const HomeLoadingMore();
}

/// حالة النجاح مع البيانات
class HomeLoaded extends HomeState {
  final Map<String, dynamic> userData;
  final List<ProjectModel> projects;
  final List<ProjectModel> filteredProjects;
  final Map<String, dynamic> statistics;
  final String selectedCategory;
  final String selectedGovernorate;
  final String searchQuery;
  final String sortBy;
  final bool hasMoreProjects;
  final int currentPage;

  const HomeLoaded({
    required this.userData,
    required this.projects,
    required this.filteredProjects,
    required this.statistics,
    this.selectedCategory = 'all',
    this.selectedGovernorate = 'all',
    this.searchQuery = '',
    this.sortBy = 'newest',
    this.hasMoreProjects = true,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [
        userData,
        projects,
        filteredProjects,
        statistics,
        selectedCategory,
        selectedGovernorate,
        searchQuery,
        sortBy,
        hasMoreProjects,
        currentPage,
      ];

  /// نسخ الحالة مع تحديث بعض القيم
  HomeLoaded copyWith({
    Map<String, dynamic>? userData,
    List<ProjectModel>? projects,
    List<ProjectModel>? filteredProjects,
    Map<String, dynamic>? statistics,
    String? selectedCategory,
    String? selectedGovernorate,
    String? searchQuery,
    String? sortBy,
    bool? hasMoreProjects,
    int? currentPage,
  }) {
    return HomeLoaded(
      userData: userData ?? this.userData,
      projects: projects ?? this.projects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      statistics: statistics ?? this.statistics,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      hasMoreProjects: hasMoreProjects ?? this.hasMoreProjects,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// حالة الخطأ
class HomeError extends HomeState {
  final String message;
  final String? errorCode;
  final bool canRetry;

  const HomeError({
    required this.message,
    this.errorCode,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [message, errorCode, canRetry];
}

/// حالة عدم وجود اتصال بالإنترنت
class HomeNoConnection extends HomeState {
  final String message;

  const HomeNoConnection({
    this.message = 'لا يوجد اتصال بالإنترنت',
  });

  @override
  List<Object?> get props => [message];
}

/// حالة البيانات فارغة
class HomeEmpty extends HomeState {
  final String message;
  final String? actionText;

  const HomeEmpty({
    this.message = 'لا توجد مشاريع متاحة',
    this.actionText,
  });

  @override
  List<Object?> get props => [message, actionText];
}

/// حالة التحديث
class HomeRefreshing extends HomeState {
  final HomeLoaded previousState;

  const HomeRefreshing(this.previousState);

  @override
  List<Object?> get props => [previousState];
}

/// حالة البحث
class HomeSearching extends HomeState {
  final HomeLoaded previousState;
  final String query;

  const HomeSearching(this.previousState, this.query);

  @override
  List<Object?> get props => [previousState, query];
}

/// حالة الفلترة
class HomeFiltering extends HomeState {
  final HomeLoaded previousState;
  final String filterType;
  final String filterValue;

  const HomeFiltering(this.previousState, this.filterType, this.filterValue);

  @override
  List<Object?> get props => [previousState, filterType, filterValue];
}
