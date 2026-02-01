import 'package:al_muslim/modules/qibla_direction/data/services/qibla_calculation_service.dart';

/// Model representing the current Qibla compass state.
/// Contains all calculated values needed for UI rendering.
class MQiblaCompassState {
  const MQiblaCompassState({
    required this.deviceHeading,
    required this.qiblaBearing,
    required this.offset,
    required this.isFacingQibla,
    required this.rotationDirection,
    this.magneticDeclination = 0,
  });

  /// Device heading in degrees [0..360) relative to TRUE NORTH
  final double deviceHeading;

  /// Qibla bearing in degrees [0..360) relative to TRUE NORTH
  final double qiblaBearing;

  /// Offset between Qibla and device heading in degrees [-180..180]
  /// Positive = rotate RIGHT, Negative = rotate LEFT
  final double offset;

  /// True if user is facing Qibla (abs(offset) <= 5°)
  final bool isFacingQibla;

  /// Direction hint for user to rotate
  final QiblaRotationDirection rotationDirection;

  /// Magnetic declination applied (for debugging)
  final double magneticDeclination;

  /// Rotation angle for UI compass in radians
  /// Use this value directly with Transform.rotate
  double get rotationAngleRad => -offset * 3.14159265359 / 180;

  @override
  String toString() {
    return 'MQiblaCompassState(heading: ${deviceHeading.toStringAsFixed(1)}°, '
        'qibla: ${qiblaBearing.toStringAsFixed(1)}°, '
        'offset: ${offset.toStringAsFixed(1)}°, '
        'facing: $isFacingQibla)';
  }
}
