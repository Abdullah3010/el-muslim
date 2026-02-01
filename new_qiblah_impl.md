You are a senior Flutter + Geo-computation engineer.

Your task is to REIMPLEMENT the Qibla direction feature
to behave exactly like Google Qibla.

========================
BUSINESS GOAL
========================
- Show accurate Qibla direction worldwide
- Same behavior as Google Qibla
- Must be correct in all countries (Egypt, Qatar, Europe, USA, etc.)
- Smooth UX and sensor-safe

========================
TECHNICAL REQUIREMENTS
========================

1) LOCATION
- Use device GPS latitude/longitude
- Handle permissions and errors
- Do NOT hardcode any country-specific logic

2) QIBLA CALCULATION (MANDATORY)
- Use Great Circle (spherical trigonometry)
- Calculate Qibla bearing relative to TRUE NORTH
- Kaaba coordinates:
  - Latitude: 21.4225
  - Longitude: 39.8262
- Formula must use atan2
- Normalize bearing to range [0..360)

Reference implementation (for validation only):

double calculateQiblaBearing(double lat, double lng) {
  const kaabaLat = 21.4225 * pi / 180;
  const kaabaLng = 39.8262 * pi / 180;

  final phi = lat * pi / 180;
  final lambda = lng * pi / 180;

  final y = sin(kaabaLng - lambda);
  final x =
      cos(phi) * tan(kaabaLat) -
      sin(phi) * cos(kaabaLng - lambda);

  final bearing = atan2(y, x) * 180 / pi;
  return (bearing + 360) % 360;
}

3) COMPASS & SENSOR HANDLING
- Use magnetometer + accelerometer
- Convert Magnetic North to True North
- Apply magnetic declination correction
- Support both Android & iOS

4) OFFSET-BASED LOGIC (CRITICAL)
- DO NOT compare absolute compass direction with bearing
- Qibla alignment must be calculated ONLY by offset:

offset = qiblaBearing - deviceHeading

Normalize offset to [-180..180]

- Facing Qibla if:
  abs(offset) <= 5 degrees

- Rotation guidance:
  offset > 0 → rotate RIGHT
  offset < 0 → rotate LEFT

5) UI ROTATION RULE (IMPORTANT)
- Compass arrow rotation must be based on OFFSET only
- Never rotate using raw bearing or raw heading

Transform.rotate(
  angle: -offset * pi / 180
)

6) MAP MODE
- Draw polyline between user and Kaaba
- Must be geodesic = true
- No flat projections

7) UX REQUIREMENTS
- Smooth sensor updates (debounce / low-pass filter)
- Calibration hint if sensor unstable
- Clear feedback:
  - "Rotate Left"
  - "Rotate Right"
  - "You are facing Qibla"

========================
ANTI-PATTERNS (DO NOT DO)
========================
- Do NOT use flat map math
- Do NOT compare direction with offset
- Do NOT rely on Magnetic North without correction
- Do NOT assume Earth is flat
- Do NOT hardcode Egypt / Qatar logic

========================
DELIVERABLES
========================
1) Clean Flutter implementation
2) Well-structured service / controller
3) Stateless UI components
4) Clear comments explaining geo math
5) Works correctly worldwide

========================
VALIDATION CHECKLIST
========================
- Egypt: Qibla ≈ 136°
- Qatar: Qibla ≈ 199°
- Europe: Southeast direction
- USA: East / Northeast curvature

If any country behaves differently than Google Qibla,
the solution is considered incorrect.

Implement now.
