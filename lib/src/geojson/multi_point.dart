part of latlng;

/// Represents a multi-point geometry.
class MultiPoint implements Geometry {
  /// Creates a [MultiPoint].
  const MultiPoint(this.coordinates);

  /// Creates a [MultiPoint] from JSON data.
  factory MultiPoint.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];

    return MultiPoint(_toLatLngList(coordinates).map((e) => Point(e)).toList());
  }

  /// The list of [Point]s.
  final List<Point> coordinates;

  /// Converts a [MultiPoint] to its GeoJSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'MultiPoint',
      'coordinates': _toListList(coordinates.map((e) => e.coordinates).toList())
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

/// Represents a multi-linestring geometry.
class MultiLineString implements Geometry {
  /// Creates a [MultiLineString].
  const MultiLineString(this.coordinates);

  /// Creates a [MultiLineString] from JSON data.
  factory MultiLineString.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];

    return MultiLineString(
      _toLatLngListList(coordinates).map((e) => LineString(e)).toList(),
    );
  }

  /// The list of [LineString]s.
  final List<LineString> coordinates;

  /// Converts a [MultiLineString] to its GeoJSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'MultiLineString',
      'coordinates':
          _toListListList(coordinates.map((e) => e.coordinates).toList())
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

/// Represents a multi-polygon geometry.
class MultiPolygon implements Geometry {
  /// Creates a [MultiPolygon].
  const MultiPolygon(this.coordinates);

  /// Creates a [MultiPolygon] from JSON data.
  factory MultiPolygon.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];

    return MultiPolygon(
      _toLatLngListListList(coordinates).map((e) => Polygon(e)).toList(),
    );
  }

  /// The list of [Polygon]s.
  final List<Polygon> coordinates;

  /// Converts a [MultiPolygon] to its GeoJSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'MultiPolygon',
      'coordinates':
          _toListListListList(coordinates.map((e) => e.coordinates).toList())
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
