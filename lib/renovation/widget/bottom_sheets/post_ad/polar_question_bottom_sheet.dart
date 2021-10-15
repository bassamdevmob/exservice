import 'package:exservice/renovation/localization/app_localization.dart';
import 'package:exservice/renovation/styles/app_colors.dart';
import 'package:exservice/renovation/styles/app_text_style.dart';
import 'package:exservice/renovation/utils/utils.dart';
import 'package:exservice/renovation/widget/application/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PolarQuestionBottomSheet extends StatelessWidget {
  static Future<bool> show(BuildContext context) {
    return showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      topRadius: Radius.circular(35),
      backgroundColor: Colors.transparent,
      builder: (context) => PolarQuestionBottomSheet(),
    );
  }

  const PolarQuestionBottomSheet({Key key}) : super(key: key);

  Widget _getChip({
    IconData icon,
    String text,
    Color color,
    VoidCallback callback,
  }) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: AppColors.white,
            ),
            Text(
              text,
              style: AppTextStyle.largeWhiteBold,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Material(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: Utils.verticalSpace(mediaQuery)),
          LineBottomSheetWidget(),
          SizedBox(height: Utils.verticalSpace(mediaQuery)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width * 0.05,
            ),
            child: Text(
              AppLocalization.of(context).trans("choose_option"),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
            child: Row(
              children: [
                Expanded(
                  child: _getChip(
                    icon: Icons.check,
                    text: AppLocalization.of(context).trans("yes"),
                    color: Colors.greenAccent.withOpacity(0.5),
                    callback: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
                SizedBox(width: mediaQuery.size.width * 0.04),
                Expanded(
                  child: _getChip(
                    icon: Icons.close,
                    text: AppLocalization.of(context).trans("no"),
                    color: Colors.redAccent.withOpacity(0.5),
                    callback: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
