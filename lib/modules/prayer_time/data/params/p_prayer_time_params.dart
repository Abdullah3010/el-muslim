import 'package:al_muslim/core/constants/constants.dart';

class PPrayerTimeParams {
  const PPrayerTimeParams({required this.lat, required this.lon, required this.method, required this.school});

  final double lat;
  final double lon;
  final int method;
  final int school;

  Map<String, dynamic> toQuery() {
    return {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'method': method,
      'school': school,
      'api_key': Constants.prayTimeApiKey,
    };
  }
}
