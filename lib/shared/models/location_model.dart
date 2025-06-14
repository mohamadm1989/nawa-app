/// نموذج الموقع
class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? country;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.country,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
      city: json['city'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
    };
  }
}
