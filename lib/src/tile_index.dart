part of latlng;

/// Index of tile on tile-map. On zoom level 0 ranges between [0, 1].
class TileIndex {
  /// Default Constructor.
  const TileIndex(this.x, this.y);

  /// Hortizontal Axis.
  final double x;

  /// Vertical Axis.
  final double y;

  /// Subtracts two [TileIndex]s.
  TileIndex operator -(TileIndex other) {
    return TileIndex(x - other.x, y - other.y);
  }

  /// Adds two [TileIndex]s.
  TileIndex operator +(TileIndex other) {
    return TileIndex(x + other.x, y + other.y);
  }

  /// Multiplies a [TileIndex] with an scalar.
  TileIndex operator *(double scale) {
    return TileIndex(x * scale, y * scale);
  }

  /// Divides a [TileIndex] with an scalar.
  TileIndex operator /(double scale) {
    return TileIndex(x / scale, y / scale);
  }

  /// Linear interpolation of two [TileIndex]s.
  static TileIndex lerp(TileIndex a, TileIndex b, double t) {
    final x = l.lerp(a.x, b.x, t);
    final y = l.lerp(a.y, b.y, t);

    return TileIndex(x, y);
  }
}
