part of '../latlng.dart';

/// Represents a look angle.
class LookAngle {
  /// Constructor.
  const LookAngle({
    required this.azimuth,
    required this.elevation,
    required this.range,
  });

  /// Azimuth.
  final Angle azimuth;

  /// Elevation.
  final Angle elevation;

  /// Distance.
  final double range;

  @override
  String toString() {
    return 'Azimuth: ${azimuth.degrees}°, Elevation: ${elevation.degrees}°, Range: $range';
  }
}
