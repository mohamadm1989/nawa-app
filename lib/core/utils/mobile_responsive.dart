import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// مساعد التجاوب للموبايل
/// يوفر دوال وثوابت لتحسين التجربة على الأجهزة المختلفة
class MobileResponsive {
  
  /// فحص نوع الجهاز
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isWeb => kIsWeb;
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  
  /// فحص حجم الشاشة
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }
  
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
  
  /// فحص الاتجاه
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
  
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
  
  /// الحصول على أبعاد الشاشة
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  /// الحصول على padding آمن
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
  
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
  
  static double getBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
  
  /// أحجام متجاوبة للنصوص
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = getScreenWidth(context);
    
    if (screenWidth < 360) {
      return baseSize * 0.85; // شاشات صغيرة جداً
    } else if (screenWidth < 600) {
      return baseSize * 0.9; // شاشات صغيرة
    } else if (screenWidth < 1200) {
      return baseSize; // شاشات متوسطة
    } else {
      return baseSize * 1.1; // شاشات كبيرة
    }
  }
  
  /// مسافات متجاوبة
  static double getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = getScreenWidth(context);
    
    if (screenWidth < 360) {
      return basePadding * 0.75;
    } else if (screenWidth < 600) {
      return basePadding * 0.85;
    } else if (screenWidth < 1200) {
      return basePadding;
    } else {
      return basePadding * 1.2;
    }
  }
  
  /// عدد الأعمدة المتجاوب
  static int getResponsiveColumns(BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
  }) {
    final screenWidth = getScreenWidth(context);
    
    if (screenWidth < 600) {
      return mobileColumns;
    } else if (screenWidth < 1200) {
      return tabletColumns;
    } else {
      return desktopColumns;
    }
  }
  
  /// ارتفاع متجاوب للعناصر
  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    final screenHeight = getScreenHeight(context);
    
    if (screenHeight < 600) {
      return baseHeight * 0.8; // شاشات قصيرة
    } else if (screenHeight < 800) {
      return baseHeight * 0.9; // شاشات متوسطة
    } else {
      return baseHeight; // شاشات طويلة
    }
  }
  
  /// عرض متجاوب للعناصر
  static double getResponsiveWidth(BuildContext context, double baseWidth) {
    final screenWidth = getScreenWidth(context);
    
    if (screenWidth < 360) {
      return screenWidth * 0.95; // استخدام معظم العرض
    } else if (screenWidth < 600) {
      return screenWidth * 0.9;
    } else if (screenWidth < 1200) {
      return baseWidth;
    } else {
      return baseWidth * 1.2;
    }
  }
  
  /// فحص إذا كان الجهاز يدعم اللمس
  static bool get supportsTouchInput => isMobile;
  
  /// فحص إذا كان الجهاز يدعم الماوس
  static bool get supportsMouseInput => isDesktop || isWeb;
  
  /// الحصول على نوع التفاعل المفضل
  static String getPreferredInteractionType() {
    if (isMobile) return 'touch';
    if (isDesktop) return 'mouse';
    return 'hybrid';
  }
  
  /// تحديد حجم الأزرار المناسب
  static double getButtonSize(BuildContext context) {
    if (isMobile) {
      return 48.0; // حجم مناسب للمس
    } else {
      return 40.0; // حجم مناسب للماوس
    }
  }
  
  /// تحديد المسافة بين العناصر
  static double getSpacing(BuildContext context, double baseSpacing) {
    if (isSmallScreen(context)) {
      return baseSpacing * 0.75;
    } else if (isMediumScreen(context)) {
      return baseSpacing;
    } else {
      return baseSpacing * 1.25;
    }
  }
  
  /// تحديد نصف قطر الحواف
  static double getBorderRadius(BuildContext context, double baseBorderRadius) {
    if (isSmallScreen(context)) {
      return baseBorderRadius * 0.8;
    } else {
      return baseBorderRadius;
    }
  }
  
  /// تحديد حجم الأيقونات
  static double getIconSize(BuildContext context, double baseIconSize) {
    if (isSmallScreen(context)) {
      return baseIconSize * 0.9;
    } else if (isLargeScreen(context)) {
      return baseIconSize * 1.1;
    } else {
      return baseIconSize;
    }
  }
  
  /// فحص إذا كان يجب إخفاء عناصر معينة على الشاشات الصغيرة
  static bool shouldHideOnSmallScreen(BuildContext context) {
    return isSmallScreen(context);
  }
  
  /// فحص إذا كان يجب استخدام تخطيط مبسط
  static bool shouldUseSimplifiedLayout(BuildContext context) {
    return isSmallScreen(context) || isPortrait(context);
  }
  
  /// الحصول على عدد العناصر في الصف
  static int getItemsPerRow(BuildContext context, double itemWidth) {
    final screenWidth = getScreenWidth(context);
    final availableWidth = screenWidth - 32; // مع مراعاة الهوامش
    return (availableWidth / itemWidth).floor().clamp(1, 4);
  }
  
  /// تحديد ما إذا كان يجب استخدام BottomSheet بدلاً من Dialog
  static bool shouldUseBottomSheet(BuildContext context) {
    return isMobile && isPortrait(context);
  }
  
  /// تحديد ما إذا كان يجب استخدام AppBar مبسط
  static bool shouldUseSimplifiedAppBar(BuildContext context) {
    return isSmallScreen(context);
  }
  
  /// الحصول على ارتفاع AppBar المناسب
  static double getAppBarHeight(BuildContext context) {
    if (isMobile) {
      return kToolbarHeight;
    } else {
      return kToolbarHeight + 8;
    }
  }
  
  /// تحديد ما إذا كان يجب إظهار FAB
  static bool shouldShowFAB(BuildContext context) {
    return !shouldHideOnSmallScreen(context) || isPortrait(context);
  }
  
  /// الحصول على موضع FAB
  static FloatingActionButtonLocation getFABLocation(BuildContext context) {
    if (isMobile && isPortrait(context)) {
      return FloatingActionButtonLocation.centerFloat;
    } else {
      return FloatingActionButtonLocation.endFloat;
    }
  }
}

/// Widget مساعد للتخطيط المتجاوب
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;
  
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, constraints);
      },
    );
  }
}

/// Widget للتخطيط المتجاوب بناءً على حجم الشاشة
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, constraints) {
        if (MobileResponsive.isLargeScreen(context)) {
          return desktop ?? tablet ?? mobile;
        } else if (MobileResponsive.isMediumScreen(context)) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
