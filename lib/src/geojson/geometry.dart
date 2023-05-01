part of latlng;

List<double> _toList(LatLng coordinates) {
  return [coordinates.latitude, coordinates.longitude];
}

List<List<double>> _toListList(List<LatLng> coordinates) {
  return coordinates.map(_toList).toList();
}

List<List<List<double>>> _toListListList(List<List<LatLng>> coordinates) {
  return coordinates.map(_toListList).toList();
}

List<List<List<List<double>>>> _toListListListList(
    List<List<List<LatLng>>> coordinates) {
  return coordinates.map(_toListListList).toList();
}

LatLng _toLatLng(dynamic coordinates) {
  final coords = List<num>.from(coordinates, growable: false);
  return LatLng(coords[0].toDouble(), coords[1].toDouble());
}

List<LatLng> _toLatLngList(dynamic coordinates) {
  final coords0 = List.from(coordinates, growable: false);
  final coords1 = coords0.map((e) => _toLatLng(e));

  return coords1.toList();
}

List<List<LatLng>> _toLatLngListList(dynamic coordinates) {
  final coords0 = List.from(coordinates, growable: false);
  final coords1 = coords0.map(_toLatLngList);

  return coords1.toList();
}

List<List<List<LatLng>>> _toLatLngListListList(dynamic coordinates) {
  final coords0 = List.from(coordinates, growable: false);
  final coords1 = coords0.map(_toLatLngListList);

  return coords1.toList();
}

/// Abstract geometry class.
abstract class Geometry {
  /// Creates either a [Point], [LineString], [Polygon], [MultiPoint], [MultiLineString] or [MultiPolygon] from JSON data.
  factory Geometry.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final coordinates = json['coordinates'];

    if (type == 'Point') {
      return Point.fromJson(coordinates);
    }

    if (type == 'LineString') {
      return LineString.fromJson(coordinates);
    }

    if (type == 'Polygon') {
      return Polygon.fromJson(coordinates);
    }

    if (type == 'MultiPoint') {
      return MultiPoint.fromJson(coordinates);
    }

    if (type == 'MultiLineString') {
      return MultiLineString.fromJson(coordinates);
    }

    if (type == 'MultiPolygon') {
      return MultiPolygon.fromJson(coordinates);
    }

    throw Exception('Invalid type: $type.');
  }

  /// Converts a [Geometry] to its GeoJSON representation.
  Map<String, dynamic> toJson();
}
