// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'user_model.dart';

/// نموذج بيانات المشروع
class ProjectModel {
  final String projectId;
  final ProjectBasic basic;
  final ProjectLocation location;
  final ProjectFinancial financial;
  final ProjectTimeline timeline;
  final ProjectCreator creator;
  final ProjectMedia media;
  final ProjectEngagement engagement;
  final ProjectVerification verification;

  const ProjectModel({
    required this.projectId,
    required this.basic,
    required this.location,
    required this.financial,
    required this.timeline,
    required this.creator,
    required this.media,
    required this.engagement,
    required this.verification,
  });

  /// إنشاء نموذج من JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'] ?? '',
      basic: ProjectBasic.fromJson(json['basic'] ?? {}),
      location: ProjectLocation.fromJson(json['location'] ?? {}),
      financial: ProjectFinancial.fromJson(json['financial'] ?? {}),
      timeline: ProjectTimeline.fromJson(json['timeline'] ?? {}),
      creator: ProjectCreator.fromJson(json['creator'] ?? {}),
      media: ProjectMedia.fromJson(json['media'] ?? {}),
      engagement: ProjectEngagement.fromJson(json['engagement'] ?? {}),
      verification: ProjectVerification.fromJson(json['verification'] ?? {}),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'basic': basic.toJson(),
      'location': location.toJson(),
      'financial': financial.toJson(),
      'timeline': timeline.toJson(),
      'creator': creator.toJson(),
      'media': media.toJson(),
      'engagement': engagement.toJson(),
      'verification': verification.toJson(),
    };
  }

  /// إنشاء نسخة محدثة
  ProjectModel copyWith({
    String? projectId,
    ProjectBasic? basic,
    ProjectLocation? location,
    ProjectFinancial? financial,
    ProjectTimeline? timeline,
    ProjectCreator? creator,
    ProjectMedia? media,
    ProjectEngagement? engagement,
    ProjectVerification? verification,
  }) {
    return ProjectModel(
      projectId: projectId ?? this.projectId,
      basic: basic ?? this.basic,
      location: location ?? this.location,
      financial: financial ?? this.financial,
      timeline: timeline ?? this.timeline,
      creator: creator ?? this.creator,
      media: media ?? this.media,
      engagement: engagement ?? this.engagement,
      verification: verification ?? this.verification,
    );
  }

  /// حساب نسبة التقدم
  double get progressPercentage {
    if (financial.targetAmount <= 0) return 0.0;
    return (financial.currentAmount / financial.targetAmount * 100).clamp(0.0, 100.0);
  }

  /// المبلغ المتبقي
  double get remainingAmount {
    return (financial.targetAmount - financial.currentAmount).clamp(0.0, double.infinity);
  }

  /// هل المشروع مكتمل التمويل؟
  bool get isFullyFunded => financial.currentAmount >= financial.targetAmount;

  /// هل المشروع نشط؟
  bool get isActive => basic.status == 'active';

  /// هل المشروع مكتمل؟
  bool get isCompleted => basic.status == 'completed';
}

/// المعلومات الأساسية للمشروع
class ProjectBasic {
  final String title;
  final String description;
  final String category;
  final String status; // pending, active, completed, cancelled, suspended
  final String priority; // low, medium, high, urgent
  final List<String> tags;

  const ProjectBasic({
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    this.tags = const [],
  });

  factory ProjectBasic.fromJson(Map<String, dynamic> json) {
    return ProjectBasic(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'priority': priority,
      'tags': tags,
    };
  }

  ProjectBasic copyWith({
    String? title,
    String? description,
    String? category,
    String? status,
    String? priority,
    List<String>? tags,
  }) {
    return ProjectBasic(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
    );
  }
}

/// الإحداثيات الجغرافية
class GeoCoordinates {
  final double lat;
  final double lng;

