import 'package:flutter/material.dart';
import '../safety/safety_monitor.dart';
import '../../features/welcome/welcome_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/account_settings_screen.dart';
// import '../../features/auth/phone_verification_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/project_details/project_details_screen.dart';
import '../../features/donate/simple_donate_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/notifications/simple_notifications_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/settings/permissions_settings_screen.dart';
import '../../features/support/support_screen.dart';
import '../../features/faq/faq_screen.dart';
import '../../features/terms/terms_screen.dart';
import '../../features/privacy/privacy_screen.dart';
import '../../features/about/about_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/donations_history/donations_history_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_share_screen.dart';
import '../../features/settings/app_settings_screen.dart';
import '../../features/add_project/add_project_screen.dart';
import '../../features/edit_project/edit_project_screen.dart';
import '../../features/manage_projects/manage_projects_screen.dart';
import '../../features/debug/responsive_test_screen.dart';
import '../../features/debug/accessibility_test_screen.dart';
import '../../features/debug/ux_test_screen.dart';
import '../../test_font_screen.dart';

/// نظام التوجيه للتطبيق
/// يدير جميع المسارات والانتقالات بين الشاشات
class AppRoutes {
  // منع إنشاء كائن من هذا الكلاس
  AppRoutes._();

  // ========== أسماء المسارات ==========
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String accountSettings = '/account-settings';
  static const String phoneVerification = '/phone-verification';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String projectDetails = '/project-details';
  static const String donate = '/donate';
  static const String addProject = '/add-project';
  static const String editProject = '/edit-project';
  static const String manageProjects = '/manage-projects';
  static const String map = '/map';
  static const String testFont = '/test-font';
  static const String responsiveTest = '/responsive-test';
  static const String accessibilityTest = '/accessibility-test';
  static const String uxTest = '/ux-test';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String permissionsSettings = '/permissions-settings';
  static const String support = '/support';
  static const String faq = '/faq';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String about = '/about';
  static const String donationsHistory = '/donations-history';
  static const String editProfile = '/edit-profile';
  static const String shareProfile = '/share-profile';

  /// خريطة جميع المسارات
  static Map<String, WidgetBuilder> get routes {
    return {
      welcome: (context) => const WelcomeScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
    };
  }

