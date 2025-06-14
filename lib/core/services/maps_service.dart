import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

/// خدمة الخرائط والموقع الجغرافي
class MapsService {
  static MapsService? _instance;
  static MapsService get instance {
    _instance ??= MapsService._();
    return _instance!;
  }

  MapsService._();

  // إعدادات الموقع
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  // Stream للموقع الحالي
  StreamSubscription<Position>? _positionStream;
  final StreamController<Position> _positionController = 
      StreamController<Position>.broadcast();

  // الموقع الحالي
  Position? _currentPosition;
  
  // مواقع سوريا المهمة
  static const LatLng damascusCenter = LatLng(33.5138, 36.2765);
  static const LatLng aleppoCenter = LatLng(36.2021, 37.1343);
  static const LatLng homsCenter = LatLng(34.7394, 36.7163);
  static const LatLng lattakiaCenter = LatLng(35.5138, 35.7831);

  // Getters
  Stream<Position> get positionStream => _positionController.stream;
  Position? get currentPosition => _currentPosition;

  /// تهيئة خدمة الخرائط
  Future<void> initialize() async {
    try {
      debugPrint('🗺️ تهيئة خدمة الخرائط...');
      
      // التحقق من الصلاحيات
      await _checkPermissions();
      
      // الحصول على الموقع الحالي
      await getCurrentLocation();
      
      debugPrint('✅ تم تهيئة خدمة الخرائط بنجاح');
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة خدمة الخرائط: $e');
      throw Exception('فشل في تهيئة خدمة الخرائط');
    }
  }

