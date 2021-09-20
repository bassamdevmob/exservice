import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function onTap;
  final double elevation;
  final BorderSide border;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const CustomAppButton({
    Key key,
    this.child,
    this.onTap,
    this.color,
    this.border = BorderSide.none,
    this.elevation = 5,
    this.borderRadius,
    this.margin,
    this.padding = const EdgeInsets.all(4),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btn = Material(
      elevation: elevation,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: border,
      ),
      child: InkWell(
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: child,
        ),
        onTap: onTap,
      ),
    );
    if (margin == null) {
      return btn;
    } else {
      return Padding(
        padding: margin,
        child: btn,
      );
    }
  }
}
