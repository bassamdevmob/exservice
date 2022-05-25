import 'package:exservice/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final Function() onTap;

  const AppButton({
    this.child,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      backgroundColor: Colors.transparent,
      strokeWidth: 2,
      radius: Radius.circular(5),
      gradient: LinearGradient(
        colors: [
          AppColors.blue,
          AppColors.deepPurple,
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ConstrainedBox(
        constraints: ButtonTheme.of(context).constraints,
        child: SizedBox(
          height: ButtonTheme.of(context).height,
          child: Center(
            child: child,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
