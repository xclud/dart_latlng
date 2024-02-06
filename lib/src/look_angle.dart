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
  final double azimuth;

  /// Elevation.
  final double elevation;

  /// Distance.
  final double range;
}
