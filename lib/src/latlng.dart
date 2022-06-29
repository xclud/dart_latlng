import 'lerp.dart' as l;

/// Coordinates in Degrees.
class LatLng {
  /// Latitude, Y Axis.
  double latitude;

  /// Longitude, X Axis.
  double longitude;

  /// Default Constructor.
  LatLng(this.latitude, this.longitude);

  /// Linear interpolation of two [LatLng]s.
  static LatLng lerp(LatLng a, LatLng b, double t) {
    final lat = l.lerp(a.latitude, b.latitude, t);
    final lng = l.lerp(a.longitude, b.longitude, t);

    return LatLng(lat, lng);
  }
}
