/// نموذج التفاعل
class EngagementModel {
  final String engagementId;
  final String userId;
  final String targetId;
  final EngagementType type;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const EngagementModel({
    required this.engagementId,
    required this.userId,
    required this.targetId,
    required this.type,
    required this.createdAt,
    this.metadata,
  });

  factory EngagementModel.fromJson(Map<String, dynamic> json) {
    return EngagementModel(
      engagementId: json['engagementId'] ?? '',
      userId: json['userId'] ?? '',
      targetId: json['targetId'] ?? '',
      type: EngagementType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => EngagementType.view,
      ),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engagementId': engagementId,
      'userId': userId,
      'targetId': targetId,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// أنواع التفاعل
enum EngagementType {
  view,
  like,
  comment,
  share,
  donate,
}

extension EngagementTypeExtension on EngagementType {
  String get displayName {
    switch (this) {
      case EngagementType.view:
        return 'مشاهدة';
      case EngagementType.like:
        return 'إعجاب';
      case EngagementType.comment:
        return 'تعليق';
      case EngagementType.share:
        return 'مشاركة';
      case EngagementType.donate:
        return 'تبرع';
    }
  }
}
