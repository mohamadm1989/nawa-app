import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

/// خدمة التحقق من رقم الهاتف
class PhoneAuthService {
  static PhoneAuthService? _instance;
  static PhoneAuthService get instance {
    _instance ??= PhoneAuthService._();
    return _instance!;
  }

  PhoneAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // معلومات التحقق الحالية
  String? _verificationId;
  int? _resendToken;
  Timer? _timer;
  
  // Stream controllers للحالة
  final StreamController<PhoneAuthState> _stateController = 
      StreamController<PhoneAuthState>.broadcast();
  final StreamController<int> _timerController = 
      StreamController<int>.broadcast();

  // Getters
  Stream<PhoneAuthState> get stateStream => _stateController.stream;
  Stream<int> get timerStream => _timerController.stream;
  String? get verificationId => _verificationId;

  /// إرسال رمز التحقق لرقم الهاتف
  Future<void> sendVerificationCode({
    required String phoneNumber,
    Duration timeout = const Duration(seconds: 60),
    int? forceResendingToken,
  }) async {
    try {
      debugPrint('📱 إرسال رمز التحقق لـ: $phoneNumber');
      
      _stateController.add(PhoneAuthState.codeSending);

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
        timeout: timeout,
        forceResendingToken: forceResendingToken ?? _resendToken,
      );

    } catch (e) {
      debugPrint('❌ خطأ في إرسال رمز التحقق: $e');
      _stateController.add(PhoneAuthState.error);
      throw Exception('فشل في إرسال رمز التحقق: $e');
    }
  }

  /// التحقق من الرمز المدخل
  Future<UserCredential?> verifyCode(String smsCode) async {
    try {
      if (_verificationId == null) {
        throw Exception('لا يوجد معرف تحقق. يرجى إعادة إرسال الرمز');
      }

      debugPrint('🔍 التحقق من الرمز: $smsCode');
      
      _stateController.add(PhoneAuthState.verifying);

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      debugPrint('✅ تم التحقق بنجاح من رقم الهاتف');
      _stateController.add(PhoneAuthState.verified);
      
      _stopTimer();
      return userCredential;

    } on FirebaseAuthException catch (e) {
      debugPrint('❌ خطأ في التحقق: ${e.code} - ${e.message}');
      _stateController.add(PhoneAuthState.error);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      debugPrint('❌ خطأ عام في التحقق: $e');
      _stateController.add(PhoneAuthState.error);
      throw Exception('فشل في التحقق من الرمز: $e');
    }
  }

  /// ربط رقم الهاتف بحساب موجود
  Future<UserCredential?> linkPhoneNumber(String smsCode) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('لا يوجد مستخدم مسجل دخول');
      }

      if (_verificationId == null) {
        throw Exception('لا يوجد معرف تحقق');
      }

      debugPrint('🔗 ربط رقم الهاتف بالحساب الحالي...');

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      final UserCredential userCredential = await currentUser.linkWithCredential(credential);
      
      debugPrint('✅ تم ربط رقم الهاتف بنجاح');
      _stateController.add(PhoneAuthState.verified);
      
      return userCredential;

    } on FirebaseAuthException catch (e) {
      debugPrint('❌ خطأ في ربط رقم الهاتف: ${e.code}');
      _stateController.add(PhoneAuthState.error);
      throw _handleFirebaseAuthException(e);
    }
  }

  /// إعادة إرسال رمز التحقق
  Future<void> resendCode(String phoneNumber) async {
    try {
      debugPrint('🔄 إعادة إرسال رمز التحقق...');
      
      await sendVerificationCode(
        phoneNumber: phoneNumber,
        forceResendingToken: _resendToken,
      );

    } catch (e) {
      debugPrint('❌ خطأ في إعادة الإرسال: $e');
      throw Exception('فشل في إعادة إرسال الرمز: $e');
    }
  }

  /// بدء العد التنازلي
  void startTimer({int seconds = 60}) {
    _stopTimer();
    
    int remainingSeconds = seconds;
    _timerController.add(remainingSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;
      _timerController.add(remainingSeconds);

      if (remainingSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  /// إيقاف العد التنازلي
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// معالجة اكتمال التحقق التلقائي
  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    try {
      debugPrint('✅ تم التحقق التلقائي من رقم الهاتف');
      
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      _stateController.add(PhoneAuthState.verified);
      _stopTimer();
      
      debugPrint('✅ تم تسجيل الدخول تلقائياً');

    } catch (e) {
      debugPrint('❌ خطأ في التحقق التلقائي: $e');
      _stateController.add(PhoneAuthState.error);
    }
  }

  /// معالجة فشل التحقق
  void _onVerificationFailed(FirebaseAuthException e) {
    debugPrint('❌ فشل التحقق: ${e.code} - ${e.message}');
    _stateController.add(PhoneAuthState.error);
    _stopTimer();
  }

  /// معالجة إرسال الرمز
  void _onCodeSent(String verificationId, int? resendToken) {
    debugPrint('📨 تم إرسال الرمز. معرف التحقق: $verificationId');
    
    _verificationId = verificationId;
    _resendToken = resendToken;
    
    _stateController.add(PhoneAuthState.codeSent);
    startTimer();
  }

  /// معالجة انتهاء مهلة الاسترجاع التلقائي
  void _onCodeAutoRetrievalTimeout(String verificationId) {
    debugPrint('⏰ انتهت مهلة الاسترجاع التلقائي');
    _verificationId = verificationId;
  }

  /// التحقق من صحة رقم الهاتف
  bool isValidPhoneNumber(String phoneNumber) {
    // تحقق أساسي من صيغة رقم الهاتف
    final RegExp phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  /// تنسيق رقم الهاتف السوري
  String formatSyrianPhoneNumber(String phoneNumber) {
    // إزالة المسافات والرموز
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // إضافة رمز سوريا إذا لم يكن موجود
    if (!cleaned.startsWith('+')) {
      if (cleaned.startsWith('963')) {
        cleaned = '+$cleaned';
      } else if (cleaned.startsWith('0')) {
        cleaned = '+963${cleaned.substring(1)}';
      } else {
        cleaned = '+963$cleaned';
      }
    }
    
    return cleaned;
  }

  /// معالجة أخطاء Firebase Auth
  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      case 'invalid-phone-number':
        message = 'رقم الهاتف غير صحيح';
        break;
      case 'too-many-requests':
        message = 'تم تجاوز عدد المحاولات المسموح. حاول مرة أخرى لاحقاً';
        break;
      case 'invalid-verification-code':
        message = 'رمز التحقق غير صحيح';
        break;
      case 'invalid-verification-id':
        message = 'معرف التحقق غير صحيح';
        break;
      case 'session-expired':
        message = 'انتهت صلاحية جلسة التحقق. يرجى إعادة المحاولة';
        break;
      case 'quota-exceeded':
        message = 'تم تجاوز الحد المسموح لإرسال الرسائل';
        break;
      case 'credential-already-in-use':
        message = 'رقم الهاتف مرتبط بحساب آخر';
        break;
      case 'provider-already-linked':
        message = 'رقم الهاتف مرتبط بالفعل بهذا الحساب';
        break;
      case 'requires-recent-login':
        message = 'يتطلب تسجيل دخول حديث لإجراء هذه العملية';
        break;
      case 'network-request-failed':
        message = 'فشل في الاتصال بالشبكة';
        break;
      default:
        message = e.message ?? 'حدث خطأ غير متوقع';
    }

    return Exception(message);
  }

  /// تنظيف الموارد
  void dispose() {
    _stopTimer();
    _stateController.close();
    _timerController.close();
  }
}

/// حالات التحقق من رقم الهاتف
enum PhoneAuthState {
  initial,
  codeSending,
  codeSent,
  verifying,
  verified,
  error,
}

/// نتيجة التحقق من رقم الهاتف
class PhoneVerificationResult {
  final bool success;
  final User? user;
  final String? error;
  final PhoneAuthState state;

  PhoneVerificationResult({
    required this.success,
    this.user,
    this.error,
    required this.state,
  });

  factory PhoneVerificationResult.success(User user) {
    return PhoneVerificationResult(
      success: true,
      user: user,
      state: PhoneAuthState.verified,
    );
  }

  factory PhoneVerificationResult.failure(String error, PhoneAuthState state) {
    return PhoneVerificationResult(
      success: false,
      error: error,
      state: state,
    );
  }
}
