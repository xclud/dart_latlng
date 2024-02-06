part of '../latlng.dart';

/// Coordinates in Degrees.
class LatLng {
  /// Default Constructor.
  const LatLng(this.latitude, this.longitude);

  /// Latitude, Y Axis.
  final double latitude;

  /// Longitude, X Axis.
  final double longitude;

  /// Linear interpolation of two [LatLng]s.
  static LatLng lerp(LatLng a, LatLng b, double t) {
    final lat = l.lerp(a.latitude, b.latitude, t);
    final lng = l.lerp(a.longitude, b.longitude, t);

    return LatLng(lat, lng);
  }
}

/// Coordinates in Degrees.
class LatLngAlt {
  /// Default Constructor.
  const LatLngAlt(this.latitude, this.longitude, this.altitude);

  /// Latitude, Y Axis.
  final double latitude;

  /// Longitude, X Axis.
  final double longitude;

  /// Altitude.
  final double altitude;

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  /// Linear interpolation of two [LatLng]s.
  static LatLngAlt lerp(LatLngAlt a, LatLngAlt b, double t) {
    final lat = l.lerp(a.latitude, b.latitude, t);
    final lng = l.lerp(a.longitude, b.longitude, t);
    final alt = l.lerp(a.altitude, b.altitude, t);

    return LatLngAlt(lat, lng, alt);
  }

  EarthCenteredEarthFixed toEcf(Planet planet) {
    final geodetic = this;
    double longitude = geodetic.longitude;
    double latitude = geodetic.latitude;
    double altitude = geodetic.altitude;
    double radius = planet.radius;
    double flattening = planet.flattening;
    double num = 2.0 * flattening - flattening * flattening;
    double num2 = radius / sqrt(1.0 - num * (sin(latitude) * sin(latitude)));
    double x = (num2 + altitude) * cos(latitude) * cos(longitude);
    double y = (num2 + altitude) * cos(latitude) * sin(longitude);
    double z = (num2 * (1.0 - num) + altitude) * sin(latitude);

    return EarthCenteredEarthFixed(x, y, z);
  }
}
