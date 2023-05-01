part of latlng;

/// A GeoJSON object with the type "FeatureCollection" is a [FeatureCollection] object.
class FeatureCollection {
  /// Default Constructor.
  const FeatureCollection(this.features);

  /// Creates a [FeatureCollection] from JSON data.
  factory FeatureCollection.fromJson(Map<String, dynamic> json) {
    final features = json['features'];

    return FeatureCollection(
      features.map((e) => Feature.fromJson(e)).toList(),
    );
  }

  /// [Feature] list.
  final List<Feature> features;

  /// Converts current object to its JSON representation.
  Map<String, dynamic> toJson() {
    return {
      'type': 'FeatureCollection',
      'features': features.map((e) => e.toJson()).toList()
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
