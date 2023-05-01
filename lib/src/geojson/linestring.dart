part of latlng;

/// LineString Geometry.
class LineString implements Geometry {
  /// Creates a [LineString].
  const LineString(this.coordinates);

  /// Creates a [LineString] from JSON data.
  factory LineString.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];

    return LineString(_toLatLngList(coordinates));
  }

  /// List of points in the 2D space.
  final List<LatLng> coordinates;

  /// Converts a [LineString] to its GeoJSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'type': 'LineString', 'coordinates': _toListList(coordinates)};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
