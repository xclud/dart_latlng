part of latlng;

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
}
