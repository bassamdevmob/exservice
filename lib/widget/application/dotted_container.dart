import 'package:dashed_container/dashed_container.dart'
    show CircularIntervalList, dashPath;
import 'package:flutter/material.dart';

class DottedContainer extends StatelessWidget {
  final Color dashColor;

  /// Width of the stroke, default is 1.0
  final double strokeWidth;

  /// Length of blank space, default 5.0
  final double blankLength;

  /// Length of dashed line, default 5.0
  final double dashedLength;
  final Widget child;
  final double borderRadius;
  final BoxShape boxShape;
  final Gradient gradient;

  DottedContainer({
    @required this.child,
    this.dashColor = Colors.black,
    this.strokeWidth = 1.0,
    this.blankLength = 5.0,
    this.dashedLength = 5.0,
    this.borderRadius = 0.0,
    this.boxShape = BoxShape.rectangle,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashPathPainter(
        gradient: gradient,
        strokeWidth: strokeWidth,
        dashColor: dashColor,
        blankWidth: blankLength,
        dashedWidth: dashedLength,
        borderRadius: borderRadius,
        boxShape: boxShape,
      ),
      child: child,
    );
  }
}

class DashPathPainter extends CustomPainter {
  final double blankWidth;
  final double dashedWidth;
  final double borderRadius;
  final BoxShape boxShape;
  final double strokeWidth;
  final Color dashColor;
  final Gradient gradient;

  DashPathPainter({
    this.blankWidth,
    this.dashedWidth,
    this.borderRadius,
    this.boxShape,
    this.strokeWidth,
    this.dashColor,
    this.gradient,
  });

  @override
  bool shouldRepaint(DashPathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
        size.width - strokeWidth, size.height - strokeWidth);

    final Paint mPaint = Paint()
      ..color = dashColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    Path p;
    double bRadius = borderRadius;

    if (boxShape == BoxShape.rectangle) {
      if (bRadius == 0)
        p = Path()..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
      else {
        Radius radius = Radius.circular(bRadius);
        p = Path()
          ..addRRect(
            RRect.fromRectAndCorners(
              Rect.fromLTWH(0.0, 0.0, size.width, size.height),
              bottomLeft: radius,
              bottomRight: radius,
              topLeft: radius,
              topRight: radius,
            ),
          );
      }
    } else {
      bRadius = size.width / 2;
      Radius radius = Radius.circular(bRadius);
      p = Path()
        ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(0.0, 0.0, size.width, size.height),
            bottomLeft: radius,
            bottomRight: radius,
            topLeft: radius,
            topRight: radius,
          ),
        );
    }
    canvas.drawPath(
      dashPath(
        p,
        dashArray: CircularIntervalList<double>(
          <double>[
            dashedWidth,
            blankWidth,
          ],
        ),
      ),
      mPaint,
    );
  }
}

class OutlineContainer extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final double _dimension;
  final double _strokeWidth;

  OutlineContainer({
    @required double strokeWidth,
    @required double radius,
    @required Gradient gradient,
    @required Widget child,
    @required double dimension,
  })  : this._painter = _GradientPainter(
      strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        this._dimension = dimension,
        this._strokeWidth = strokeWidth,
        this._child = child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _dimension,
      height: _dimension,
      child: CustomPaint(
        painter: _painter,
        child: Padding(
          padding: EdgeInsets.all(_strokeWidth),
          child: _child,
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {@required double strokeWidth,
        @required double radius,
        @required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
    RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
