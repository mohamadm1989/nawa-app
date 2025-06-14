// import 'package:cloud_firestore/cloud_firestore.dart';
import 'project_model.dart';

/// نموذج بيانات المستخدم
class UserModel {
  final String uid;
  final UserProfile profile;
  final UserStats stats;
  final UserSettings settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.profile,
    required this.stats,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  /// إنشاء نموذج من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      stats: UserStats.fromJson(json['stats'] ?? {}),
      settings: UserSettings.fromJson(json['settings'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'profile': profile.toJson(),
      'stats': stats.toJson(),
      'settings': settings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// إنشاء نسخة محدثة
  UserModel copyWith({
    String? uid,
    UserProfile? profile,
    UserStats? stats,
    UserSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      profile: profile ?? this.profile,
      stats: stats ?? this.stats,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// الملف الشخصي للمستخدم
class UserProfile {
  final String name;
  final String phone;
  final String email;
  final String? avatar;
  final UserLocation? location;
  final String userType; // local, diaspora, organization, admin
  final List<String> interests;
  final List<String> skills;

  const UserProfile({
    required this.name,
    required this.phone,
    required this.email,
    this.avatar,
    this.location,
    required this.userType,
    this.interests = const [],
    this.skills = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      location: json['location'] != null 
          ? UserLocation.fromJson(json['location']) 
          : null,
      userType: json['userType'] ?? 'local',
      interests: List<String>.from(json['interests'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'location': location?.toJson(),
      'userType': userType,
      'interests': interests,
      'skills': skills,
    };
  }

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    String? avatar,
    UserLocation? location,
    String? userType,
    List<String>? interests,
    List<String>? skills,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      userType: userType ?? this.userType,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
    );
  }
}

/// موقع المستخدم
class UserLocation {
  final String city;
  final String country;
  final GeoCoordinates? coordinates;

  const UserLocation({
    required this.city,
    required this.country,
    this.coordinates,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      coordinates: json['coordinates'] != null 
          ? GeoCoordinates.fromJson(json['coordinates']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'coordinates': coordinates?.toJson(),
    };
  }
}



/// إحصائيات المستخدم
class UserStats {
  final double totalDonations;
  final int projectsSupported;
  final int projectsCreated;
  final int volunteeredHours;
  final List<String> badges;

  const UserStats({
    this.totalDonations = 0.0,
    this.projectsSupported = 0,
    this.projectsCreated = 0,
    this.volunteeredHours = 0,
    this.badges = const [],
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalDonations: (json['totalDonations'] ?? 0.0).toDouble(),
      projectsSupported: json['projectsSupported'] ?? 0,
      projectsCreated: json['projectsCreated'] ?? 0,
      volunteeredHours: json['volunteeredHours'] ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDonations': totalDonations,
      'projectsSupported': projectsSupported,
      'projectsCreated': projectsCreated,
      'volunteeredHours': volunteeredHours,
      'badges': badges,
    };
  }

  UserStats copyWith({
    double? totalDonations,
    int? projectsSupported,
    int? projectsCreated,
    int? volunteeredHours,
    List<String>? badges,
  }) {
    return UserStats(
      totalDonations: totalDonations ?? this.totalDonations,
      projectsSupported: projectsSupported ?? this.projectsSupported,
      projectsCreated: projectsCreated ?? this.projectsCreated,
      volunteeredHours: volunteeredHours ?? this.volunteeredHours,
      badges: badges ?? this.badges,
    );
  }
}

/// إعدادات المستخدم
class UserSettings {
  final String language;
  final bool notifications;
  final UserPrivacy privacy;

  const UserSettings({
    this.language = 'ar',
    this.notifications = true,
    this.privacy = const UserPrivacy(),
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      language: json['language'] ?? 'ar',
      notifications: json['notifications'] ?? true,
      privacy: UserPrivacy.fromJson(json['privacy'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'notifications': notifications,
      'privacy': privacy.toJson(),
    };
  }

  UserSettings copyWith({
    String? language,
    bool? notifications,
    UserPrivacy? privacy,
  }) {
    return UserSettings(
      language: language ?? this.language,
      notifications: notifications ?? this.notifications,
      privacy: privacy ?? this.privacy,
    );
  }
}

/// إعدادات الخصوصية
class UserPrivacy {
  final bool showName;
  final bool showDonations;

  const UserPrivacy({
    this.showName = true,
    this.showDonations = false,
  });

  factory UserPrivacy.fromJson(Map<String, dynamic> json) {
    return UserPrivacy(
      showName: json['showName'] ?? true,
      showDonations: json['showDonations'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showName': showName,
      'showDonations': showDonations,
    };
  }

  UserPrivacy copyWith({
    bool? showName,
    bool? showDonations,
  }) {
    return UserPrivacy(
      showName: showName ?? this.showName,
      showDonations: showDonations ?? this.showDonations,
    );
  }
}
