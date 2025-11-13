import 'package:hive_ce_flutter/hive_flutter.dart';

part 'm_user.g.dart';

@HiveType(typeId: 0)
class MUser {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? phone;
  @HiveField(2)
  String? firstName;
  @HiveField(3)
  String? lastName;
  @HiveField(4)
  String? email;
  @HiveField(5)
  bool? isActive;
  @HiveField(6)
  bool? isVerified;
  @HiveField(7)
  String? accessToken;
  @HiveField(8)
  String? refreshToken;

  MUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.isActive,
    this.isVerified,
    this.accessToken,
    this.refreshToken,
  });

  factory MUser.fromJson(Map<String, dynamic>? json) {
    return MUser(
      id: json?['id'] as String?,
      firstName: json?['first_name'] as String?,
      lastName: json?['last_name'] as String?,
      email: json?['email'] as String?,
      phone: json?['phone'] as String?,
      isActive: json?['is_active'] as bool?,
      isVerified: json?['is_verified'] as bool?,
      accessToken: json?['access_token'] as String?,
      refreshToken: json?['refresh_token'] as String?,
    );
  }

  String? get name {
    if (firstName != null && firstName!.isNotEmpty && lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'is_active': isActive,
      'is_verified': isVerified,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
