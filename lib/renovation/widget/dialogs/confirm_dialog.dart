import 'dart:io';

import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/widget/button/app_button.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String text;
  final String mediaPath;
  final VoidCallback onTap;

  const ConfirmDialog({
    Key key,
    @required this.text,
    this.onTap,
    this.mediaPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalization.of(context).trans('note')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            text,
            style: AppTextStyle.mediumBlack,
          ),
          SizedBox(height: 10),
          if (mediaPath != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(mediaPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppButton(
                child: Text(
                  AppLocalization.of(context).trans('cancel'),
                  style: AppTextStyle.largeBlack,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              AppButton(
                child: Text(
                  AppLocalization.of(context).trans('ok'),
                  style: AppTextStyle.largeBlack,
                ),
                onTap: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
