
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/utils/utils.dart';
import 'package:exservice/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';

Future<dynamic> showErrorBottomSheet(
    BuildContext context, String title, String message) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: Utils.bottomSheetBorderRadius(MediaQuery.of(context)),
    ),
    builder: (ctx) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                Utils.forgetPasswordBottomSheetPadding(MediaQuery.of(context)),
            // height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius:
                    Utils.bottomSheetBorderRadius(MediaQuery.of(context)),
                color: AppColors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: Utils.verticalSpace(MediaQuery.of(context)),
                ),
                LineBottomSheetWidget(),
                SizedBox(
                  height: Utils.verticalSpace(MediaQuery.of(context)) * 1.5,
                ),
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: AppColors.redAccent, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Utils.verticalSpace(MediaQuery.of(context)),
                ),
                Text(
                  message,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
