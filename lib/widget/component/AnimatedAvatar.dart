import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/application/dotted_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UnboundedListView.dart';

class AnimatedAvatarGroup extends StatefulWidget {
  final int itemCount;
  final GroupedAnimatedAvatar Function(BuildContext, int) builder;
  final void Function(int) onIndexChanged;
  final Duration duration;
  final Curve curve;
  final EdgeInsetsGeometry padding;
  final int checked;
  final Axis axis;

  const AnimatedAvatarGroup({
    Key key,
    @required this.itemCount,
    @required this.builder,
    @required this.duration,
    @required this.curve,
    // this.controller,
    this.onIndexChanged,
    this.axis = Axis.horizontal,
    this.padding,
    this.checked,
  }) : super(key: key);

  @override
  _AnimatedAvatarGroupState createState() => _AnimatedAvatarGroupState();
}

class _AnimatedAvatarGroupState extends State<AnimatedAvatarGroup> {
  List<AnimatedAvatar> _list;

  @override
  Widget build(BuildContext context) {
    _list = List.generate(widget.itemCount, (index) {
      final element = widget.builder(context, index);
      return AnimatedAvatar(
        label: element.label,
        duration: widget.duration,
        curve: widget.curve,
        checked: widget.checked == index,
        text: element.text,
        disabled: element.disabled,
        width: element.width,
        color: element.color,
        space: element.space,
        image: element.image,
        padding: element.padding,
        enabledStyle: element.activeStyle,
        disabledStyle: element.inactiveStyle,
        onTap: element.disabled
            ? null
            : () {
                if (widget.onIndexChanged != null) {
                  widget.onIndexChanged(index);
                }
              },
      );
    });
    return UnboundedListView(
      scrollDirection: Axis.horizontal,
      children: _list,
      padding: widget.padding,
    );
//    return SingleChildScrollView(
//      scrollDirection: widget.axis,
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: _list,
//      ),
//    );
  }
}

class GroupedAnimatedAvatar {
  final String text;
  final Widget image;
  final double width;
  final TextStyle activeStyle;
  final TextStyle inactiveStyle;
  final EdgeInsetsGeometry padding;
  final double space;
  final Color color;
  final bool disabled;
  final String label;
  final Key key;

  GroupedAnimatedAvatar({
    this.label,
    this.disabled = false,
    this.color,
    this.text,
    this.image,
    this.space,
    this.width,
    this.padding = EdgeInsets.zero,
    this.activeStyle,
    this.inactiveStyle,
    this.key,
  });
}

class AnimatedAvatar extends ImplicitlyAnimatedWidget {
  final String text;
  final String label;
  final Widget image;
  final double width;
  final TextStyle enabledStyle;
  final TextStyle disabledStyle;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final double space;
  final bool checked;
  final bool disabled;
  final Color color;

  factory AnimatedAvatar.picker(
    String title,
    bool checked, {
    image,
    VoidCallback onTap,
    double width = 50,
  }) =>
      AnimatedAvatar(
        duration: Duration(milliseconds: 200),
        width: width,
        color: AppColors.blue,
        text: title,
        padding: EdgeInsets.only(top: 5),
        space: 5,
        checked: checked,
        disabledStyle: AppTextStyle.mediumBlack,
        enabledStyle: AppTextStyle.mediumBlue,
        image: image,
        onTap: onTap,
      );

  const AnimatedAvatar({
    this.label,
    this.color,
    this.text,
    this.image,
    this.space = 10,
    this.width = 50,
    this.checked = false,
    this.disabled = false,
    this.padding = EdgeInsets.zero,
    this.enabledStyle,
    this.disabledStyle,
    this.onTap,
    Key key,
    @required Duration duration,
    Curve curve = Curves.linear,
  })  : assert(duration != null),
        super(
          key: key,
          duration: duration,
          curve: curve,
        );

  @override
  _AnimatedAvatarState createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends AnimatedWidgetBaseState<AnimatedAvatar> {
  Tween<double> _tween;
  Color _color;

  @override
  void initState() {
    _color = widget.color ?? AppColors.blue;
    super.initState();
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _tween = visitor(_tween, widget.checked ? 2.5 : 0.0,
        (value) => Tween<double>(begin: value));
  }

  TextStyle getTextStyle() {
    if (widget.checked)
      return widget.enabledStyle;
    else
      return widget.disabledStyle;
  }

  Color getBorderColor() {
    if (widget.disabled)
      return _color.withOpacity(0.1);
    else
      return _color;
  }

  @override
  Widget build(BuildContext context) {
    double _width = widget.width;
    Widget main = DottedContainer(
      boxShape: BoxShape.circle,
      dashedLength: 2.0,
      blankLength: _tween.evaluate(animation),
      gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.blue,
            AppColors.deepPurple,
          ],
          stops: [
            0.4,
            0.8
          ]),
      strokeWidth: 2.0,
      dashColor: getBorderColor(),
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
    );
    Widget complete;
    if (widget.label == null) {
      complete = main;
    } else {
      const width = 60.0;
      complete = Stack(
        children: <Widget>[
          main,
          Positioned(
            right: 0,
            child: Container(
              constraints: BoxConstraints(maxWidth: width),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(width / 2),
              ),
              child: Text(
                widget.label.split(" ").first,
                style: AppTextStyle.xxSmallWhite,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
            ),
          )
        ],
      );
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: widget.padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            complete,
            SizedBox(height: widget.space),
            Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: getTextStyle(),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
