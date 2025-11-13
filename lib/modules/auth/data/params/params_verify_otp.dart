class ParamsVerifyOtp {
  final String phoneNumber;
  final String code;

  ParamsVerifyOtp({
    required this.phoneNumber,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': phoneNumber,
      'code': code,
    };
  }
}
