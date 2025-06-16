import 'package:flutter/material.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/constants/responsive_constants.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_colors.dart';

/// ويدجت النص المتجاوب المحسّن
/// يتكيف مع جميع أحجام الشاشات بما في ذلك الشاشات الصغيرة جداً
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final double? minFontSize;
  final double? maxFontSize;
  final double scaleFactor;
  final ResponsiveTextType type;

  const ResponsiveText(
    this.text, {
    super.key,
    this.baseStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
    this.scaleFactor = 1.0,
    this.type = ResponsiveTextType.body,
  });

  /// نص عنوان رئيسي
  const ResponsiveText.headline(
    this.text, {
    super.key,
    this.baseStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
    this.scaleFactor = 1.0,
  }) : type = ResponsiveTextType.headline;

  /// نص عنوان فرعي
  const ResponsiveText.subheadline(
    this.text, {
    super.key,
    this.baseStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
    this.scaleFactor = 1.0,
  }) : type = ResponsiveTextType.subheadline;

  /// نص الجسم
  const ResponsiveText.body(
    this.text, {
    super.key,
    this.baseStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
    this.scaleFactor = 1.0,
  }) : type = ResponsiveTextType.body;

  /// نص تفسيري
  const ResponsiveText.caption(
    this.text, {
    super.key,
    this.baseStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
    this.scaleFactor = 1.0,
  }) : type = ResponsiveTextType.caption;

  @override
  Widget build(BuildContext context) {
    final style = _getTextStyle(context);
    
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    TextStyle style;
    
    // اختيار النمط الأساسي حسب النوع
    switch (type) {
      case ResponsiveTextType.headline:
        style = ResponsiveConstants.getHeadlineStyle(context);
        break;
      case ResponsiveTextType.subheadline:
        style = ResponsiveConstants.getSubheadlineStyle(context);
        break;
      case ResponsiveTextType.body:
        style = ResponsiveConstants.getBodyStyle(context);
        break;
      case ResponsiveTextType.caption:
        style = ResponsiveConstants.getCaptionStyle(context);
        break;
    }

    // تطبيق النمط المخصص إذا كان موجوداً
    if (baseStyle != null) {
      style = style.merge(baseStyle);
    }

    // تطبيق عامل التحجيم
    if (scaleFactor != 1.0) {
      final fontSize = style.fontSize ?? 16.0;
      style = style.copyWith(fontSize: fontSize * scaleFactor);
    }

    // تطبيق الحد الأدنى والأقصى لحجم الخط
    if (minFontSize != null || maxFontSize != null) {
      final fontSize = style.fontSize ?? 16.0;
      final clampedSize = fontSize.clamp(
        minFontSize ?? 8.0,
        maxFontSize ?? 100.0,
      );
      style = style.copyWith(fontSize: clampedSize);
    }

    return style;
  }
}

/// أنواع النصوص المتجاوبة
enum ResponsiveTextType {
  headline,
  subheadline,
  body,
  caption,
}

/// ويدجت للنص التكيفي مع الشاشات الصغيرة<|im_start|>
class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool autoResize;

  const AdaptiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.autoResize = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!autoResize) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
        final fontSize = textStyle.fontSize ?? 16.0;
        
        // حساب حجم الخط المناسب للمساحة المتاحة
        final adjustedFontSize = _calculateOptimalFontSize(
          context,
          constraints,
          fontSize,
        );

        return Text(
          text,
          style: textStyle.copyWith(fontSize: adjustedFontSize),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow ?? TextOverflow.ellipsis,
        );
      },
    );
  }

  double _calculateOptimalFontSize(
    BuildContext context,
    BoxConstraints constraints,
    double baseFontSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // تقليل حجم الخط للشاشات الصغيرة<|im_start|>
    if (ResponsiveHelper.isExtraSmall(context)) {
      return (baseFontSize * 0.8).clamp(10.0, baseFontSize);
    }
    
    if (ResponsiveHelper.isSmallMobile(context)) {
      return (baseFontSize * 0.9).clamp(11.0, baseFontSize);
    }

    // حساب نسبة العرض المتاح
    final widthRatio = constraints.maxWidth / screenWidth;
    
    if (widthRatio < 0.5) {
      return (baseFontSize * 0.85).clamp(12.0, baseFontSize);
    }
    
    if (widthRatio < 0.7) {
      return (baseFontSize * 0.9).clamp(13.0, baseFontSize);
    }

    return baseFontSize;
  }
}

/// ويدجت للنص مع حد أدنى للقراءة
class ReadableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double minReadableSize;

  const ReadableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.minReadableSize = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
    final fontSize = textStyle.fontSize ?? 16.0;
    
    // ضمان الحد الأدنى للقراءة
    final readableFontSize = fontSize.clamp(minReadableSize, double.infinity);
    
    // تقليل المسافات للشاشات الصغيرة<|im_start|> إذا كان الخط كبيراً
    double? height = textStyle.height;
    if (ResponsiveHelper.needsCompactLayout(context) && readableFontSize > 16.0) {
      height = 1.2;
    }

    return Text(
      text,
      style: textStyle.copyWith(
        fontSize: readableFontSize,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// ويدجت للنص مع تحجيم تلقائي
class AutoSizeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;

  const AutoSizeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.minFontSize = 8.0,
    this.maxFontSize = 100.0,
    this.stepGranularity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
        final baseFontSize = textStyle.fontSize ?? 16.0;
        
        double fontSize = baseFontSize;
        
        // تجربة أحجام مختلفة حتى نجد المناسب
        while (fontSize > minFontSize) {
          final testStyle = textStyle.copyWith(fontSize: fontSize);
          final textPainter = TextPainter(
            text: TextSpan(text: text, style: testStyle),
            textDirection: Directionality.of(context),
            maxLines: maxLines,
          );
          
          textPainter.layout(maxWidth: constraints.maxWidth);
          
          if (textPainter.didExceedMaxLines ||
              textPainter.height > constraints.maxHeight) {
            fontSize -= stepGranularity;
          } else {
            break;
          }
        }
        
        fontSize = fontSize.clamp(minFontSize, maxFontSize);
        
        return Text(
          text,
          style: textStyle.copyWith(fontSize: fontSize),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
