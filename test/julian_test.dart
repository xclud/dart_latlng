import 'package:test/test.dart';
import 'package:latlng/latlng.dart';

final date = DateTime.utc(2024, 2, 9, 15, 4, 11);

var observer = LatLngAlt(
  Angle.degree(36.9613422),
  Angle.degree(-122.0308),
  0.370,
);

void main() {
  group('Julian', () {
    final julian = date.julian;
    test('Day', () {
      expect(julian.value, 2460350.1279050927);
    });
    test('Greenwich Mean Sidereal Time', () {
      expect(julian.gmst.radians, 0.09176249618717236);
    });
  });
}
