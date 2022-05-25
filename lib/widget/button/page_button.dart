import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final String text;
  final bool disabled;
  final VoidCallback onTap;

  const PageButton({
    Key key,
    this.text,
    this.disabled,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Text(
            text,
            style:
                disabled ? AppTextStyle.mediumGray : AppTextStyle.mediumBlack,
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: disabled ? AppColors.gray : AppColors.black,
                width: disabled ? 1 : 2,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
