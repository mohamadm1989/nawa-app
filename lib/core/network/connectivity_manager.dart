import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// مدير الاتصال بالإنترنت ومراقبة حالة الشبكة
class ConnectivityManager {
  static ConnectivityManager? _instance;
  static final Connectivity _connectivity = Connectivity();
  
  // Stream controllers
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  final StreamController<ConnectionQuality> _connectionQualityController = StreamController<ConnectionQuality>.broadcast();
  
  // Current status
  bool _isConnected = false;
  ConnectionQuality _currentQuality = ConnectionQuality.unknown;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityManager._();

  static ConnectivityManager get instance {
    _instance ??= ConnectivityManager._();
    return _instance!;
  }

  // ========== Getters ==========
  
  bool get isConnected => _isConnected;
  ConnectionQuality get connectionQuality => _currentQuality;
  Stream<bool> get connectionStream => _connectionStatusController.stream;
  Stream<ConnectionQuality> get qualityStream => _connectionQualityController.stream;

  // ========== تهيئة المدير ==========

  /// تهيئة مراقب الاتصال
  Future<void> initialize() async {
    // فحص الحالة الأولية
    await _checkInitialConnection();
    
    // بدء مراقبة التغييرات
    _startListening();
    
    // بدء مراقبة جودة الاتصال
    _startQualityMonitoring();
  }

  /// فحص الحالة الأولية للاتصال
  Future<void> _checkInitialConnection() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(connectivityResults);
    } catch (e) {
      debugPrint('خطأ في فحص الاتصال الأولي: $e');
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }

  /// بدء مراقبة تغييرات الاتصال
  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (error) {
        debugPrint('خطأ في مراقبة الاتصال: $error');
      },
    );
  }

  /// تحديث حالة الاتصال
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final bool wasConnected = _isConnected;
    
    // تحديد حالة الاتصال
    _isConnected = results.any((result) => 
      result != ConnectivityResult.none
    );

    // فحص الاتصال الفعلي بالإنترنت
    if (_isConnected) {
      _isConnected = await _hasInternetConnection();
    }

    // إرسال التحديث إذا تغيرت الحالة
    if (wasConnected != _isConnected) {
      _connectionStatusController.add(_isConnected);
      
      if (_isConnected) {
        debugPrint('🌐 تم الاتصال بالإنترنت');
        _onConnectionRestored();
      } else {
        debugPrint('📵 انقطع الاتصال بالإنترنت');
        _onConnectionLost();
      }
    }

    // تحديث جودة الاتصال
    await _updateConnectionQuality(results);
  }

  /// فحص الاتصال الفعلي بالإنترنت
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      debugPrint('خطأ في فحص الاتصال بالإنترنت: $e');
      return false;
    }
  }

  // ========== مراقبة جودة الاتصال ==========

  /// بدء مراقبة جودة الاتصال
  void _startQualityMonitoring() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        _measureConnectionQuality();
      }
    });
  }

  /// تحديث جودة الاتصال
  Future<void> _updateConnectionQuality(List<ConnectivityResult> results) async {
    if (!_isConnected) {
      _currentQuality = ConnectionQuality.none;
      _connectionQualityController.add(_currentQuality);
      return;
    }

    // تحديد الجودة بناءً على نوع الاتصال
    if (results.contains(ConnectivityResult.wifi)) {
      _currentQuality = ConnectionQuality.excellent;
    } else if (results.contains(ConnectivityResult.mobile)) {
      _currentQuality = ConnectionQuality.good;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      _currentQuality = ConnectionQuality.excellent;
    } else {
      _currentQuality = ConnectionQuality.poor;
    }

    _connectionQualityController.add(_currentQuality);
  }

  /// قياس جودة الاتصال الفعلية
  Future<void> _measureConnectionQuality() async {
    if (!_isConnected) return;

    try {
      final stopwatch = Stopwatch()..start();
      await InternetAddress.lookup('google.com');
      stopwatch.stop();

      final latency = stopwatch.elapsedMilliseconds;
      
      ConnectionQuality newQuality;
      if (latency < 100) {
        newQuality = ConnectionQuality.excellent;
      } else if (latency < 300) {
        newQuality = ConnectionQuality.good;
      } else if (latency < 1000) {
        newQuality = ConnectionQuality.fair;
      } else {
        newQuality = ConnectionQuality.poor;
      }

      if (newQuality != _currentQuality) {
        _currentQuality = newQuality;
        _connectionQualityController.add(_currentQuality);
      }
    } catch (e) {
      debugPrint('خطأ في قياس جودة الاتصال: $e');
    }
  }

  // ========== معالجة الأحداث ==========

  /// عند استعادة الاتصال
  void _onConnectionRestored() {
    // يمكن إضافة منطق مزامنة البيانات هنا
    debugPrint('🔄 بدء مزامنة البيانات...');
  }

  /// عند فقدان الاتصال
  void _onConnectionLost() {
    // يمكن إضافة منطق حفظ البيانات محلياً هنا
    debugPrint('💾 تفعيل الوضع المحلي...');
  }

  // ========== دوال مساعدة ==========

  /// فحص سريع للاتصال
  Future<bool> checkConnection() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none)) {
        return false;
      }
      return await _hasInternetConnection();
    } catch (e) {
      debugPrint('خطأ في فحص الاتصال: $e');
      return false;
    }
  }

  /// انتظار الاتصال
  Future<void> waitForConnection({Duration? timeout}) async {
    if (_isConnected) return;

    final completer = Completer<void>();
    late StreamSubscription subscription;

    subscription = connectionStream.listen((isConnected) {
      if (isConnected) {
        subscription.cancel();
        completer.complete();
      }
    });

    if (timeout != null) {
      Timer(timeout, () {
        if (!completer.isCompleted) {
          subscription.cancel();
          completer.completeError(TimeoutException('انتهت مهلة انتظار الاتصال', timeout));
        }
      });
    }

    return completer.future;
  }

  /// الحصول على نوع الاتصال
  Future<String> getConnectionType() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      
      if (connectivityResults.contains(ConnectivityResult.wifi)) {
        return 'WiFi';
      } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
        return 'Mobile Data';
      } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
        return 'Ethernet';
      } else {
        return 'No Connection';
      }
    } catch (e) {
      debugPrint('خطأ في تحديد نوع الاتصال: $e');
      return 'Unknown';
    }
  }

  /// الحصول على معلومات مفصلة عن الاتصال
  Future<Map<String, dynamic>> getConnectionInfo() async {
    return {
      'isConnected': _isConnected,
      'quality': _currentQuality.name,
      'type': await getConnectionType(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // ========== تنظيف الموارد ==========

  /// إيقاف المراقبة وتنظيف الموارد
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
    _connectionQualityController.close();
  }
}

/// تعداد جودة الاتصال
enum ConnectionQuality {
  none('لا يوجد اتصال'),
  poor('ضعيف'),
  fair('متوسط'),
  good('جيد'),
  excellent('ممتاز'),
  unknown('غير معروف');

  const ConnectionQuality(this.displayName);
  final String displayName;
}

/// استثناء انتهاء المهلة
class TimeoutException implements Exception {
  final String message;
  final Duration? duration;

  const TimeoutException(this.message, this.duration);

  @override
  String toString() => 'TimeoutException: $message';
}
