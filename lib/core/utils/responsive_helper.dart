import 'package:flutter/material.dart';

/// مساعد التجاوب
/// يوفر أدوات لجعل التطبيق متجاوب على جميع أحجام الشاشات
class ResponsiveHelper {
  // نقاط الكسر للشاشات المختلفة
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// التحقق من نوع الجهاز
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// الحصول على نوع الجهاز
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
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
    double mobileSpacing = 8.0,
    double tabletSpacing = 12.0,
    double desktopSpacing = 16.0,
  }) {
    if (isMobile(context)) return mobileSpacing;
    if (isTablet(context)) return tabletSpacing;
    return desktopSpacing;
  }

  /// الحصول على حجم الخط المناسب
  static double getFontSize(BuildContext context, {
    double mobileFontSize = 14.0,
    double tabletFontSize = 16.0,
    double desktopFontSize = 18.0,
  }) {
    if (isMobile(context)) return mobileFontSize;
    if (isTablet(context)) return tabletFontSize;
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
    if (width < mobileBreakpoint) return 16.0;
    if (width < tabletBreakpoint) return 32.0;
    return (width - 1200) / 2; // توسيط المحتوى على الشاشات الكبيرة
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
    double mobileSize = 40.0,
    double tabletSize = 48.0,
    double desktopSize = 56.0,
  }) {
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) return tabletSize;
    return desktopSize;
  }
}

/// أنواع الأجهزة
enum DeviceType {
  mobile,
  tablet,
  desktop,
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

/// ويدجت للنص المتجاوب
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getFontSize(
      context,
      mobileFontSize: mobileFontSize ?? 14.0,
      tabletFontSize: tabletFontSize ?? 16.0,
      desktopFontSize: desktopFontSize ?? 18.0,
    );

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
