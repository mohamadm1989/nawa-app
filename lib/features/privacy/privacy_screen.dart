import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// صفحة سياسة الخصوصية
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      title: const Text('سياسة الخصوصية'),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // مقدمة
          _buildIntroduction(),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // الأقسام
          _buildSection(
            '1. المعلومات التي نجمعها',
            _getDataCollectionContent(),
            Icons.data_usage,
          ),
          
          _buildSection(
            '2. كيف نستخدم معلوماتك',
            _getDataUsageContent(),
            Icons.settings,
          ),
          
          _buildSection(
            '3. مشاركة المعلومات',
            _getDataSharingContent(),
            Icons.share,
          ),
          
          _buildSection(
            '4. أمان البيانات',
            _getDataSecurityContent(),
            Icons.security,
          ),
          
          _buildSection(
            '5. حقوقك في البيانات',
            _getDataRightsContent(),
            Icons.account_circle,
          ),
          
          _buildSection(
            '6. ملفات تعريف الارتباط',
            _getCookiesContent(),
            Icons.cookie,
          ),
          
          _buildSection(
            '7. خدمات الطرف الثالث',
            _getThirdPartyContent(),
            Icons.extension,
          ),
          
          _buildSection(
            '8. حماية الأطفال',
            _getChildrenProtectionContent(),
            Icons.child_care,
          ),
          
          _buildSection(
            '9. التغييرات على السياسة',
            _getPolicyChangesContent(),
            Icons.update,
          ),
          
          _buildSection(
            '10. التواصل معنا',
            _getContactContent(),
            Icons.contact_support,
          ),
          
          const SizedBox(height: AppConstants.spacingXLarge),
          
          // تاريخ آخر تحديث
          _buildLastUpdated(),
        ],
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip, color: Colors.blue, size: 32),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Text(
                  'سياسة الخصوصية',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'نحن في تطبيق نوى نقدر خصوصيتك ونلتزم بحماية معلوماتك الشخصية. هذه السياسة توضح كيف نجمع ونستخدم ونحمي بياناتك.',
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingLarge),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.update, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: AppConstants.spacingSmall),
          Text(
            'آخر تحديث: 15 ديسمبر 2024',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/support'),
              icon: const Icon(Icons.help),
              label: const Text('أسئلة؟'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGreen,
                side: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: const Text('فهمت'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== محتوى الأقسام ==========

  String _getDataCollectionContent() {
    return '''نجمع الأنواع التالية من المعلومات:

المعلومات الشخصية:
• الاسم الكامل
• عنوان البريد الإلكتروني
• رقم الهاتف
• تاريخ الميلاد
• الصورة الشخصية (اختيارية)

معلومات التبرعات:
• تاريخ ومبلغ التبرعات
• طريقة الدفع المستخدمة
• المشاريع المدعومة

المعلومات التقنية:
• عنوان IP
• نوع الجهاز ونظام التشغيل
• معلومات المتصفح
• سجلات الاستخدام''';
  }

  String _getDataUsageContent() {
    return '''نستخدم معلوماتك للأغراض التالية:

تقديم الخدمة:
• إنشاء وإدارة حسابك
• معالجة التبرعات
• إرسال الإيصالات والتأكيدات
• تقديم الدعم الفني

التحسين والتطوير:
• تحليل استخدام التطبيق
• تحسين الأداء والوظائف
• تطوير ميزات جديدة

التواصل:
• إرسال التحديثات المهمة
• الإشعارات حول المشاريع
• النشرات الإخبارية (بموافقتك)''';
  }

  String _getDataSharingContent() {
    return '''لا نبيع أو نؤجر معلوماتك الشخصية. قد نشارك معلوماتك في الحالات التالية:

مع منشئي المشاريع:
• اسمك (إذا اخترت عدم إخفاء هويتك)
• مبلغ التبرع
• رسائل الدعم (إن وجدت)

مع مقدمي الخدمات:
• معالجات الدفع (بيانات مشفرة فقط)
• خدمات الاستضافة والتخزين
• أدوات التحليل (بيانات مجهولة الهوية)

للأغراض القانونية:
• عند طلب السلطات المختصة
• لحماية حقوقنا أو حقوق الآخرين
• في حالات الطوارئ''';
  }

  String _getDataSecurityContent() {
    return '''نتخذ إجراءات أمنية صارمة لحماية بياناتك:

التشفير:
• جميع البيانات الحساسة مشفرة
• اتصالات آمنة (HTTPS/SSL)
• تشفير قواعد البيانات

الوصول المحدود:
• وصول الموظفين محدود حسب الحاجة
• مراجعة دورية للصلاحيات
• تسجيل جميع عمليات الوصول

النسخ الاحتياطية:
• نسخ احتياطية منتظمة
• تخزين آمن في مواقع متعددة
• اختبار دوري لاستعادة البيانات

مراقبة الأمان:
• مراقبة مستمرة للتهديدات
• تحديثات أمنية منتظمة
• فريق أمان متخصص''';
  }

  String _getDataRightsContent() {
    return '''لديك الحقوق التالية بخصوص بياناتك:

الوصول:
• طلب نسخة من بياناتك الشخصية
• معرفة كيف نستخدم معلوماتك
• الحصول على تقرير مفصل

التصحيح:
• تحديث المعلومات غير الصحيحة
• إضافة معلومات ناقصة
• تصحيح الأخطاء

الحذف:
• طلب حذف حسابك
• إزالة بيانات معينة
• "الحق في النسيان"

التحكم:
• إيقاف الإشعارات
• تحديد مستوى الخصوصية
• سحب الموافقات المعطاة

النقل:
• تصدير بياناتك
• نقلها لخدمة أخرى
• الحصول على نسخة قابلة للقراءة''';
  }

  String _getCookiesContent() {
    return '''نستخدم ملفات تعريف الارتباط وتقنيات مشابهة:

الأنواع المستخدمة:
• ملفات أساسية (ضرورية للتشغيل)
• ملفات الأداء (لتحسين الخدمة)
• ملفات التفضيلات (لحفظ إعداداتك)

الأغراض:
• تذكر تسجيل دخولك
• حفظ تفضيلاتك
• تحليل الاستخدام
• تحسين الأداء

التحكم:
• يمكنك إدارة ملفات الكوكيز من إعدادات المتصفح
• بعض الملفات ضرورية لعمل التطبيق
• يمكنك رفض ملفات التتبع الاختيارية''';
  }

  String _getThirdPartyContent() {
    return '''نتعامل مع خدمات طرف ثالث موثوقة:

معالجات الدفع:
• Stripe للبطاقات الائتمانية
• PayPal للمحافظ الرقمية
• بوابات دفع محلية

الخدمات السحابية:
• Amazon Web Services للاستضافة
• Google Cloud للتخزين
• Microsoft Azure للنسخ الاحتياطية

أدوات التحليل:
• Google Analytics (بيانات مجهولة)
• Firebase للإحصائيات
• أدوات مراقبة الأداء

جميع هؤلاء الشركاء:
• يلتزمون بمعايير الخصوصية الصارمة
• يوقعون اتفاقيات حماية البيانات
• يخضعون لمراجعات دورية''';
  }

  String _getChildrenProtectionContent() {
    return '''نحن ملتزمون بحماية خصوصية الأطفال:

العمر المطلوب:
• التطبيق مخصص للأشخاص 18 عاماً فما فوق
• المستخدمون الأصغر سناً يحتاجون موافقة ولي الأمر
• نتحقق من العمر عند التسجيل

حماية إضافية:
• لا نجمع بيانات من الأطفال عمداً
• إذا اكتشفنا بيانات طفل، نحذفها فوراً
• نطلب من الأهل مراقبة استخدام أطفالهم

التبليغ:
• إذا كنت تعتقد أن طفلاً استخدم التطبيق بدون إذن
• تواصل معنا فوراً
• سنتخذ الإجراءات اللازمة''';
  }

  String _getPolicyChangesContent() {
    return '''قد نحدث هذه السياسة من وقت لآخر:

الإشعار بالتغييرات:
• سنرسل إشعاراً عبر التطبيق
• رسالة بريد إلكتروني للتغييرات المهمة
• إشعار في الصفحة الرئيسية

أنواع التغييرات:
• تحديثات قانونية
• ميزات جديدة
• تحسينات الأمان
• توضيحات إضافية

موافقتك:
• التغييرات البسيطة تسري تلقائياً
• التغييرات الجوهرية تتطلب موافقتك
• يمكنك رفض التغييرات وإنهاء حسابك

الأرشيف:
• نحتفظ بنسخ من السياسات السابقة
• يمكنك مراجعة التغييرات
• تواريخ التحديث مسجلة''';
  }

  String _getContactContent() {
    return '''للاستفسارات حول الخصوصية:

فريق الخصوصية:
البريد الإلكتروني: privacy@nawa.sy
الهاتف: +963 11 123 4567
العنوان: دمشق، سوريا

أوقات الاستجابة:
• الاستفسارات العامة: خلال 48 ساعة
• طلبات البيانات: خلال 30 يوماً
• الحالات العاجلة: خلال 24 ساعة

طرق أخرى للتواصل:
• نموذج الاتصال في التطبيق
• قسم الدعم الفني
• البريد المسجل للمسائل القانونية

نحن هنا لمساعدتك في فهم وممارسة حقوقك في الخصوصية.''';
  }
}
