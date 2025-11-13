import 'package:al_muslim/core/constants/constants.dart';

class ParamsLogin {
  final String phoneNumber;
  final String password;

  ParamsLogin({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': '${Constants.countryCode}${phoneNumber.replaceAll(' ', '')}'.replaceAll('+', ''),
      'password': password,
    };
  }
}