  /// التحقق من صلاحيات الموقع
  Future<void> _checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // التحقق من تفعيل خدمة الموقع
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعلة');
    }

    // التحقق من الصلاحيات
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض صلاحية الوصول للموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('تم رفض صلاحية الوصول للموقع نهائياً');
    }
  }

  /// الحصول على الموقع الحالي
  Future<Position> getCurrentLocation() async {
    try {
      debugPrint('📍 الحصول على الموقع الحالي...');
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      _currentPosition = position;
      _positionController.add(position);
      
      debugPrint('✅ تم الحصول على الموقع: ${position.latitude}, ${position.longitude}');
      return position;
      
    } catch (e) {
      debugPrint('❌ خطأ في الحصول على الموقع: $e');
      throw Exception('فشل في الحصول على الموقع الحالي');
    }
  }

  /// بدء تتبع الموقع
  void startLocationTracking() {
    try {
      debugPrint('🎯 بدء تتبع الموقع...');
      
      _positionStream = Geolocator.getPositionStream(
        locationSettings: _locationSettings,
      ).listen(
        (Position position) {
          _currentPosition = position;
          _positionController.add(position);
          debugPrint('📍 موقع جديد: ${position.latitude}, ${position.longitude}');
        },
        onError: (error) {
          debugPrint('❌ خطأ في تتبع الموقع: $error');
        },
      );
      
    } catch (e) {
      debugPrint('❌ خطأ في بدء تتبع الموقع: $e');
    }
  }

  /// إيقاف تتبع الموقع
  void stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    debugPrint('⏹️ تم إيقاف تتبع الموقع');
  }

  /// تحويل الإحداثيات إلى عنوان
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      debugPrint('🏠 تحويل الإحداثيات إلى عنوان: $latitude, $longitude');
      
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((element) => element != null && element.isNotEmpty).join(', ');
        
        debugPrint('✅ العنوان: $address');
        return address;
      }
      
      return 'عنوان غير معروف';
      
    } catch (e) {
      debugPrint('❌ خطأ في تحويل الإحداثيات: $e');
      return 'فشل في تحديد العنوان';
    }
  }

  /// تحويل العنوان إلى إحداثيات
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      debugPrint('📍 تحويل العنوان إلى إحداثيات: $address');
      
      List<Location> locations = await locationFromAddress(address);
      
      if (locations.isNotEmpty) {
        final location = locations.first;
        final coordinates = LatLng(location.latitude, location.longitude);
        
        debugPrint('✅ الإحداثيات: ${coordinates.latitude}, ${coordinates.longitude}');
        return coordinates;
      }
      
      return null;
      
    } catch (e) {
      debugPrint('❌ خطأ في تحويل العنوان: $e');
      return null;
    }
  }

  /// حساب المسافة بين نقطتين
  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  /// حساب المسافة من الموقع الحالي
  double? calculateDistanceFromCurrent(LatLng destination) {
    if (_currentPosition == null) return null;
    
    return calculateDistance(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      destination,
    );
  }

  /// البحث عن الأماكن القريبة
  Future<List<MapLocation>> searchNearbyPlaces({
    required LatLng center,
    required double radiusInMeters,
    String? query,
  }) async {
    try {
      debugPrint('🔍 البحث عن الأماكن القريبة من: ${center.latitude}, ${center.longitude}');
      
      // هنا يمكن إضافة API للبحث عن الأماكن
      // مثل Google Places API أو OpenStreetMap Nominatim
      
      // مؤقتاً نرجع قائمة تجريبية
      return _getMockNearbyPlaces(center, radiusInMeters);
      
    } catch (e) {
      debugPrint('❌ خطأ في البحث عن الأماكن: $e');
      return [];
    }
  }

  /// الحصول على أماكن تجريبية قريبة
  List<MapLocation> _getMockNearbyPlaces(LatLng center, double radius) {
    return [
      MapLocation(
        id: '1',
        name: 'مسجد الأموي الكبير',
        description: 'أحد أهم المساجد في العالم الإسلامي',
        coordinates: const LatLng(33.5138, 36.2765),
        type: MapLocationType.mosque,
        address: 'دمشق القديمة، سوريا',
      ),
      MapLocation(
        id: '2',
        name: 'قلعة دمشق',
        description: 'قلعة تاريخية في قلب دمشق',
        coordinates: const LatLng(33.5118, 36.2775),
        type: MapLocationType.historical,
        address: 'دمشق القديمة، سوريا',
      ),
      MapLocation(
        id: '3',
        name: 'مستشفى دمشق',
        description: 'مستشفى عام',
        coordinates: const LatLng(33.5158, 36.2785),
        type: MapLocationType.hospital,
        address: 'دمشق، سوريا',
      ),
    ];
  }

  /// التحقق من وجود الموقع داخل سوريا
  bool isLocationInSyria(LatLng location) {
    // حدود سوريا التقريبية
    const double minLat = 32.0;
    const double maxLat = 37.5;
    const double minLng = 35.0;
    const double maxLng = 42.5;
    
    return location.latitude >= minLat &&
           location.latitude <= maxLat &&
           location.longitude >= minLng &&
           location.longitude <= maxLng;
  }

  /// الحصول على المحافظة من الإحداثيات
  String getProvinceFromCoordinates(LatLng location) {
    // تحديد المحافظة بناءً على الإحداثيات (تقريبي)
    if (location.latitude >= 36.0 && location.latitude <= 37.5) {
      return 'حلب';
    } else if (location.latitude >= 35.0 && location.latitude <= 36.0) {
      if (location.longitude <= 36.0) {
        return 'اللاذقية';
      } else {
        return 'إدلب';
      }
    } else if (location.latitude >= 34.0 && location.latitude <= 35.0) {
      return 'حمص';
    } else if (location.latitude >= 33.0 && location.latitude <= 34.0) {
      return 'دمشق';
    } else if (location.latitude >= 32.0 && location.latitude <= 33.0) {
      return 'درعا';
    }
    
    return 'غير محدد';
  }

  /// تنظيف الموارد
  void dispose() {
    stopLocationTracking();
    _positionController.close();
  }
}

/// موقع على الخريطة
class MapLocation {
  final String id;
  final String name;
  final String description;
  final LatLng coordinates;
  final MapLocationType type;
  final String address;
  final String? imageUrl;
  final double? rating;
  final Map<String, dynamic>? metadata;

  MapLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.type,
    required this.address,
    this.imageUrl,
    this.rating,
    this.metadata,
  });
}

/// أنواع المواقع على الخريطة
enum MapLocationType {
  mosque,
  hospital,
  school,
  market,
  restaurant,
  hotel,
  historical,
  government,
  charity,
  other,
}

/// نتيجة البحث في الخرائط
class MapSearchResult {
  final List<MapLocation> locations;
  final String query;
  final LatLng? searchCenter;
  final double? searchRadius;

  MapSearchResult({
    required this.locations,
    required this.query,
    this.searchCenter,
    this.searchRadius,
  });
}
