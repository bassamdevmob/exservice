import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/button/app_button.dart';
import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final String text;
  final Function() onTap;
  final bool _isError;

  const NoteDialog(
    this.text, {
    Key key,
    @required this.onTap,
  })  : _isError = false,
        super(key: key);

  const NoteDialog.error(
    this.text, {
    Key key,
    @required this.onTap,
  })  : _isError = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _isError
          ? Text(
              AppLocalization.of(context).trans('err'),
              style: AppTextStyle.mediumRed,
            )
          : Text(
              AppLocalization.of(context).trans('note'),
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
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
