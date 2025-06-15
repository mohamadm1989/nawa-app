import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nawa_app/features/home/bloc/bloc.dart';
import 'package:nawa_app/core/services/projects_service.dart';
import 'package:nawa_app/shared/models/models.dart';

// Mock classes
class MockProjectsService extends Mock implements ProjectsService {}

void main() {
  group('HomeBloc', () {
    late HomeBloc homeBloc;
    late MockProjectsService mockProjectsService;

    setUp(() {
      mockProjectsService = MockProjectsService();
      homeBloc = HomeBloc(projectsService: mockProjectsService);
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state is HomeInitial', () {
      expect(homeBloc.state, equals(const HomeInitial()));
    });

    group('LoadHomeData', () {
      final mockProjects = [
        _createMockProject('1', 'مشروع تجريبي 1'),
        _createMockProject('2', 'مشروع تجريبي 2'),
      ];

      final mockStatistics = {
        'totalProjects': 2,
        'totalDonations': 1000.0,
        'activeProjects': 2,
      };

      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoading, HomeLoaded] when LoadHomeData is successful',
        build: () {
          when(() => mockProjectsService.getProjectsPaginated(
                page: any(named: 'page'),
                pageSize: any(named: 'pageSize'),
              )).thenAnswer((_) async => mockProjects);
          
          when(() => mockProjectsService.getStatistics())
              .thenAnswer((_) async => mockStatistics);
          
          return homeBloc;
        },
        act: (bloc) => bloc.add(const LoadHomeData()),
        expect: () => [
          const HomeLoading(),
          isA<HomeLoaded>()
              .having((state) => state.projects.length, 'projects length', 2)
              .having((state) => state.statistics, 'statistics', mockStatistics),
        ],
        verify: (_) {
          verify(() => mockProjectsService.getProjectsPaginated(
                page: 1,
                pageSize: 10,
              )).called(1);
          verify(() => mockProjectsService.getStatistics()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoading, HomeError] when LoadHomeData fails',
        build: () {
          when(() => mockProjectsService.getProjectsPaginated(
                page: any(named: 'page'),
                pageSize: any(named: 'pageSize'),
              )).thenThrow(Exception('فشل في تحميل المشاريع'));
          
          return homeBloc;
        },
        act: (bloc) => bloc.add(const LoadHomeData()),
        expect: () => [
          const HomeLoading(),
          isA<HomeError>()
              .having((state) => state.message, 'error message', 
                     contains('فشل في تحميل البيانات')),
        ],
      );
    });

    group('SearchProjects', () {
      final initialState = HomeLoaded(
        userData: const {'name': 'تجريبي'},
        projects: [
          _createMockProject('1', 'مشروع تعليمي'),
          _createMockProject('2', 'مشروع صحي'),
        ],
        filteredProjects: [
          _createMockProject('1', 'مشروع تعليمي'),
          _createMockProject('2', 'مشروع صحي'),
        ],
        statistics: const {'total': 2},
      );

      blocTest<HomeBloc, HomeState>(
        'filters projects based on search query',
        build: () => homeBloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const SearchProjects('تعليمي')),
        expect: () => [
          isA<HomeSearching>(),
          isA<HomeLoaded>()
              .having((state) => state.searchQuery, 'search query', 'تعليمي')
              .having((state) => state.filteredProjects.length, 'filtered count', 1)
              .having((state) => state.filteredProjects.first.title, 'filtered title', 'مشروع تعليمي'),
        ],
      );
    });

    group('FilterProjectsByCategory', () {
      final initialState = HomeLoaded(
        userData: const {'name': 'تجريبي'},
        projects: [
          _createMockProject('1', 'مشروع 1', category: 'education'),
          _createMockProject('2', 'مشروع 2', category: 'health'),
        ],
        filteredProjects: [
          _createMockProject('1', 'مشروع 1', category: 'education'),
          _createMockProject('2', 'مشروع 2', category: 'health'),
        ],
        statistics: const {'total': 2},
      );

      blocTest<HomeBloc, HomeState>(
        'filters projects by category',
        build: () => homeBloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const FilterProjectsByCategory('education')),
        expect: () => [
          isA<HomeFiltering>(),
          isA<HomeLoaded>()
              .having((state) => state.selectedCategory, 'selected category', 'education')
              .having((state) => state.filteredProjects.length, 'filtered count', 1),
        ],
      );
    });

    group('LoadMoreProjects', () {
      final initialState = HomeLoaded(
        userData: const {'name': 'تجريبي'},
        projects: [_createMockProject('1', 'مشروع 1')],
        filteredProjects: [_createMockProject('1', 'مشروع 1')],
        statistics: const {'total': 1},
        currentPage: 1,
        hasMoreProjects: true,
      );

      final newProjects = [_createMockProject('2', 'مشروع 2')];

      blocTest<HomeBloc, HomeState>(
        'loads more projects successfully',
        build: () {
          when(() => mockProjectsService.getProjectsPaginated(
                page: 2,
                pageSize: 10,
              )).thenAnswer((_) async => newProjects);
          
          return homeBloc;
        },
        seed: () => initialState,
        act: (bloc) => bloc.add(const LoadMoreProjects()),
        expect: () => [
          const HomeLoadingMore(),
          isA<HomeLoaded>()
              .having((state) => state.projects.length, 'total projects', 2)
              .having((state) => state.currentPage, 'current page', 2),
        ],
      );
    });

    group('ResetFilters', () {
      final initialState = HomeLoaded(
        userData: const {'name': 'تجريبي'},
        projects: [_createMockProject('1', 'مشروع 1')],
        filteredProjects: [],
        statistics: const {'total': 1},
        selectedCategory: 'education',
        selectedGovernorate: 'damascus',
        searchQuery: 'تجريبي',
      );

      blocTest<HomeBloc, HomeState>(
        'resets all filters to default values',
        build: () => homeBloc,
        seed: () => initialState,
        act: (bloc) => bloc.add(const ResetFilters()),
        expect: () => [
          isA<HomeLoaded>()
              .having((state) => state.selectedCategory, 'category', 'all')
              .having((state) => state.selectedGovernorate, 'governorate', 'all')
              .having((state) => state.searchQuery, 'search query', '')
              .having((state) => state.filteredProjects.length, 'filtered projects', 1),
        ],
      );
    });
  });
}

