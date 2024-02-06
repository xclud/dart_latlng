part of '../latlng.dart';

/// Earth-centered, Earth-fixed is a cartesian spatial reference system that represents locations in the vicinity of the [Planet] (including its surface, interior, atmosphere, and surrounding outer space) as X, Y, and Z measurements from its center of mass.
class EarthCenteredEarthFixed {
  /// The default constructor.
  EarthCenteredEarthFixed(this.x, this.y, this.z);

  /// X Coordinate.
  final double x;

  /// Y Coordinate.
  final double y;

  /// Z Coordinate.
  final double z;

  EarthCenteredEarthFixed operator +(EarthCenteredEarthFixed other) {
    final dx = x + other.x;
    final dy = x + other.y;
    final dz = x + other.z;

    return EarthCenteredEarthFixed(dx, dy, dz);
  }

  EarthCenteredEarthFixed operator -(EarthCenteredEarthFixed other) {
    final dx = x - other.x;
    final dy = x - other.y;
    final dz = x - other.z;

    return EarthCenteredEarthFixed(dx, dy, dz);
  }
}
