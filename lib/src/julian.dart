part of '../latlng.dart';

/// A set of extensions on [DateTime] object.
extension DateTimeExtensions on DateTime {
  double get dayOfYear {
    final diff = difference(DateTime(year, 1, 1, 0, 0));
    final diffInDays = diff.inMilliseconds / 86400000.0;

    return diffInDays;
  }

  /// Calculates the Julian date.
  Julian get julian => Julian.fromDateTime(this);

  /// Calculate Greenwich Mean Sidereal Time according to http://aa.usno.navy.mil/faq/docs/GAST.php
  Angle get gsmt {
    final result = julian.gmst;

    return result;
  }
}

/// Encapsulates a Julian date.
class Julian {
  /// Initialize the Julian date object.
  ///
  /// The first day of the year, Jan 1, is day 1.0. Noon on Jan 1 is
  /// represented by the day value of 1.5, etc.

  const Julian(this.value);
  // Jan  1.5 2000 = Jan  1 2000 12h UTC

  /// Create a Julian date object from a DateTime object. The time
  /// contained in the DateTime object is assumed to be UTC.
  ///
  /// [utc] The UTC time to convert.
  factory Julian.fromDateTime(DateTime utc) {
    double floor(double v) => v.floorToDouble();

    final year = utc.year;
    final mon = utc.month;
    final day = utc.day;
    final hr = utc.hour;
    final minute = utc.minute;
    final sec = utc.second;
    final msec = utc.millisecond;

    final j = 367.0 * year -
            floor(7 * (year + floor((mon + 9) / 12.0)) * 0.25) +
            floor(275 * mon / 9.0) +
            day +
            1721013.5 +
            ((msec / 60000 + sec / 60.0 + minute) / 60.0 + hr) /
                24.0 // ut in days
        // # - 0.5*sgn(100.0*year + mon - 190002.5) + 0.5;
        ;

    return Julian(j);
  }

  /// The Julian date.
  final double value;

  /// Dec 31.5 1899 = Dec 31 1899 12h UTC
  double fromJan0_12h_1900() => value - _j0H12Y1900;

  /// Jan 1.0 1900 = Jan  1 1900 00h UTC
  double fromJan1_00h_1900() => value - _j1H00Y1900;

  /// Jan 1.5 1900 = Jan  1 1900 12h UTC
  double fromJan1_12h_1900() => value - _j1H12Y1900;

  /// Jan 1.5 2000 = Jan  1 2000 12h UTC
  double fromJan1_12h_2000() => value - _j1H12Y2000;

  /// Dec 31.5 1899 = Dec 31 1899 12h UTC
  static const _j0H12Y1900 = 2415020.0;

  /// Jan 1.0 1900 = Jan  1 1900 00h UTC
  static const _j1H00Y1900 = 2415020.5;

  /// Jan 1.5 1900 = Jan  1 1900 12h UTC
  static const _j1H12Y1900 = 2415021.0;

  /// Jan 1.5 2000 = Jan  1 2000 12h UTC
  static const _j1H12Y2000 = 2451545.0;

  /// Adds days.
  Julian addDays(double day) => Julian(value + day);

  /// Adds hours.
  Julian addHours(double hours) => Julian(value + hours / _hoursPerDay);

  /// Adds minutes.
  Julian addMinutes(double min) => Julian(value + min / _minutesPerDay);

  /// Adds seconds.
  Julian addSeconds(double sec) => Julian(value + _secondsPerDay);

  /// Calculate Greenwich Mean Sidereal Time for the Julian date.
  ///
  /// Returns the angle, in radians, measuring eastward from the Vernal Equinox to
  /// the prime meridian. This angle is also referred to as "ThetaG"
  /// (Theta GMST).
  Angle get gmst {
    final jdut1 = value;

    var tut1 = (jdut1 - 2451545.0) / 36525.0;
    var temp = -6.2e-6 * tut1 * tut1 * tut1 +
        0.093104 * tut1 * tut1 +
        (876600.0 * 3600 + 8640184.812866) * tut1 +
        67310.54841; // # sec
    temp =
        temp * _deg2rad / 240.0 % _twopi; // 360/86400 = 1/240, to deg, to rad

    //  ------------------------ check quadrants ---------------------
    if (temp < 0.0) {
      temp += _twopi;
    }
    return Angle.radian(temp);
  }

  /// Calculate Local Mean Sidereal Time for this Julian date at the given
  /// longitude.
  ///
  /// [longitude] The longitude, in radians, measured west from Greenwich.
  ///
  /// The angle, in radians, measuring eastward from the Vernal Equinox to
  /// the given longitude.
  Angle lmst(Angle longitude) {
    final rad = (gmst.radians + longitude.radians) % _twopi;

    return Angle.radian(rad);
  }
}
