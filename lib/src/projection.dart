import 'dart:math';

import 'latlng.dart';
import 'tile_index.dart';

abstract class Projection {
  const Projection();

  /// Converts a [LatLng] to its corresponing X-Y screen coordinates.
  TileIndex fromLngLatToTileIndex(LatLng location);

  /// Converts a [TileIndex] to its corresponing geo-coordinates.
  LatLng fromTileIndexToLngLat(TileIndex tile);

  TileIndex fromLngLatToTileIndexWithZoom(LatLng location, double zoom) {
    var ret = fromLngLatToTileIndex(location);

    var mapSize = pow(2.0, zoom);

    return new TileIndex(ret.x * mapSize, ret.y * mapSize);
  }

  LatLng fromTileIndexToLngLatWithZoom(TileIndex tile, double zoom) {
    var mapSize = pow(2, zoom);

    final x = tile.x / mapSize;
    final y = tile.y / mapSize;

    final normalTile = new TileIndex(x, y);

    return fromTileIndexToLngLat(normalTile);
  }
}

/// The Mercator projection is a cylindrical map projection presented
/// by Flemish geographer and cartographer Gerardus Mercator in 1569.
/// It became the standard map projection for navigation because of
/// its unique property of representing any course of constant bearing
/// as a straight segment.
class EPSG4326 extends Projection {
  static const EPSG4326 instance = EPSG4326();

  const EPSG4326();

  @override
  TileIndex fromLngLatToTileIndex(LatLng location) {
    final lng = location.longitude;
    final lat = location.latitude;

    double x = (lng + 180.0) / 360.0;
    double sinLatitude = sin(lat * pi / 180.0);
    double y =
        0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * pi);

    return new TileIndex(x, y);
  }

  @override
  LatLng fromTileIndexToLngLat(TileIndex tile) {
    final x = tile.x;
    final y = tile.y;

    final xx = x - 0.5;
    final yy = 0.5 - y;

    final lat = 90.0 - 360.0 * atan(exp(-yy * 2.0 * pi)) / pi;
    final lng = 360.0 * xx;

    return LatLng(lat, lng);
  }
}
