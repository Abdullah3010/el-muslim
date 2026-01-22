class PPrayerTimeParams {
  const PPrayerTimeParams({required this.lat, required this.lon, required this.method, this.shafaq});

  final double lat;
  final double lon;
  final int method;
  final String? shafaq;

  Map<String, dynamic> toQuery() {
    final resolvedShafaq = shafaq;
    return {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'method': method,
      if (resolvedShafaq != null && resolvedShafaq.trim().isNotEmpty) 'shafaq': resolvedShafaq,
    };
  }
}
