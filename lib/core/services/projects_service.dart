import 'package:flutter/foundation.dart';
import '../../shared/models/project_model.dart';

/// خدمة إدارة المشاريع المشتركة
class ProjectsService {
  static final ProjectsService _instance = ProjectsService._internal();
  factory ProjectsService() => _instance;
  ProjectsService._internal();

  static ProjectsService get instance => _instance;

  // قائمة المشاريع المحملة
  List<ProjectModel> _allProjects = [];
  
  // Getters
  List<ProjectModel> get allProjects => List.unmodifiable(_allProjects);
  
  /// تحميل جميع المشاريع
  Future<List<ProjectModel>> loadAllProjects() async {
    try {
      // محاكاة تحميل من قاعدة البيانات
      await Future.delayed(const Duration(milliseconds: 500));
      
      _allProjects = _generateAllProjects();
      return _allProjects;
    } catch (e) {
      debugPrint('خطأ في تحميل المشاريع: $e');
      return [];
    }
  }

  /// البحث في المشاريع
  List<ProjectModel> searchProjects({
    required String query,
    String? category,
    String? governorate,
    double? minAmount,
    double? maxAmount,
    String sortBy = 'newest',
  }) {
    var results = _allProjects.where((project) {
      // البحث النصي
      bool matchesQuery = query.isEmpty ||
          project.basic.title.toLowerCase().contains(query.toLowerCase()) ||
          project.basic.description.toLowerCase().contains(query.toLowerCase()) ||
          project.basic.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));

      // فلتر الفئة
      bool matchesCategory = category == null || 
          category == 'all' || 
          project.basic.category == category;

      // فلتر المحافظة
      bool matchesGovernorate = governorate == null || 
          governorate == 'all' || 
          _matchesGovernorate(project.location.city, governorate);

      // فلتر المبلغ
      bool matchesAmount = (minAmount == null || project.financial.targetAmount >= minAmount) &&
          (maxAmount == null || project.financial.targetAmount <= maxAmount);

      return matchesQuery && matchesCategory && matchesGovernorate && matchesAmount;
    }).toList();

    // ترتيب النتائج
    _sortProjects(results, sortBy);
    
    return results;
  }

  /// ترتيب المشاريع
  void _sortProjects(List<ProjectModel> projects, String sortBy) {
    switch (sortBy) {
      case 'newest':
        projects.sort((a, b) => b.timeline.createdAt.compareTo(a.timeline.createdAt));
        break;
      case 'oldest':
        projects.sort((a, b) => a.timeline.createdAt.compareTo(b.timeline.createdAt));
        break;
      case 'most_funded':
        projects.sort((a, b) => b.progressPercentage.compareTo(a.progressPercentage));
        break;
      case 'least_funded':
        projects.sort((a, b) => a.progressPercentage.compareTo(b.progressPercentage));
        break;
      case 'alphabetical':
        projects.sort((a, b) => a.basic.title.compareTo(b.basic.title));
        break;
      case 'amount_high':
        projects.sort((a, b) => b.financial.targetAmount.compareTo(a.financial.targetAmount));
        break;
      case 'amount_low':
        projects.sort((a, b) => a.financial.targetAmount.compareTo(b.financial.targetAmount));
        break;
    }
  }

  /// مطابقة المحافظة
  bool _matchesGovernorate(String city, String governorate) {
    final governorateMap = {
      'damascus': ['دمشق', 'Damascus'],
      'aleppo': ['حلب', 'Aleppo'],
      'homs': ['حمص', 'Homs'],
      'hama': ['حماة', 'Hama'],
      'lattakia': ['اللاذقية', 'Lattakia'],
      'tartous': ['طرطوس', 'Tartous'],
      'daraa': ['درعا', 'Daraa'],
      'sweida': ['السويداء', 'Sweida'],
      'quneitra': ['القنيطرة', 'Quneitra'],
      'idlib': ['إدلب', 'Idlib'],
      'raqqa': ['الرقة', 'Raqqa'],
      'deir_ezzor': ['دير الزور', 'Deir Ezzor'],
      'hasaka': ['الحسكة', 'Hasaka'],
    };

    final cities = governorateMap[governorate] ?? [];
    return cities.any((govCity) => city.contains(govCity));
  }

  /// الحصول على مشروع بالمعرف
  ProjectModel? getProjectById(String projectId) {
    try {
      return _allProjects.firstWhere((project) => project.projectId == projectId);
    } catch (e) {
      return null;
    }
  }

  /// إنشاء جميع المشاريع التجريبية
  List<ProjectModel> _generateAllProjects() {
    return [
      // مشروع تعليمي - حلب
      ProjectModel(
        projectId: '1',
        basic: const ProjectBasic(
          title: 'ترميم مدرسة الأمل',
          description: 'مشروع لترميم مدرسة الأمل في حي الصالحين لتوفير بيئة تعليمية آمنة للأطفال',
          category: 'education',
          status: 'active',
          priority: 'high',
          tags: ['مدرسة', 'ترميم', 'أطفال', 'تعليم'],
        ),
        location: const ProjectLocation(
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

      // مشروع صحي - دمشق
      ProjectModel(
        projectId: '2',
        basic: const ProjectBasic(
          title: 'مركز صحي متنقل',
          description: 'توفير خدمات صحية أساسية للمناطق النائية من خلال مركز صحي متنقل',
          category: 'health',
          status: 'active',
          priority: 'urgent',
          tags: ['صحة', 'متنقل', 'ريف', 'طبي'],
        ),
        location: const ProjectLocation(
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

      // مشروع مياه - حمص
      ProjectModel(
        projectId: '3',
        basic: const ProjectBasic(
          title: 'بئر مياه للقرية',
          description: 'حفر بئر مياه جوفية لتوفير المياه النظيفة لسكان القرية',
          category: 'water',
          status: 'active',
          priority: 'high',
          tags: ['مياه', 'بئر', 'قرية', 'نظيفة'],
        ),
        location: const ProjectLocation(
          city: 'حمص',
          district: 'الريف الشمالي',
          address: 'قرية الخضراء',
          coordinates: GeoCoordinates(lat: 34.7394, lng: 36.7163),
        ),
        financial: const ProjectFinancial(
          targetAmount: 3000.0,
          currentAmount: 1800.0,
          currency: 'USD',
          breakdown: ProjectBreakdown(
            materials: 2000.0,
            labor: 800.0,
            other: 200.0,
          ),
        ),
        timeline: ProjectTimeline(
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          startDate: DateTime.now().subtract(const Duration(days: 3)),
          expectedEndDate: DateTime.now().add(const Duration(days: 20)),
        ),
        creator: const ProjectCreator(
          uid: 'creator3',
          name: 'أبو أحمد',
          role: 'مختار القرية',
          contact: '+963944556677',
        ),
        media: const ProjectMedia(
          mainImage: null,
          gallery: [],
          documents: [],
        ),
        engagement: const ProjectEngagement(
          supporters: 15,
          likes: 28,
          comments: 7,
          shares: 5,
          views: 145,
        ),
        verification: ProjectVerification(
          status: 'verified',
          verifiedBy: 'admin2',
          verificationDate: DateTime.now().subtract(const Duration(days: 12)),
          documents: [],
        ),
      ),
    ];
  }
}
