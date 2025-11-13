class ParamsUpdateProfile {
  final String fullName;
  final String email;
  final String phoneNumber;

  ParamsUpdateProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "phoneNumber": phoneNumber,
    };
  }
}
