import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_font_size.dart';
import 'package:flutter/material.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';

class AnimatedCrossIcon extends ImplicitlyAnimatedWidget {
  final bool value;
  final IconData startIcon;
  final IconData endIcon;

  AnimatedCrossIcon({
    this.startIcon,
    this.endIcon,
    this.value = true,
    Key key,
  }) : super(key: key, duration: Duration(milliseconds: 200));

  @override
  _AnimatedCrossIconState createState() => _AnimatedCrossIconState();
}

class _AnimatedCrossIconState
    extends AnimatedWidgetBaseState<AnimatedCrossIcon> {
  Tween<double> _tween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween = visitor(
      _tween,
      widget.value ? 1.0 : 0.0,
      (value) => Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      key: ValueKey(widget.value),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: SimpleAnimatedIcon(
        key: ValueKey(widget.value),
        startIcon: widget.startIcon,
        endIcon: widget.endIcon,
        progress: _tween.animate(animation),
        color: AppColors.white,
        size: AppFontSize.LARGE,
      ),
    );
  }
}
