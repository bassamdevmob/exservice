import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';

Future showErrorBottomSheet(
  BuildContext context, {
  String title,
  String message,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: Sizer.bottomSheetBorderRadius,
    ),
    builder: (context) {
      return Padding(
        padding: Sizer.bottomSheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: Sizer.vs3),
            const Center(child: BottomSheetStroke()),
            SizedBox(height: Sizer.vs2),
            Text(
              title,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .primaryTextTheme
                  .displaySmall
                  .copyWith(color: AppColors.red),
            ),
            SizedBox(height: Sizer.vs3),
            Text(
              message,
              textAlign: TextAlign.start,
              style: Theme.of(context).primaryTextTheme.labelLarge,
            ),
          ],
        ),
      );
    },
  );
}
