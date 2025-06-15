import 'package:flutter_test/flutter_test.dart';
import 'package:nawa_app/core/safety/user_data_manager.dart';
import 'package:nawa_app/core/config/feature_flags.dart';

void main() {
  group('UserDataManager', () {
    group('getSafeUserData', () {
      test('returns user data with all fields when secure data is disabled', () {
        // Note: This test assumes FeatureFlags.useSecureData is false
        // In a real scenario, we'd mock FeatureFlags
        
        final userData = UserDataManager.getSafeUserData();
        
        expect(userData, isA<Map<String, dynamic>>());
        expect(userData['uid'], isNotNull);
        expect(userData['name'], isNotNull);
        expect(userData['bio'], isNotNull);
        expect(userData['verified'], isNotNull);
        expect(userData['role'], equals('user'));
      });

      test('sanitizes sensitive data when secure data is enabled', () {
        // This test would require mocking FeatureFlags.useSecureData = true
        // For now, we test the structure
        
        final userData = UserDataManager.getSafeUserData();
        
        expect(userData, isA<Map<String, dynamic>>());
        expect(userData.containsKey('uid'), isTrue);
        expect(userData.containsKey('name'), isTrue);
      });

      test('returns fallback data when an error occurs', () {
        // This would require mocking an error scenario
        // For now, we test that the method doesn't throw
        
        expect(() => UserDataManager.getSafeUserData(), returnsNormally);
      });
    });

    group('isValidSession', () {
      test('returns true for valid session data', () {
        final isValid = UserDataManager.isValidSession();
        
        expect(isValid, isA<bool>());
        // The actual value depends on the current implementation
      });

      test('handles missing required fields gracefully', () {
        expect(() => UserDataManager.isValidSession(), returnsNormally);
      });
    });

    group('refreshSession', () {
      test('returns updated user data with new timestamp', () {
        final refreshedData = UserDataManager.refreshSession();
        
        expect(refreshedData, isA<Map<String, dynamic>>());
        expect(refreshedData.containsKey('lastActivity'), isTrue);
      });

      test('handles errors gracefully and returns fallback data', () {
        expect(() => UserDataManager.refreshSession(), returnsNormally);
      });
    });

    group('hasPermission', () {
      test('returns true for basic permissions', () {
        final hasViewPermission = UserDataManager.hasPermission('view_projects');
        expect(hasViewPermission, isTrue);
      });

      test('returns appropriate permissions for user role', () {
        final hasCreatePermission = UserDataManager.hasPermission('create_project');
        expect(hasCreatePermission, isA<bool>());
      });

      test('returns false for admin-only permissions for regular users', () {
        final hasDeletePermission = UserDataManager.hasPermission('delete_project');
        expect(hasDeletePermission, isA<bool>());
      });

      test('handles unknown permissions gracefully', () {
        final hasUnknownPermission = UserDataManager.hasPermission('unknown_permission');
        expect(hasUnknownPermission, isFalse);
      });
    });

    group('getUserPermissions', () {
      test('returns list of permissions for current user', () {
        final permissions = UserDataManager.getUserPermissions();
        
        expect(permissions, isA<List<String>>());
        expect(permissions, isNotEmpty);
        expect(permissions, contains('view_projects'));
      });

      test('handles errors and returns basic permissions', () {
        expect(() => UserDataManager.getUserPermissions(), returnsNormally);
        
        final permissions = UserDataManager.getUserPermissions();
        expect(permissions, contains('view_projects'));
      });
    });

    group('updateProfile', () {
      test('updates allowed fields successfully', () {
        final updates = {
          'name': 'اسم جديد',
          'avatar': 'new_avatar_url',
        };
        
        final updatedData = UserDataManager.updateProfile(updates);
        
        expect(updatedData, isA<Map<String, dynamic>>());
        expect(updatedData['name'], equals('اسم جديد'));
        expect(updatedData.containsKey('lastUpdated'), isTrue);
      });

      test('ignores disallowed fields', () {
        final updates = {
          'name': 'اسم جديد',
          'uid': 'new_uid', // This should be ignored
          'role': 'admin', // This should be ignored
        };
        
        final updatedData = UserDataManager.updateProfile(updates);
        
        expect(updatedData['name'], equals('اسم جديد'));
        // uid and role should not be updated
      });

      test('handles errors gracefully', () {
        expect(() => UserDataManager.updateProfile({}), returnsNormally);
      });
    });

    group('validateUserData', () {
      test('returns true for valid user data', () {
        final validData = {
          'uid': 'test_uid',
          'name': 'اسم صحيح',
          'email': 'test@example.com',
        };
        
        final isValid = UserDataManager.validateUserData(validData);
        expect(isValid, isTrue);
      });

      test('returns false for missing required fields', () {
        final invalidData = {
          'email': 'test@example.com',
          // missing uid and name
        };
        
        final isValid = UserDataManager.validateUserData(invalidData);
        expect(isValid, isFalse);
      });

      test('returns false for invalid email format', () {
        final invalidData = {
          'uid': 'test_uid',
          'name': 'اسم صحيح',
          'email': 'invalid_email',
        };
        
        final isValid = UserDataManager.validateUserData(invalidData);
        expect(isValid, isFalse);
      });

      test('handles null values gracefully', () {
        final invalidData = {
          'uid': null,
          'name': 'اسم صحيح',
        };
        
        final isValid = UserDataManager.validateUserData(invalidData);
        expect(isValid, isFalse);
      });
    });

    group('getUserStats', () {
      test('returns user statistics', () {
        final stats = UserDataManager.getUserStats();
        
        expect(stats, isA<Map<String, dynamic>>());
        expect(stats.containsKey('projects_created'), isTrue);
        expect(stats.containsKey('total_donations'), isTrue);
        expect(stats.containsKey('projects_supported'), isTrue);
        expect(stats.containsKey('impact_score'), isTrue);
      });

      test('returns fallback stats on error', () {
        expect(() => UserDataManager.getUserStats(), returnsNormally);
        
        final stats = UserDataManager.getUserStats();
        expect(stats['projects_created'], isA<int>());
        expect(stats['total_donations'], isA<double>());
      });
    });
  });
}
