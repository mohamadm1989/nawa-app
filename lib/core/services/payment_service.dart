import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// خدمة الدفع المتكاملة
class PaymentService {
  static PaymentService? _instance;
  static PaymentService get instance {
    _instance ??= PaymentService._();
    return _instance!;
  }

  PaymentService._();

  // إعدادات Stripe
  static const String _stripePublishableKey = 'pk_test_your_publishable_key_here';
  static const String _stripeSecretKey = 'sk_test_your_secret_key_here';
  static const String _merchantId = 'merchant.com.nawa.app';

  // إعدادات Apple Pay
  final List<PaymentItem> _applePayItems = [];
  
  // إعدادات Google Pay
  final List<PaymentItem> _googlePayItems = [];

  /// تهيئة خدمة الدفع
  Future<void> initialize() async {
    try {
      // تهيئة Stripe
      Stripe.publishableKey = _stripePublishableKey;
      Stripe.merchantIdentifier = _merchantId;
      
      await Stripe.instance.applySettings();
      
      debugPrint('✅ تم تهيئة خدمة الدفع بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الدفع: $e');
      throw Exception('فشل في تهيئة خدمة الدفع');
    }
  }

  /// معالجة الدفع بالبطاقة الائتمانية
  Future<PaymentResult> processCardPayment({
    required double amount,
    required String currency,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      debugPrint('💳 بدء عملية الدفع بالبطاقة: $amount $currency');

      // إنشاء Payment Intent
      final paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        description: description,
        metadata: metadata,
      );

      if (paymentIntent == null) {
        throw Exception('فشل في إنشاء Payment Intent');
      }

      // تأكيد الدفع
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        data: const PaymentMethodData.card(
          CardFieldInputDetails(),
        ),
      );

      debugPrint('✅ تم الدفع بنجاح');
      
