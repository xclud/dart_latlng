part of '../latlng.dart';

/// Topocentric parameters.
class Topocentric {
  /// The constructor.
  const Topocentric({
    required this.south,
    required this.east,
    required this.normal,
  });

  /// South
  final double south;

  /// East
  final double east;

  /// Normal
  final double normal;

  /// Converts to [LookAngle].
  LookAngle toLookAngle() {
    final range = sqrt(south * south + east * east + normal * normal);
    final elevation = asin(normal / range);
    final azimuth = atan2(-east, south) + pi;

    return LookAngle(azimuth: azimuth, elevation: elevation, range: range);
  }
}

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
