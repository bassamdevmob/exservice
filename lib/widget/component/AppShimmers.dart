import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius _borderRadius;
  final Widget child;
  final Duration period;

  CustomShimmer.normal({
    this.height,
    this.width,
    this.child,
    this.period,
  }) : _borderRadius = null;

  CustomShimmer.circular({
    this.height,
    this.width,
    this.child,
    this.period,
  }) : _borderRadius = BorderRadius.circular(100);

  CustomShimmer.squarer({
    this.height,
    this.width,
    this.child,
    this.period,
  }) : _borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      period: period ?? const Duration(milliseconds: 1500),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: _borderRadius,
          color: Colors.white,
        ),
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
