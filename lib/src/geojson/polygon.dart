part of latlng;

/// Polygon Geometry.
class Polygon implements Geometry {
  /// Creates a [Polygon].
  const Polygon(this.coordinates);

  /// Creates a [Polygon] from JSON data.
  factory Polygon.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];

    return Polygon(_toLatLngListList(coordinates));
  }

  /// List of rings of polygons in the 2D space.
  final List<List<LatLng>> coordinates;

  /// Converts a [Polygon] to its GeoJSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'type': 'Polygon', 'coordinates': _toListListList(coordinates)};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
