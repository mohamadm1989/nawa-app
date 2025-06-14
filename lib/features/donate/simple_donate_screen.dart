import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/mobile_responsive.dart';
import '../../core/animations/celebration_animations.dart';
import '../../shared/widgets/widgets.dart';

/// صفحة تبرع مبسطة للاختبار
class SimpleDonateScreen extends StatefulWidget {
  final String projectId;

  const SimpleDonateScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<SimpleDonateScreen> createState() => _SimpleDonateScreenState();
}

class _SimpleDonateScreenState extends State<SimpleDonateScreen> {
  double _selectedAmount = 0.0;
  String _selectedPaymentMethod = 'visa';
  bool _isProcessing = false;

  final List<double> _suggestedAmounts = [10.0, 25.0, 50.0, 100.0, 250.0, 500.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('ساهم بالخير'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // معلومات المشروع
              _buildProjectInfo(),

              SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.5),

              // اختيار المبلغ
              _buildAmountSelection(),

              SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.5),

              // طريقة الدفع
              _buildPaymentMethod(),

              SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.5),

              // ملخص التبرع
              if (_selectedAmount > 0) _buildSummary(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProjectInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ترميم مدرسة الأمل في حي الصالحين',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'حلب - الصالحين',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تم جمع: \$3,250',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'الهدف: \$5,000',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'كم بدك تساهم؟',
                  style: AppTextStyles.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'كل مساهمة، مهما كانت صغيرة، بتفرق كتير! 💝',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ResponsiveGrid(
              mobileColumns: 2,
              tabletColumns: 3,
              desktopColumns: 3,
              spacing: ResponsiveHelper.getSpacing(context),
              childAspectRatio: ResponsiveHelper.isMobile(context) ? 2.0 : 2.5,
              children: _suggestedAmounts.map((amount) {
                final isSelected = _selectedAmount == amount;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = amount;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: ResponsiveText(
                        '\$${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        mobileFontSize: 14,
                        tabletFontSize: 16,
                        desktopFontSize: 18,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'طريقة الدفع',
                  style: AppTextStyles.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              'visa',
              'بطاقة ائتمان (Visa/Mastercard)',
              Icons.credit_card,
              'آمن ومضمون 🔒',
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'paypal',
              'PayPal',
              Icons.account_balance_wallet,
              'سريع وسهل 💙',
            ),
          ],
        ),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primaryGreen : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryGreen,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final processingFee = _selectedAmount * 0.029;
    final totalAmount = _selectedAmount + processingFee;
    
    return Card(
      color: AppColors.primaryGreen.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'ملخص التبرع',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('مبلغ التبرع:'),
                Text('\$${_selectedAmount.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('رسوم المعالجة:'),
                Text('\$${processingFee.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المجموع الكلي:',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.numberLarge.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondaryBeige.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 8),
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
      ),
    );
  }

  Widget _buildBottomButton() {
    final canDonate = _selectedAmount > 0;
    final totalAmount = _selectedAmount + (_selectedAmount * 0.029);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: NawaButton.primary(
          text: _isProcessing 
              ? 'جاري المعالجة...' 
              : canDonate 
                  ? 'ساهم بـ \$${totalAmount.toStringAsFixed(2)}'
                  : 'اختر مبلغ التبرع',
          icon: _isProcessing ? null : Icons.favorite,
          onPressed: canDonate && !_isProcessing ? _handleDonate : null,
          isLoading: _isProcessing,
        ),
      ),
    );
  }

  Future<void> _handleDonate() async {
    setState(() => _isProcessing = true);

    try {
      // محاكاة معالجة الدفع
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        final totalAmount = _selectedAmount + (_selectedAmount * 0.029);
        CelebrationAnimations.showDonationCelebration(context, totalAmount);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في معالجة التبرع. يرجى المحاولة مرة أخرى.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }


}
