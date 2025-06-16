import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../../shared/widgets/responsive_text_widget.dart' as responsive_widgets;
import '../../shared/widgets/widgets.dart';

/// شاشة اختبار الاستجابة
/// تعرض كيف تبدو العناصر على أحجام شاشات مختلفة
class ResponsiveTestScreen extends StatelessWidget {
  const ResponsiveTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('اختبار الاستجابة'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveConstants.getMediumPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceInfo(context),
            SizedBox(height: ResponsiveConstants.getLargeSpacing(context)),
            _buildTextSamples(context),
            SizedBox(height: ResponsiveConstants.getLargeSpacing(context)),
            _buildButtonSamples(context),
            SizedBox(height: ResponsiveConstants.getLargeSpacing(context)),
            _buildCardSamples(context),
            SizedBox(height: ResponsiveConstants.getLargeSpacing(context)),
            _buildGridSample(context),
            SizedBox(height: ResponsiveConstants.getLargeSpacing(context)),
            _buildSpacingSamples(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final deviceType = ResponsiveHelper.getDeviceType(context);
    
    return Container(
      padding: ResponsiveConstants.getMediumPadding(context),
      decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsive_widgets.ResponsiveText.headline(
            'معلومات الجهاز',
            baseStyle: const TextStyle(color: AppColors.primaryGreen),
          ),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),
          _buildInfoRow('العرض', '${screenSize.width.toInt()}px'),
          _buildInfoRow('الارتفاع', '${screenSize.height.toInt()}px'),
          _buildInfoRow('نوع الجهاز', _getDeviceTypeName(deviceType)),
          _buildInfoRow('تخطيط مضغوط', ResponsiveHelper.needsCompactLayout(context) ? 'نعم' : 'لا'),
          _buildInfoRow('اتجاه الشاشة', ResponsiveHelper.isPortrait(context) ? 'عمودي' : 'أفقي'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  String _getDeviceTypeName(DeviceType type) {
    switch (type) {
      case DeviceType.extraSmall:
        return 'صغير جداً';
      case DeviceType.smallMobile:
        return 'هاتف صغير';
      case DeviceType.mobile:
        return 'هاتف';
      case DeviceType.tablet:
        return 'جهاز لوحي';
      case DeviceType.desktop:
        return 'سطح المكتب';
      case DeviceType.largeDesktop:
        return 'شاشة كبيرة';
    }
  }

  Widget _buildTextSamples(BuildContext context) {
    return Container(
      padding: ResponsiveConstants.getMediumPadding(context),
      decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsive_widgets.ResponsiveText.headline(
            'عينات النصوص',
            baseStyle: const TextStyle(color: AppColors.primaryGreen),
          ),
          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),

          responsive_widgets.ResponsiveText.headline('عنوان رئيسي متجاوب'),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),

          responsive_widgets.ResponsiveText.subheadline('عنوان فرعي متجاوب'),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),

          responsive_widgets.ResponsiveText.body('نص الجسم المتجاوب - هذا النص يتكيف مع حجم الشاشة ويضمن القراءة المريحة على جميع الأجهزة.'),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),

          responsive_widgets.ResponsiveText.caption('نص تفسيري صغير متجاوب'),
          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),
          
          const Divider(),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),
          
          const Text('نص عادي للمقارنة', style: TextStyle(fontSize: 16)),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),

          responsive_widgets.AdaptiveText(
            'نص تكيفي يتغير حسب المساحة المتاحة - يصبح أصغر في المساحات الضيقة',
            autoResize: true,
          ),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),

          responsive_widgets.ReadableText(
            'نص مضمون القراءة - لن يصبح أصغر من الحد المسموح',
            minReadableSize: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSamples(BuildContext context) {
    return Container(
      padding: ResponsiveConstants.getMediumPadding(context),
      decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsive_widgets.ResponsiveText.headline(
            'عينات الأزرار',
            baseStyle: const TextStyle(color: AppColors.primaryGreen),
          ),
          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ResponsiveConstants.getResponsivePrimaryButtonStyle(context),
              onPressed: () {},
              child: const Text('زر أساسي متجاوب'),
            ),
          ),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: ResponsiveConstants.getResponsiveSecondaryButtonStyle(context),
              onPressed: () {},
              child: const Text('زر ثانوي متجاوب'),
            ),
          ),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ResponsiveConstants.getResponsivePrimaryButtonStyle(context),
                  onPressed: () {},
                  child: const Text('زر 1'),
                ),
              ),
              SizedBox(width: ResponsiveConstants.getSmallSpacing(context)),
              Expanded(
                child: OutlinedButton(
                  style: ResponsiveConstants.getResponsiveSecondaryButtonStyle(context),
                  onPressed: () {},
                  child: const Text('زر 2'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardSamples(BuildContext context) {
    return Container(
      padding: ResponsiveConstants.getMediumPadding(context),
      decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsive_widgets.ResponsiveText.headline(
            'عينات الكروت',
            baseStyle: const TextStyle(color: AppColors.primaryGreen),
          ),
          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),
          
          AppLayouts.statisticCard(
            title: 'إحصائية متجاوبة',
            value: '1,234',
            icon: Icons.star,
            color: AppColors.warning,
          ),
          SizedBox(height: ResponsiveConstants.getSmallSpacing(context)),
          
          Container(
            padding: ResponsiveConstants.getSmallPadding(context),
            decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: ResponsiveConstants.getMediumAvatarSize(context) / 2,
                      backgroundColor: AppColors.primaryGreen,
                      child: Icon(
                        Icons.person,
                        size: ResponsiveConstants.getMediumIconSize(context),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: ResponsiveConstants.getSmallSpacing(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          responsive_widgets.ResponsiveText.body('اسم المستخدم'),
                          responsive_widgets.ResponsiveText.caption('معلومات إضافية'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSample(BuildContext context) {
    return Container(
      padding: ResponsiveConstants.getMediumPadding(context),
      decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsive_widgets.ResponsiveText.headline(
            'شبكة متجاوبة',
            baseStyle: const TextStyle(color: AppColors.primaryGreen),
          ),
          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),
          
          ResponsiveGrid(
            mobileColumns: ResponsiveHelper.needsCompactLayout(context) ? 1 : 2,
            tabletColumns: 3,
            desktopColumns: 4,
            spacing: ResponsiveConstants.getSmallSpacing(context),
            childAspectRatio: ResponsiveConstants.getOptimalCardAspectRatio(context),
            children: List.generate(6, (index) => Container(
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: responsive_widgets.ResponsiveText.body('عنصر ${index + 1}'),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingSamples(BuildContext context) {
    return Container(
      padding: ResponsiveConstants.getMediumPadding(context),
      decoration: ResponsiveConstants.getResponsiveCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsive_widgets.ResponsiveText.headline(
            'عينات المسافات',
            baseStyle: const TextStyle(color: AppColors.primaryGreen),
          ),
          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),
          
          _buildSpacingDemo('مسافة صغيرة', ResponsiveConstants.getSmallSpacing(context)),
          _buildSpacingDemo('مسافة متوسطة', ResponsiveConstants.getMediumSpacing(context)),
          _buildSpacingDemo('مسافة كبيرة', ResponsiveConstants.getLargeSpacing(context)),
        ],
      ),
    );
  }

  Widget _buildSpacingDemo(String label, double spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          height: spacing,
          width: 100,
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
        Text('${spacing.toInt()}px'),
        const SizedBox(height: 16),
      ],
    );
  }
}
