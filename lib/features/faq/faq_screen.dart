import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

/// صفحة الأسئلة الشائعة
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _allFAQs = [];
  List<FAQItem> _filteredFAQs = [];
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'عام',
    'التبرعات',
    'المشاريع',
    'الحساب',
    'التقنية',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFAQs();
    _filteredFAQs = _allFAQs;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeFAQs() {
    _allFAQs = [
      // أسئلة عامة
      FAQItem(
        category: 'عام',
        question: 'ما هو تطبيق نوى؟',
        answer: 'نوى هو تطبيق سوري مخصص لإعادة الإعمار المجتمعي، يربط بين المتبرعين والمشاريع التنموية في سوريا بطريقة شفافة وموثوقة.',
      ),
      FAQItem(
        category: 'عام',
        question: 'كيف يمكنني التسجيل في التطبيق؟',
        answer: 'يمكنك التسجيل عبر البريد الإلكتروني أو رقم الهاتف أو حساب Google. اتبع الخطوات في صفحة التسجيل وأكمل التحقق من هويتك.',
      ),
      FAQItem(
        category: 'عام',
        question: 'هل التطبيق مجاني؟',
        answer: 'نعم، تطبيق نوى مجاني تماماً للاستخدام. لا توجد رسوم على التسجيل أو تصفح المشاريع.',
      ),

      // أسئلة التبرعات
      FAQItem(
        category: 'التبرعات',
        question: 'ما هي طرق الدفع المتاحة؟',
        answer: 'نقبل الدفع عبر البطاقات الائتمانية (Visa, Mastercard)، PayPal، والتحويل البنكي. جميع المعاملات آمنة ومشفرة.',
      ),
      FAQItem(
        category: 'التبرعات',
        question: 'هل يمكنني استرداد تبرعي؟',
        answer: 'يمكن استرداد التبرع خلال 24 ساعة من التبرع إذا لم يتم تحويل المبلغ للمشروع بعد. بعد ذلك، يصبح الاسترداد صعباً.',
      ),
      FAQItem(
        category: 'التبرعات',
        question: 'كيف أتأكد من وصول تبرعي للمستفيدين؟',
        answer: 'نوفر نظام تتبع شامل يتيح لك متابعة تقدم المشروع وتأثير تبرعك من خلال التقارير والصور والفيديوهات.',
      ),
      FAQItem(
        category: 'التبرعات',
        question: 'هل أحصل على إيصال للتبرع؟',
        answer: 'نعم، ستحصل على إيصال إلكتروني فوري بعد كل تبرع، ويمكنك تحميله من قسم "تبرعاتي" في التطبيق.',
      ),

      // أسئلة المشاريع
      FAQItem(
        category: 'المشاريع',
        question: 'كيف يتم اختيار المشاريع؟',
        answer: 'جميع المشاريع تخضع لعملية مراجعة دقيقة من فريقنا المختص، بالإضافة إلى التصويت المجتمعي لضمان الشفافية والمصداقية.',
      ),
      FAQItem(
        category: 'المشاريع',
        question: 'كيف يمكنني إضافة مشروع جديد؟',
        answer: 'يمكنك إضافة مشروع من خلال قسم "إضافة مشروع" في التطبيق. ستحتاج لتقديم تفاصيل كاملة ومستندات داعمة للمراجعة.',
      ),
      FAQItem(
        category: 'المشاريع',
        question: 'ماذا يحدث إذا لم يصل المشروع لهدفه المالي؟',
        answer: 'إذا لم يصل المشروع لـ 30% من هدفه خلال المدة المحددة، سيتم إرجاع التبرعات للمتبرعين أو تحويلها لمشاريع مشابهة بموافقتهم.',
      ),

      // أسئلة الحساب
      FAQItem(
        category: 'الحساب',
        question: 'كيف يمكنني تغيير كلمة المرور؟',
        answer: 'اذهب إلى الإعدادات > إعدادات الحساب > تغيير كلمة المرور، أو استخدم خيار "نسيت كلمة المرور" في صفحة تسجيل الدخول.',
      ),
      FAQItem(
        category: 'الحساب',
        question: 'كيف يمكنني حذف حسابي؟',
        answer: 'يمكنك حذف حسابك من الإعدادات > الخصوصية والأمان > حذف الحساب. تذكر أن هذا الإجراء لا يمكن التراجع عنه.',
      ),
      FAQItem(
        category: 'الحساب',
        question: 'هل يمكنني تغيير رقم الهاتف المرتبط بحسابي؟',
        answer: 'نعم، يمكنك تحديث رقم الهاتف من الإعدادات > إعدادات الحساب > تحديث رقم الهاتف. ستحتاج للتحقق من الرقم الجديد.',
      ),

      // أسئلة تقنية
      FAQItem(
        category: 'التقنية',
        question: 'التطبيق لا يعمل بشكل صحيح، ماذا أفعل؟',
        answer: 'جرب إعادة تشغيل التطبيق أولاً. إذا استمرت المشكلة، تأكد من أن لديك أحدث إصدار من التطبيق واتصال إنترنت مستقر.',
      ),
      FAQItem(
        category: 'التقنية',
        question: 'هل يعمل التطبيق بدون إنترنت؟',
        answer: 'يمكنك تصفح المشاريع المحفوظة مسبقاً بدون إنترنت، لكن التبرع والتحديثات تتطلب اتصال إنترنت.',
      ),
      FAQItem(
        category: 'التقنية',
        question: 'كيف يمكنني تحديث التطبيق؟',
        answer: 'يمكنك تحديث التطبيق من متجر Google Play أو App Store. سنرسل لك إشعاراً عند توفر تحديث جديد.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      title: const Text('الأسئلة الشائعة'),
      elevation: 0,
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // شريط البحث والفلترة
        _buildSearchAndFilter(),
        
        // قائمة الأسئلة
        Expanded(
          child: _buildFAQList(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // شريط البحث
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ابحث في الأسئلة الشائعة...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterFAQs();
                      },
                    )
                  : null,
            ),
            onChanged: (value) => _filterFAQs(),
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // فلتر الفئات
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.only(right: AppConstants.spacingSmall),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterFAQs();
                    },
                    backgroundColor: AppColors.backgroundAccent,
                    selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList() {
    if (_filteredFAQs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      itemCount: _filteredFAQs.length,
      itemBuilder: (context, index) {
        return _buildFAQCard(_filteredFAQs[index]);
      },
    );
  }

  Widget _buildFAQCard(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            faq.category,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            child: Text(
              faq.answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              'لم نجد أسئلة مطابقة لبحثك',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              'جرب كلمات مختلفة أو تصفح الفئات',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/support'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('تواصل مع الدعم الفني'),
            ),
          ],
        ),
      ),
    );
  }

  void _filterFAQs() {
    setState(() {
      _filteredFAQs = _allFAQs.where((faq) {
        final matchesSearch = _searchController.text.isEmpty ||
            faq.question.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            faq.answer.toLowerCase().contains(_searchController.text.toLowerCase());
        
        final matchesCategory = _selectedCategory == 'الكل' ||
            faq.category == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }
}

/// نموذج عنصر الأسئلة الشائعة
class FAQItem {
  final String category;
  final String question;
  final String answer;

  FAQItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}
