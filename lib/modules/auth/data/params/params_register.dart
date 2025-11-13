class ParamsRegister {
  final String username;
  final String phoneNumber;
  final String password;
  final String firstName;
  final String lastName;
  final String email;

  ParamsRegister({
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': phoneNumber,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }
}
