import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // لإخفاء رسائل overflow
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/constants.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/local_storage_manager.dart';
import 'core/services/notification_service.dart';
// import 'core/network/connectivity_manager.dart';
// import 'core/sync/sync_manager.dart';
// import 'shared/widgets/connectivity_indicator.dart';
// import 'core/services/firebase_service.dart';

void main() async {
  // إعداد معالج الأخطاء الآمن
  _setupSafeErrorHandling();

  WidgetsFlutterBinding.ensureInitialized();

  // طباعة معلومات النظام للتشخيص
  PlatformSafe.printPlatformInfo();
  FeatureFlags.printStatus();

  try {
    await _initializeAppSafely();
    runApp(const NawaApp());
  } catch (e, stackTrace) {
    SafetyMonitor.logError('App Initialization', e, stackTrace);
    runApp(const ErrorApp());
  }
}

/// إعداد معالج الأخطاء الآمن
void _setupSafeErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // إخفاء رسائل overflow تمامًا
    if (details.exception.toString().contains('RenderFlex overflowed') ||
        details.exception.toString().contains('overflow')) {
      return;
    }

    // تسجيل الخطأ في نظام المراقبة
    SafetyMonitor.logError(
      'Flutter Error',
      details.exception,
      details.stack,
    );
  };

  // معالج الأخطاء غير المتوقعة
  PlatformDispatcher.instance.onError = (error, stack) {
    SafetyMonitor.logError('Platform Error', error, stack);
    return true;
  };
}

/// تهيئة التطبيق بأمان
Future<void> _initializeAppSafely() async {
  try {
    SafetyMonitor.logInfo('App Init', 'بدء تهيئة التطبيق');

    // تطبيق إعدادات شريط الحالة
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);
    SafetyMonitor.logSuccess('System UI Setup');

    // تهيئة التخزين المحلي
    await LocalStorageManager.init();
    SafetyMonitor.logSuccess('Local Storage Init');

    // تهيئة خدمة الإشعارات (مع حماية المنصة)
    if (PlatformSafe.supportsLocalNotifications) {
      await NotificationService.instance.initialize();
      SafetyMonitor.logSuccess('Notification Service Init');
    } else {
      SafetyMonitor.logInfo('Notification Service', 'غير مدعوم على هذه المنصة');
    }

    // تهيئة Firebase (إذا كان مفعل)
    if (FeatureFlags.useFirebase) {
      // await FirebaseService.instance.initialize();
      SafetyMonitor.logInfo('Firebase', 'سيتم تفعيله لاحقاً');
    }

    // تهيئة مدير الاتصال (معطل مؤقتاً)
    // if (FeatureFlags.useAdvancedOfflineMode) {
    //   await ConnectivityManager.instance.initialize();
    // }

    // تهيئة مدير المزامنة (معطل مؤقتاً)
    // if (FeatureFlags.useAdvancedOfflineMode) {
    //   await SyncManager.instance.initialize();
    // }

    // فحص صحة التطبيق بعد التهيئة
    final isHealthy = SafetyMonitor.checkAppHealth();
    if (!isHealthy) {
      SafetyMonitor.logWarning('App Init', 'التطبيق غير صحي بعد التهيئة');
    }

    SafetyMonitor.logSuccess('App Initialization Complete');
  } catch (e, stackTrace) {
    SafetyMonitor.logError('App Initialization', e, stackTrace);
    rethrow;
  }
}

/// تطبيق الخطأ في حالة فشل التهيئة
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'خطأ في التطبيق',
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'حدث خطأ في تهيئة التطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'يرجى إعادة تشغيل التطبيق',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NawaApp extends StatelessWidget {
  const NawaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ========== معلومات التطبيق ==========
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // ========== الثيم ==========
      theme: AppTheme.lightTheme,

      // ========== اللغة والتوطين ==========
      locale: const Locale('en', 'US'), // الإنجليزية مؤقت<|im_start|>ح
      supportedLocales: const [
        Locale('ar', 'SY'), // العربية
        Locale('en', 'US'), // الإنجليزية
      ],

      // ========== التوجيه ==========
      initialRoute: AppRoutes.welcome,

      // إعداد اتجاه النص للعربية مع معالجة الأخطاء
      builder: (context, child) {
        // إخفاء رسائل overflow البصرية تماماً
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          SafetyMonitor.logError('Widget Error', errorDetails.exception);
          return Container(); // عرض فارغ بدلاً من رسالة الخطأ
        };

        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,

      // ========== Builder مع مؤشر الاتصال (معطل مؤقتاً) ==========
      // builder: (context, child) {
      //   return ConnectivityIndicator(
      //     showWhenConnected: true,
      //     child: child ?? const SizedBox(),
      //   );
      // },
    );
  }
}


