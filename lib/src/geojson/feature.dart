part of latlng;

/// Features are described in section 4.2 of the specification.
class Feature {
  /// Default constructor.
  const Feature({
    required this.geometry,
    this.properties,
    this.id,
  }) : assert(id == null || id is int || id is String);

  /// Creates an object from JSON data.
  factory Feature.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final geometry = json['geometry'];
    final properties = json['properties'];

    final props =
        properties != null ? Map<String, Object>.from(properties) : null;

    Geometry? geo;

    if (geometry != null) {
      final g = Map<String, dynamic>.from(geometry);
      geo = Geometry.fromJson(g);
    }

    return Feature(
      id: id,
      geometry: geo,
      properties: props,
    );
  }

  /// Id of this feature. Either a [String] or [int].
  final Object? id;

  /// [Geometry] of this [Feature].
  final Geometry? geometry;

  /// Properties of this feature.
  final Map<String, Object>? properties;

  /// Converts current object to its JSON representation.
  Map<String, dynamic> toJson() {
    final object = <String, dynamic>{
      'type': 'Feature',
    };

    final i = id;
    final p = properties;
    final g = geometry;

    if (g != null) {
      object['geometry'] = g.toJson();
    }

    if (p != null) {
      object['properties'] = p;
    }
    if (i != null) {
      object['id'] = i;
    }

    return object;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
