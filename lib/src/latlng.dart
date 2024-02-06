part of '../latlng.dart';

/// Coordinates in Degrees.
class LatLng {
  /// Default Constructor.
  const LatLng(this.latitude, this.longitude);

  /// Latitude, Y Axis.
  final Angle latitude;

  /// Longitude, X Axis.
  final Angle longitude;

  /// Linear interpolation of two [LatLng]s.
  static LatLng lerp(LatLng a, LatLng b, double t) {
    final lat = l.lerp(a.latitude.degrees, b.latitude.degrees, t);
    final lng = l.lerp(a.longitude.degrees, b.longitude.degrees, t);

    return LatLng(Angle.degree(lat), Angle.degree(lng));
  }
}

/// Coordinates in Degrees.
class LatLngAlt {
  /// Default Constructor.
  const LatLngAlt(this.latitude, this.longitude, this.altitude);

  /// Latitude, Y Axis.
  final Angle latitude;

  /// Longitude, X Axis.
  final Angle longitude;

  /// Altitude.
  final double altitude;

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  /// Linear interpolation of two [LatLng]s.
  static LatLngAlt lerp(LatLngAlt a, LatLngAlt b, double t) {
    final lat = l.lerp(a.latitude.degrees, b.latitude.degrees, t);
    final lng = l.lerp(a.longitude.degrees, b.longitude.degrees, t);
    final alt = l.lerp(a.altitude, b.altitude, t);

    return LatLngAlt(Angle.degree(lat), Angle.degree(lng), alt);
  }

  EarthCenteredEarthFixed toEcf(Planet planet) {
    final geodetic = this;
    final longitude = geodetic.longitude.radians;
    final latitude = geodetic.latitude.radians;
    final altitude = geodetic.altitude;
    final radius = planet.radius;
    final flattening = planet.flattening;
    final num = 2.0 * flattening - flattening * flattening;
    final num2 = radius / sqrt(1.0 - num * (sin(latitude) * sin(latitude)));
    final x = (num2 + altitude) * cos(latitude) * cos(longitude);
    final y = (num2 + altitude) * cos(latitude) * sin(longitude);
    final z = (num2 * (1.0 - num) + altitude) * sin(latitude);

    return EarthCenteredEarthFixed(x, y, z);
  }
}
