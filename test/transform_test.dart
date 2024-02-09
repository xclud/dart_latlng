import 'package:test/test.dart';
import 'package:latlng/latlng.dart';

final date = DateTime.utc(2024, 2, 9, 15, 4, 11);

var observer = LatLngAlt(
  Angle.degree(36.9613422),
  Angle.degree(-122.0308),
  0.370,
);

void main() {
  group('Transforms', () {
    final eci = EarthCenteredInertial(1200, 1300, 1400);
    final ecf = eci.toEcfByDateTime(date);

    test('ECI -> ECF', () {
      expect(ecf.x, 1314.0752337608803);
      expect(ecf.y, 1184.5700823574298);
    });

    final topocentric = wgs84.topocentric(observer, ecf);
    test('ECF -> Topocentric', () {
      expect(topocentric.east, 485.75807117112936);
      expect(topocentric.south, -2162.0799754449126);
      expect(topocentric.normal, -6888.316804233157);
    });

    final lookAngle = topocentric.toLookAngle();

    test('Topocentric -> Look Angle', () {
      expect(lookAngle.azimuth.radians, 0.22100189021015426);
      expect(lookAngle.elevation.radians, -1.2595514317723322);
      expect(lookAngle.range, 7235.983631781422);
    });
  });
}
