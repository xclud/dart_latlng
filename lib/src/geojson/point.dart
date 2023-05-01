part of latlng;

/// Point Geometry.
class Point implements Geometry {
  /// Creates a [Point].
  const Point(this.coordinates);

  /// Creates a [Point] from JSON data.
  factory Point.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];

    return Point(_toLatLng(coordinates));
  }

  /// The point in the 2D space.
  final LatLng coordinates;

  /// Converts a [Point] to its GeoJSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'type': 'Point', 'coordinates': _toList(coordinates)};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
