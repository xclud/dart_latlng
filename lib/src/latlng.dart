part of '../latlng.dart';

/// Coordinates in Degrees.
class LatLng {
  /// Default Constructor.
  const LatLng(this.latitude, this.longitude);

  /// Create an instance from degrees.
  LatLng.degree(double latitude, double longitude)
      : latitude = Angle.degree(latitude),
        longitude = Angle.degree(longitude);

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
    final height = geodetic.altitude;
    final radius = planet.radius;
    final f = planet.flattening;

    final e2 = 2 * f - f * f;
    final normal = radius / sqrt(1 - e2 * (sin(latitude) * sin(latitude)));

    final x = (normal + height) * cos(latitude) * cos(longitude);
    final y = (normal + height) * cos(latitude) * sin(longitude);
    final z = (normal * (1 - e2) + height) * sin(latitude);

    return EarthCenteredEarthFixed(x, y, z);
  }
}
