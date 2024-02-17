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

  /// Convert this ECF to ECI.
  EarthCenteredInertial toEci(Angle gmst) {
    // ccar.colorado.edu/ASEN5070/handouts/coordsys.doc
    //
    // [X]     [C -S  0][X]
    // [Y]  =  [S  C  0][Y]
    // [Z]eci  [0  0  1][Z]ecf
    //
    var dx = x * cos(gmst.radians) - y * sin(gmst.radians);
    var dy = x * sin(gmst.radians) + y * cos(gmst.radians);
    var dz = z;

    return EarthCenteredInertial(dx, dy, dz);
  }

  /// Convert this ECF to ECI.
  EarthCenteredInertial toEciByDateTime(DateTime utc) =>
      toEci(utc.toUtc().gsmt);

  /// Sum of two ECFs.
  EarthCenteredEarthFixed operator +(EarthCenteredEarthFixed other) {
    return EarthCenteredEarthFixed(x + other.x, y + other.y, z + other.z);
  }

  /// Sub of two ECFs.
  EarthCenteredEarthFixed operator -(EarthCenteredEarthFixed other) {
    return EarthCenteredEarthFixed(x - other.x, y - other.y, z - other.z);
  }
}
