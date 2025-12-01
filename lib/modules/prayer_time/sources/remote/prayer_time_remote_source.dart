import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../data/models/m_prayer_time_response.dart';
import '../../data/params/p_prayer_time_params.dart';

class PrayerTimeRemoteSource {
  PrayerTimeRemoteSource({Dio? dio}) : _dio = dio ?? Dio(BaseOptions());

  final Dio _dio;

  Future<MPrayerTime> fetchPrayerTimes(PPrayerTimeParams params, {DateTime? date}) async {
    try {
      final query = Map<String, dynamic>.from(params.toQuery());

      if (date != null) {
        query['date'] = DateFormat('yyyy-MM-dd').format(date);
      }

      final response = await _dio.get('https://islamicapi.com/api/v1/prayer-time/', queryParameters: query);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return MPrayerTime.fromJson(data['data'] as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching prayer times: $e');
      rethrow;
    }
    throw const FormatException('Unexpected prayer time response');
  }
}
