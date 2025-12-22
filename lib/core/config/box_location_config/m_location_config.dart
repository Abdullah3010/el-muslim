import 'package:hive_ce/hive.dart';

part 'm_location_config.g.dart';

@HiveType(typeId: 2)
class MLocationConfig {
  const MLocationConfig({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.updatedAt,
    required this.autoDetect,
  });

  @HiveField(0)
  final double latitude;
  @HiveField(1)
  final double longitude;
  @HiveField(2)
  final String city;
  @HiveField(3)
  final String country;
  @HiveField(4)
  final DateTime updatedAt;
  @HiveField(5)
  final bool autoDetect;

  String get displayName {
    final parts = [city, country].where((value) => value.isNotEmpty).toList();
    return parts.join(', ');
  }

  MLocationConfig copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    DateTime? updatedAt,
    bool? autoDetect,
  }) {
    return MLocationConfig(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      updatedAt: updatedAt ?? this.updatedAt,
      autoDetect: autoDetect ?? this.autoDetect,
    );
  }
}
