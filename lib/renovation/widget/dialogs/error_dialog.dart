import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/button/app_button.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String text;

  const ErrorDialog(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalization.of(context).trans('error'),
        style: AppTextStyle.mediumRed,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            maxLines: 12,
            style: AppTextStyle.mediumBlack,
          ),
          SizedBox(height: 10),
          AppButton(
            child: Text(
              AppLocalization.of(context).trans('ok'),
              style: AppTextStyle.largeBlack,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
