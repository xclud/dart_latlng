part of latlng;

abstract class Projection {
  const Projection();

  /// Converts a [LatLng] to its corresponing [TileIndex] screen coordinates.
  TileIndex toTileIndex(LatLng location);

  /// Converts a [TileIndex] to its corresponing [LatLng].
  LatLng toLatLng(TileIndex tile);
}

extension ProjectionExtensions on Projection {
  TileIndex toTileIndexZoom(LatLng location, double zoom) {
    var ret = toTileIndex(location);

    var mapSize = pow(2.0, zoom);

    return TileIndex(ret.x * mapSize, ret.y * mapSize);
  }

  LatLng toLatLngZoom(TileIndex tile, double zoom) {
    var mapSize = pow(2, zoom);

    final x = tile.x / mapSize;
    final y = tile.y / mapSize;

    final normalTile = TileIndex(x, y);

    return toLatLng(normalTile);
  }

  Iterable<TileIndex> toTileIndexMany(Iterable<LatLng> locations) {
    var ret = locations.map((e) => toTileIndex(e));

    return ret;
  }

  Iterable<LatLng> toLatLngMany(Iterable<TileIndex> tile) {
    var ret = tile.map((e) => toLatLng(e));

    return ret;
  }

  Iterable<TileIndex> toTileIndexManyZoom(
    Iterable<LatLng> locations,
    double zoom,
  ) {
    var ret = locations.map((e) => toTileIndexZoom(e, zoom));

    return ret;
  }

  Iterable<LatLng> toLatLngManyZoom(Iterable<TileIndex> tile, double zoom) {
    var ret = tile.map((e) => toLatLngZoom(e, zoom));

    return ret;
  }
}

/// The Mercator projection is a cylindrical map projection presented
/// by Flemish geographer and cartographer Gerardus Mercator in 1569.
/// It became the standard map projection for navigation because of
/// its unique property of representing any course of constant bearing
/// as a straight segment.
class EPSG4326 extends Projection {
  const EPSG4326();

  static const EPSG4326 instance = EPSG4326();

  @override
  TileIndex toTileIndex(LatLng location) {
    final lng = location.longitude;
    final lat = location.latitude;

    double x = (lng + 180.0) / 360.0;
    double sinLatitude = sin(lat * pi / 180.0);
    double y =
        0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * pi);

    return TileIndex(x, y);
  }

  @override
  LatLng toLatLng(TileIndex tile) {
    final x = tile.x;
    final y = tile.y;

    final xx = x - 0.5;
    final yy = 0.5 - y;

    final lat = 90.0 - 360.0 * atan(exp(-yy * 2.0 * pi)) / pi;
    final lng = 360.0 * xx;

    return LatLng(lat, lng);
  }
}
