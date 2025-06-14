import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/models/project_model.dart';

/// صفحة التبرع
/// تتيح للمستخدم التبرع للمشاريع بطرق دفع متنوعة
class DonateScreen extends StatefulWidget {
  final String projectId;

  const DonateScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen>
    with TickerProviderStateMixin {
  ProjectModel? _project;
  bool _isLoading = true;
  
  // مبلغ التبرع
  double _selectedAmount = 0.0;
  final TextEditingController _customAmountController = TextEditingController();
  
  // طريقة الدفع
  String _selectedPaymentMethod = 'visa';
  
  // بيانات البطاقة
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  
  // بيانات PayPal
  final TextEditingController _paypalEmailController = TextEditingController();
  
  // رسالة شخصية
  final TextEditingController _messageController = TextEditingController();
  
  // حالة المعالجة
  bool _isProcessing = false;
  
  // الرسوم
  double get _processingFee => _selectedAmount * 0.029; // 2.9%
  double get _totalAmount => _selectedAmount + _processingFee;

  @override
  void initState() {
    super.initState();
    _loadProjectDetails();
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _paypalEmailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('التبرع')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('المشروع غير موجود')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // معلومات المشروع
            _buildProjectInfo(),
            
            // مبلغ التبرع
            _buildAmountSelection(),
            
            // طريقة الدفع
            _buildPaymentMethod(),
            
            // بيانات الدفع
            _buildPaymentDetails(),
            
            // رسالة شخصية
            _buildPersonalMessage(),
            
            // ملخص التبرع
            _buildDonationSummary(),
            
            // مساحة إضافية للأسفل
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('ساهم بالخير'),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            // TODO: مشاركة المشروع
          },
          icon: const Icon(Icons.share),
        ),
      ],
    );
  }

  Widget _buildProjectInfo() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Text(
            _project!.basic.title,
            style: AppTextStyles.headlineSmall,
          ),
          
          const SizedBox(height: AppConstants.spacingSmall),
          
          // الموقع
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.helperGray),
              const SizedBox(width: 4),
              Text(
                '${_project!.location.city} - ${_project!.location.district}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          // شريط التقدم
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  child: LinearProgressIndicator(
                    value: _project!.progressPercentage / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.progressBackground,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressBar),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                '${_project!.progressPercentage.toStringAsFixed(1)}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingSmall),
          
          // المبالغ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تم جمع: \$${_project!.financial.currentAmount.toStringAsFixed(0)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'الهدف: \$${_project!.financial.targetAmount.toStringAsFixed(0)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSelection() {
    final suggestedAmounts = [10.0, 25.0, 50.0, 100.0, 250.0, 500.0];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                'كم بدك تساهم؟',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingSmall),
          
          Text(
            'كل مساهمة، مهما كانت صغيرة، بتفرق كتير! 💝',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // المبالغ المقترحة
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: AppConstants.spacingSmall,
              mainAxisSpacing: AppConstants.spacingSmall,
            ),
            itemCount: suggestedAmounts.length,
            itemBuilder: (context, index) {
              final amount = suggestedAmounts[index];
              final isSelected = _selectedAmount == amount;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAmount = amount;
                    _customAmountController.clear();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : AppColors.backgroundAccent,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryGreen : AppColors.borderLight,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '\$${amount.toStringAsFixed(0)}',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isSelected ? AppColors.textOnColor : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // مبلغ مخصص
          Text(
            'أو أدخل مبلغ مخصص:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingSmall),
          
          TextField(
            controller: _customAmountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: 'أدخل المبلغ بالدولار',
              prefixIcon: const Icon(Icons.attach_money),
              suffixText: 'USD',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _selectedAmount = double.tryParse(value) ?? 0.0;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              const Icon(Icons.payment, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                'طريقة الدفع',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingLarge),
          
          // خيارات الدفع
          _buildPaymentOption(
            'visa',
            'بطاقة ائتمان (Visa/Mastercard)',
            Icons.credit_card,
            'آمن ومضمون 🔒',
          ),
          
          const SizedBox(height: AppConstants.spacingMedium),
          
          _buildPaymentOption(
            'paypal',
            'PayPal',
            Icons.account_balance_wallet,
            'سريع وسهل 💙',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon, String subtitle) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.1) : AppColors.backgroundAccent,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderLight,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : AppColors.helperGray,
              size: 24,
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    if (_selectedPaymentMethod == 'visa') {
      return _buildCreditCardForm();
    } else if (_selectedPaymentMethod == 'paypal') {
      return _buildPayPalForm();
    }
    return const SizedBox.shrink();
  }

  Widget _buildCreditCardForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              const Icon(Icons.credit_card, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                'بيانات البطاقة',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // رقم البطاقة
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
            ],
            decoration: const InputDecoration(
              labelText: 'رقم البطاقة',
              hintText: '1234 5678 9012 3456',
              prefixIcon: Icon(Icons.credit_card),
            ),
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          // اسم حامل البطاقة
          TextField(
            controller: _cardHolderController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'اسم حامل البطاقة',
              hintText: 'كما هو مكتوب على البطاقة',
              prefixIcon: Icon(Icons.person),
            ),
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          // تاريخ الانتهاء و CVV
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الانتهاء',
                    hintText: 'MM/YY',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          // رسالة الأمان
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: AppColors.success, size: 20),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: Text(
                    'بياناتك محمية بتشفير SSL 256-bit 🔒',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: AppColors.info, size: 24),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                'PayPal',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          Text(
            'رح يتم توجيهك لموقع PayPal لإتمام الدفع بشكل آمن',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // إيميل PayPal (اختياري)
          TextField(
            controller: _paypalEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'إيميل PayPal (اختياري)',
              hintText: 'example@email.com',
              prefixIcon: Icon(Icons.email),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalMessage() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              const Icon(Icons.message, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                'رسالة دعم (اختياري)',
                style: AppTextStyles.headlineSmall,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingSmall),

          Text(
            'شاركنا كلمة تشجيع أو دعاء للمشروع 💝',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          TextField(
            controller: _messageController,
            maxLines: 3,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: 'مثال: الله يعطيكم العافية ويبارك فيكم...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationSummary() {
    if (_selectedAmount <= 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              const Icon(Icons.receipt, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                'ملخص التبرع',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // تفاصيل المبلغ
          _buildSummaryRow('مبلغ التبرع:', '\$${_selectedAmount.toStringAsFixed(2)}'),
          _buildSummaryRow('رسوم المعالجة:', '\$${_processingFee.toStringAsFixed(2)}'),

          const Divider(height: AppConstants.spacingLarge),

          _buildSummaryRow(
            'المجموع الكلي:',
            '\$${_totalAmount.toStringAsFixed(2)}',
            isTotal: true,
          ),

          const SizedBox(height: AppConstants.spacingMedium),

          // رسالة تشجيعية
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.secondaryBeige.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: Text(
                    'مساهمتك رح تساعد في تحقيق حلم جميل! 🌟',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyles.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.numberLarge.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  )
                : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final canDonate = _selectedAmount > 0 && _isValidPaymentData();

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
      child: SafeArea(
        child: NawaButton.primary(
          text: _isProcessing
              ? 'جاري المعالجة...'
              : 'ساهم بـ \$${_totalAmount.toStringAsFixed(2)}',
          icon: _isProcessing ? null : Icons.favorite,
          onPressed: canDonate && !_isProcessing ? _handleDonate : null,
          isLoading: _isProcessing,
        ),
      ),
    );
  }

  // ========== معالجات الأحداث ==========

  Future<void> _loadProjectDetails() async {
    // محاكاة تحميل البيانات
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _project = _generateSampleProject();
      _isLoading = false;
    });
  }

  bool _isValidPaymentData() {
    if (_selectedPaymentMethod == 'visa') {
      return _cardNumberController.text.isNotEmpty &&
             _cardHolderController.text.isNotEmpty &&
             _expiryController.text.isNotEmpty &&
             _cvvController.text.isNotEmpty;
    } else if (_selectedPaymentMethod == 'paypal') {
      return true; // PayPal doesn't require pre-validation
    }
    return false;
  }

  Future<void> _handleDonate() async {
    setState(() => _isProcessing = true);

    try {
      // محاكاة معالجة الدفع
      await Future.delayed(const Duration(seconds: 3));

      // إظهار رسالة نجاح
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في معالجة التبرع. يرجى المحاولة مرة أخرى.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة النجاح
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 50,
              ),
            ),

            const SizedBox(height: AppConstants.spacingLarge),

            // رسالة الشكر
            Text(
              'شكراً لك من كل قلبنا! 💝',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.primaryGreen,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            Text(
              'تم استلام تبرعك بمبلغ \$${_totalAmount.toStringAsFixed(2)} بنجاح',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingSmall),

            Text(
              'الله يجزيك خير ويبارك فيك! مساهمتك رح تفرق كتير في حياة الناس 🌟',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacingLarge),

            // معرف المعاملة
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              decoration: BoxDecoration(
                color: AppColors.backgroundAccent,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    'رقم المعاملة:',
                    style: AppTextStyles.labelMedium,
                  ),
                  Text(
                    'TXN${DateTime.now().millisecondsSinceEpoch}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          NawaButton.primary(
            text: 'العودة للرئيسية',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  // ========== البيانات التجريبية ==========

  ProjectModel _generateSampleProject() {
    return ProjectModel(
      projectId: widget.projectId,
      basic: const ProjectBasic(
        title: 'ترميم مدرسة الأمل في حي الصالحين',
        description: 'مشروع شامل لترميم وتأهيل مدرسة الأمل',
        category: 'education',
        status: 'active',
        priority: 'high',
        tags: ['school', 'renovation', 'children'],
      ),
      location: ProjectLocation(
        city: 'حلب',
        district: 'الصالحين',
        address: 'شارع المدرسة، بناء رقم 15',
        coordinates: GeoCoordinates(lat: 36.2021, lng: 37.1343),
      ),
      financial: const ProjectFinancial(
        targetAmount: 5000.0,
        currentAmount: 3250.0,
        currency: 'USD',
        breakdown: ProjectBreakdown(
          materials: 3000.0,
          labor: 1500.0,
          other: 500.0,
        ),
      ),
      timeline: ProjectTimeline(
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        expectedEndDate: DateTime.now().add(const Duration(days: 45)),
      ),
      creator: const ProjectCreator(
        uid: 'creator1',
        name: 'أبو محمد الحلبي',
        role: 'مدير المدرسة',
        contact: '+963912345678',
      ),
      media: const ProjectMedia(
        mainImage: 'https://via.placeholder.com/400x300',
        gallery: [],
        documents: [],
      ),
      engagement: const ProjectEngagement(
        supporters: 42,
        likes: 89,
        comments: 23,
        shares: 15,
        views: 456,
      ),
      verification: ProjectVerification(
        status: 'verified',
        verifiedBy: 'admin1',
        verificationDate: DateTime.now().subtract(const Duration(days: 12)),
        documents: [],
      ),
    );
  }
}