// Helper function to create mock projects
ProjectModel _createMockProject(String id, String title, {String category = 'general'}) {
  return ProjectModel(
    projectId: id,
    title: title,
    description: 'وصف $title',
    category: category,
    location: const ProjectLocation(
      governorate: 'دمشق',
      city: 'دمشق',
      address: 'عنوان تجريبي',
      coordinates: ProjectCoordinates(latitude: 33.5138, longitude: 36.2765),
    ),
    funding: const ProjectFunding(
      targetAmount: 1000.0,
      currentAmount: 500.0,
      currency: 'USD',
      progressPercentage: 50.0,
    ),
    timeline: ProjectTimeline(
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      expectedEndDate: DateTime.now().add(const Duration(days: 30)),
    ),
    creator: const ProjectCreator(
      uid: 'creator123',
      name: 'منشئ تجريبي',
      role: 'مدير المشروع',
      contact: 'test@example.com',
    ),
    media: const ProjectMedia(
      mainImage: 'https://example.com/image.jpg',
      gallery: [],
      documents: [],
    ),
    engagement: const ProjectEngagement(
      supporters: 10,
      likes: 5,
      comments: 2,
      shares: 1,
      views: 100,
    ),
    verification: const ProjectVerification(
      status: 'verified',
      verifiedBy: 'admin',
      verificationDate: null,
      documents: [],
    ),
  );
}
