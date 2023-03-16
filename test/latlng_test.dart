import 'package:test/test.dart';
import 'package:latlng/latlng.dart';

void main() {
  test('Lat, Long test', () {
    final location = LatLng(10, 20);
    expect(location.latitude, 10);
    expect(location.longitude, 20);
  });
}
