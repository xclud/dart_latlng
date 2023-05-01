/// Geodesy and Geographical calculations for Dart. Provides LatLong and Mercator projection (EPSG4326).
library latlng;

import 'dart:convert';
import 'dart:math';

import 'src/lerp.dart' as l;

part 'src/boundary.dart';
part 'src/latlng.dart';
part 'src/projection.dart';
part 'src/tile_index.dart';

part 'src/geojson/feature.dart';
part 'src/geojson/feature_collection.dart';
part 'src/geojson/geometry.dart';
part 'src/geojson/linestring.dart';
part 'src/geojson/multi_point.dart';
part 'src/geojson/point.dart';
part 'src/geojson/polygon.dart';
