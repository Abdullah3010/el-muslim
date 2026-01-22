import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:al_muslim/modules/prayer_time/data/models/m_prayer_time_response.dart';
import 'package:al_muslim/modules/prayer_time/data/params/p_prayer_time_params.dart';

class PrayerTimeRemoteSource {
  PrayerTimeRemoteSource({Dio? dio}) : _dio = dio ?? Dio(BaseOptions());

  final Dio _dio;

  Future<MPrayerTime> fetchPrayerTimes(PPrayerTimeParams params, {DateTime? date}) async {
    try {
      final query = Map<String, dynamic>.from(params.toQuery());
      final formattedDate = date != null ? DateFormat('dd-MM-yyyy').format(date) : null;
      final endpoint =
          formattedDate != null
              ? 'https://api.aladhan.com/v1/timings/$formattedDate'
              : 'https://api.aladhan.com/v1/timings';

      final response = await _dio.get(endpoint, queryParameters: query);
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