  const GeoCoordinates({
    required this.lat,
    required this.lng,
  });

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) {
    return GeoCoordinates(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

/// موقع المشروع
class ProjectLocation {
  final String city;
  final String district;
  final String address;
  final GeoCoordinates coordinates;

  const ProjectLocation({
    required this.city,
    required this.district,
    required this.address,
    required this.coordinates,
  });

  factory ProjectLocation.fromJson(Map<String, dynamic> json) {
    return ProjectLocation(
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      address: json['address'] ?? '',
      coordinates: GeoCoordinates.fromJson(json['coordinates'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'district': district,
      'address': address,
      'coordinates': coordinates.toJson(),
    };
  }
}

/// المعلومات المالية للمشروع
class ProjectFinancial {
  final double targetAmount;
  final double currentAmount;
  final String currency;
  final ProjectBreakdown breakdown;

  const ProjectFinancial({
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.currency = 'USD',
    required this.breakdown,
  });

  factory ProjectFinancial.fromJson(Map<String, dynamic> json) {
    return ProjectFinancial(
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      breakdown: ProjectBreakdown.fromJson(json['breakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'currency': currency,
      'breakdown': breakdown.toJson(),
    };
  }
}

/// تفصيل الميزانية
class ProjectBreakdown {
  final double materials;
  final double labor;
  final double other;

  const ProjectBreakdown({
    this.materials = 0.0,
    this.labor = 0.0,
    this.other = 0.0,
  });

  factory ProjectBreakdown.fromJson(Map<String, dynamic> json) {
    return ProjectBreakdown(
      materials: (json['materials'] ?? 0.0).toDouble(),
      labor: (json['labor'] ?? 0.0).toDouble(),
      other: (json['other'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materials': materials,
      'labor': labor,
      'other': other,
    };
  }

  double get total => materials + labor + other;
}

/// الجدول الزمني للمشروع
class ProjectTimeline {
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? expectedEndDate;
  final DateTime? actualEndDate;

  const ProjectTimeline({
    required this.createdAt,
    this.startDate,
    this.expectedEndDate,
    this.actualEndDate,
  });

  factory ProjectTimeline.fromJson(Map<String, dynamic> json) {
    return ProjectTimeline(
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      expectedEndDate: json['expectedEndDate'] != null ? DateTime.tryParse(json['expectedEndDate']) : null,
      actualEndDate: json['actualEndDate'] != null ? DateTime.tryParse(json['actualEndDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'expectedEndDate': expectedEndDate?.toIso8601String(),
      'actualEndDate': actualEndDate?.toIso8601String(),
    };
  }
}

/// منشئ المشروع
class ProjectCreator {
  final String uid;
  final String name;
  final String role;
  final String contact;

  const ProjectCreator({
    required this.uid,
    required this.name,
    required this.role,
    required this.contact,
  });

  factory ProjectCreator.fromJson(Map<String, dynamic> json) {
    return ProjectCreator(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      contact: json['contact'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'role': role,
      'contact': contact,
    };
  }
}

/// وسائط المشروع
class ProjectMedia {
  final String? mainImage;
  final List<String> gallery;
  final List<String> documents;
  final String? video; // إضافة حقل الفيديو

  const ProjectMedia({
    this.mainImage,
    this.gallery = const [],
    this.documents = const [],
    this.video, // إضافة الفيديو للمنشئ
  });

  factory ProjectMedia.fromJson(Map<String, dynamic> json) {
    return ProjectMedia(
      mainImage: json['mainImage'],
      gallery: List<String>.from(json['gallery'] ?? []),
      documents: List<String>.from(json['documents'] ?? []),
      video: json['video'], // إضافة الفيديو
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainImage': mainImage,
      'gallery': gallery,
      'documents': documents,
      'video': video, // إضافة الفيديو
    };
  }
}

/// تفاعل المستخدمين مع المشروع
class ProjectEngagement {
  final int supporters;
  final int likes;
  final int comments;
  final int shares;
  final int views;

  const ProjectEngagement({
    this.supporters = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.views = 0,
  });

  factory ProjectEngagement.fromJson(Map<String, dynamic> json) {
    return ProjectEngagement(
      supporters: json['supporters'] ?? 0,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      views: json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supporters': supporters,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'views': views,
    };
  }
}

/// التحقق من المشروع
class ProjectVerification {
  final String status; // pending, verified, rejected
  final String? verifiedBy;
  final DateTime? verificationDate;
  final List<String> documents;
  final bool communityVotingEnabled; // تفعيل التصويت المجتمعي
  final int communityVotes; // عدد الأصوات المجتمعية
  final int requiredVotes; // عدد الأصوات المطلوبة

  const ProjectVerification({
    this.status = 'pending',
    this.verifiedBy,
    this.verificationDate,
    this.documents = const [],
    this.communityVotingEnabled = false,
    this.communityVotes = 0,
    this.requiredVotes = 10,
  });

  factory ProjectVerification.fromJson(Map<String, dynamic> json) {
    return ProjectVerification(
      status: json['status'] ?? 'pending',
      verifiedBy: json['verifiedBy'],
      verificationDate: json['verificationDate'] != null ? DateTime.tryParse(json['verificationDate']) : null,
      documents: List<String>.from(json['documents'] ?? []),
      communityVotingEnabled: json['communityVotingEnabled'] ?? false,
      communityVotes: json['communityVotes'] ?? 0,
      requiredVotes: json['requiredVotes'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'verifiedBy': verifiedBy,
      'verificationDate': verificationDate?.toIso8601String(),
      'documents': documents,
      'communityVotingEnabled': communityVotingEnabled,
      'communityVotes': communityVotes,
      'requiredVotes': requiredVotes,
    };
  }

  bool get isVerified => status == 'verified';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';

  // دوال مساعدة للتصويت المجتمعي
  bool get hasEnoughVotes => communityVotes >= requiredVotes;
  double get votingProgress => communityVotes / requiredVotes;
  int get remainingVotes => (requiredVotes - communityVotes).clamp(0, requiredVotes);
}
