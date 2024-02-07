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

  LatLngAlt toGeodetic(Planet planet, double gmst) {
    // http://www.celestrak.com/columns/v02n03/
    final a = planet.radius;
    final f = planet.flattening;
    final e2 = (2 * f) - (f * f);

    final R = sqrt((x * x) + (y * y));

    var longitude = atan2(y, x) - gmst;
    while (longitude < -pi) {
      longitude += pi * 2;
    }
    while (longitude > pi) {
      longitude -= pi * 2;
    }

    const int kmax = 20;
    var k = 0;
    var latitude = atan2(z, sqrt((x * x) + (y * y)));
    var C = 1.0;
    while (k < kmax) {
      C = 1 / sqrt(1 - (e2 * (sin(latitude) * sin(latitude))));
      latitude = atan2(z + (a * C * e2 * sin(latitude)), R);
      k += 1;
    }

    final height = (R / cos(latitude)) - (a * C);

    return LatLngAlt(
      Angle.radian(latitude),
      Angle.radian(longitude),
      height,
    );
  }

  LatLngAlt toGeodeticByDateTime(Planet planet, DateTime utc) {
    final gmst = Julian.fromDateTime(utc).toGmst();
    return toGeodetic(planet, gmst);
  }
}
