part of latlng;

class Boundary {
  const Boundary({
    required this.topLeft,
    required this.bottomRight,
  });

  final LatLng topLeft;
  final LatLng bottomRight;

  LatLng get topRight => LatLng(topLeft.latitude, bottomRight.longitude);
  LatLng get bottomLeft => LatLng(bottomRight.latitude, topLeft.longitude);
}
