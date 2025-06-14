import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// صفحة الشروط والأحكام
class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 100) {
      if (!_hasScrolledToBottom) {
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    }
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
      title: const Text('الشروط والأحكام'),
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
            '1. التعريفات',
            _getDefinitionsContent(),
          ),
          
          _buildSection(
            '2. قبول الشروط',
            _getAcceptanceContent(),
          ),
          
          _buildSection(
            '3. استخدام التطبيق',
            _getUsageContent(),
          ),
          
          _buildSection(
            '4. التبرعات والمدفوعات',
            _getDonationsContent(),
          ),
          
          _buildSection(
            '5. المشاريع والمحتوى',
            _getProjectsContent(),
          ),
          
          _buildSection(
            '6. الخصوصية وحماية البيانات',
            _getPrivacyContent(),
          ),
          
          _buildSection(
            '7. المسؤوليات والالتزامات',
            _getResponsibilitiesContent(),
          ),
          
          _buildSection(
            '8. الملكية الفكرية',
            _getIntellectualPropertyContent(),
          ),
          
          _buildSection(
            '9. إنهاء الخدمة',
            _getTerminationContent(),
          ),
          
          _buildSection(
            '10. القانون المطبق وحل النزاعات',
            _getLegalContent(),
          ),
          
          _buildSection(
            '11. التعديلات على الشروط',
            _getModificationsContent(),
          ),
          
          _buildSection(
            '12. معلومات الاتصال',
            _getContactContent(),
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
            AppColors.primaryGreen.withValues(alpha: 0.1),
            AppColors.primaryGreen.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: AppColors.primaryGreen, size: 32),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Text(
                  'شروط وأحكام استخدام تطبيق نوى',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            'مرحباً بك في تطبيق نوى. يرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام التطبيق. باستخدامك للتطبيق، فإنك توافق على الالتزام بهذه الشروط.',
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
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
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.bold,
            ),
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
              onPressed: _hasScrolledToBottom ? () => Navigator.pop(context) : null,
              icon: const Icon(Icons.check),
              label: const Text('فهمت وأوافق'),
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

  String _getDefinitionsContent() {
    return '''في هذه الشروط والأحكام:

• "التطبيق" يعني تطبيق نوى لإعادة الإعمار المجتمعي
• "المستخدم" يعني أي شخص يستخدم التطبيق
• "المتبرع" يعني المستخدم الذي يقوم بالتبرع للمشاريع
• "منشئ المشروع" يعني المستخدم الذي ينشئ مشروعاً على التطبيق
• "المحتوى" يعني أي نص أو صورة أو فيديو أو بيانات أخرى
• "الخدمات" تعني جميع الخدمات المقدمة من خلال التطبيق''';
  }

  String _getAcceptanceContent() {
    return '''باستخدامك لتطبيق نوى، فإنك:

• تؤكد أنك تبلغ من العمر 18 عاماً على الأقل أو لديك موافقة ولي الأمر
• توافق على الالتزام بجميع الشروط والأحكام المذكورة هنا
• تتعهد بعدم استخدام التطبيق لأي أغراض غير قانونية
• تقر بأنك قرأت وفهمت سياسة الخصوصية الخاصة بنا

إذا كنت لا توافق على هذه الشروط، يرجى عدم استخدام التطبيق.''';
  }

  String _getUsageContent() {
    return '''يحق لك استخدام التطبيق للأغراض التالية:

• تصفح ومراجعة المشاريع المتاحة
• التبرع للمشاريع التي تختارها
• إنشاء ونشر مشاريع جديدة (بعد المراجعة)
• التفاعل مع المحتوى بطريقة إيجابية

يُمنع عليك:
• استخدام التطبيق لأي أغراض احتيالية أو مضللة
• نشر محتوى مسيء أو غير لائق
• محاولة اختراق أو إلحاق الضرر بالتطبيق
• انتهاك حقوق المستخدمين الآخرين''';
  }

  String _getDonationsContent() {
    return '''بخصوص التبرعات والمدفوعات:

• جميع التبرعات نهائية ولا يمكن استردادها إلا في ظروف استثنائية
• نحن نتقاضى رسوماً إدارية بسيطة لتغطية تكاليف التشغيل
• جميع المعاملات المالية آمنة ومشفرة
• ستحصل على إيصال إلكتروني لكل تبرع
• يحق لك تتبع استخدام تبرعك من خلال التطبيق
• في حالة عدم اكتمال المشروع، سيتم إعادة توجيه التبرعات لمشاريع مشابهة أو إرجاعها''';
  }

  String _getProjectsContent() {
    return '''بخصوص المشاريع والمحتوى:

• جميع المشاريع تخضع لمراجعة دقيقة قبل النشر
• منشئو المشاريع مسؤولون عن دقة المعلومات المقدمة
• نحتفظ بالحق في رفض أو إزالة أي مشروع لا يتوافق مع معاييرنا
• يجب أن تكون جميع المشاريع لأغراض خيرية أو تنموية مشروعة
• المحتوى المنشور يجب أن يكون أصلياً أو مرخصاً للاستخدام
• نحن غير مسؤولين عن النتائج النهائية للمشاريع''';
  }

  String _getPrivacyContent() {
    return '''نحن ملتزمون بحماية خصوصيتك:

• نجمع فقط البيانات الضرورية لتشغيل الخدمة
• لا نشارك بياناتك الشخصية مع أطراف ثالثة دون موافقتك
• نستخدم أحدث تقنيات الأمان لحماية بياناتك
• يمكنك طلب حذف بياناتك في أي وقت
• نحتفظ بسجلات التبرعات للأغراض القانونية والمحاسبية
• لمزيد من التفاصيل، راجع سياسة الخصوصية الكاملة''';
  }

  String _getResponsibilitiesContent() {
    return '''مسؤولياتك كمستخدم:

• تقديم معلومات صحيحة ومحدثة
• الحفاظ على سرية بيانات حسابك
• استخدام التطبيق بطريقة مسؤولة وأخلاقية
• الإبلاغ عن أي مشاكل أو مخالفات
• احترام حقوق المستخدمين الآخرين

مسؤولياتنا:
• توفير خدمة آمنة وموثوقة
• مراجعة المشاريع بعناية
• حماية بياناتك الشخصية
• تقديم الدعم الفني عند الحاجة''';
  }

  String _getIntellectualPropertyContent() {
    return '''حقوق الملكية الفكرية:

• تطبيق نوى وجميع محتوياته محمية بحقوق الطبع والنشر
• لا يحق لك نسخ أو توزيع أو تعديل التطبيق دون إذن
• المحتوى الذي تنشره يبقى ملكك، لكنك تمنحنا ترخيصاً لاستخدامه
• نحترم حقوق الملكية الفكرية للآخرين
• إذا كنت تعتقد أن محتوى ينتهك حقوقك، يرجى التواصل معنا
• استخدام علامتنا التجارية أو شعارنا يتطلب إذناً مسبقاً''';
  }

  String _getTerminationContent() {
    return '''إنهاء الخدمة:

• يمكنك إنهاء حسابك في أي وقت من خلال الإعدادات
• نحتفظ بالحق في تعليق أو إنهاء حسابك في حالة انتهاك الشروط
• عند إنهاء الحساب، ستفقد الوصول لجميع البيانات والمحتوى
• التبرعات السابقة لن تتأثر بإنهاء الحساب
• بعض البيانات قد تبقى محفوظة للأغراض القانونية
• يمكنك طلب حذف جميع بياناتك نهائياً''';
  }

  String _getLegalContent() {
    return '''القانون المطبق وحل النزاعات:

• هذه الشروط تخضع للقانون السوري
• أي نزاع سيتم حله أولاً عبر التفاوض المباشر
• في حالة فشل التفاوض، سيتم اللجوء للتحكيم
• المحاكم السورية لها الاختصاص النهائي
• نسعى لحل جميع المشاكل بطريقة ودية
• يمكنك التواصل مع فريق الدعم لأي استفسارات قانونية''';
  }

  String _getModificationsContent() {
    return '''تعديل الشروط والأحكام:

• نحتفظ بالحق في تعديل هذه الشروط في أي وقت
• سيتم إشعارك بأي تغييرات مهمة عبر التطبيق أو البريد الإلكتروني
• استمرارك في استخدام التطبيق يعني موافقتك على التغييرات
• التغييرات الجوهرية ستتطلب موافقتك الصريحة
• يمكنك مراجعة أحدث نسخة من الشروط في أي وقت
• تاريخ آخر تحديث مذكور في أسفل هذه الصفحة''';
  }

  String _getContactContent() {
    return '''للتواصل معنا:

البريد الإلكتروني: legal@nawa.sy
الهاتف: +963 11 123 4567
العنوان: دمشق، سوريا

أوقات العمل:
الأحد - الخميس: 9:00 ص - 6:00 م
الجمعة - السبت: مغلق

يمكنك أيضاً التواصل معنا من خلال:
• قسم الدعم الفني في التطبيق
• صفحاتنا على وسائل التواصل الاجتماعي
• نموذج الاتصال على موقعنا الإلكتروني''';
  }
}
