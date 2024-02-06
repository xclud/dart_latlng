part of '../latlng.dart';

/// Represents an angle.
class Angle {
  Angle._(this.degrees, this.radians);

  /// From degrees.
  Angle.degree(double value) : this._(value, value * _deg2rad);

  /// From degrees.
  Angle.radian(double value) : this._(value * _rad2deg, value);

  /// In degrees.
  final double degrees;

  /// In radians.
  final double radians;

  @override
  String toString() {
    return '$degrees° ($radians rad)';
  }
}
