import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/application/dotted_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedAvatar extends ImplicitlyAnimatedWidget {
  final String text;
  final Widget image;
  final double size;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final bool checked;
  final bool disabled;

  const AnimatedAvatar({
    this.text,
    this.image,
    this.size = 50,
    this.checked = false,
    this.disabled = false,
    this.padding = EdgeInsets.zero,
    this.onTap,
    Key key,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
  })  : assert(duration != null),
        super(key: key, duration: duration, curve: curve);

  @override
  _AnimatedAvatarState createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends AnimatedWidgetBaseState<AnimatedAvatar> {
  Tween<double> _tween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween = visitor(_tween, widget.checked ? 2.5 : 0.0,
        (value) => Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    double _width = widget.size;
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: widget.padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DottedContainer(
              boxShape: BoxShape.circle,
              dashedLength: 2.0,
              blankLength: _tween.evaluate(animation),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.blue, AppColors.deepPurple],
                stops: [0.4, 0.8],
              ),
              strokeWidth: 2.0,
              child: Container(
                width: _width,
                height: _width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: ClipOval(child: widget.image),
                ),
              ),
            ),
            Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: widget.checked
                  ? AppTextStyle.mediumBlue
                  : AppTextStyle.mediumBlack,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
