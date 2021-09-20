import 'package:exservice/controller/InfoManager.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/widget/component/AnimatedAvatar.dart';
import 'package:flutter/material.dart';

import 'HelperWidgets.dart';

class AdPicker extends StatelessWidget {
  final InfoPicker info;
  final Function(int) onSubIndexChange;
  final int checked;

  const AdPicker({
    Key key,
    this.info,
    this.onSubIndexChange,
    this.checked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (info.options == null || info.options.isEmpty) return SizedBox();
    final options = info.options;
    return Column(
      children: <Widget>[
        AnimatedAvatarGroup(
          checked: checked,
          onIndexChanged: onSubIndexChange,
          duration: Duration(milliseconds: 200),
          curve: Curves.linear,
          itemCount: options.length,
          builder: (context, index) {
            // print("${options[index].id} ${options[index].image}");
            return GroupedAnimatedAvatar(
              key: UniqueKey(),
              text: options[index].title,
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 10),
              space: 5,
              inactiveStyle: AppTextStyle.mediumBlack,
              activeStyle: AppTextStyle.mediumGray,
              image: constructImageProvider(
                NetworkImage('${options[index].image}'),
              ),
              width: 50,
            );
          },
        ),
        Divider(height: 2),
      ],
    );
  }
}

class AdSlider extends StatelessWidget {
  final InfoSlider info;
  final Function(double) onSliderChange;

  const AdSlider({
    Key key,
    this.info,
    this.onSliderChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Slider(
        divisions: 100,
        label: '${info.title}',
        value: info.value,
        onChanged: onSliderChange,
      ),
    );
  }
}
