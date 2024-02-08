import 'package:example/example.dart' as example;
import 'package:latlng/latlng.dart';

void main(List<String> arguments) {
  final gt = wgs84.getGroundTrack(
    LatLngAlt(
      Angle.degree(10),
      Angle.degree(10),
      500,
    ),
  );

  print(gt);

  print('Hello world: ${example.calculate()}!');
}
