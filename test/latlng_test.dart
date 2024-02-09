import 'package:test/test.dart';
import 'package:latlng/latlng.dart';

void main() {
  // test('Julian', () {
  //   final date = DateTime.utc(2024, 2, 9, 22, 4, 11);
  //   final julian = date.julian;

  //   expect(julian.gmst.degrees, 8.943690756103024);
  // });

  test('Lat, Long test', () {
    final location = LatLng(Angle.degree(10), Angle.degree(20));
    expect(location.latitude.degrees, 10);
    expect(location.longitude.degrees, 20);
  });
}
