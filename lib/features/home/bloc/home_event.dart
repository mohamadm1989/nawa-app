import 'package:equatable/equatable.dart';

/// أحداث الصفحة الرئيسية
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// حدث تحميل البيانات الأولية
class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

/// حدث تحديث البيانات
class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}

/// حدث البحث في المشاريع
class SearchProjects extends HomeEvent {
  final String query;

  const SearchProjects(this.query);

  @override
  List<Object?> get props => [query];
}

/// حدث فلترة المشاريع حسب الفئة
class FilterProjectsByCategory extends HomeEvent {
  final String category;

  const FilterProjectsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// حدث فلترة المشاريع حسب المحافظة
class FilterProjectsByGovernorate extends HomeEvent {
  final String governorate;

  const FilterProjectsByGovernorate(this.governorate);

  @override
  List<Object?> get props => [governorate];
}

/// حدث تحميل المزيد من المشاريع (Pagination)
class LoadMoreProjects extends HomeEvent {
  const LoadMoreProjects();
}

/// حدث تحديث بيانات المستخدم
class UpdateUserData extends HomeEvent {
  final Map<String, dynamic> userData;

  const UpdateUserData(this.userData);

  @override
  List<Object?> get props => [userData];
}

/// حدث إعادة تعيين الفلاتر
class ResetFilters extends HomeEvent {
  const ResetFilters();
}

/// حدث تغيير ترتيب المشاريع
class ChangeSortOrder extends HomeEvent {
  final String sortBy;

  const ChangeSortOrder(this.sortBy);

  @override
  List<Object?> get props => [sortBy];
}

/// حدث تحديث الإحصائيات
class UpdateStatistics extends HomeEvent {
  const UpdateStatistics();
}

/// حدث معالجة خطأ
class HandleError extends HomeEvent {
  final String error;

  const HandleError(this.error);

  @override
  List<Object?> get props => [error];
}
