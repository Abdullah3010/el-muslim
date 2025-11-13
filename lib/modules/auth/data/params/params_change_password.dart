class ParamsChangePassword {
  final String currentPassword;
  final String password;
  final String confirmPassword;

  ParamsChangePassword({
    required this.currentPassword,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': password,
      'confirmNewPassword': confirmPassword,
    };
  }
}

