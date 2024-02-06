import 'package:test/test.dart';
import 'package:latlng/latlng.dart';

void main() {
  test('Lat, Long test', () {
    final location = LatLng(Angle.degree(10), Angle.degree(20));
    expect(location.latitude.degrees, 10);
    expect(location.longitude.degrees, 20);
  });
}
