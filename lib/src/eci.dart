part of '../latlng.dart';

/// Earth-centered inertial (ECI) coordinate frames have their origins at the center of
/// mass of [Planet] and are fixed with respect to the stars.
class EarthCenteredInertial {
  /// The default constructor.
  EarthCenteredInertial(this.x, this.y, this.z);

  /// X Coordinate.
  final double x;

  /// Y Coordinate.
  final double y;

  /// Z Coordinate.
  final double z;

  /// Converts this ECI object to ECF.
  EarthCenteredEarthFixed toEcf(double gmst) {
    double x = this.x * cos(gmst) + this.y * sin(gmst);
    double y = this.x * (-sin(gmst)) + this.y * cos(gmst);

    return EarthCenteredEarthFixed(x, y, z);
  }

  /// Converts this ECI object to ECF.
  EarthCenteredEarthFixed toEcfByDateTime(DateTime utc) {
    return toEcf(utc.toUtc().gsmt);
  }
}
