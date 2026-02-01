import 'dart:math';

/// Service for calculating Qibla direction using Great Circle (spherical trigonometry).
/// This provides accurate Qibla bearing relative to TRUE NORTH worldwide.
class QiblaCalculationService {
  QiblaCalculationService._();

  /// Kaaba coordinates in Mecca, Saudi Arabia
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// Kaaba coordinates in radians (pre-calculated for efficiency)
  static const double _kaabaLatRad = kaabaLatitude * pi / 180;
  static const double _kaabaLngRad = kaabaLongitude * pi / 180;

  /// Calculates the Qibla bearing from a given location using Great Circle formula.
  ///
  /// [latitude] - User's latitude in degrees
  /// [longitude] - User's longitude in degrees
  ///
  /// Returns bearing in degrees [0..360) relative to TRUE NORTH
  ///
  /// Formula uses atan2 for accurate bearing calculation:
  /// y = sin(λ_kaaba - λ_user)
  /// x = cos(φ_user) * tan(φ_kaaba) - sin(φ_user) * cos(λ_kaaba - λ_user)
  /// bearing = atan2(y, x)
  static double calculateQiblaBearing(double latitude, double longitude) {
    final double userLatRad = latitude * pi / 180;
    final double userLngRad = longitude * pi / 180;

    final double deltaLng = _kaabaLngRad - userLngRad;

    final double y = sin(deltaLng);
    final double x = cos(userLatRad) * tan(_kaabaLatRad) - sin(userLatRad) * cos(deltaLng);

    final double bearingRad = atan2(y, x);
    final double bearingDeg = bearingRad * 180 / pi;

    return _normalizeBearing(bearingDeg);
  }

  /// Calculates the offset between Qibla bearing and device heading.
  ///
  /// [qiblaBearing] - Qibla direction in degrees [0..360)
  /// [deviceHeading] - Device compass heading in degrees [0..360)
  ///
  /// Returns offset in degrees [-180..180]
  /// - Positive offset: rotate RIGHT to face Qibla
  /// - Negative offset: rotate LEFT to face Qibla
  static double calculateOffset(double qiblaBearing, double deviceHeading) {
    double offset = qiblaBearing - deviceHeading;
    return _normalizeOffset(offset);
  }

  /// Checks if the user is facing Qibla within tolerance.
  ///
  /// [offset] - The offset angle in degrees
  /// [tolerance] - Acceptable deviation in degrees (default 5°)
  ///
  /// Returns true if abs(offset) <= tolerance
  static bool isFacingQibla(double offset, {double tolerance = 5.0}) {
    return offset.abs() <= tolerance;
  }

  /// Gets the rotation direction hint.
  ///
  /// Returns:
  /// - `QiblaRotationDirection.none` if facing Qibla
  /// - `QiblaRotationDirection.right` if offset > 0
  /// - `QiblaRotationDirection.left` if offset < 0
  static QiblaRotationDirection getRotationDirection(double offset, {double tolerance = 5.0}) {
    if (isFacingQibla(offset, tolerance: tolerance)) {
      return QiblaRotationDirection.none;
    }
    return offset > 0 ? QiblaRotationDirection.right : QiblaRotationDirection.left;
  }

  /// Normalizes bearing to range [0..360)
  static double _normalizeBearing(double bearing) {
    return (bearing + 360) % 360;
  }

  /// Normalizes offset to range [-180..180]
  static double _normalizeOffset(double offset) {
    while (offset > 180) {
      offset -= 360;
    }
    while (offset < -180) {
      offset += 360;
    }
    return offset;
  }
}

/// Direction hint for user to rotate towards Qibla
enum QiblaRotationDirection { none, left, right }
