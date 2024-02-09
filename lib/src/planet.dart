part of '../latlng.dart';

/// Abstract planet for calculations.
abstract class Planet {
  /// The constructor.
  const Planet({
    required this.radius,
    required this.mu,
    required this.j2,
    required this.j3,
    required this.j4,
    required this.flattening,
  });

  /// Radius of the planet in Kilometers.
  final double radius;

  /// Gravitational constant.
  final double mu;

  /// j2
  final double j2;

  /// j3
  final double j3;

  /// j4
  final double j4;

  /// Flattening of the planet.
  final double flattening;

  /// Gets a polygon on the surface of the planet where a [satellite] or flying object can see.
  ///
  /// [satellite] Altitude must be in Kilometers and positive (altitude > 0).
  List<LatLng> getGroundTrack(
    LatLngAlt satellite, {
    double precesion = 1,
  }) {
    final zone = <LatLng>[];

    final latitude = satellite.latitude.radians;
    final longitude = satellite.longitude.radians;
    final temp = satellite.altitude;

    if (temp <= 0) {
      throw Exception('Altitude must be higher then 0 ($temp).');
    }

    final altitude = radius + temp;

    final cosLat = cos(latitude);
    final sinLat = sin(latitude);

    double asocAlt = acos(radius / altitude);
    if (asocAlt.isNaN) {
      asocAlt = 0.0;
    }
    final cosAlt = cos(asocAlt);
    final sinAlt = sin(asocAlt);
    int i = 0;
    do {
      final angle = pi / 180.0 * i;
      final lat = asin(sinLat * cosAlt + cos(angle) * sinAlt * cosLat);
      final num9 = (cosAlt - sinLat * sin(lat)) / (cosLat * cos(lat));
      final lng = (((i != 0 || !(asocAlt > pi / 2.0 - latitude)) && 0 == 0)
          ? (((i == 180 && asocAlt > pi / 2.0 + latitude))
              ? (longitude + pi)
              : ((num9.abs() > 1.0)
                  ? longitude
                  : ((i > 180)
                      ? (longitude - acos(num9))
                      : (longitude + acos(num9)))))
          : (longitude + pi));

      final z = LatLng(
        Angle.radian(lat),
        Angle.radian(lng),
      );

      zone.add(z);

      i++;
    } while (i <= 359);

    zone.add(
      LatLng(
        zone[0].latitude,
        zone[0].longitude,
      ),
    );

    return zone;
  }

  /// Calculates Topocentrics.
  Topocentric topocentric(
    LatLngAlt observer,
    EarthCenteredEarthFixed satellite,
  ) {
    final longitude = observer.longitude.radians;
    final latitude = observer.latitude.radians;
    final earthCenteredEarthFixed = observer.toEcf(this);
    final dx = satellite.x - earthCenteredEarthFixed.x;
    final dy = satellite.y - earthCenteredEarthFixed.y;
    final dz = satellite.z - earthCenteredEarthFixed.z;

    final south = sin(latitude) * cos(longitude) * dx +
        sin(latitude) * sin(longitude) * dy -
        cos(latitude) * dz;
    final east = (0.0 - sin(longitude)) * dx + cos(longitude) * dy;
    final normal = cos(latitude) * cos(longitude) * dx +
        cos(latitude) * sin(longitude) * dy +
        sin(latitude) * dz;

    return Topocentric(south: south, east: east, normal: normal);
  }
}

/// Represents Earth planet.
class Earth extends Planet {
  const Earth._({
    required double radius,
    required double mu,
    required double j2,
    required double j3,
    required double j4,
    required double flattening,
  }) : super(
          radius: radius,
          mu: mu,
          j2: j2,
          j3: j3,
          j4: j4,
          flattening: flattening,
        );

  /// Represents a WGS72 Earth.
  factory Earth.wgs72() => wgs72;

  /// Represents a WGS84 Earth.
  factory Earth.wgs84() => wgs84;
}

const wgs72 = Earth._(
  radius: 6378.135,
  mu: 398600.8,
  j2: 0.0010826162,
  j3: -0.00000253881,
  j4: -0.00000165597,
  flattening: 1 / 298.26,
);

const wgs84 = Earth._(
  radius: 6378.137,
  mu: 398600.5,
  j2: 0.00108262998905,
  j3: -0.00000253215306,
  j4: -0.00000161098761,
  flattening: 0.0033528106718309306,
);
