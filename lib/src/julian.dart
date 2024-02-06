part of '../latlng.dart';

/// Calculates the Julian date.
double _julian(int year, double doy) {
  // Now calculate Julian date
  // Ref: "Astronomical Formulae for Calculators", Jean Meeus, pages 23-25

  year--;

  // Centuries are not leap years unless they divide by 400
  int A = year ~/ 100;
  int B = 2 - A + (A ~/ 4);

  double jan01 =
      (365.25 * year).toInt() + (30.6001 * 14).toInt() + 1720994.5 + B;

  return jan01 + doy;
}

double _dayOfYear(DateTime someDate) {
  final diff = someDate.difference(DateTime(someDate.year, 1, 1, 0, 0));
  final diffInDays = diff.inMilliseconds / 86400000.0;

  return diffInDays;
}

/// A set of extensions on [DateTime] object.
extension DateTimeExtensions on DateTime {
  /// Calculates the Julian date.
  double get julian {
    final doy = _dayOfYear(this);
    final julianDay = _julian(year, doy);

    return julianDay;
  }

  /// Calculate Greenwich Mean Sidereal Time according to http://aa.usno.navy.mil/faq/docs/GAST.php
  double get gsmt {
    final j = julian;

    final d1 = j - 2451545.0;
    final d2 = (j + 0.5) % 1.0;
    final d3 = (d1 - d2) / 36525.0;
    var d4 =
        24110.54841 + d3 * (8640184.812866 + d3 * (0.093104 - d3 * 6.2E-06));

    d4 = (d4 + 86636.555366976 * d2) % 86400.0;

    if (d4 < 0.0) {
      d4 += 86400.0;
    }

    final result = pi * 2.0 * (d4 / 86400.0);

    return result;
  }
}
