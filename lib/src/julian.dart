part of '../latlng.dart';

double _dayOfYear(DateTime someDate) {
  final diff = someDate.difference(DateTime(someDate.year, 1, 1, 0, 0));
  final diffInDays = diff.inMilliseconds / 86400000.0;

  return diffInDays;
}

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
  double get gsmt {
    final result = julian.toGmst();

    return result;
  }
}

/// Encapsulates a Julian date.
class Julian {
  // Jan  1.5 2000 = Jan  1 2000 12h UTC

  /// Create a Julian date object from a DateTime object. The time
  /// contained in the DateTime object is assumed to be UTC.
  ///
  /// [utc] The UTC time to convert.
  factory Julian.fromDateTime(DateTime utc) {
    final v = _dayOfYear(utc) +
        ((utc.hour +
                ((utc.minute +
                        ((utc.second + (utc.millisecond / 1000.0)) / 60.0)) /
                    60.0)) /
            24.0);

    return Julian._(v);
  }

  /// Initialize the Julian date object.
  ///
  /// The first day of the year, Jan 1, is day 1.0. Noon on Jan 1 is
  /// represented by the day value of 1.5, etc.

  const Julian._(this.value);

  /// Create a Julian date object given a year and day-of-year.
  ///
  /// [year] The year, including the century (i.e., 2012).
  /// [doy] Day of year (1 means January 1, etc.).

  /// The fractional part of the day value is the fractional portion of
  /// the day.
  /// Examples:
  ///    day = 1.0  Jan 1 00h
  ///    day = 1.5  Jan 1 12h
  ///    day = 2.0  Jan 2 00h
  factory Julian.fromYearAndDoy(int year, double doy) {
    // Arbitrary years used for error checking
    if (year < 1900 || year > 2100) {
      throw Exception('Year (1900, 2100)');
    }

    // The last day of a leap year is day 366
    if (doy < 1.0 || doy >= 367.0) {
      throw Exception('Day (1, 367)');
    }

    // Now calculate Julian date
    // Ref: "Astronomical Formulae for Calculators", Jean Meeus, pages 23-25

    year--;

    // Centuries are not leap years unless they divide by 400
    int A = year ~/ 100;
    int B = 2 - A + (A ~/ 4);

    final jan01 =
        (365.25 * year).floor() + (30.6001 * 14).floor() + 1720994.5 + B;

    return Julian._(jan01 + doy);
  }

  /// Calculates the time difference between two Julian dates.
  ///
  /// Returns a [Duration] representing the time difference between the two dates.
  Duration diffrence(Julian other) {
    return toDateTime().difference(other.toDateTime());
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
  Julian addDays(double day) => Julian._(value + day);

  /// Adds hours.
  Julian addHours(double hours) => Julian._(value + hours / _hoursPerDay);

  /// Adds minutes.
  Julian addMinutes(double min) => Julian._(value + min / _minutesPerDay);

  /// Adds seconds.
  Julian addSeconds(double sec) => Julian._(value + _secondsPerDay);

  /// Calculate Greenwich Mean Sidereal Time for the Julian date.
  ///
  /// Returns the angle, in radians, measuring eastward from the Vernal Equinox to
  /// the prime meridian. This angle is also referred to as "ThetaG"
  /// (Theta GMST).
  double toGmst() {
    // References:
    //    The 1992 Astronomical Almanac, page B6.
    //    Explanatory Supplement to the Astronomical Almanac, page 50.
    //    Orbital Coordinate Systems, Part III, Dr. T.S. Kelso,
    //       Satellite Times, Nov/Dec 1995

    final ut = (value + 0.5) % 1.0;
    final tu = (fromJan1_12h_2000() - ut) / 36525.0;

    double gmst = 24110.54841 +
        (tu * (8640184.812866 + (tu * (0.093104 - (tu * 6.2e-06)))));

    gmst = (gmst + (_secondsPerDay * _omegaE * ut)) % _secondsPerDay;

    if (gmst < 0.0) {
      gmst += _secondsPerDay; // "wrap" negative modulo value
    }

    return _twopi * (gmst / _secondsPerDay);
  }

  /// Calculate Local Mean Sidereal Time for this Julian date at the given
  /// longitude.
  ///
  /// [longitude] The longitude, in radians, measured west from Greenwich.
  ///
  /// The angle, in radians, measuring eastward from the Vernal Equinox to
  /// the given longitude.
  double toLmst(double longitude) {
    return (toGmst() + longitude) % _twopi;
  }

  /// Returns a UTC DateTime object that corresponds to this Julian date.
  DateTime toDateTime() {
    final d2 = value + 0.5;
    final Z = d2.floor();
    final alpha = ((Z - 1867216.25) / 36524.25).floor();
    final A = Z + 1 + alpha - (alpha ~/ 4);
    final B = A + 1524;
    final C = ((B - 122.1) / 365.25).floor();
    final D = (365.25 * C).floor();
    final E = ((B - D) / 30.6001).floor();

    // For reference: the fractional day of the month can be
    // calculated as follows:
    //
    // double day = B - D - (int)(30.6001 * E) + F;

    final month = (E <= 13) ? (E - 1) : (E - 13);
    final year = (month >= 3) ? (C - 4716) : (C - 4715);

    final jdJan01 = Julian.fromYearAndDoy(year, 1.0);
    final doy = value - jdJan01.value; // zero-relative
    final r = doy - doy.floor();
    final h = r / 24.0;
    final m = h / 60.0;
    final s = m / 60.0;
    final ms = s / 1000.0;
    final ks = ms / 1000.0;

    final dtJan01 = DateTime(year, 1, 1, 0, 0, 0);

    return dtJan01.add(
      Duration(
        days: doy.floor(),
        hours: h.floor(),
        minutes: m.floor(),
        seconds: s.floor(),
        milliseconds: ms.floor(),
        microseconds: ks.floor(),
      ),
    );
  }
}
