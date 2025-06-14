import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// خدمة تسجيل الدخول بـ Google
class GoogleAuthService {
  static GoogleAuthService? _instance;
  static GoogleAuthService get instance {
    _instance ??= GoogleAuthService._();
    return _instance!;
  }

  GoogleAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  /// تسجيل الدخول بـ Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('🔐 بدء تسجيل الدخول بـ Google...');

      // بدء عملية تسجيل الدخول
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        debugPrint('❌ تم إلغاء تسجيل الدخول من قبل المستخدم');
        return null;
      }

      debugPrint('✅ تم اختيار الحساب: ${googleUser.email}');

      // الحصول على تفاصيل المصادقة
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint('❌ فشل في الحصول على tokens');
        throw Exception('فشل في الحصول على بيانات المصادقة');
      }

      // إنشاء credential للـ Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      debugPrint('🔄 تسجيل الدخول في Firebase...');

      // تسجيل الدخول في Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      debugPrint('✅ تم تسجيل الدخول بنجاح: ${userCredential.user?.email}');

      return userCredential;

    } on FirebaseAuthException catch (e) {
      debugPrint('❌ خطأ Firebase Auth: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      debugPrint('❌ خطأ عام في تسجيل الدخول بـ Google: $e');
      throw Exception('فشل في تسجيل الدخول بـ Google: $e');
    }
  }

  /// ربط حساب Google بحساب موجود
  Future<UserCredential?> linkWithGoogle() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('لا يوجد مستخدم مسجل دخول');
      }

      debugPrint('🔗 ربط حساب Google بالحساب الحالي...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await currentUser.linkWithCredential(credential);

      debugPrint('✅ تم ربط حساب Google بنجاح');
      return userCredential;

    } on FirebaseAuthException catch (e) {
      debugPrint('❌ خطأ في ربط حساب Google: ${e.code}');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      debugPrint('❌ خطأ عام في ربط حساب Google: $e');
      throw Exception('فشل في ربط حساب Google: $e');
    }
  }

  /// إلغاء ربط حساب Google
  Future<void> unlinkGoogle() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('لا يوجد مستخدم مسجل دخول');
      }

      await currentUser.unlink(GoogleAuthProvider.PROVIDER_ID);
      await _googleSignIn.signOut();

      debugPrint('✅ تم إلغاء ربط حساب Google');

    } on FirebaseAuthException catch (e) {
      debugPrint('❌ خطأ في إلغاء ربط Google: ${e.code}');
      throw _handleFirebaseAuthException(e);
    }
  }

  /// تسجيل الخروج من Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      debugPrint('✅ تم تسجيل الخروج من Google');
    } catch (e) {
      debugPrint('❌ خطأ في تسجيل الخروج من Google: $e');
    }
  }

  /// التحقق من حالة تسجيل الدخول
  bool get isSignedIn => _googleSignIn.currentUser != null;

  /// الحصول على المستخدم الحالي
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// الحصول على معلومات المستخدم
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final GoogleSignInAccount? user = _googleSignIn.currentUser;
      if (user == null) return null;

      return {
        'id': user.id,
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'serverAuthCode': user.serverAuthCode,
      };
    } catch (e) {
      debugPrint('❌ خطأ في الحصول على معلومات المستخدم: $e');
      return null;
    }
  }

  /// التحقق من صلاحيات Google
  Future<bool> hasRequiredScopes() async {
    try {
      final GoogleSignInAccount? user = _googleSignIn.currentUser;
      if (user == null) return false;

      final bool hasScopes = await _googleSignIn.requestScopes([
        'email',
        'profile',
      ]);

      return hasScopes;
    } catch (e) {
      debugPrint('❌ خطأ في التحقق من الصلاحيات: $e');
      return false;
    }
  }

  /// معالجة أخطاء Firebase Auth
  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      case 'account-exists-with-different-credential':
        message = 'يوجد حساب بنفس البريد الإلكتروني مع طريقة تسجيل دخول مختلفة';
        break;
      case 'invalid-credential':
        message = 'بيانات المصادقة غير صحيحة';
        break;
      case 'operation-not-allowed':
        message = 'تسجيل الدخول بـ Google غير مفعل';
        break;
      case 'user-disabled':
        message = 'تم تعطيل هذا الحساب';
        break;
      case 'user-not-found':
        message = 'لم يتم العثور على المستخدم';
        break;
      case 'wrong-password':
        message = 'كلمة المرور غير صحيحة';
        break;
      case 'invalid-verification-code':
        message = 'رمز التحقق غير صحيح';
        break;
      case 'invalid-verification-id':
        message = 'معرف التحقق غير صحيح';
        break;
      case 'credential-already-in-use':
        message = 'هذا الحساب مرتبط بمستخدم آخر';
        break;
      case 'provider-already-linked':
        message = 'حساب Google مرتبط بالفعل';
        break;
      case 'no-such-provider':
        message = 'حساب Google غير مرتبط بهذا المستخدم';
        break;
      case 'requires-recent-login':
        message = 'يتطلب تسجيل دخول حديث لإجراء هذه العملية';
        break;
      case 'network-request-failed':
        message = 'فشل في الاتصال بالشبكة';
        break;
      case 'too-many-requests':
        message = 'تم تجاوز عدد المحاولات المسموح. حاول مرة أخرى لاحقاً';
        break;
      default:
        message = e.message ?? 'حدث خطأ غير متوقع';
    }

    return Exception(message);
  }

  /// تنظيف الموارد
  void dispose() {
    // تنظيف أي موارد إضافية إذا لزم الأمر
  }
}

/// نتيجة تسجيل الدخول
class GoogleSignInResult {
  final bool success;
  final User? user;
  final String? error;
  final Map<String, dynamic>? userData;

  GoogleSignInResult({
    required this.success,
    this.user,
    this.error,
    this.userData,
  });

  factory GoogleSignInResult.success(User user, Map<String, dynamic>? userData) {
    return GoogleSignInResult(
      success: true,
      user: user,
      userData: userData,
    );
  }

  factory GoogleSignInResult.failure(String error) {
    return GoogleSignInResult(
      success: false,
      error: error,
    );
  }
}

/// حالة تسجيل الدخول
enum GoogleSignInStatus {
  initial,
  loading,
  success,
  failure,
  cancelled,
}
