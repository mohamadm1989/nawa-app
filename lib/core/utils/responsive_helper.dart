import 'package:flutter/material.dart';

/// مساعد التجاوب المحسّن
/// يوفر أدوات لجعل التطبيق متجاوب على جميع أحجام الشاشات
/// مع دعم خاص للشاشات الصغيرة جداً (أقل من 360px)
class ResponsiveHelper {
  // نقاط الكسر للشاشات المختلفة
  static const double extraSmallBreakpoint = 360;  // الشاشات الصغيرة جداً
  static const double smallBreakpoint = 480;       // الهواتف الصغيرة
  static const double mobileBreakpoint = 600;      // الهواتف العادية
  static const double tabletBreakpoint = 900;      // الأجهزة اللوحية
  static const double desktopBreakpoint = 1200;    // أجهزة سطح المكتب
  static const double largeDesktopBreakpoint = 1600; // الشاشات الكبيرة

  /// التحقق من نوع الجهاز
  static bool isExtraSmall(BuildContext context) {
    return MediaQuery.of(context).size.width < extraSmallBreakpoint;
  }

  static bool isSmallMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= extraSmallBreakpoint && width < smallBreakpoint;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint && width < largeDesktopBreakpoint;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopBreakpoint;
  }

  /// الحصول على نوع الجهاز
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < extraSmallBreakpoint) return DeviceType.extraSmall;
    if (width < smallBreakpoint) return DeviceType.smallMobile;
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < tabletBreakpoint) return DeviceType.tablet;
    if (width < largeDesktopBreakpoint) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// الحصول على عدد الأعمدة المناسب
  static int getGridColumns(BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
  }) {
    if (isMobile(context)) return mobileColumns;
    if (isTablet(context)) return tabletColumns;
    return desktopColumns;
  }

  /// الحصول على المساحات المناسبة
  static double getSpacing(BuildContext context, {
    double extraSmallSpacing = 4.0,
    double smallMobileSpacing = 6.0,
    double mobileSpacing = 8.0,
    double tabletSpacing = 12.0,
    double desktopSpacing = 16.0,
    double largeDesktopSpacing = 20.0,
  }) {
    if (isExtraSmall(context)) return extraSmallSpacing;
    if (isSmallMobile(context)) return smallMobileSpacing;
    if (isMobile(context)) return mobileSpacing;
    if (isTablet(context)) return tabletSpacing;
    if (isLargeDesktop(context)) return largeDesktopSpacing;
    return desktopSpacing;
  }

  /// الحصول على حجم الخط المناسب
  static double getFontSize(BuildContext context, {
    double extraSmallFontSize = 12.0,
    double smallMobileFontSize = 13.0,
    double mobileFontSize = 14.0,
    double tabletFontSize = 16.0,
    double desktopFontSize = 18.0,
    double largeDesktopFontSize = 20.0,
  }) {
    if (isExtraSmall(context)) return extraSmallFontSize;
    if (isSmallMobile(context)) return smallMobileFontSize;
    if (isMobile(context)) return mobileFontSize;
    if (isTablet(context)) return tabletFontSize;
    if (isLargeDesktop(context)) return largeDesktopFontSize;
    return desktopFontSize;
  }

  /// الحصول على الحد الأقصى للعرض
  static double getMaxWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 800;
    return 1200;
  }

  /// الحصول على المساحة الجانبية
  static double getSidePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < extraSmallBreakpoint) return 8.0;   // شاشات صغيرة جداً
    if (width < smallBreakpoint) return 12.0;       // هواتف صغيرة
    if (width < mobileBreakpoint) return 16.0;      // هواتف عادية
    if (width < tabletBreakpoint) return 24.0;      // أجهزة لوحية صغيرة
    if (width < desktopBreakpoint) return 32.0;     // أجهزة لوحية كبيرة
    if (width < largeDesktopBreakpoint) return (width - 1200) / 2; // سطح المكتب
    return (width - 1600) / 2; // شاشات كبيرة
  }

  /// الحصول على نسبة العرض إلى الارتفاع للكروت
  static double getCardAspectRatio(BuildContext context) {
    if (isMobile(context)) return 1.2;
    if (isTablet(context)) return 1.3;
    return 1.4;
  }

  /// التحقق من الاتجاه
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// الحصول على ارتفاع الشاشة
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// الحصول على عرض الشاشة
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// التحقق من الشاشات الصغيرة جداً
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 600;
  }

  /// الحصول على حجم الأيقونة المناسب
  static double getIconSize(BuildContext context, {
    double mobileSize = 20.0,
    double tabletSize = 24.0,
    double desktopSize = 28.0,
  }) {
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) return tabletSize;
    return desktopSize;
  }

  /// الحصول على ارتفاع الأزرار
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) return 48.0;
    if (isTablet(context)) return 52.0;
    return 56.0;
  }

  /// الحصول على حجم الصورة الشخصية
  static double getAvatarSize(BuildContext context, {
    double extraSmallSize = 32.0,
    double smallMobileSize = 36.0,
    double mobileSize = 40.0,
    double tabletSize = 48.0,
    double desktopSize = 56.0,
    double largeDesktopSize = 64.0,
  }) {
    if (isExtraSmall(context)) return extraSmallSize;
    if (isSmallMobile(context)) return smallMobileSize;
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) return tabletSize;
    if (isLargeDesktop(context)) return largeDesktopSize;
    return desktopSize;
  }

  /// الحصول على حجم الخط المتجاوب بناءً على النوع
  static double getResponsiveFontSize(BuildContext context, {
    required double baseSize,
    double scaleFactor = 1.0,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.extraSmall:
        return (baseSize * 0.8 * scaleFactor).clamp(10.0, 100.0);
      case DeviceType.smallMobile:
        return (baseSize * 0.9 * scaleFactor).clamp(11.0, 100.0);
      case DeviceType.mobile:
        return (baseSize * 1.0 * scaleFactor).clamp(12.0, 100.0);
      case DeviceType.tablet:
        return (baseSize * 1.1 * scaleFactor).clamp(14.0, 100.0);
      case DeviceType.desktop:
        return (baseSize * 1.2 * scaleFactor).clamp(16.0, 100.0);
      case DeviceType.largeDesktop:
        return (baseSize * 1.3 * scaleFactor).clamp(18.0, 100.0);
    }
  }

  /// الحصول على المساحة المتجاوبة
  static double getResponsiveSpacing(BuildContext context, {
    required double baseSpacing,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.extraSmall:
        return baseSpacing * 0.5;
      case DeviceType.smallMobile:
        return baseSpacing * 0.7;
      case DeviceType.mobile:
        return baseSpacing * 1.0;
      case DeviceType.tablet:
        return baseSpacing * 1.2;
      case DeviceType.desktop:
        return baseSpacing * 1.4;
      case DeviceType.largeDesktop:
        return baseSpacing * 1.6;
    }
  }

  /// التحقق من الحاجة لتخطيط مضغوط
  static bool needsCompactLayout(BuildContext context) {
    return isExtraSmall(context) || isSmallMobile(context);
  }

  /// الحصول على عدد الأعمدة للشاشات الصغيرة<|im_start|>
  static int getCompactGridColumns(BuildContext context) {
    if (isExtraSmall(context)) return 1;
    if (isSmallMobile(context)) return 1;
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  /// الحصول على ارتفاع العنصر المتجاوب
  static double getResponsiveHeight(BuildContext context, {
    required double baseHeight,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.extraSmall:
        return baseHeight * 0.8;
      case DeviceType.smallMobile:
        return baseHeight * 0.9;
      case DeviceType.mobile:
        return baseHeight * 1.0;
      case DeviceType.tablet:
        return baseHeight * 1.1;
      case DeviceType.desktop:
        return baseHeight * 1.2;
      case DeviceType.largeDesktop:
        return baseHeight * 1.3;
    }
  }

  /// الحصول على عرض العنصر المتجاوب
  static double getResponsiveWidth(BuildContext context, {
    required double baseWidth,
    double? maxWidth,
  }) {
    final screenWidth = getScreenWidth(context);
    final calculatedWidth = baseWidth * _getWidthScale(context);

    if (maxWidth != null) {
      return calculatedWidth.clamp(0, maxWidth);
    }

    return calculatedWidth.clamp(0, screenWidth * 0.9);
  }

  /// مقياس العرض الداخلي
  static double _getWidthScale(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.extraSmall:
        return 0.95;
      case DeviceType.smallMobile:
        return 0.92;
      case DeviceType.mobile:
        return 0.9;
      case DeviceType.tablet:
        return 0.85;
      case DeviceType.desktop:
        return 0.8;
      case DeviceType.largeDesktop:
        return 0.75;
    }
  }
}

/// أنواع الأجهزة المحسّنة
enum DeviceType {
  extraSmall,    // أقل من 360px
  smallMobile,   // 360px - 480px
  mobile,        // 480px - 600px
  tablet,        // 600px - 900px
  desktop,       // 900px - 1600px
  largeDesktop,  // أكبر من 1600px
}

/// ويدجت للتخطيط المتجاوب
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
    if (ResponsiveHelper.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (ResponsiveHelper.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// ويدجت للحاوية المتجاوبة
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSidePadding(context),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? ResponsiveHelper.getMaxWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// ويدجت للشبكة المتجاوبة
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double? spacing;
  final double? runSpacing;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing,
    this.runSpacing,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveHelper.getGridColumns(
      context,
      mobileColumns: mobileColumns ?? 1,
      tabletColumns: tabletColumns ?? 2,
      desktopColumns: desktopColumns ?? 3,
    );

    final spacingValue = spacing ?? ResponsiveHelper.getSpacing(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacingValue,
        mainAxisSpacing: runSpacing ?? spacingValue,
        childAspectRatio: childAspectRatio ?? ResponsiveHelper.getCardAspectRatio(context),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}


