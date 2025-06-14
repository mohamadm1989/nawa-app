/// نموذج الوسائط
class MediaModel {
  final String mediaId;
  final String url;
  final MediaType type;
  final String? caption;
  final DateTime uploadedAt;
  final int? size;

  const MediaModel({
    required this.mediaId,
    required this.url,
    required this.type,
    this.caption,
    required this.uploadedAt,
    this.size,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      mediaId: json['mediaId'] ?? '',
      url: json['url'] ?? '',
      type: MediaType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => MediaType.image,
      ),
      caption: json['caption'],
      uploadedAt: DateTime.tryParse(json['uploadedAt'] ?? '') ?? DateTime.now(),
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'url': url,
      'type': type.name,
      'caption': caption,
      'uploadedAt': uploadedAt.toIso8601String(),
      'size': size,
    };
  }
}

/// أنواع الوسائط
enum MediaType {
  image,
  video,
  document,
}

extension MediaTypeExtension on MediaType {
  String get displayName {
    switch (this) {
      case MediaType.image:
        return 'صورة';
      case MediaType.video:
        return 'فيديو';
      case MediaType.document:
        return 'مستند';
    }
  }
}
