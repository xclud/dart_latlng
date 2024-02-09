part of '../latlng.dart';

/// Represents a 2D point on screen-space in pixels.
class Point2D {
  const Point2D(this.x, this.y);
  final double x;
  final double y;

  /// Offsets a line by given [amount] in pixels.
  List<Point2D> offset(List<Point2D> points, double amount) {
    final offsetSegments = _offsetPointLine(points, amount);
    return _joinLineSegments(offsetSegments, amount);
  }
}

void _forEachPair<T>(List<T> list, Function(T a, T b) callback) {
  if (list.isEmpty) {
    return;
  }
  for (var i = 1, l = list.length; i < l; i++) {
    callback(list[i - 1], list[i]);
  }
}

/// Find the coefficients (a,b) of a line of equation y = a.x + b,
/// or the constant x for vertical lines
/// Return null if there's no equation possible
class _LineEquation {
  const _LineEquation({this.x, this.a, this.b});

  final double? x;
  final double? a;
  final double? b;
}

class _OffsetSegment {
  const _OffsetSegment({
    required this.offsetAngle,
    required this.original,
    required this.offset,
  });
  final double offsetAngle;
  final List<Point2D> original;
  final List<Point2D> offset;
}

_LineEquation? _lineEquation(Point2D pt1, Point2D pt2) {
  if (pt1.x == pt2.x) {
    return pt1.y == pt2.y ? null : _LineEquation(x: pt1.x);
  }

  var a = (pt2.y - pt1.y) / (pt2.x - pt1.x);
  return _LineEquation(
    a: a,
    b: pt1.y - a * pt1.x,
  );
}

/// Return the intersection point of two lines defined by two points each
/// Return null when there's no unique intersection
Point2D? _intersection(Point2D l1a, Point2D l1b, Point2D l2a, Point2D l2b) {
  var line1 = _lineEquation(l1a, l1b);
  var line2 = _lineEquation(l2a, l2b);

  if (line1 == null || line2 == null) {
    return null;
  }

  if (line1.x != null) {
    return line2.x != null
        ? null
        : Point2D(
            line1.x!,
            line2.a! * line1.x! + line2.b!,
          );
  }
  if (line2.x != null) {
    return Point2D(
      line2.x!,
      line1.a! * line2.x! + line1.b!,
    );
  }

  if (line1.a == line2.a) {
    return null;
  }

  var x = (line2.b! - line1.b!) / (line1.a! - line2.a!);
  return Point2D(
    x,
    line1.a! * x + line1.b!,
  );
}

Point2D _translatePoint(Point2D pt, double dist, double heading) {
  return Point2D(
    pt.x + dist * cos(heading),
    pt.y + dist * sin(heading),
  );
}

List<_OffsetSegment> _offsetPointLine(List<Point2D> points, double distance) {
  var offsetSegments = <_OffsetSegment>[];

  _forEachPair<Point2D>(points, (a, b) {
    if (a.x == b.x && a.y == b.y) {
      return;
    }

    // angles in (-PI, PI]
    var segmentAngle = atan2(a.y - b.y, a.x - b.x);
    var offsetAngle = segmentAngle - pi / 2;

    offsetSegments.add(_OffsetSegment(offsetAngle: offsetAngle, original: [
      a,
      b
    ], offset: [
      _translatePoint(a, distance, offsetAngle),
      _translatePoint(b, distance, offsetAngle)
    ]));
  });

  return offsetSegments;
}

/// Join 2 line segments defined by 2 points each with a circular arc

List<Point2D> _joinSegments(
  _OffsetSegment s1,
  _OffsetSegment s2,
  double offset,
) {
  // TO DO: different join styles
  return _circularArc(s1, s2, offset)
      .where((x) {
        return x != null;
      })
      .map((e) => e!)
      .toList();
}

List<Point2D> _joinLineSegments(List<_OffsetSegment> segments, double offset) {
  var joinedPoints = <Point2D>[];

  if (segments.isNotEmpty) {
    var first = segments.first;
    var last = segments.last;

    joinedPoints.add(first.offset[0]);
    _forEachPair<_OffsetSegment>(segments, (s1, s2) {
      joinedPoints = [...joinedPoints, ..._joinSegments(s1, s2, offset)];
    });
    joinedPoints.add(last.offset[1]);
  }

  return joinedPoints;
}

Point2D _segmentAsVector(List<Point2D> s) {
  return Point2D(
    s[1].x - s[0].x,
    s[1].y - s[0].y,
  );
}

double _getSignedAngle(List<Point2D> s1, List<Point2D> s2) {
  final a = _segmentAsVector(s1);
  final b = _segmentAsVector(s2);
  return atan2(a.x * b.y - a.y * b.x, a.x * b.x + a.y * b.y);
}

/// Interpolates points between two offset segments in a circular form
List<Point2D?> _circularArc(
    _OffsetSegment s1, _OffsetSegment s2, double distance) {
  // if the segments are the same angle,
  // there should be a single join point
  if (s1.offsetAngle == s2.offsetAngle) {
    return [s1.offset[1]];
  }

  final signedAngle = _getSignedAngle(s1.offset, s2.offset);
  // for inner angles, just find the offset segments intersection
  if ((signedAngle * distance > 0) &&
      (signedAngle * _getSignedAngle(s1.offset, [s1.offset[0], s2.offset[1]]) >
          0)) {
    return [
      _intersection(s1.offset[0], s1.offset[1], s2.offset[0], s2.offset[1])
    ];
  }

  // draws a circular arc with R = offset distance, C = original meeting point
  var points = <Point2D>[];
  var center = s1.original[1];
  // ensure angles go in the anti-clockwise direction
  var rightOffset = distance > 0;
  var startAngle = rightOffset ? s2.offsetAngle : s1.offsetAngle;
  var endAngle = rightOffset ? s1.offsetAngle : s2.offsetAngle;
  // and that the end angle is bigger than the start angle
  if (endAngle < startAngle) {
    endAngle += pi * 2;
  }
  var step = pi / 8;
  for (var alpha = startAngle; alpha < endAngle; alpha += step) {
    points.add(_translatePoint(center, distance, alpha));
  }
  points.add(_translatePoint(center, distance, endAngle));

  return rightOffset ? points.reversed.toList() : points;
}
