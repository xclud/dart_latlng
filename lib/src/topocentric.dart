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

    return LookAngle(
        azimuth: Angle.radian(azimuth),
        elevation: Angle.radian(elevation),
        range: range);
  }
}