  /// معالج المسارات المخصصة
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        );

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          builder: (context) => const ForgotPasswordScreen(),
        );

      case AppRoutes.accountSettings:
        return MaterialPageRoute(
          builder: (context) => const AccountSettingsScreen(),
        );

      case AppRoutes.phoneVerification:
        // TODO: إضافة صفحة التحقق من الهاتف
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('التحقق من الهاتف')),
            body: Center(
              child: Text('صفحة التحقق من الهاتف قيد التطوير'),
            ),
          ),
          settings: settings,
        );

      case AppRoutes.projectDetails:
        final projectId = settings.arguments as String?;
        if (projectId != null) {
          return MaterialPageRoute(
            builder: (context) => ProjectDetailsScreen(projectId: projectId),
          );
        }
        return _errorRoute();

      case AppRoutes.addProject:
        return MaterialPageRoute(
          builder: (context) => const AddProjectScreen(),
        );

      case AppRoutes.editProject:
        final project = settings.arguments;
        if (project != null) {
          return MaterialPageRoute(
            builder: (context) => EditProjectScreen(project: project as dynamic),
          );
        }
        return _errorRoute();

      case AppRoutes.manageProjects:
        return MaterialPageRoute(
          builder: (context) => const ManageProjectsScreen(),
        );

      case AppRoutes.donate:
        final projectId = settings.arguments as String?;
        if (projectId != null) {
          return MaterialPageRoute(
            builder: (context) => SimpleDonateScreen(projectId: projectId),
          );
        }
        return _errorRoute();

      case AppRoutes.search:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => SearchScreen(
            initialQuery: args?['query'] as String?,
            initialTabIndex: args?['tabIndex'] as int?,
          ),
        );

      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (context) => const FavoritesScreen(),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        );

      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (context) => const SimpleNotificationsScreen(),
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (context) => const AppSettingsScreen(),
        );

      case AppRoutes.permissionsSettings:
        return MaterialPageRoute(
          builder: (context) => const PermissionsSettingsScreen(),
        );

      case AppRoutes.support:
        return MaterialPageRoute(
          builder: (context) => const SupportScreen(),
        );

      case AppRoutes.faq:
        return MaterialPageRoute(
          builder: (context) => const FAQScreen(),
        );

      case AppRoutes.terms:
        return MaterialPageRoute(
          builder: (context) => const TermsScreen(),
        );

      case AppRoutes.privacy:
        return MaterialPageRoute(
          builder: (context) => const PrivacyScreen(),
        );

      case AppRoutes.about:
        return MaterialPageRoute(
          builder: (context) => const AboutScreen(),
        );

      case AppRoutes.donationsHistory:
        return MaterialPageRoute(
          builder: (context) => const DonationsHistoryScreen(),
        );

      case AppRoutes.editProfile:
        return MaterialPageRoute(
          builder: (context) => const EditProfileScreen(),
        );

      case AppRoutes.shareProfile:
        return MaterialPageRoute(
          builder: (context) => const ProfileShareScreen(),
        );

      case AppRoutes.map:
        return MaterialPageRoute(
          builder: (context) => const MapScreen(),
        );

      case AppRoutes.testFont:
        return MaterialPageRoute(
          builder: (context) => const TestFontScreen(),
        );

      case AppRoutes.responsiveTest:
        return MaterialPageRoute(
          builder: (context) => const ResponsiveTestScreen(),
        );

      case AppRoutes.accessibilityTest:
        return MaterialPageRoute(
          builder: (context) => const AccessibilityTestScreen(),
        );

      case AppRoutes.uxTest:
        return MaterialPageRoute(
          builder: (context) => const UXTestScreen(),
        );

      default:
        return _errorRoute();
    }
  }

  /// صفحة الخطأ
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(
          child: Text(
            'الصفحة غير موجودة',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  /// دوال مساعدة للتنقل
  static void pushWelcome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      welcome,
      (route) => false,
    );
  }

  static void pushLogin(BuildContext context) {
    Navigator.of(context).pushNamed(login);
  }

  static void pushPhoneVerification(
    BuildContext context, {
    required String phoneNumber,
    required String verificationId,
  }) {
    Navigator.of(context).pushNamed(
      phoneVerification,
      arguments: PhoneVerificationArgs(
        phoneNumber: phoneNumber,
        verificationId: verificationId,
      ),
    );
  }

  static void pushHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      home,
      (route) => false,
    );
  }

  static void pushProjectDetails(BuildContext context, String projectId) {
    Navigator.of(context).pushNamed(
      projectDetails,
      arguments: projectId,
    );
  }

  static void pushAddProject(BuildContext context) {
    Navigator.of(context).pushNamed(addProject);
  }

  static void pushDonate(BuildContext context, String projectId) {
    Navigator.of(context).pushNamed(
      donate,
      arguments: projectId,
    );
  }

  static void pushSearch(BuildContext context) {
    Navigator.of(context).pushNamed(search);
  }

  static void pushFavorites(BuildContext context) {
    Navigator.of(context).pushNamed(favorites);
  }

  static void pushProfile(BuildContext context) {
    Navigator.of(context).pushNamed(profile);
  }

  static void pushNotifications(BuildContext context) {
    Navigator.of(context).pushNamed(notifications);
  }

  static void pushSettings(BuildContext context) {
    Navigator.of(context).pushNamed(settings);
  }

  static void pushMap(BuildContext context) {
    Navigator.of(context).pushNamed(map);
  }

  static void pushManageProjects(BuildContext context) {
    Navigator.of(context).pushNamed(manageProjects);
  }

  static Future<dynamic> pushEditProject(BuildContext context, dynamic project) {
    return Navigator.of(context).pushNamed(
      editProject,
      arguments: project,
    );
  }

  static void pushSupport(BuildContext context) {
    Navigator.of(context).pushNamed(support);
  }

  static void pushFAQ(BuildContext context) {
    Navigator.of(context).pushNamed(faq);
  }

  static void pushTerms(BuildContext context) {
    Navigator.of(context).pushNamed(terms);
  }

  static void pushPrivacy(BuildContext context) {
    Navigator.of(context).pushNamed(privacy);
  }

  static void pushAbout(BuildContext context) {
    Navigator.of(context).pushNamed(about);
  }

  static void pushDonationsHistory(BuildContext context) {
    Navigator.of(context).pushNamed(donationsHistory);
  }

  /// التوجيه إلى صفحة تعديل الملف الشخصي مع إرجاع النتيجة
  /// إرجاع: Future<bool?> - true إذا تم حفظ التغييرات، false أو null إذا تم الإلغاء
  static Future<bool?> pushEditProfile(BuildContext context) {
    try {
      return Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => const EditProfileScreen(),
        ),
      );
    } catch (e) {
      SafetyMonitor.logError('Navigation Error in pushEditProfile', e);
      return Future.value(null);
    }
  }

  static void pushShareProfile(BuildContext context) {
    Navigator.of(context).pushNamed(shareProfile);
  }

  /// العودة للصفحة السابقة
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.of(context).pop(result);
  }

  /// العودة للصفحة السابقة مع التحقق
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  /// إزالة جميع الصفحات والانتقال لصفحة جديدة
  static void pushAndRemoveUntil(
    BuildContext context,
    String routeName, {
    dynamic arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// استبدال الصفحة الحالية
  static void pushReplacement(
    BuildContext context,
    String routeName, {
    dynamic arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// التوجيه إلى صفحة اختبار الاستجابة
  static void pushResponsiveTest(BuildContext context) {
    try {
      Navigator.of(context).pushNamed(responsiveTest);
    } catch (e) {
      debugPrint('خطأ في التوجيه إلى صفحة اختبار الاستجابة: $e');
    }
  }

  /// التوجيه إلى صفحة اختبار إمكانية الوصول
  static void pushAccessibilityTest(BuildContext context) {
    try {
      Navigator.of(context).pushNamed(accessibilityTest);
    } catch (e) {
      debugPrint('خطأ في التوجيه إلى صفحة اختبار إمكانية الوصول: $e');
    }
  }

  /// التوجيه إلى صفحة اختبار تجربة المستخدم
  static void pushUXTest(BuildContext context) {
    try {
      Navigator.of(context).pushNamed(uxTest);
    } catch (e) {
      debugPrint('خطأ في التوجيه إلى صفحة اختبار تجربة المستخدم: $e');
    }
  }
}

/// معاملات شاشة التحقق من الهاتف
class PhoneVerificationArgs {
  final String phoneNumber;
  final String verificationId;

  const PhoneVerificationArgs({
    required this.phoneNumber,
    required this.verificationId,
  });
}

/// معاملات تفاصيل المشروع
class ProjectDetailsArgs {
  final String projectId;
  final String? heroTag;

  const ProjectDetailsArgs({
    required this.projectId,
    this.heroTag,
  });
}

/// معاملات التبرع
class DonateArgs {
  final String projectId;
  final double? suggestedAmount;

  const DonateArgs({
    required this.projectId,
    this.suggestedAmount,
  });
}
