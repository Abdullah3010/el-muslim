import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class MQiblaLocationState {
  MQiblaLocationState({required this.status, DateTime? updatedAt}) : updatedAt = updatedAt ?? DateTime.now();

  final LocationStatus status;
  final DateTime updatedAt;

  bool get isEnabled => status.enabled;
  LocationPermission get permission => status.status;
  bool get isPermissionGranted =>
      permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  bool get isPermissionDenied => permission == LocationPermission.denied;
  bool get isPermissionDeniedForever => permission == LocationPermission.deniedForever;
}
