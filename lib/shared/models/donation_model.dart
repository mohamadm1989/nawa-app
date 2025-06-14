/// نموذج التبرع
class DonationModel {
  final String donationId;
  final String projectId;
  final String donorId;
  final double amount;
  final String currency;
  final DateTime createdAt;
  final DonationStatus status;
  final String? message;
  final bool isAnonymous;

  const DonationModel({
    required this.donationId,
    required this.projectId,
    required this.donorId,
    required this.amount,
    required this.currency,
    required this.createdAt,
    required this.status,
    this.message,
    this.isAnonymous = false,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      donationId: json['donationId'] ?? '',
      projectId: json['projectId'] ?? '',
      donorId: json['donorId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      status: DonationStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => DonationStatus.pending,
      ),
      message: json['message'],
      isAnonymous: json['isAnonymous'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donationId': donationId,
      'projectId': projectId,
      'donorId': donorId,
      'amount': amount,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'message': message,
      'isAnonymous': isAnonymous,
    };
  }
}

/// حالة التبرع
enum DonationStatus {
  pending,
  completed,
  failed,
  refunded,
}

extension DonationStatusExtension on DonationStatus {
  String get displayName {
    switch (this) {
      case DonationStatus.pending:
        return 'في الانتظار';
      case DonationStatus.completed:
        return 'مكتمل';
      case DonationStatus.failed:
        return 'فشل';
      case DonationStatus.refunded:
        return 'مسترد';
    }
  }
}
