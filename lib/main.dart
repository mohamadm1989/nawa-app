import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // لإخفاء رسائل overflow
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/constants.dart';
import 'core/routes/app_routes.dart';
import 'core/storage/local_storage_manager.dart';
// import 'core/network/connectivity_manager.dart';
// import 'core/sync/sync_manager.dart';
// import 'shared/widgets/connectivity_indicator.dart';
// import 'core/services/firebase_service.dart';

void main() async {
  // إعداد معالج الأخطاء الشامل - إخفاء الأخطاء البصرية في الواجهة
  FlutterError.onError = (FlutterErrorDetails details) {
    // إخفاء رسائل overflow تمامًا
    if (details.exception.toString().contains('RenderFlex overflowed') ||
        details.exception.toString().contains('overflow')) {
      // لا تطبع رسائل overflow نهائيًا
      return;
    }

    // إخفاء الأخطاء البصرية في الواجهة (للإنتاج)
    // FlutterError.presentError(details); // معطل لإخفاء رسائل الخطأ البصرية

    // طباعة الأخطاء الأخرى في الكونسول فقط (للتطوير)
    debugPrint('🚨 Flutter Error: ${details.exception}');
    debugPrint('📍 Stack: ${details.stack}');
  };

  // معالج الأخطاء غير المتوقعة
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('🚨 Platform Error: $error');
    debugPrint('📍 Stack: $stack');
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();

  try {
    // تطبيق إعدادات شريط الحالة
    SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);

    // تهيئة التخزين المحلي
    await LocalStorageManager.init();

    // تهيئة مدير الاتصال (معطل مؤقتاً)
    // await ConnectivityManager.instance.initialize();

    // تهيئة مدير المزامنة (معطل مؤقتاً)
    // await SyncManager.instance.initialize();

    // تهيئة Firebase (معطل مؤقتاً للويب)
    // await FirebaseService.instance.initialize();

    runApp(const NawaApp());
  } catch (e, stackTrace) {
    debugPrint('🚨 خطأ في تهيئة التطبيق: $e');
    debugPrint('📍 Stack: $stackTrace');
    runApp(const ErrorApp());
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

      // إعداد اتجاه النص للعربية
      builder: (context, child) {
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