      return PaymentResult.success(
        transactionId: paymentIntent['id'],
        amount: amount,
        currency: currency,
        paymentMethod: PaymentMethod.card,
      );

    } on StripeException catch (e) {
      debugPrint('❌ خطأ Stripe: ${e.error.message}');
      return PaymentResult.failure(
        error: e.error.message ?? 'فشل في عملية الدفع',
        errorCode: e.error.code,
      );
    } catch (e) {
      debugPrint('❌ خطأ عام في الدفع: $e');
      return PaymentResult.failure(error: 'فشل في عملية الدفع: $e');
    }
  }

  /// معالجة الدفع بـ Apple Pay
  Future<PaymentResult> processApplePay({
    required double amount,
    required String currency,
    required String description,
    required List<PaymentItem> items,
  }) async {
    try {
      debugPrint('🍎 بدء عملية الدفع بـ Apple Pay: $amount $currency');

      // التحقق من توفر Apple Pay
      if (!await Pay.isApplePaySupported()) {
        throw Exception('Apple Pay غير مدعوم على هذا الجهاز');
      }

      // إعداد عناصر الدفع
      final paymentItems = items.isNotEmpty ? items : [
        PaymentItem(
          label: description,
          amount: amount.toString(),
          status: PaymentItemStatus.final_price,
        ),
      ];

      // إنشاء Payment Intent
      final paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        description: description,
      );

      if (paymentIntent == null) {
        throw Exception('فشل في إنشاء Payment Intent');
      }

      // معالجة الدفع
      final result = await Pay.showPaymentSelector(
        PayProvider.apple_pay,
        paymentItems,
      );

      // تأكيد الدفع مع Stripe
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        data: PaymentMethodData.applePay(
          ApplePayPaymentMethodData(
            paymentData: result,
          ),
        ),
      );

      debugPrint('✅ تم الدفع بـ Apple Pay بنجاح');
      
      return PaymentResult.success(
        transactionId: paymentIntent['id'],
        amount: amount,
        currency: currency,
        paymentMethod: PaymentMethod.applePay,
      );

    } catch (e) {
      debugPrint('❌ خطأ في Apple Pay: $e');
      return PaymentResult.failure(error: 'فشل في الدفع بـ Apple Pay: $e');
    }
  }

  /// معالجة الدفع بـ Google Pay
  Future<PaymentResult> processGooglePay({
    required double amount,
    required String currency,
    required String description,
    required List<PaymentItem> items,
  }) async {
    try {
      debugPrint('🤖 بدء عملية الدفع بـ Google Pay: $amount $currency');

      // التحقق من توفر Google Pay
      if (!await Pay.isGooglePaySupported()) {
        throw Exception('Google Pay غير مدعوم على هذا الجهاز');
      }

      // إعداد عناصر الدفع
      final paymentItems = items.isNotEmpty ? items : [
        PaymentItem(
          label: description,
          amount: amount.toString(),
          status: PaymentItemStatus.final_price,
        ),
      ];

      // إنشاء Payment Intent
      final paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        description: description,
      );

      if (paymentIntent == null) {
        throw Exception('فشل في إنشاء Payment Intent');
      }

      // معالجة الدفع
      final result = await Pay.showPaymentSelector(
        PayProvider.google_pay,
        paymentItems,
      );

      // تأكيد الدفع مع Stripe
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntent['client_secret'],
        data: PaymentMethodData.googlePay(
          GooglePayPaymentMethodData(
            paymentData: result,
          ),
        ),
      );

      debugPrint('✅ تم الدفع بـ Google Pay بنجاح');
      
      return PaymentResult.success(
        transactionId: paymentIntent['id'],
        amount: amount,
        currency: currency,
        paymentMethod: PaymentMethod.googlePay,
      );

    } catch (e) {
      debugPrint('❌ خطأ في Google Pay: $e');
      return PaymentResult.failure(error: 'فشل في الدفع بـ Google Pay: $e');
    }
  }

  /// إنشاء Payment Intent
  Future<Map<String, dynamic>?> _createPaymentIntent({
    required double amount,
    required String currency,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // تحويل المبلغ إلى أصغر وحدة (cents)
      final int amountInCents = (amount * 100).round();

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': currency.toLowerCase(),
          'description': description,
          if (metadata != null) ...metadata.map((k, v) => MapEntry('metadata[$k]', v.toString())),
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('❌ خطأ في إنشاء Payment Intent: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ خطأ في إنشاء Payment Intent: $e');
      return null;
    }
  }

  /// التحقق من حالة الدفع
  Future<PaymentStatus> checkPaymentStatus(String paymentIntentId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String;

        switch (status) {
          case 'succeeded':
            return PaymentStatus.succeeded;
          case 'processing':
            return PaymentStatus.processing;
          case 'requires_payment_method':
            return PaymentStatus.requiresPaymentMethod;
          case 'requires_confirmation':
            return PaymentStatus.requiresConfirmation;
          case 'requires_action':
            return PaymentStatus.requiresAction;
          case 'canceled':
            return PaymentStatus.canceled;
          case 'requires_capture':
            return PaymentStatus.requiresCapture;
          default:
            return PaymentStatus.unknown;
        }
      } else {
        debugPrint('❌ خطأ في التحقق من حالة الدفع: ${response.body}');
        return PaymentStatus.unknown;
      }
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من حالة الدفع: $e');
      return PaymentStatus.unknown;
    }
  }

  /// استرداد الدفع
  Future<bool> refundPayment({
    required String paymentIntentId,
    double? amount,
    String? reason,
  }) async {
    try {
      debugPrint('💰 بدء عملية الاسترداد للدفع: $paymentIntentId');

      final body = <String, String>{
        'payment_intent': paymentIntentId,
        if (amount != null) 'amount': (amount * 100).round().toString(),
        if (reason != null) 'reason': reason,
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/refunds'),
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint('✅ تم الاسترداد بنجاح');
        return true;
      } else {
        debugPrint('❌ خطأ في الاسترداد: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ خطأ في عملية الاسترداد: $e');
      return false;
    }
  }

  /// التحقق من دعم طرق الدفع
  Future<PaymentSupport> checkPaymentSupport() async {
    final applePaySupported = await Pay.isApplePaySupported();
    final googlePaySupported = await Pay.isGooglePaySupported();

    return PaymentSupport(
      applePay: applePaySupported,
      googlePay: googlePaySupported,
      card: true, // البطاقات مدعومة دائماً
    );
  }

  /// تنظيف الموارد
  void dispose() {
    // تنظيف أي موارد إضافية
  }
}

/// نتيجة عملية الدفع
class PaymentResult {
  final bool success;
  final String? transactionId;
  final double? amount;
  final String? currency;
  final PaymentMethod? paymentMethod;
  final String? error;
  final String? errorCode;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.amount,
    this.currency,
    this.paymentMethod,
    this.error,
    this.errorCode,
  });

  factory PaymentResult.success({
    required String transactionId,
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) {
    return PaymentResult(
      success: true,
      transactionId: transactionId,
      amount: amount,
      currency: currency,
      paymentMethod: paymentMethod,
    );
  }

  factory PaymentResult.failure({
    required String error,
    String? errorCode,
  }) {
    return PaymentResult(
      success: false,
      error: error,
      errorCode: errorCode,
    );
  }
}

/// طرق الدفع المدعومة
enum PaymentMethod {
  card,
  applePay,
  googlePay,
}

/// حالة الدفع
enum PaymentStatus {
  succeeded,
  processing,
  requiresPaymentMethod,
  requiresConfirmation,
  requiresAction,
  canceled,
  requiresCapture,
  unknown,
}

/// دعم طرق الدفع
class PaymentSupport {
  final bool applePay;
  final bool googlePay;
  final bool card;

  PaymentSupport({
    required this.applePay,
    required this.googlePay,
    required this.card,
  });
}
