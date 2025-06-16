import 'package:flutter/material.dart';

/// نموذج الإشعار المتقدم
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final bool isArchived;
  final bool isPinned;
  final Map<String, dynamic>? actionData;
  final String? imageUrl;
  final String? projectId;
  final String? userId;
  final List<String> tags;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    this.isRead = false,
    this.isArchived = false,
    this.isPinned = false,
    this.actionData,
    this.imageUrl,
    this.projectId,
    this.userId,
    this.tags = const [],
  });

  /// إنشاء نسخة محدثة من الإشعار
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    bool? isArchived,
    bool? isPinned,
    Map<String, dynamic>? actionData,
    String? imageUrl,
    String? projectId,
    String? userId,
    List<String>? tags,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
      actionData: actionData ?? this.actionData,
      imageUrl: imageUrl ?? this.imageUrl,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
      tags: tags ?? this.tags,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'priority': priority.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'isArchived': isArchived,
      'isPinned': isPinned,
      'actionData': actionData,
      'imageUrl': imageUrl,
      'projectId': projectId,
      'userId': userId,
      'tags': tags,
    };
  }

  /// إنشاء من JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      actionData: json['actionData'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
      projectId: json['projectId'] as String?,
      userId: json['userId'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  /// الحصول على أيقونة الإشعار
  IconData get icon {
    switch (type) {
      case NotificationType.donation:
        return Icons.favorite;
      case NotificationType.project:
        return Icons.work;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.update:
        return Icons.update;
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.social:
        return Icons.people;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  /// الحصول على لون الإشعار
  Color get color {
    switch (priority) {
      case NotificationPriority.high:
        return Colors.red;
      case NotificationPriority.medium:
        return Colors.orange;
      case NotificationPriority.low:
        return Colors.blue;
      case NotificationPriority.info:
        return Colors.green;
    }
  }

  /// الحصول على وصف نوع الإشعار
  String get typeDescription {
    switch (type) {
      case NotificationType.donation:
        return 'تبرع';
      case NotificationType.project:
        return 'مشروع';
      case NotificationType.system:
        return 'نظام';
      case NotificationType.update:
        return 'تحديث';
      case NotificationType.achievement:
        return 'إنجاز';
      case NotificationType.reminder:
        return 'تذكير';
      case NotificationType.social:
        return 'اجتماعي';
      case NotificationType.security:
        return 'أمان';
      case NotificationType.general:
        return 'عام';
    }
  }

  /// التحقق من انتهاء صلاحية الإشعار
  bool get isExpired {
    final now = DateTime.now();
    final daysDiff = now.difference(timestamp).inDays;
    return daysDiff > 30; // ينتهي بعد 30 يوم
  }

  /// التحقق من كون الإشعار جديد
  bool get isNew {
    final now = DateTime.now();
    final hoursDiff = now.difference(timestamp).inHours;
    return hoursDiff < 24 && !isRead; // جديد إذا كان أقل من 24 ساعة وغير مقروء
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, priority: $priority)';
  }
}

/// أنواع الإشعارات
enum NotificationType {
  general,    // عام
  donation,   // تبرع
  project,    // مشروع
  system,     // نظام
  update,     // تحديث
  achievement, // إنجاز
  reminder,   // تذكير
  social,     // اجتماعي
  security,   // أمان
}

/// أولويات الإشعارات
enum NotificationPriority {
  low,     // منخفضة
  medium,  // متوسطة
  high,    // عالية
  info,    // معلوماتية
}

/// إعدادات الإشعارات
class NotificationSettings {
  final bool enableNotifications;
  final bool enableSound;
  final bool enableVibration;
  final Map<NotificationType, bool> typeSettings;
  final List<String> quietHours; // ساعات الصمت
  final bool enablePreview;
  final int maxNotifications;

  const NotificationSettings({
    this.enableNotifications = true,
    this.enableSound = true,
    this.enableVibration = true,
    this.typeSettings = const {},
    this.quietHours = const [],
    this.enablePreview = true,
    this.maxNotifications = 100,
  });

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'enableNotifications': enableNotifications,
      'enableSound': enableSound,
      'enableVibration': enableVibration,
      'typeSettings': typeSettings.map((k, v) => MapEntry(k.name, v)),
      'quietHours': quietHours,
      'enablePreview': enablePreview,
      'maxNotifications': maxNotifications,
    };
  }

  /// إنشاء من JSON
  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    final typeSettingsJson = json['typeSettings'] as Map<String, dynamic>? ?? {};
    final typeSettings = <NotificationType, bool>{};

    for (final entry in typeSettingsJson.entries) {
      final type = NotificationType.values.firstWhere(
        (e) => e.name == entry.key,
        orElse: () => NotificationType.general,
      );
      typeSettings[type] = entry.value as bool;
    }

    return NotificationSettings(
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableSound: json['enableSound'] as bool? ?? true,
      enableVibration: json['enableVibration'] as bool? ?? true,
      typeSettings: typeSettings,
      quietHours: List<String>.from(json['quietHours'] as List? ?? []),
      enablePreview: json['enablePreview'] as bool? ?? true,
      maxNotifications: json['maxNotifications'] as int? ?? 100,
    );
  }

  /// إنشاء نسخة محدثة
  NotificationSettings copyWith({
    bool? enableNotifications,
    bool? enableSound,
    bool? enableVibration,
    Map<NotificationType, bool>? typeSettings,
    List<String>? quietHours,
    bool? enablePreview,
    int? maxNotifications,
  }) {
    return NotificationSettings(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableSound: enableSound ?? this.enableSound,
      enableVibration: enableVibration ?? this.enableVibration,
      typeSettings: typeSettings ?? this.typeSettings,
      quietHours: quietHours ?? this.quietHours,
      enablePreview: enablePreview ?? this.enablePreview,
      maxNotifications: maxNotifications ?? this.maxNotifications,
    );
  }
}